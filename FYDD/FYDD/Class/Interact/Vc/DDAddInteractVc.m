//
//  DDAddInteractVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAddInteractVc.h"
#import "DDOrdeStepImageView.h"
#import "YYPhotoGroupView.h"
#import <SDWebImage/SDWebImage.h>
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>

@interface DDAddInteractVc () <UITextViewDelegate> {
    NSMutableArray * _urls;
}
@property (weak, nonatomic) IBOutlet UITextField *titlePlaceTd;
@property (weak, nonatomic) IBOutlet UITextView *contenTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;



@end

@implementation DDAddInteractVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"互助编辑";
    
    _contenTextView.delegate = self;
    [self updateImageView];
    _urls = @[].mutableCopy;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitDidClick)];
}

- (void)textViewDidChange:(UITextView *)textView{
    _placeLb.hidden = textView.text.length > 0;
}

- (void)commitDidClick{
    if (yyTrimNullText(_titlePlaceTd.text).length == 0) {
        [DDHub hub:@"请输入互助标题" view:self.view];
        return;
    }
    if (yyTrimNullText(_contenTextView.text).length == 0) {
        [DDHub hub:@"请输入互助内容" view:self.view];
        return;
    }
    @weakify(self)
    [DDHub hub:self.view];
    NSMutableString * imageURLs = @"".mutableCopy;
    for (NSString * text in _urls) {
        [imageURLs appendString:text];
        [imageURLs appendString:@"|"];
    }
    
    NSString * url = [NSString stringWithFormat:@"%@/helpEachOther/add?token=%@",DDAPP_2T_URL,[DDUserManager share].user.token];
    NSDictionary * dic = @{@"title" : yyTrimNullText(_titlePlaceTd.text),
                           @"contents" : yyTrimNullText(_contenTextView.text),
                           @"showImage" : imageURLs,
                           @"types" : [DDUserManager share].user.userType == DDUserTypePromoter ? @"3" : @"2"
                           };
    [[DDAppNetwork share] get:NO url:url body:[dic modelToJSONString] completion:^(NSInteger code, NSString *message, id data) {
        @strongify(self)
        if (!self) return ;
        if (code == 200) {
            [DDHub hub:@"提交成功" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [DDHub hub:message view:self.view];
        }
    }];
}

- (void)updateImageView{
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
            [self updateImageView];
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
        [self updateImageView];
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
