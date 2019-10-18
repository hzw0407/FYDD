//
//  DDInputCell.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface DDInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textTd;
@property (weak, nonatomic) IBOutlet UIImageView *upView;
@property (strong, nonatomic) NSIndexPath * indexPath;

@property (nonatomic,copy) DDInputCellTextChange textChange;
@property (nonatomic,copy) DDcommitButtonBlock codeBlock;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (nonatomic,assign) NSInteger maxLimit;

// 开始计时
- (void)start;
// 结束
- (void)stop;

@end

