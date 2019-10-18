//
//  DDUserTypeCell.m
//  FYDD
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDUserTypeCell.h"
#import <YYKit/YYKit.h>
@implementation DDUserTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _containerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _containerView.layer.shadowOffset = CGSizeMake(0,3);
    _containerView.layer.shadowRadius = 6;
    _containerView.layer.shadowOpacity = 1;
    _containerView.layer.cornerRadius = 10;
}



- (void)setShowType:(DDUserType)showType{
    _showType = showType;
    [_statusTypeLb removeAllSubviews];
    CGFloat left = _showType == DDUserTypeSystem ? 18 : 0;
    if ([DDUserManager share].user.userType == showType) {
        UIButton * btn = [self getStatueButton:@"icon_change_user1" title:@"当前身份"];
        btn.left = left;
        left += btn.size.width + 8;
        [self.statusTypeLb addSubview:btn];
    }
    switch (_showType) {
        case DDUserTypeOnline:
            _iconView.image = [UIImage imageNamed:@"icon_user_type2"];
            _userLb.text = @"实施方";
            _textLb1.text = @"软件实施工程,制造IT人员";
            _textLb2.text = @"完成订单可取得实施佣金";
            _userLb.textColor = UIColorHex(0x325C78);
            if ([DDUserManager share].user.isAuth == 1) {
                UIButton * btn = [self getStatueButton:@"icon_change_user3" title:@"认证实施方"];
                btn.left = left;
                [self.statusTypeLb addSubview:btn];
            }else {
                NSString * title = @"待申请";
                if ([DDUserManager share].user.isAuth == -1) {
                    title = @"申请中";
                }else if ([DDUserManager share].user.isAuth == 0){
                    title = @"未认证";
                }else if ([DDUserManager share].user.isAuth == 2) {
                    title = @"未通过";
                }
                UIButton * btn = [self getStatueButton:@"icon_change_user2" title:title];
                btn.left = left;
                [self.statusTypeLb addSubview:btn];
            }
            break;
        case DDUserTypeSystem:{
            _iconView.image = [UIImage imageNamed:@"icon_user_type1"];
            _userLb.text = @"企业用户";
            _textLb1.text = @"企业主、企业管理人员需";
            _textLb2.text = @"要安装系统、软件";
            _userLb.textColor = UIColorHex(0xE95F3A);
    
        }break;
        case DDUserTypePromoter:
            _iconView.image = [UIImage imageNamed:@"icon_user_type3"];
            _userLb.text = @"代理方";
            _textLb1.text = @"推荐三特产品给用户使用";
            _textLb2.text = @"推荐成功可取的推广佣金";
            _userLb.textColor = UIColorHex(0x3CB9B1);
            if ([DDUserManager share].user.isExtensionUser == 1) {
                UIButton * btn = [self getStatueButton:@"icon_change_user3" title:@"认证代理方"];
                btn.left = left;
                [self.statusTypeLb addSubview:btn];
            }else if ([DDUserManager share].user.isExtensionUser == 2){
                UIButton * btn = [self getStatueButton:@"icon_change_user2" title:@"未认证"];
                btn.left = left;
                [self.statusTypeLb addSubview:btn];
            }else if ([DDUserManager share].user.isExtensionUser == 0){
                UIButton * btn = [self getStatueButton:@"icon_change_user2" title:@"待申请"];
                btn.left = left;
                [self.statusTypeLb addSubview:btn];
            }
            break;
            
        default:
            break;
    }
}

- (UIButton *)getStatueButton:(NSString *)imageName title:(NSString *)title{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:title forState:UIControlStateNormal];
    CGFloat width = [title sizeForFont:[UIFont systemFontOfSize:10] size:CGSizeMake(10000, 18  ) mode:NSLineBreakByWordWrapping].width + 12;
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, width, 18);
    return btn;
}


@end
