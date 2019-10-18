//
//  DDModifyPasswordVC.m
//  FYDD
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDModifyPasswordVC.h"
#import "DDCommitCell.h"
#import "DDInputCell.h"

@interface DDModifyPasswordVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _xmm;
    NSString * _xmmt;
    NSString * _code;
    DDInputCell * _codeCell;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void)modifyPassword{
    if (_xmm.length < 8 ) {
        [DDHub hub:@"请输入8位以上新密码" view:self.view];
        return;
    }
    if (_xmmt.length < 8 ) {
        [DDHub hub:@"请再次输入8位以上新密码" view:self.view];
        return;
    }
    if (![_xmmt isEqualToString:_xmm]) {
        [DDHub hub:@"输入的两次新密码不一致" view:self.view];
        return;
    }
    if (_code.length == 0 ) {
        [DDHub hub:@"请输入验证码" view:self.view];
        return;
    }
    if (_code.length != 4 ) {
        [DDHub hub:@"验证码须4位数字" view:self.view];
        return;
    }
    [DDHub hub:self.view];
    @weakify(self)
    NSString * body = [NSString stringWithFormat:@"{\"userName\" : \"%@\" , \"newPassword\" : \"%@\",\"verifiCode\" : \"%@\"}",[DDUserManager share].user.phone,_xmmt,_code];
    [[DDAppNetwork share] get:NO
                         path:@"/uas/user/user/userInfo/updatePassword"
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           [self.navigationController popViewControllerAnimated:YES];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
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
            [self modifyPassword];
        };
        return  cell;
    }
    DDInputCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDInputCellId"];
    cell.textTd.userInteractionEnabled = YES;
    cell.indexPath = indexPath;
    cell.upView.hidden = YES;
    cell.codeBtn.hidden = YES;
    cell.maxLimit = 100000;
    cell.textTd.secureTextEntry = NO;
    if (indexPath.row == 0) {
        cell.textTd.placeholder = @"请输入新密码";
        cell.textTd.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textTd.secureTextEntry = YES;
        cell.maxLimit = 120;
    }else if (indexPath.row == 1) {
        cell.textTd.placeholder = @"请再次输入新密码";
        cell.textTd.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textTd.secureTextEntry = YES;
        cell.maxLimit = 120;
    }else if (indexPath.row == 2) {
        if (!_codeCell) {
            _codeCell = cell;
        }else {
            cell = _codeCell;
        }
        cell.codeBtn.hidden = NO;
        cell.textTd.placeholder = @"请输入手机验证码";
        cell.textTd.keyboardType = UIKeyboardTypeNumberPad;
        cell.maxLimit = 6;
    }
    cell.textChange = ^(NSString * text , NSIndexPath * index) {
        @strongify(self)
        if (index.row == 0) {
            self->_xmm = text;
        }else if (index.row == 1) {
            self->_xmmt = text;
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

- (void)codeBtnDidClick {
    NSString * phone = [DDUserManager share].user.phone;
    if (phone.length ==  0) {
        [DDHub hub:@"未绑定手机号" view:self.view];
        return;
    }
    self->_codeCell.codeBtn.userInteractionEnabled = NO;
    @weakify(self)
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
                           self->_codeCell.codeBtn.userInteractionEnabled = YES;
                           [DDHub hub:@"获取验证码失败" view:self.view];
                       }
                   }];
}

@end
