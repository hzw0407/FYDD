//
//  DDRequestionAllView.h
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDRequstionRecordObj.h"


@interface DDRequestionAllView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView * collectionView;
@property (weak, nonatomic) IBOutlet UIButton *questionNumberView;
@property (nonatomic,strong) NSArray * requestions;
@property (nonatomic,copy) void (^requestionBlock)(DDRequstionRecordObj * obj);
@end

