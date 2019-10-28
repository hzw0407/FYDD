//
//  DDIdCardInfoVC.m
//  FYDD
//
//  Created by mac on 2019/4/17.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDIdCardInfoVC.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "DDUserAvatarCell.h"
#import "DDBaseCell.h"
#import "BRStringPickerView.h"
#import "UIView+TYAlertView.h"
#import "DDAlertSheetView.h"
#import "BRAddressPickerView.h"
#import <UIImage+YYAdd.h>
#import <NSString+YYAdd.h>
#import <FSCalendar/FSCalendar.h>
#import "DDIdCardInfoVC.h"

@interface DDIdCardInfoVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_identificationCardNumber;// 身份证号码
    NSString *_expiryDate; // 有效期
    NSString *_name;// 名字
    NSString *_sex;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIViewController* idCardVC;
@end

@implementation DDIdCardInfoVC

- (void)dealloc{
    self.idCardVC = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/user/getUserRealName?token=", [DDUserManager share].user.token)
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                       @strongify(self)
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           self->_identificationCardNumber = data[@"identificationCardNumber"];
                           self->_name = data[@"name"];
                           self->_sex = data[@"sex"];
                           self->_expiryDate = data[@"expiryDate"];
                           [self.tableView reloadData];
                           
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
        _tableView.backgroundColor = UIColorHex(0xefefef);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDUserAvatarCell" bundle:nil] forCellReuseIdentifier:@"DDUserAvatarCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDBaseCell" bundle:nil] forCellReuseIdentifier:@"DDBaseCellId"];
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDBaseCellId"];
    NSArray * titles = @[@"姓名",@"性别",@"证件类型",@"证件号码",@"证件有效期"];
    NSArray * contents = @[yyTrimNullText(_name),yyTrimNullText(_sex),@"身份证",yyTrimNullText(_identificationCardNumber),yyTrimNullText(_expiryDate)];
    cell.dictView.hidden = YES;
    cell.nameLB.text = titles[indexPath.row];
    cell.contentLb.text = contents[indexPath.row];
    cell.contentLb.userInteractionEnabled = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
@end
