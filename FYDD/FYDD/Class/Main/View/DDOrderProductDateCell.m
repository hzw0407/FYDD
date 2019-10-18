//
//  DDOrderProductDateCell.m
//  FYDD
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderProductDateCell.h"

@interface DDOrderProductDateCell(){
    NSArray * dataList;
}

@end

@implementation DDOrderProductDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _pickView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _items.count;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * textLb = [UILabel new];
    textLb.text = _items[row].packageTitle;
    textLb.textAlignment = NSTextAlignmentCenter;
    textLb.textColor = UIColorHex(0x549BF3);
    textLb.font = [UIFont systemFontOfSize:20];
    return textLb;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_event) {
        _event(_items[row]);
    }
}


@end
