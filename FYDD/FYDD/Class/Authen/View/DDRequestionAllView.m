//
//  DDRequestionAllView.m
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDRequestionAllView.h"
#import "DDQuestionItemCell.h"

@implementation DDRequestionAllView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(@60);
    }];
}

- (void)setRequestions:(NSArray *)requestions{
    _requestions = requestions;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView{
    if (!_collectionView){
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenSize.width /7 , kScreenSize.width / 7);
        layout.minimumLineSpacing =  0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"DDQuestionItemCell" bundle:nil] forCellWithReuseIdentifier:@"DDQuestionItemCellId"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _requestions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDQuestionItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDQuestionItemCellId" forIndexPath:indexPath];
    cell.recordObj = _requestions[indexPath.row];
    cell.questionLb.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_requestionBlock) {
        _requestionBlock(_requestions[indexPath.row]);
    }
}

@end
