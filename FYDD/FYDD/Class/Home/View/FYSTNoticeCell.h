//
//  FYSTNoticeCell.h
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProductItemView.h"
#import "DDProductObj.h"
#import "DDMessageModel.h"

@interface FYSTNoticeCell : UITableViewCell {
    double _contentWidth;
    double _contentLeft;
    NSTimer * _timer;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *messageContentView;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
@property (weak, nonatomic) IBOutlet UIScrollView *productContainerView;
@property (nonatomic,copy) void (^itemBlock)(NSInteger type);
@property (nonatomic,copy) void (^moduleBlock)(NSInteger type);
@property (nonatomic,copy) void (^messageBlock)(NSInteger type);
@property (nonatomic,strong) NSArray *productObjs;
@property (nonatomic,strong) NSArray * messages;
@end


