//
//  DDIDCardView.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDIDCardView.h"
#import "UIView+TYAlertView.h"
#import <UIButton+WebCache.h>

@interface DDIDCardView()

@property (nonatomic, strong) UIView *topView;//上半部view
@property (nonatomic, strong) UIView *bottomview;//下半部view

@end

@implementation DDIDCardView
#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        [self creatUI];
        
    }
    return self;
}

#pragma mark - CustomMethod
- (void)creatUI {
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self).offset(0);
        make.height.equalTo(@(215));
    }];
    
    [self addSubview:self.bottomview];
    [self.bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(0);
    }];
}

//刷新数据
- (void)refrehsInfoWithDic:(NSDictionary *)dic {
    UILabel *nameLabel = [self.topView viewWithTag:100];
    nameLabel.text = [NSString stringWithFormat:@"姓名   %@",dic[@"name"]];
    UILabel *numberLabel = [self.topView viewWithTag:101];
    numberLabel.text = [NSString stringWithFormat:@"身份证号码   %@",dic[@"number"]];
    UILabel *expiryDateLabel = [self.topView viewWithTag:102];
    expiryDateLabel.text = [NSString stringWithFormat:@"有效期至    %@",dic[@"expiryDate"]];
    UIButton *portraitButton = [self.bottomview viewWithTag:200];
    UIButton *emblemButton = [self.bottomview viewWithTag:201];
    NSString *urlString1 = dic[@"url1"];
    NSString *urlString2 = dic[@"url2"];
    if (urlString1.length > 0) {
        //正面
        [portraitButton setBackgroundImage:nil forState:UIControlStateNormal];
        [portraitButton sd_setImageWithURL:[NSURL URLWithString:urlString1] forState:UIControlStateNormal];
    }
    if (urlString2.length > 0) {
        //反面
        [emblemButton setBackgroundImage:nil forState:UIControlStateNormal];
        [emblemButton sd_setImageWithURL:[NSURL URLWithString:urlString2] forState:UIControlStateNormal];
    }
}

#pragma mark - ClickMethod
- (void)btnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickIndex:)]) {
        [self.delegate clickIndex:btn.tag - 200];
    }
}

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"实名认证";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:17];
        [_topView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView).offset(15);
            make.right.equalTo(_topView).offset(-15);
            make.top.equalTo(_topView).offset(20);
            make.height.equalTo(@(20));
        }];
        
        //姓名
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"姓名";
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.tag = 100;
        [_topView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_left);
            make.right.mas_equalTo(titleLabel.mas_right);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(titleLabel.mas_height);
        }];
        
        //线
        UIView *lineViewOne = [[UIView alloc] init];
        lineViewOne.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        [_topView addSubview:lineViewOne];
        [lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topView).offset(0);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
            make.height.equalTo(@(1));
        }];
        
        //身份证号码
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.text = @"身份证号码";
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.font = [UIFont systemFontOfSize:15];
        numberLabel.tag = 101;
        [_topView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_left);
            make.right.mas_equalTo(nameLabel.mas_right);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(35);
            make.height.mas_equalTo(nameLabel.mas_height);
        }];
        
        //线
        UIView *lineViewTwo = [[UIView alloc] init];
        lineViewTwo.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        [_topView addSubview:lineViewTwo];
        [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topView).offset(0);
            make.top.mas_equalTo(numberLabel.mas_bottom).offset(15);
            make.height.equalTo(@(1));
        }];
        
        //有效期
        UILabel *expiryDateLabel = [[UILabel alloc] init];
        expiryDateLabel.text = @"有效期";
        expiryDateLabel.textColor = [UIColor blackColor];
        expiryDateLabel.font = [UIFont systemFontOfSize:15];
        expiryDateLabel.tag = 102;
        [_topView addSubview:expiryDateLabel];
        [expiryDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numberLabel.mas_left);
            make.right.mas_equalTo(numberLabel.mas_right);
            make.top.mas_equalTo(numberLabel.mas_bottom).offset(35);
            make.height.mas_equalTo(numberLabel.mas_height);
        }];
    }
    return _topView;
}

- (UIView *)bottomview {
    if (!_bottomview) {
        _bottomview  = [[UIView alloc] init];
        _bottomview.backgroundColor = [UIColor whiteColor];
        
        //tip1
        UILabel *tipLabelOne = [[UILabel alloc] init];
        tipLabelOne.text = @"身份证照片";
        tipLabelOne.textColor = [UIColor blackColor];
        tipLabelOne.font = [UIFont systemFontOfSize:17];
        [_bottomview addSubview:tipLabelOne];
        [tipLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomview).offset(15);
            make.right.equalTo(_bottomview).offset(-15);
            make.top.equalTo(_bottomview).offset(20);
            make.height.equalTo(@(20));
        }];
        
        //tip2
        UILabel *tipLabelTwo = [[UILabel alloc] init];
        tipLabelTwo.text = @"1.拍照时请确保边框完整、图像清晰、光线均匀";
        tipLabelTwo.textColor = [UIColor grayColor];
        tipLabelTwo.font = [UIFont systemFontOfSize:15];
        [_bottomview addSubview:tipLabelTwo];
        [tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tipLabelOne.mas_left).offset(0);
            make.right.mas_equalTo(tipLabelOne.mas_right).offset(0);
            make.top.mas_equalTo(tipLabelOne.mas_bottom).offset(30);
            make.height.mas_equalTo(tipLabelOne.mas_height);
        }];
        
        //tip3
        UILabel *tipLabelThree = [[UILabel alloc] init];
        tipLabelThree.text = @"2.请上传该账户本人身份证照片";
        tipLabelThree.textColor = [UIColor grayColor];
        tipLabelThree.font = [UIFont systemFontOfSize:15];
        [_bottomview addSubview:tipLabelThree];
        [tipLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tipLabelTwo.mas_left);
            make.right.mas_equalTo(tipLabelTwo.mas_right);
            make.top.mas_equalTo(tipLabelTwo.mas_bottom).offset(10);
            make.height.mas_equalTo(tipLabelTwo.mas_height);
        }];
        
        //正面照按钮
        CGFloat spaceWidth = (kScreenWidth - 260) / 2;
        UIButton *portraitButton = [[UIButton alloc] init];
        [portraitButton setBackgroundImage:[UIImage imageNamed:@"Authen_Portrait"] forState:UIControlStateNormal];
        [portraitButton setImage:[UIImage imageNamed:@"Authen_Camera"] forState:UIControlStateNormal];
        portraitButton.tag = 200;
        [portraitButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomview addSubview:portraitButton];
        [portraitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomview).offset(spaceWidth);
            make.width.equalTo(@(120));
            make.top.mas_equalTo(tipLabelThree.mas_bottom).offset(30);
            make.height.equalTo(@(80));
        }];
        
        //国徽按钮
        UIButton *emblemButton = [[UIButton alloc] init];
        [emblemButton setBackgroundImage:[UIImage imageNamed:@"Authen_Emblem"] forState:UIControlStateNormal];
        [emblemButton setImage:[UIImage imageNamed:@"Authen_Camera"] forState:UIControlStateNormal];
        emblemButton.tag = 201;
        [emblemButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomview addSubview:emblemButton];
        [emblemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomview).offset(-spaceWidth);
            make.width.mas_equalTo(portraitButton.mas_width);
            make.top.mas_equalTo(portraitButton.mas_top);
            make.height.mas_equalTo(portraitButton.mas_height);
        }];
        
        UILabel *tipLabelFour = [[UILabel alloc] init];
        tipLabelFour.text = @"人像正面照";
        tipLabelFour.textColor = [UIColor blackColor];
        tipLabelFour.font = [UIFont systemFontOfSize:15];
        tipLabelFour.textAlignment = NSTextAlignmentCenter;
        [_bottomview addSubview:tipLabelFour];
        [tipLabelFour mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(portraitButton.mas_left);
            make.width.mas_equalTo(portraitButton.mas_width);
            make.top.mas_equalTo(portraitButton.mas_bottom).offset(20);
            make.height.equalTo(@(20));
        }];
        
        UILabel *tipLabelFive = [[UILabel alloc] init];
        tipLabelFive.text = @"国徽面照片";
        tipLabelFive.textColor = [UIColor blackColor];
        tipLabelFive.font = [UIFont systemFontOfSize:15];
        tipLabelFive.textAlignment = NSTextAlignmentCenter;
        [_bottomview addSubview:tipLabelFive];
        [tipLabelFive mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(emblemButton.mas_right);
            make.width.mas_equalTo(emblemButton.mas_width);
            make.top.mas_equalTo(tipLabelFour.mas_top);
            make.height.mas_equalTo(tipLabelFour.mas_height);
        }];
        
        //申请认证
        UIButton *applyButton = [[UIButton alloc] init];
        applyButton.backgroundColor = [UIColor colorWithRed:41 / 255.0 green:150 / 255.0 blue:235 /255.0 alpha:1.0];
        [applyButton setTitle:@"申请认证" forState:UIControlStateNormal];
        [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        applyButton.titleLabel.font = [UIFont systemFontOfSize:17];
        applyButton.tag = 202;
        [applyButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomview addSubview:applyButton];
        [applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bottomview.mas_centerX);
            make.width.equalTo(@(200));
            make.top.mas_equalTo(tipLabelFive.mas_bottom).offset(30);
            make.height.equalTo(@(45));
        }];
        [applyButton layoutIfNeeded];
        applyButton.layer.cornerRadius = applyButton.size.height / 2;
    }
    return _bottomview;
}

@end
