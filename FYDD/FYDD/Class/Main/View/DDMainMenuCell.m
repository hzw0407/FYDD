//
//  DDMainMenuCell.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMainMenuCell.h"
#import "DDMainMenuCellView.h"

@implementation DDMainMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)setMenuDatas:(NSArray<NSDictionary *> *)data{
    [self.contentView removeAllSubviews];
    for (NSInteger i = 0 ; i < data.count ; i++){
        DDMainMenuCellView * menu = [self getMenuView];
        menu.tag = i;
        NSDictionary * dic = data[i];
        CGFloat width = kScreenSize.width / data.count;
        menu.frame = CGRectMake(i * width, 0, width, self.contentView.frame.size.height);
        menu.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        menu.iconView.image = [UIImage imageNamed:dic[@"icon"]];
        menu.nameLB.text = dic[@"text"];
        [self.contentView addSubview:menu];
    }
}

- (DDMainMenuCellView *)getMenuView{
    DDMainMenuCellView * menu = [[[NSBundle mainBundle] loadNibNamed:@"DDMainMenuCellView" owner:nil options:nil] lastObject];
    menu.event = _event;
    return menu;
}

@end
