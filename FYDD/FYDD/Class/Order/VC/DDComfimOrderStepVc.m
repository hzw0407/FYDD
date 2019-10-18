//
//  DDComfimOrderStepVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDComfimOrderStepVc.h"

@interface DDComfimOrderStepVc () <UIPickerViewDelegate,UIPickerViewDataSource>{
    NSArray * _componetDataNames;
    NSMutableDictionary * _rowValues;
    NSInteger _currentType;
}
@property (weak, nonatomic) IBOutlet UILabel *orderLb;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *oneLb;
@property (weak, nonatomic) IBOutlet UIButton *zhuanyeButton;
@property (weak, nonatomic)  UIButton *tempButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation DDComfimOrderStepVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"满意度调查";
    _tempButton = _zhuanyeButton;
//    _commitButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
//    _commitButton.layer.shadowOffset = CGSizeMake(0,3);
//    _commitButton.layer.shadowRadius = 6;
//    _commitButton.layer.shadowOpacity = 1;
//    _commitButton.layer.cornerRadius = 20;
    
    _scrollView.contentSize = CGSizeMake(0, 700);
    _contentView.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    _contentView.layer.borderWidth = 1;
    _contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _contentView.layer.cornerRadius = 10;
    
    _pickView.delegate = self;
    _pickView.dataSource = self;
    
    _orderLb.text = _order.orderNumber;
    _productName.text = _order.productName;
    _oneLb.text = _order.onlineName;
    _rowValues = @{@"0" : @(2),
                   @"1" : @(2),
                   @"2" : @(2),
                   }.mutableCopy;
    _componetDataNames = @[@"非常满意",@"比较满意",@"满意",@"一般",@"一般般"];
    [self.pickView selectRow:[self getCurrentRow] inComponent:0 animated:YES];
    [self.pickView reloadComponent:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitButtonDidClick)];
}

- (NSInteger)getCurrentRow {
    return [_rowValues[[NSString stringWithFormat:@"%zd",_currentType]] integerValue];
}

- (IBAction)commentTypeButtonDidClick:(UIButton *)sender {
    if (sender == _tempButton) return;
    _currentType = sender.tag;
    [self.pickView selectRow:[self getCurrentRow] inComponent:0 animated:YES];
    [self.pickView reloadComponent:0];
    sender.selected = YES;
    sender.backgroundColor = UIColorHex(0x2996EB);
    _tempButton.selected = NO;
    _tempButton.backgroundColor = UIColorHex(0xF3F4F6);
    _tempButton = sender;
}

- (void)commitButtonDidClick {
    NSDictionary * dic= @{
                          @"evaluate1" : @(5-  [[_rowValues objectForKey:@"0"] integerValue]),
                          @"evaluate2" : @(5 - [[_rowValues objectForKey:@"1"] integerValue]),
                          @"evaluate3" : @(5 - [[_rowValues objectForKey:@"2"] integerValue]),
                          @"userDetail " : yyTrimNullText(_textView.text),
                          @"status" : @(1),
                          @"planId" : _planModel.planId,
                          @"planDetailId" : _planModel.planDetailId,
                          @"orderNumber" : _order.orderNumber,
//                          @"onlineRemarks" :yyTrimNullText(_textView.text),
                          @"id" : _planModel.orderDetailId,
                          };
    @weakify(self)
    [[DDAppNetwork share] get:NO path:[NSString stringWithFormat:@"/t-phase/onlineplan/orderdetail/update?token=%@",[DDUserManager share].user.token] body:[dic modelToJSONString] completion:^(NSInteger code, NSString *message, id data) {
        @strongify(self)
        if (!self) return ;
        if(code == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [DDHub hub:message view:self.view];
        }
    }];
}

#pragma mark - dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _componetDataNames.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_componetDataNames[row] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [self getCurrentRow] == row ? UIColorHex(0xEF8200) : UIColorHex(0x56585A)}];
    return string;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [_rowValues setObject:@(row) forKey:[NSString stringWithFormat:@"%zd",_currentType]];
    [self.pickView reloadComponent:0];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 38;
}


@end
