//
//  DDProductItem.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductItem.h"
#import <YYKit/NSString+YYAdd.h>
@implementation DDProductItem
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"itemId":@"id"};
}

-(void)layout{
//    CGFloat cellHight = 100;
    /*
    if (_isShowPrice) {
        cellHight += 50;
    }
    CGFloat max_width = 0;
    CGFloat limit_width = ((kScreenSize.width - 24) - 50) * 0.5;
    
    for (NSInteger i = 0 ; i < _texts.count ; i ++ ){
        NSString * text = _texts[i];
        CGFloat width = [text sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(10000, 20) mode:NSLineBreakByWordWrapping].width;
        if (width > max_width) {
            max_width = width;
        }
    }
    
    // 计算高度
    CGFloat left = 12;
    CGFloat top = 0;
    CGFloat width = max_width > limit_width ? (kScreenSize.width - 24) : limit_width;
    CGFloat height = 25;
    
    NSMutableArray * items = @[].mutableCopy;
    for (NSInteger i = 0 ; i < _texts.count ; i ++ ){
        NSString * text = _texts[i];
        height = [text sizeForFont:[UIFont systemFontOfSize:13] size:CGSizeMake(width, 5000) mode:NSLineBreakByWordWrapping].height;
        DDProductDescTextItem * item = [DDProductDescTextItem new];
        item.text = text;
        
        if (height < 25) {
            height =  30;
        }

        if (max_width < limit_width) {
            left = 12 + (50 + limit_width) * (i%2);
            if (i % 2 == 0 && i > 0) {
                top += height;
            }
        }else {
            if (i > 0) {
                top += height;
            }
        }
        item.frame  = CGRectMake(left, top, width, height);
        [items addObject:item];
    }
    
    _cellHeight = cellHight + top + 35;
    _textItems = items;
    */
    NSString * desc = [NSString stringWithFormat:@"%@",_describe1];
    if (_describe2) {
        desc = [NSString stringWithFormat:@"%@\n\n%@",desc,_describe2];
    }
    if (_describe3) {
        desc = [NSString stringWithFormat:@"%@\n\n%@",desc,_describe3];
    }
    CGFloat height = [desc sizeForFont:[UIFont systemFontOfSize:13] size:CGSizeMake(kScreenSize.width - 24, 5000) mode:NSLineBreakByWordWrapping].height;
    _contentText = desc;
    _cellHeight = 120 + height;
    if (_cellHeight < 180) {
        _cellHeight = 180;
    }
    
    // J价格
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    NSString * text1 = @"优惠价 ";
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:text1];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = UIColorHex(0xFFDF30);
    dic[NSForegroundColorAttributeName] = UIColorHex(0xFFDF30);
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [attribut addAttributes:dic range:NSMakeRange(0,text1.length)];

    NSString * text2 = [NSString stringWithFormat:@"¥%.2f",_salePrice];
    NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    dic2[NSFontAttributeName] = [UIFont boldSystemFontOfSize:15];
    dic2[NSForegroundColorAttributeName] = UIColorHex(0xFFDF30);
    [attribut2 addAttributes:dic2 range:NSMakeRange(0,text2.length)];
    
    NSString * text3 = [NSString stringWithFormat:@"/%@ %.1f折",_useTimeText,_discount];
    NSMutableAttributedString *attribut3 = [[NSMutableAttributedString alloc]initWithString:text3];
    [attribut3 addAttributes:dic range:NSMakeRange(0,text3.length)];
    
    [priceAtt appendAttributedString:attribut];
    [priceAtt appendAttributedString:attribut2];
    [priceAtt appendAttributedString:attribut3];
    _priceAttr = priceAtt;

}
- (void)setUseTime:(NSInteger)useTime{
    _useTime = useTime;
    _useTimeText = @"年";
    if (useTime <12) {
        NSArray * time = @[@"一个月",@"两个月",@"三个月",@"四个月",@"五个月",@"半年",@"七个月",@"八个月",@"九个月",@"十个月",@"十一个月",@"年"];
        _useTimeText = [NSString stringWithFormat:@"%@",time[useTime]];
    }
}
@end

@implementation DDProductDescTextItem

@end

@implementation DDProductDetailItem
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"itemId":@"id"};
}
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"list" : [DDProductPriceItem class]};
}
+ (NSAttributedString *)convert:(double)salePrice
                         uptime:(NSString *)uptimetext
                       discount:(NSString *)discount
                    marketPrice:(double)marketPrice{
    
    
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:@"优惠价 "];
    [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,3)];
    
    NSString * text2 = [NSString stringWithFormat:@"¥%.2f",salePrice];
    NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
    [attribut2 addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],
                               NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,text2.length)];
    
    NSString * text3 = [NSString stringWithFormat:@"/%@ %@折\n",uptimetext,discount];
    NSMutableAttributedString *attribut3 = [[NSMutableAttributedString alloc]initWithString:text3];
    [attribut3 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,text3.length)];
    
    NSString * text4 = [NSString stringWithFormat:@"市场价 ¥%.2f/%@",marketPrice,uptimetext];
    NSMutableAttributedString *attribut4 = [[NSMutableAttributedString alloc]initWithString:text4];
    [attribut4 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                               } range:NSMakeRange(0,text4.length)];
    
    
    [priceAtt appendAttributedString:attribut1];
    [priceAtt appendAttributedString:attribut2];
    [priceAtt appendAttributedString:attribut3];
    [priceAtt appendAttributedString:attribut4];
    return priceAtt;
}



@end

@implementation DDProductPriceItem
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"priceId":@"id"};
}


- (void)setUseTime:(NSInteger)useTime{
    _useTime = useTime;
    _useTimeText = @"年";
    if (useTime <12) {
        NSArray * time = @[@"一个月",@"两个月",@"三个月",@"四个月",@"五个月",@"半年",@"七个月",@"八个月",@"九个月",@"十个月",@"十一个月",@"一年"];
        _useTimeText = [NSString stringWithFormat:@"%@",time[useTime]];
    }
}
@end
