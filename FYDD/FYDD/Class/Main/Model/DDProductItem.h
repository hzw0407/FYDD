//
//  DDProductItem.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DDProductPriceItem;

@interface DDProductDescTextItem : NSObject
@property (nonatomic,copy) NSString * text;
@property (nonatomic,assign) CGRect frame;
@end


// 产品信息
@interface DDProductItem : NSObject
/*
@property (nonatomic,assign) BOOL isShowPrice;
@property (nonatomic,strong) NSArray <DDProductDescTextItem *>*textItems;
@property (nonatomic,strong) NSArray <NSString *>*texts;
 */

@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong) NSAttributedString * priceAttr;
// 产品信息
@property (nonatomic,copy) NSString * describe1;
@property (nonatomic,copy) NSString * describe2;
@property (nonatomic,copy) NSString * describe3;
@property (nonatomic,copy) NSString * contentText;
@property (nonatomic,assign) double discount;     // 折扣
@property (nonatomic,assign) NSInteger itemId;       // 产品id
@property (nonatomic,assign) NSInteger inventory;   // 存库
@property (nonatomic,assign) double marketPrice; // 市场价额
@property (nonatomic,assign) NSInteger packageId;
@property (nonatomic,copy) NSString* packageTitle; // 规格名称
@property (nonatomic,copy) NSString* peopleBuy;   // 购买人数
@property (nonatomic,copy) NSString* productDetails; // 产品详情
@property (nonatomic,copy) NSString* productName; // 产品名称
@property (nonatomic,copy) NSString* readNumber; // 阅读次数
@property (nonatomic,assign) double salePrice; // 销售价格
@property (nonatomic,copy) NSString* selling;
@property (nonatomic,assign) NSInteger sort;
@property (nonatomic,assign) NSInteger useTime; // 产品期限/月
@property (nonatomic,copy) NSString * useTimeText;

@property (nonatomic,copy) NSString* shareTitle; // 产品详情
@property (nonatomic,copy) NSString* shareImage; // 产品名称
@property (nonatomic,copy) NSString* shareContext; // 阅读次数
@property (nonatomic,copy) NSString* backImg; // 阅读次数
- (void)layout;
@end

@interface DDProductDetailItem :NSObject
@property (nonatomic,copy) NSString* createDate;
@property (nonatomic,assign) NSInteger deploymentTime;
@property (nonatomic,copy) NSString* describe1;
@property (nonatomic,assign) NSInteger itemId;
@property (nonatomic,assign) NSInteger inventory;
@property (nonatomic,assign) NSInteger keyword;
@property (nonatomic,copy) NSString* productName;

@property (nonatomic,copy) NSString* masterGraph;
@property (nonatomic,assign) NSInteger packageId;
@property (nonatomic,copy) NSString* peopleBuy;
@property (nonatomic,assign) double price;
@property (nonatomic,copy) NSString* productBrief;
@property (nonatomic,copy) NSString* productCategories;
@property (nonatomic,copy) NSString* productDetails;
@property (nonatomic,assign) NSInteger putaway;

@property (nonatomic,copy) NSString* readNumber;
@property (nonatomic,copy) NSString* selling;
@property (nonatomic,copy) NSString* shareContext;
@property (nonatomic,copy) NSString* productSharePath;

@property (nonatomic,copy) NSString* shareImage;
@property (nonatomic,copy) NSString* shareTitle;
@property (nonatomic,copy) NSString* unitType;

@property (nonatomic,strong) NSArray <DDProductPriceItem *>*list;

+ (NSAttributedString *)convert:(double)salePrice
                         uptime:(NSString *)uptimetext
                       discount:(NSString *)discount
                    marketPrice:(double)marketPrice;
@end


@interface DDProductPriceItem:NSObject
@property (nonatomic,copy) NSString* discount;
@property (nonatomic,assign) NSInteger priceId;
@property (nonatomic,assign) double marketPrice;
@property (nonatomic,copy) NSString* packageTitle;
@property (nonatomic,assign) NSInteger productId;
@property (nonatomic,assign) NSInteger salePrice;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger useTime;
@property (nonatomic,copy) NSString * useTimeText;
@end


