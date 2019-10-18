//
//  DDQuestionItemCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDRequstionRecordObj.h"


@interface DDQuestionItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionLb;
@property (nonatomic,strong) DDRequstionRecordObj * recordObj;
@end

