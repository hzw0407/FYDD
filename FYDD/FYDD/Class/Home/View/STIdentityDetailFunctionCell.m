//
//  STIdentityDetailFunctionCell.m
//  FYDD
//
//  Created by 何志武 on 2019/10/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "STIdentityDetailFunctionCell.h"

@interface STIdentityDetailFunctionCell ()

@property (nonatomic, strong) UIView *procedureView;//流程
@property (nonatomic, strong) UIView *orderView;//订单
@property (nonatomic, strong) UIView *customerView;//客户
@property (nonatomic, strong) UIButton *applyButton;//申请

@end

@implementation STIdentityDetailFunctionCell
#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatUI];
        
    }
    return self;
}

#pragma mark - CustomMethod
- (void)creatUI {
    [self addSubview:self.procedureView];
    [self.procedureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.width.equalTo(@(90));
        make.top.equalTo(@(15));
        make.height.equalTo(@(100));
    }];
    
    UIImageView *procedureImageView = [self.procedureView viewWithTag:100];
    [procedureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.procedureView.mas_centerX);
        make.width.equalTo(@(33));
        make.top.equalTo(self.procedureView).offset(26);
        make.height.equalTo(@(33));
    }];
    
    UILabel *procedureLabel = [self.procedureView viewWithTag:101];
    [procedureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.procedureView).offset(0);
        make.top.mas_equalTo(procedureImageView.mas_bottom).offset(15);
        make.height.equalTo(@(20));
    }];
    
    [self addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.procedureView.mas_width);
        make.top.mas_equalTo(self.procedureView.mas_top);
        make.height.mas_equalTo(self.procedureView.mas_height);
    }];
    
    UIImageView *orderImageView = [self.orderView viewWithTag:200];
    [orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.orderView.mas_centerX);
        make.width.equalTo(@(35));
        make.top.equalTo(self.orderView).offset(23);
        make.height.equalTo(@(37));
    }];
    
    UILabel *orderLabel = [self.orderView viewWithTag:201];
    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.orderView).offset(0);
        make.top.mas_equalTo(procedureLabel.mas_top);
        make.height.mas_equalTo(procedureLabel.mas_height);
    }];
    
    [self addSubview:self.customerView];
    [self.customerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.width.mas_equalTo(self.orderView.mas_width);
        make.top.mas_equalTo(self.orderView.mas_top);
        make.height.mas_equalTo(self.orderView.mas_height);
    }];
    
    UIImageView *customerImageView = [self.customerView viewWithTag:300];
    [customerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.customerView.mas_centerX);
        make.width.equalTo(@(35));
        make.top.equalTo(self.customerView).offset(25);
        make.height.equalTo(@(32));
    }];
    
    UILabel *customerLabel = [self.customerView viewWithTag:301];
    [customerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.customerView).offset(0);
        make.top.mas_equalTo(orderLabel.mas_top);
        make.height.mas_equalTo(orderLabel.mas_height);
    }];
    
    [self addSubview:self.applyButton];
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.right.equalTo(self).offset(-80);
        make.top.mas_equalTo(self.customerView.mas_bottom).offset(30);
        make.height.equalTo(@(40));
    }];
    [self.applyButton layoutIfNeeded];
    self.applyButton.layer.cornerRadius = self.applyButton.size.height / 2;
}

- (void)refreshDataWithType:(NSInteger)type {
    UILabel *procedureLabel = [self.procedureView viewWithTag:101];
    if (type == 1) {
        //代理方
        procedureLabel.text = @"代理流程";
        if ([DDUserManager share].user.isExtensionUser == 1 || [DDUserManager share].user.isExtensionUser == 2) {
            //代理方认证通过、审核中
            self.applyButton.hidden = YES;
        }else {
            self.applyButton.hidden = NO;
            [self.applyButton setTitle:@"申请代理方" forState:UIControlStateNormal];
        }
    }else {
        //实施方
        procedureLabel.text = @"实施流程";
        if ([DDUserManager share].user.isOnlineUser == 1 || [DDUserManager share].user.isOnlineUser == 2) {
            //实施方认证通过、审核中
            self.applyButton.hidden = YES;
        }else {
            self.applyButton.hidden = NO;
            [self.applyButton setTitle:@"申请实施方" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - ClickMethod
//点击功能
- (void)click:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickIndex:)]) {
        [self.delegate clickIndex:tap.view.tag];
    }
}

//点击申请
- (void)applyclick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyClick)]) {
        [self.delegate applyClick];
    }
}

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
- (UIView *)procedureView {
    if (!_procedureView) {
        _procedureView = [[UIView alloc] init];
        _procedureView.backgroundColor = [UIColor whiteColor];
        _procedureView.userInteractionEnabled = YES;
        _procedureView.tag = 1;
        //添加阴影效果
        _procedureView.layer.masksToBounds = false;
        _procedureView.layer.shadowOffset = CGSizeMake(0, 3);
        _procedureView.layer.shadowOpacity = 0.3;
        _procedureView.layer.shadowRadius = 3;
        _procedureView.layer.shadowColor = [UIColor blackColor].CGColor;
        _procedureView.layer.cornerRadius = 10.0;
        
        UIImageView *procedureImageView = [[UIImageView alloc] init];
        procedureImageView.image = [UIImage imageNamed:@"IdentityDetail_Procedure"];
        procedureImageView.tag = 100;
        [_procedureView addSubview:procedureImageView];
        
        UILabel *procedureLabel = [[UILabel alloc] init];
        procedureLabel.textColor = [UIColor blackColor];
        procedureLabel.font = [UIFont systemFontOfSize:14];
        procedureLabel.textAlignment = NSTextAlignmentCenter;
        procedureLabel.tag = 101;
        [_procedureView addSubview:procedureLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [_procedureView addGestureRecognizer:tap];
    }
    return _procedureView;
}

- (UIView *)orderView {
    if (!_orderView) {
        _orderView = [[UIView alloc] init];
        _orderView.backgroundColor = [UIColor whiteColor];
        _orderView.userInteractionEnabled = YES;
        _orderView.tag = 2;
        //添加阴影效果
        _orderView.layer.masksToBounds = false;
        _orderView.layer.shadowOffset = CGSizeMake(0, 3);
        _orderView.layer.shadowOpacity = 0.3;
        _orderView.layer.shadowRadius = 3;
        _orderView.layer.shadowColor = [UIColor blackColor].CGColor;
        _orderView.layer.cornerRadius = 10.0;
        
        UIImageView *orderImageView = [[UIImageView alloc] init];
        orderImageView.image = [UIImage imageNamed:@"IdentityDetail_Order"];
        orderImageView.tag = 200;
        [_orderView addSubview:orderImageView];
        
        UILabel *orderLabel = [[UILabel alloc] init];
        orderLabel.text = @"我的订单";
        orderLabel.textColor = [UIColor blackColor];
        orderLabel.font = [UIFont systemFontOfSize:14];
        orderLabel.textAlignment = NSTextAlignmentCenter;
        orderLabel.tag = 201;
        [_orderView addSubview:orderLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [_orderView addGestureRecognizer:tap];
    }
    return _orderView;
}

- (UIView *)customerView {
    if (!_customerView) {
        _customerView = [[UIView alloc] init];
        _customerView.backgroundColor = [UIColor whiteColor];
        _customerView.userInteractionEnabled = YES;
        _customerView.tag = 3;
        //添加阴影效果
        _customerView.layer.masksToBounds = false;
        _customerView.layer.shadowOffset = CGSizeMake(0, 3);
        _customerView.layer.shadowOpacity = 0.3;
        _customerView.layer.shadowRadius = 3;
        _customerView.layer.shadowColor = [UIColor blackColor].CGColor;
        _customerView.layer.cornerRadius = 10.0;
        
        UIImageView *customerImageView = [[UIImageView alloc] init];
        customerImageView.image = [UIImage imageNamed:@"IdentityDetail_Customer"];
        customerImageView.tag = 300;
        [_customerView addSubview:customerImageView];
        
        UILabel *customerLabel = [[UILabel alloc] init];
        customerLabel.text = @"我的客户";
        customerLabel.textColor = [UIColor blackColor];
        customerLabel.font = [UIFont systemFontOfSize:14];
        customerLabel.textAlignment = NSTextAlignmentCenter;
        customerLabel.tag = 301;
        [_customerView addSubview:customerLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [_customerView addGestureRecognizer:tap];
    }
    return _customerView;
}

- (UIButton *)applyButton {
    if (!_applyButton) {
        _applyButton = [[UIButton alloc] init];
        _applyButton.backgroundColor = [UIColor colorWithRed:41 / 255.0 green:150 / 255.0 blue:235 / 255.0 alpha:1.0];
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _applyButton.tag = 4;
        [_applyButton addTarget:self action:@selector(applyclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
