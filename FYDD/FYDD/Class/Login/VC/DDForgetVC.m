//
//  DDForgetVC.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDForgetVC.h"
#import "DDInputCell.h"
#import "DDCommitCell.h"
#import "DDUserAgreeInfoCell.h"

@interface DDForgetVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _password;
    NSString * _passwordAgain;
    NSString * _tel;
    NSString * _code;
    DDInputCell * _codeCell;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DDForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [_tableView registerNib:[UINib nibWithNibName:@"DDInputCell" bundle:nil] forCellReuseIdentifier:@"DDInputCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommitCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDUserAgreeInfoCell" bundle:nil] forCellReuseIdentifier:@"DDUserAgreeInfoCellId"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:false];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 4) {
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
    cell.textTd.keyboardType = UIKeyboardTypeASCIICapable;
    cell.textTd.secureTextEntry = NO;
    cell.maxLimit = 10000;
    if (indexPath.row == 0 ){
        cell.textTd.placeholder = @"请输入您的手机号";
        cell.codeBtn.hidden = NO;
        cell.maxLimit = 11;
        cell.textTd.keyboardType = UIKeyboardTypePhonePad;
        if (!_codeCell){
            _codeCell = cell;
        }else {
            cell = _codeCell;
        }
    }else if (indexPath.row == 1) {
        cell.textTd.placeholder = @"请输入验证码";
        cell.maxLimit = 6;
        cell.textTd.keyboardType = UIKeyboardTypeNumberPad;
    }else if (indexPath.row == 2) {
        cell.textTd.placeholder = @"请输入新密码";
        cell.textTd.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textTd.secureTextEntry = YES;
        cell.maxLimit = 100;
    }else if (indexPath.row == 3) {
        cell.textTd.placeholder = @"请再次输入新密码";
        cell.textTd.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textTd.secureTextEntry = YES;
        cell.maxLimit = 100;
    }
    
    cell.textChange = ^(NSString * text , NSIndexPath * index) {
        @strongify(self)
        if(index.row == 0) {
            self->_tel = text;
        }else if (index.row == 1) {
            self->_code = text;
        }else if (index.row == 2) {
            self->_password = text;
        }else if (index.row == 3) {
            self->_passwordAgain = text;
        }
    };
    cell.codeBlock = ^{
        @strongify(self)
        [self codeBtnDidClick];
    };
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return 80;
    }
    return  60;
}

- (void)codeBtnDidClick {
    if (_tel.length == 0 || _tel.length != 11) {
        [DDHub hub:_tel.length == 0 ? @"请输入手机号" : @"手机号须11位" view:self.view];
        return;
    }
    @weakify(self)
    NSString * body = [NSString stringWithFormat:@"{\"mobile\" : %@}",_tel];
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

- (void)modifyPassword{
    if (_tel.length == 0 || _tel.length != 11) {
        [DDHub hub:_tel.length == 0 ? @"请输入手机号" : @"手机号须11位" view:self.view];
        return;
    }
    if (_code.length == 0 || _code.length != 4) {
        [DDHub hub:_code.length == 0 ? @"请输入验证码" : @"验证码须4位" view:self.view];
        return;
    }
    if (_password.length == 0) {
        [DDHub hub:@"请输入新密码" view:self.view];
        return;
    }
    if (_passwordAgain.length == 0) {
        [DDHub hub:@"请再次输入新密码" view:self.view];
        return;
    }
    
    if (_passwordAgain.length < 8  || _password.length < 8 ) {
        [DDHub hub:@"新密码须8位以上" view:self.view];
        return;
    }
    if (![_passwordAgain isEqualToString:_password]) {
        [DDHub hub:@"输入的密码不一致" view:self.view];
        return;
    }
    [DDHub hub:self.view];
    @weakify(self)
    NSString * body = [NSString stringWithFormat:@"{\"userName\" : \"%@\" , \"newPassword\" : \"%@\",\"verifiCode\" : \"%@\"}",_tel,_password,_code];
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

@end
