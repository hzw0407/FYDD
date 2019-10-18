//
//  DDCarryUserCell3.h
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCarryUserCell3 : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *textContentView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong) NSArray * urls;

@property (nonatomic,copy) void (^addBlock)(void);
@property (nonatomic,copy) void (^removeBlock)(NSInteger);
@property (nonatomic,copy) void (^showBlock)(UIImageView * originView,NSString * url);
@property (nonatomic,copy) void (^textChangeBlock)(NSString * text);
@property (nonatomic,copy) void (^commitBlock)(void);
@end

NS_ASSUME_NONNULL_END
