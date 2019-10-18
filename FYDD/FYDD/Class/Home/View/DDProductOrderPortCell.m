//
//  DDProductOrderPortCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductOrderPortCell.h"

@implementation DDProductOrderPortCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _pickView.delegate = self;
    _pickView.dataSource = self;
}

- (void)setDetailObj:(DDProductDetailObj *)detailObj{
    _detailObj = detailObj;
    [self.pickView reloadAllComponents];
    [self updateUI];
}

- (void)updateUI{
    _softPriceLb.text = [NSString stringWithFormat:@"¥%.f元",_detailObj.port.afterMarketPrice];
    _onlinePriceLb.text = [NSString stringWithFormat:@"¥%.f元",_detailObj.port.afterImplementPrice];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"费用合计" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:171/255.0 green:174/255.0 blue:177/255.0 alpha:1.0]}];
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" ¥%.f元",_detailObj.port.salePrice] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16], NSForegroundColorAttributeName: [UIColor colorWithRed:239/255.0 green:130/255.0 blue:0/255.0 alpha:1.0]}];
    [string appendAttributedString:string1];
    _totalMoneyLb.attributedText = string;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _detailObj.list.count;
}


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    DDProductPort * port = _detailObj.list[row];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:port.packageTitle attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: _currentRow == row ? UIColorHex(0xEF8200) : UIColorHex(0x56585A)}];
    return string;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _detailObj.port = _detailObj.list[row];
    _currentRow = row;
    [self updateUI];
}

@end
