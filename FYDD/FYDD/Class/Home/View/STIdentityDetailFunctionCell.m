//
//  STIdentityDetailFunctionCell.m
//  FYDD
//
//  Created by 何志武 on 2019/10/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "STIdentityDetailFunctionCell.h"

@interface STIdentityDetailFunctionCell ()

@property (nonatomic, strong) UIButton *procedureButton;//流程
@property (nonatomic, strong) UIButton *orderButton;//订单
@property (nonatomic, strong) UIButton *customerButton;//客户
@property (nonatomic, strong) UIButton *applyButton;//申请

@end

@implementation STIdentityDetailFunctionCell
#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat spaceWidth = (kScreenWidth - 210) / 4;
        [self addSubview:self.procedureButton];
        [self.procedureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(spaceWidth);
            make.width.equalTo(@(70));
            make.top.equalTo(@(15));
            make.height.equalTo(@(70));
        }];
        [self.procedureButton layoutIfNeeded];
        self.procedureButton.layer.cornerRadius = self.procedureButton.size.height / 2;
        
        [self addSubview:self.orderButton];
        [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.procedureButton.mas_right).offset(spaceWidth);
            make.width.mas_equalTo(self.procedureButton.mas_width);
            make.top.mas_equalTo(self.procedureButton.mas_top);
            make.height.mas_equalTo(self.procedureButton.mas_height);
        }];
        [self.orderButton layoutIfNeeded];
        self.orderButton.layer.cornerRadius = self.orderButton.size.height / 2;
        
        [self addSubview:self.customerButton];
        [self.customerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.orderButton.mas_right).offset(spaceWidth);
            make.width.mas_equalTo(self.orderButton.mas_width);
            make.top.mas_equalTo(self.orderButton.mas_top);
            make.height.mas_equalTo(self.orderButton.mas_height);
        }];
        [self.customerButton layoutIfNeeded];
        self.customerButton.layer.cornerRadius = self.customerButton.size.height / 2;
        
        [self addSubview:self.applyButton];
        [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.top.mas_equalTo(self.customerButton.mas_bottom).offset(10);
            make.height.equalTo(@(30));
        }];
        [self.applyButton layoutIfNeeded];
        self.applyButton.layer.cornerRadius = self.applyButton.size.height / 2;
        
    }
    return self;
}

#pragma mark - CustomMethod
- (void)refreshDataWithType:(NSInteger)type {
    if (type == 1) {
        //代理方
        [self.procedureButton setTitle:@"代理流程" forState:UIControlStateNormal];
        [self.applyButton setTitle:@"申请代理方" forState:UIControlStateNormal];
    }else {
        //实施方
        [self.procedureButton setTitle:@"实施流程" forState:UIControlStateNormal];
        [self.applyButton setTitle:@"申请实施方" forState:UIControlStateNormal];
    }
}

#pragma mark - ClickMethod

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
- (UIButton *)procedureButton {
    if (!_procedureButton) {
        _procedureButton = [[UIButton alloc] init];
        [_procedureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _procedureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _procedureButton.layer.borderWidth = 1;
        _procedureButton.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _procedureButton;
}

- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [[UIButton alloc] init];
        [_orderButton setTitle:@"我的订单" forState:UIControlStateNormal];
        [_orderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _orderButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _orderButton.layer.borderWidth = 1;
        _orderButton.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _orderButton;
}

- (UIButton *)customerButton {
    if (!_customerButton) {
        _customerButton = [[UIButton alloc] init];
        [_customerButton setTitle:@"我的客户" forState:UIControlStateNormal];
        [_customerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _customerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _customerButton.layer.borderWidth = 1;
        _customerButton.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _customerButton;
}

- (UIButton *)applyButton {
    if (!_applyButton) {
        _applyButton = [[UIButton alloc] init];
        _applyButton.backgroundColor = [UIColor blackColor];
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:14];
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
