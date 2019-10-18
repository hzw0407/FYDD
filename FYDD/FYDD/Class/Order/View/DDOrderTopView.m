//
//  DDOrderTopView.m
//  FYDD
//
//  Created by mac on 2019/4/1.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderTopView.h"
#import <Masonry/Masonry.h>

@interface DDOrderTopView()
@property (nonatomic,strong)UIButton * tempBtn;
@end


@implementation DDOrderTopView
- (void)awakeFromNib {
    [super awakeFromNib];
    _cons.constant = ((kScreenSize.width - 210) / 3) * (0.5);
    
    DDUser * user =  [DDUserManager share].user;
    switch (user.userType) {
        case DDUserTypeOnline:{
            _nameLb1.text = @"工匠等级";
            _nameLb2.text = @"服务评价";
            _nameLb3.text = @"累计收入";
            
            _typeLb.hidden = NO;
            _progressiveView.hidden = NO;
            _companyLb.text = @"";
            _industryNameLb.hidden = YES;
            
            self.starView.hidden = NO;
            self.starView.type = 1;
            self.starView.userInteractionEnabled = false;
            self.starLb.hidden = NO;
            
            
        }break;
        // 企业用户
        case DDUserTypeSystem:{
            NSString * status = @"未认证";
            if (user.enterpriseAuthentication == 1){
                status = @"已认证";
            }else if(user.enterpriseAuthentication == 2) {
                status = @"未通过";
            }else if(user.enterpriseAuthentication == 0) {
                status = @"未认证";
            }
            _moneLb.text = status;
            _industryNameLb.text = yyTrimNullText(user.industry);
            _companyLb.text = yyTrimNullText(user.enterpriseName);
            _nameLb1.text = @"所属企业";
            _nameLb2.text = @"所属行业";
            _nameLb3.text = @"企业认证";
        }break;
            
        case DDUserTypePromoter:{
            _nameLb1.text = @"推广等级";
            _nameLb2.text = @"服务评价";
            _nameLb3.text = @"累计收入";
            _typeLb.hidden = NO;
            _progressiveView.hidden = NO;
            _companyLb.text = @"";
            _industryNameLb.hidden = YES;
            self.starView.hidden = NO;
            self.starView.type = 1;
            self.starView.userInteractionEnabled = false;
            self.starLb.hidden = NO;
        }break;
        default:
            break;
    }
    _tempBtn = _nextButton;
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    sender.selected = YES;
    _tempBtn.selected = NO;
    _cons.constant = (kScreenSize.width / 3)* 0.5 + (kScreenSize.width / 3)  * sender.tag - 15;;
    
    [self layoutIfNeeded];
    if (_event) {
        _event(sender.tag);
    }
    _tempBtn = sender;
}

- (void)setCheckUser:(DDOrderCheckUser *)checkUser{
    _checkUser = checkUser;
    if ([DDUserManager share].user.userType == DDUserTypeOnline){
        self.starLb.text = [NSString stringWithFormat:@"%.2f",[checkUser.totlaScore doubleValue]];
        self.starView.progress = [checkUser.totlaScore doubleValue];
        NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
        _typeLb.text = checkUser.onlineName;
        
        
        NSString * text2 = [NSString stringWithFormat:@"¥%.f",[checkUser.totalIncome doubleValue]];
        NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
        [attribut2 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,text2.length)];
        
        
        NSString * text3 = [NSString stringWithFormat:@"     ¥%.f结算中",[checkUser.settlementMoney doubleValue]];
        NSMutableAttributedString *attribut3 = [[NSMutableAttributedString alloc]initWithString:text3];
        [attribut3 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,text3.length)];
        
        [priceAtt appendAttributedString:attribut2];
        [priceAtt appendAttributedString:attribut3];
        _moneLb.attributedText = priceAtt;
        _consWidth.constant = (kScreenSize.width - 260) * [checkUser.upgradeRatio doubleValue] /3;
        _probackView.hidden = NO;
    }

}


- (void)setExtensionUser:(DDOrderExtensionUser *)extensionUser{
    _extensionUser = extensionUser;
    if ([DDUserManager share].user.userType == DDUserTypePromoter){
        self.starLb.text = [NSString stringWithFormat:@"%.2f",[extensionUser.totalScore doubleValue]];
        self.starView.progress = [extensionUser.totalScore doubleValue];
        NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
        
        
        _typeLb.text = extensionUser.extensionName;
        NSString * text2 = [NSString stringWithFormat:@"¥%.f",[extensionUser.totalIncome doubleValue]];
        NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
        [attribut2 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,text2.length)];
        
        
        NSString * text3 = [NSString stringWithFormat:@"     ¥%.f结算中",[extensionUser.settlementMoney doubleValue]];
        NSMutableAttributedString *attribut3 = [[NSMutableAttributedString alloc]initWithString:text3];
        [attribut3 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,text3.length)];
        
        [priceAtt appendAttributedString:attribut2];
        [priceAtt appendAttributedString:attribut3];
        _moneLb.attributedText = priceAtt;
        _consWidth.constant = (kScreenSize.width - 260) * [extensionUser.upgradeRatio doubleValue] /3;
        _probackView.hidden = NO;
    }
}

@end
