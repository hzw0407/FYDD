//
//  DDEditUserVC.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDEditUserVC.h"
#import "DDInputCell.h"
#import "DDCommitCell.h"
#import "DDUserAgreeInfoCell.h"
#import <LCActionSheet/LCActionSheet.h>
#import "BRAddressPickerView.h"
#import "DDEditUserTopCell.h"
#import "DDWebVC.h"
@interface DDEditUserVC ()<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate>{
    NSString * _password;
    NSString * _passwordAgain;
    NSString * _tel;
    NSInteger _user_type;
    BOOL _agree;
    NSString * _wechartPhone;
    NSString * _code;
    DDInputCell * _codeCell;
    
    NSString * _areaName;
    NSString * _areaId;
    
}
@property (nonatomic,copy) NSString * nickname;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DDEditUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _wechart ? @"绑定手机号" : @"完善用户信息";
    [_tableView registerNib:[UINib nibWithNibName:@"DDInputCell" bundle:nil] forCellReuseIdentifier:@"DDInputCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommitCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDUserAgreeInfoCell" bundle:nil] forCellReuseIdentifier:@"DDUserAgreeInfoCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDEditUserTopCell" bundle:nil] forCellReuseIdentifier:@"DDEditUserTopCellId"];
    _user_type =   1;
    _agree = YES;
    _user_type = 100;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isCheckEnter) {
        [self.navigationController setNavigationBarHidden:NO animated:false];
    }else {
        self.title = @"完善用户信息";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    }
}


- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 9) {
        DDCommitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommitCellId"];
        cell.event = ^(){
            @strongify(self)
            [self commitUserInfo];
        };
        return  cell;
    }else if (indexPath.row == 8) {
        DDUserAgreeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDUserAgreeInfoCellId"];
        cell.isSelected = _agree;
        cell.event = ^{
            @strongify(self)
            DDWebVC * vc = [DDWebVC new];
            vc.url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/manager/userAgreementDetail"];
            vc.title = @"服务协议";
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else if (indexPath.row == 0) {
        DDEditUserTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDEditUserTopCellId"];
        return cell;
    }
    DDInputCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"DDInputCellId"];
    if (_wechart  && indexPath.row == 4) {
        if (!_codeCell) {
            _codeCell = cell;
        }else {
            cell = _codeCell;
        }
    }
    
    cell.textTd.userInteractionEnabled = YES;
    cell.indexPath = indexPath;
    cell.upView.hidden = YES;
    cell.textTd.secureTextEntry = NO;
    cell.codeBtn.hidden = YES;
    cell.clipsToBounds = YES;
    cell.maxLimit = 1000000;
    cell.clipsToBounds = YES;
    if (indexPath.row == 1 ){
        cell.textTd.placeholder = @"请输入您的昵称";
        cell.textTd.text = _nickname;
        cell.textTd.keyboardType = UIKeyboardTypeDefault;
    }else if (indexPath.row == 2) {
        cell.textTd.secureTextEntry = YES;
        cell.textTd.placeholder = @"请输入您的密码";
        cell.textTd.keyboardType = UIKeyboardTypeASCIICapable;
        cell.maxLimit = 50;
        cell.textTd.text = _password;
    }else if (indexPath.row == 3) {
        cell.textTd.placeholder = @"请再次输入您的密码";
        cell.textTd.text = _passwordAgain;
        cell.textTd.secureTextEntry = YES;
        cell.textTd.keyboardType = UIKeyboardTypeASCIICapable;
        cell.maxLimit = 50;
        // 手机号
    }else if (indexPath.row == 4) {
        // 微信登录
        if (_wechart) {
            cell.textTd.userInteractionEnabled = YES;
            cell.codeBtn.hidden = NO;
            cell.textTd.text = _wechartPhone;
            cell.maxLimit = 6;
            cell.textTd.placeholder = @"请输入您的手机号";
            cell.textTd.keyboardType = UIKeyboardTypePhonePad;
            cell.maxLimit = 11;
        }else {
            if([DDUserManager share].user.phone.length > 7) {
                cell.textTd.text = [[DDUserManager share].user.phone stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"];
            }else {
                cell.textTd.text = @"";
            }cell.textTd.placeholder = @"";
            cell.textTd.userInteractionEnabled = NO;
        }

    }else if (indexPath.row == 7) {
        cell.textTd.placeholder = @"请选择您的身份";
        cell.textTd.userInteractionEnabled = NO;
        cell.upView.hidden = NO;
        if (_user_type < 4) {
            cell.textTd.text = @[@"企业用户", @"系统代理方", @"系统实施方"][_user_type - 1];
        }
    }else if (indexPath.row == 6) {
        cell.textTd.placeholder = @"所在地区";
        cell.textTd.userInteractionEnabled = NO;
        cell.upView.hidden = NO;
        cell.textTd.text = yyTrimNullText(_areaName);

    }else if (indexPath.row == 5) {
        cell.textTd.placeholder = @"请输入验证码";
        cell.textTd.text = _code;
         cell.textTd.userInteractionEnabled = YES;
        cell.textTd.keyboardType = UIKeyboardTypeNumberPad;
        cell.maxLimit = 6;
    }
    
    cell.textChange = ^(NSString * text , NSIndexPath * index) {
        @strongify(self)
        if(index.row == 1) {
            self->_nickname = text;
        }else if (index.row == 2) {
            self->_password = text;
        }else if (index.row == 3) {
            self->_passwordAgain = text;
        }else if (index.row == 4) {
            self->_wechartPhone = text;
        }else if (index.row == 5) {
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
    if (indexPath.row == 7) return  0.00;
    if (indexPath.row == 9) {
        return  80;
    }else if(indexPath.row == 8) {
        return 35;
    }
    if (!_wechart && indexPath.row == 5) {
        return 0.01;
    }
    if (indexPath.row == 2 || indexPath.row == 3) {
        if ([DDUserManager share].user.isFinishPwd == 0) {
            return 0.01;
        }
    }
    if (!_wechart && indexPath.row == 0) {
        return 0.01;
    }
    return  60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 8) {
        _agree = !_agree;
        [tableView reloadData];
    }else if (indexPath.row == 7) {
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"选择身份"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"企业用户", @"系统代理方", @"系统实施方", nil];
        [actionSheet show];
    }else if (indexPath.row == 6) {
        @weakify(self)
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity
                                           defaultSelected:@[]
                                              isAutoSelect:NO
                                                themeColor:nil
                                               resultBlock:^(BRProvinceModel *province,
                                                             BRCityModel *city,
                                                             BRAreaModel *area) {
                                                   @strongify(self)
                                                   if (!self) return ;
                                                   self->_areaName = city.name;
                                                   self->_areaId = city.code;
                                                   [self.tableView reloadData];
                                               } cancelBlock:^{
                                                   
                                               }];
    }
}

- (void)codeBtnDidClick {
    if (_wechartPhone.length ==  0) {
        [DDHub hub:@"请输入手机号" view:self.view];
        return;
    }
    @weakify(self)
    NSString * body = [NSString stringWithFormat:@"{\"mobile\" : %@}",_wechartPhone];
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

// 完善用户信息
- (void)commitUserInfo{
    if (_nickname.length == 0) {
        [DDHub hub:@"请输入昵称" view:self.view];
        return;
    }

    if ([DDUserManager share].user.isFinishPwd == 1) {
        if (_password.length == 0) {
            [DDHub hub:@"请输入密码" view:self.view];
            return;
        }
        if (_passwordAgain.length == 0) {
            [DDHub hub:@"请再次输入密码" view:self.view];
            return;
        }
        if (_password.length < 8
            || _passwordAgain.length < 8) {
            [DDHub hub:@"密码须8位以上" view:self.view];
            return;
        }
        if (![_password isEqualToString:_passwordAgain]) {
            [DDHub hub:@"两次密码不一致" view:self.view];
            return;
        }
    }
    
    
    if (_wechart) {
        if (_wechartPhone.length == 0) {
            [DDHub hub:@"请输入手机号" view:self.view];
            return;
        }
        if (_wechartPhone.length != 11) {
            [DDHub hub:@"手机号须11位" view:self.view];
            return;
        }
        if (_code.length == 0) {
            [DDHub hub:@"请输入验证码" view:self.view];
            return;
        }
        if (_code.length != 4) {
            [DDHub hub:@"验证码须4位" view:self.view];
            return;
        }
    }
    
    if (_areaName.length == 0) {
        [DDHub hub:@"请选择所在地区" view:self.view];
        return;
    }
    
//    if (_user_type > 4) {
//        [DDHub hub:@"请选择您的身份" view:self.view];
//        return;
//    }
    
    if (!_agree) {
        [DDHub hub:@"未同意服务协议" view:self.view];
        return;
    }

    DDUser * user = [DDUserManager share].user;
    NSString * body = @"";
    NSString * url = @"";
    if (_wechart) {
        body = [NSString stringWithFormat:@"{\"area\" : \"%@\" ,\"areaId\" : \"%@\" ,\"nickname\" : \"%@\" ,\"password\" : \"%@\" , \"userType\" :%zd , \"phone\" : \"%@\" , \"validateCode\" : \"%@\"}",_areaName,_areaId,_nickname,_password,_user_type,_wechartPhone,_code];
        url = [NSString stringWithFormat:@"/uas/user/user/userInfo/bindPhone?token=%@",user.token];
    }else {
        body = [NSString stringWithFormat:@"{\"area\" : \"%@\" ,\"areaId\" : \"%@\", \"nickname\" : \"%@\" ,\"password\" : \"%@\" , \"userType\" :%zd}",_areaName,_areaId,_nickname,_password,_user_type];
        url = [NSString stringWithFormat:@"/uas/user/user/userInfo/improveUserInfo?token=%@",user.token];
    }
    [DDHub hub:self.view];
    [[DDAppNetwork share] get:NO
                         path:url
                         body:body
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       if (code == 200) {
                           [DDHub hub:@"完善信息成功！" view:self.view];
                           [DDUserManager share].isLogged = YES;
                           [[DDUserManager share] save];
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
                           });
                       }else {
                           [DDHub hub:@"完善信息失败，请稍后尝试！" view:self.view];
                       }
                   }];
}

- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) return;
    _user_type = buttonIndex;
    [self.tableView reloadData];
}
@end
