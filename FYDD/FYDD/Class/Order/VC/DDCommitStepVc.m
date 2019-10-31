//
//  DDCommitStepVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.

#import "DDCommitStepVc.h"
#import "DDOrdeStepImageView.h"
#import "YYPhotoGroupView.h"
#import <SDWebImage/SDWebImage.h>
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>

@interface DDCommitStepVc () <UITextViewDelegate>{
    NSMutableArray * _urls;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHib;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *stepLb;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *stepYQ;//步骤要求

@end

@implementation DDCommitStepVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传实施步骤";
    _urls = @[].mutableCopy;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [self updateUI];
    _textView.delegate = self;
    _stepLb.text = [NSString stringWithFormat:@"%zd",_planModel.step];
    _nameLb.text = _planModel.detailTitle;
    self.stepYQ.numberOfLines = 0;
    self.stepYQ.text = self.planModel.detail;
}

- (void)textViewDidChange:(UITextView *)textView{
    _placeHib.hidden = textView.text.length > 0;
}

- (void)commit{
    NSMutableString * urlTexts = @"".mutableCopy;
    for (NSString * url in _urls) {
        [urlTexts appendFormat:@"%@", url];
        [urlTexts appendFormat:@";"];
    }
    
    NSDictionary * dic= @{
                          @"planId" : _planModel.planId,
                          @"planDetailId" : _planModel.planDetailId,
                          @"id" : yyTrimNullText(_planModel.orderDetailId),
                          @"orderNumber" : _order.orderNumber,
                          @"onlineRemarks" : _textView.text,
                          @"onlineContent" :urlTexts,
                          };// 我的
    @weakify(self)
    [[DDAppNetwork share] get:NO path:[NSString stringWithFormat:@"/t-phase/onlineplan/orderdetail/add?token=%@",[DDUserManager share].user.token] body:[dic modelToJSONString] completion:^(NSInteger code, NSString *message, id data) {
        @strongify(self)
        if (!self) return ;
        if(code == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [DDHub hub:message view:self.view];
        }
    }];

}

- (void)updateUI{
    [_scrollView removeAllSubviews];
    
    double width = (kScreenSize.width - 30) / 4;
    double left = 0;
    double top = 0;
    for (NSInteger i =0; i <=_urls.count ; i++) {
        DDOrdeStepImageView * stepView = [self getStepImageView];
        if ((i) % 4 == 0 && i > 0) {
            top += width;
            left = 0;
        }else {
            left = (width)*(i % 4);
        }
        if (i == _urls.count) {
            stepView.iconView.image = [UIImage imageNamed:@"icon_upload_img"];
            stepView.closeBtn.hidden = YES;
        }else {
            stepView.closeBtn.hidden = NO;
            [stepView.iconView sd_setImageWithURL:[NSURL URLWithString:_urls[i]]];
        }
      
        stepView.tag = i;
        stepView.left = left;
        stepView.top = top;
        stepView.size = CGSizeMake(width, width);
        [_scrollView addSubview:stepView];
    }
}

- (DDOrdeStepImageView *)getStepImageView{
    DDOrdeStepImageView * stepView = [[[NSBundle mainBundle] loadNibNamed:@"DDOrdeStepImageView" owner:nil options:nil] lastObject];
    @weakify(self)
    @weakify(stepView);
    stepView.stepOrderButtonDidClick = ^(NSInteger index) {
        @strongify(self)
        if (!self) return ;
        if (index == 0) {
            [self->_urls removeObjectAtIndex:weak_stepView.tag];
            [self updateUI];
        }else {
            if (weak_stepView.tag == self->_urls.count) {
                [self uploadImage];
            }else {
                NSMutableArray *items = [NSMutableArray new];
                YYPhotoGroupItem *groupItem = [YYPhotoGroupItem new];
                groupItem.thumbView = weak_stepView.iconView;
                groupItem.largeImageURL = [NSURL URLWithString:self->_urls[weak_stepView.tag]];
                [items addObject:groupItem];
                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
                [v presentFromImageView:weak_stepView.iconView toContainer:self.navigationController.view animated:YES completion:nil];
            }
        }
    };
    return stepView;
}


- (void)uploadImage{
    [self showPhotoActionSheetCompletion:^(bool suc,
                                           NSString *url) {
        if(suc) {
            [self->_urls addObject:yyTrimNullText(url)];
        }
        [self updateUI];
    }];
}

- (void)showPhotoActionSheetCompletion:(void (^)(bool suc ,NSString * url ) )completion{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.configuration.maxSelectCount = 1;
    actionSheet.configuration.maxPreviewCount = 10;
    actionSheet.configuration.navBarColor = [UIColor whiteColor];
    actionSheet.configuration.navTitleColor = UIColorHex(0x193750);
    actionSheet.configuration.allowRecordVideo = NO;
    actionSheet.configuration.allowSelectGif = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    @weakify(self)
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images,
                                       NSArray<PHAsset *> * _Nonnull assets,
                                       BOOL isOriginal) {
        @strongify(self)
        if (!self) return ;
        [self uploadImage:[images firstObject] completion:completion];
    }];
    
    actionSheet.sender = self;
    actionSheet.cancleBlock = ^{
        NSLog(@"取消选择图片");
    };
    [actionSheet showPreviewAnimated:YES];
}


- (void)uploadImage:(UIImage*)image
         completion:(void (^)(bool suc ,NSString * url ) )completion{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] path:@"/uas/st/upload"
                        upload:image
                    completion:^(NSInteger code,
                                 NSString *message,
                                 id data) {
                        @strongify(self)
                        if (!self) return ;
                        [DDHub dismiss:self.view];
                        if (code == 200) {
                            if (completion) completion(YES, message);
                            
                        }else {
                            [DDHub hub:message view:self.view];
                            if(completion) completion(NO, nil);
                        }
                    }];
}




@end
