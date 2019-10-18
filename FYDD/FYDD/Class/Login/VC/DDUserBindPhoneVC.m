//
//  DDUserBindPhoneVC.m
//  FYDD
//
//  Created by mac on 2019/3/1.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDUserBindPhoneVC.h"
#import "DDInputCell.h"
#import "DDCommitCell.h"
#import "DDUserAgreeInfoCell.h"
#import "DDContentCell.h"
#import <LCActionSheet/LCActionSheet.h>

@interface DDUserBindPhoneVC ()<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate>{
    NSString  * _nickname;
    NSString * _password;
    NSString * _passwordAgain;
    NSString * _tel;
    NSString * _code;
    NSString * _user_type;
    BOOL _agree;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DDUserBindPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    [_tableView registerNib:[UINib nibWithNibName:@"DDInputCell" bundle:nil] forCellReuseIdentifier:@"DDInputCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommitCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDUserAgreeInfoCell" bundle:nil] forCellReuseIdentifier:@"DDUserAgreeInfoCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDContentCell" bundle:nil] forCellReuseIdentifier:@"DDContentCellId"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:false];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  9;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ){
        DDContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDContentCellId"];
        cell.contentLb.text = @"依《网络安全法》相关要求以及为了您的账号安全，请您将当前账号和手机绑定";
        return cell;
    }
    if (indexPath.row == 8) {
        DDCommitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommitCellId"];
        cell.event = ^(){
            
        };
        return  cell;
    }else if (indexPath.row == 7) {
        DDUserAgreeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDUserAgreeInfoCellId"];
        cell.isSelected = _agree;
        return cell;
    }
    DDInputCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDInputCellId"];
    cell.textTd.userInteractionEnabled = YES;
    cell.indexPath = indexPath;
    cell.upView.hidden = YES;
    cell.codeBtn.hidden = YES;
    if (indexPath.row == 1 ){
        cell.textTd.placeholder = @"请输入您的昵称";
    }else if (indexPath.row == 2) {
        cell.textTd.placeholder = @"请设置密码";
    }else if (indexPath.row == 3) {
        cell.textTd.placeholder = @"请再吃输入您的密码";
    }else if (indexPath.row == 4) {
        cell.textTd.placeholder = @"请输入您的手机号";
        cell.codeBtn.hidden = NO;
    }else if (indexPath.row == 5) {
        cell.textTd.placeholder = @"请输入短信验证码";
        cell.textTd.userInteractionEnabled = NO;
    }else if (indexPath.row == 6) {
        cell.textTd.placeholder = @"请选择您的身份";
        cell.textTd.userInteractionEnabled = NO;
        cell.upView.hidden = NO;
    }
    @weakify(self)
    cell.textChange = ^(NSString * text , NSIndexPath * index) {
        @strongify(self)
        if(index.row == 1) {
            self->_nickname = text;
        }else if (index.row == 2) {
            self->_password = text;
        }else if (index.row == 3) {
            self->_passwordAgain = text;
        }else if (index.row == 4) {
            self->_tel = text;
        }else if (index.row == 5) {
            self->_code = text;
        }
    };
    cell.codeBlock = ^{
        
    };
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 8) {
        return 80;
    }else if(indexPath.row == 7) {
        return 35;
    }
    return  60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        _agree = !_agree;
        [tableView reloadData];
    }else if (indexPath.row == 6) {
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"选择身份"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"企业用户", @"系统代理方", @"系统实施方", nil];
        [actionSheet show];
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
@end
