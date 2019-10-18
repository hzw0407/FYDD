//
//  DDOrderTranferCell.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDOrderTranferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;
@property (weak, nonatomic) IBOutlet UILabel *companyNoLb;
@property (weak, nonatomic) IBOutlet UILabel *companyBankLb;
@property (weak, nonatomic) IBOutlet UITextField *liushuimaLb;
@property (weak, nonatomic) IBOutlet UIButton *camaraBtn;
@property (nonatomic,copy) DDcommitButtonValueBlock block;
@property (nonatomic,copy) DDInputTextBlock textBlock;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (nonatomic,copy) void (^phoneCallButtonDidClick)();
- (void)setImageURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
