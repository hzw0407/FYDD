//
//  DDPayPasswordVC.m
//  FYDD
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDPayPasswordVC.h"
#import "DDCommitCell.h"
#import "DDInputCell.h"
#import "DDAlertView.h"

@interface DDPayPasswordVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _zfmm;
    NSString * _zfmmt;
    NSString * _code;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) DDInputCell * codeCell;
@end

@implementation DDPayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付密码";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xf0f0f0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDInputCell" bundle:nil] forCellReuseIdentifier:@"DDInputCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommitCellId"];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 3) {
        DDCommitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommitCellId"];
        cell.event = ^(){
            @strongify(self)
            [self commitModifyPayPassoword];
        };
        return  cell;
    }
    DDInputCell * cell;
    if (indexPath.row == 2 && _codeCell) {
        cell = _codeCell;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DDInputCellId"];
        if (indexPath.row == 2) {
            _codeCell = cell;
        }
    }
    cell.textTd.userInteractionEnabled = YES;
    cell.indexPath = indexPath;
    cell.upView.hidden = YES;
    cell.codeBtn.hidden = YES;
    cell.textTd.keyboardType = UIKeyboardTypeNumberPad;
    cell.textTd.secureTextEntry = YES;
    cell.maxLimit = 100000;
    if (indexPath.row == 0 ){
        cell.textTd.placeholder = @"请输入新支付密码";
        cell.maxLimit = 6;
    }else if (indexPath.row == 1) {
        cell.textTd.placeholder = @"请再次输入支付密码";
        cell.maxLimit = 6;
    }else if (indexPath.row == 2) {
        cell.textTd.placeholder = @"请输入手机验证码";
        cell.codeBtn.hidden = NO;
        cell.maxLimit = 50;
        cell.textTd.secureTextEntry = NO;
    }else if (indexPath.row == 3) {
    }
    
    cell.textChange = ^(NSString * text , NSIndexPath * index) {
        @strongify(self)
        if(index.row == 0) {
            self->_zfmm = text;
        }else if (index.row == 1) {
            self->_zfmmt = text;
        }else if (index.row == 2) {
            self->_code = text;
        }
    };
    cell.codeBlock = ^{
        @strongify(self)
        [self codeBtnDidClick];
        
    };
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 80;
    }
    return  60;
}

- (void)commitModifyPayPassoword{
    if (_zfmm.length == 0) {
        [DDHub hub:@"请输入新支付密码" view:self.view];
        return;
    }
    if (_zfmmt.length == 0) {
        [DDHub hub:@"请再次输入新的支付密码" view:self.view];
        return;
    }
    if (![_zfmmt isEqualToString:_zfmm]) {
        [DDHub hub:@"两次输入的支付密码不一致，请重新输入" view:self.view];
        return;
    }
    
    if (_zfmmt.length != 6 || _zfmm.length != 6) {
        [DDHub hub:@"支付密码须6位" view:self.view];
        return;
    }
    
    if (_code.length == 0) {
        [DDHub hub:@"请输入手机验证码" view:self.view];
        return;
    }
    
    @weakify(self)
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"newPassword\" : \"%@\" , \"verifiCode\" : \"%@\" ,\"userName\" : \"%@\"}",_zfmm,_code,[DDUserManager share].user.phone];
    [[DDAppNetwork share] get:NO
                         path:[NSString stringWithFormat:@"/uas/user/user/userInfo/updatePayPassword?token=%@",[DDUserManager share].user.token]
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           @weakify(self)
                           [DDAlertView showTitle:@"提示"
                                         subTitle:@"设置支付密码成功" cancelEvent:^{
                               @strongify(self)
                               [self.navigationController popViewControllerAnimated:YES];
                           }];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (void)codeBtnDidClick {
    NSString * phone = [DDUserManager share].user.phone;
    if (phone.length ==  0) {
        [DDHub hub:@"未绑定手机号" view:self.view];
        return;
    }
    @weakify(self)
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"mobile\" : %@}",phone];
    [[DDAppNetwork share] get:NO
                         path:@"/uas/messageSend/sms/sendValidateCode"
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       // 成功
                       if (code == 200) {
                           [DDHub hub:@"获取验证码成功" view:self.view];
                           [self->_codeCell start];
                       }else {
                           [DDHub hub:@"获取验证码失败" view:self.view];
                       }
                   }];
}

@end
