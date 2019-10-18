//
//  DDProductOrderOnlineCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductOrderOnlineCell.h"

@implementation DDProductOrderOnlineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _nextButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _nextButton.layer.shadowOffset = CGSizeMake(0,3);
    _nextButton.layer.shadowRadius = 6;
    _nextButton.layer.shadowOpacity = 1;
    _nextButton.layer.cornerRadius = 20;
    _searchBar.delegate = self;
}
- (IBAction)nextButtonDidClick:(UIButton *)sender {
    
    if (_onlineBlock) {
        _onlineBlock(1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setObj:(DDProductDetailObj *)obj{
    _obj = obj;
    _iconView.image = [UIImage imageNamed:_obj.isSystemOnline ? @"icon_order_selected" : @"icon_order_unselected"];
    _nameLb.text = obj.isSystemOnline ?  @"" : obj.onlineModel.userName;
    _phoneLb.text = obj.isSystemOnline ?  @"" : obj.onlineModel.userPhone;;
}

- (IBAction)sysButtonDidClick:(UIButton *)sender {
    _obj.isSystemOnline = YES;
    self.obj = _obj;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (_onlineSeachBarBlock) {
        _onlineSeachBarBlock(searchBar.text);
    }
}





@end
