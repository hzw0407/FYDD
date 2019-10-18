//
//  DDBannerCell.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDBannerCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface  DDBannerCell() <SDCycleScrollViewDelegate>{
    SDCycleScrollView *_cycleScrollView;
}

@end

@implementation DDBannerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenSize.width, (kScreenSize.width / 375.0) * 180) delegate:self placeholderImage:nil];
    [self.contentView addSubview:_cycleScrollView];
    _cycleScrollView.imageURLStringsGroup = @[];
    _cycleScrollView.autoScrollTimeInterval = 5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (_event) {
        _event(index);
    }
}

- (void)setBanners:(NSArray<DDBannerTopModel *> *)banners{
    _banners = banners;
    NSMutableArray * datas = @[].mutableCopy;
    for (NSInteger i =0;i<banners.count;i++){
        DDBannerTopModel * model = banners[i];
        [datas addObject:yyTrimNullText(model.imageUrl)];
    }
    _cycleScrollView.imageURLStringsGroup = datas;
}

@end
