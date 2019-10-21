//
//  FYSTNoticeCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "FYSTNoticeCell.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/SDWebImage.h>
#import "UIButton+FYCustonButton.h"
#import "SDCycleScrollView.h"

@interface FYSTNoticeCell ()

@property (nonatomic, strong) UIView *newsView;//消息view
@property (nonatomic, strong) UIImageView *hornImageView;//喇叭图片
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;//文字轮播
@property (nonatomic, strong) UIView *plateView;//板块view
@property (nonatomic, strong) UIView *identityView;//身份view
@property (nonatomic, strong) UIView *materialView;//素材view
@property (nonatomic, strong) UILabel *knowledgeLabel;//涨知识
@property (nonatomic, strong) NSArray *tempPlateArray;

@end

@implementation FYSTNoticeCell

#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor redColor];
        
        [self creatUI];
    }
    return self;
}

#pragma mark - CustomMethod
- (void)creatUI {
    [self addSubview:self.newsView];
    [self.newsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(5);
        make.height.equalTo(@(36));
    }];
    
    [self.newsView addSubview:self.hornImageView];
    [self.hornImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newsView).offset(10);
        make.width.equalTo(@(18));
        make.centerY.mas_equalTo(self.newsView.mas_centerY);
        make.height.equalTo(@(18));
    }];
    
    [self.newsView addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hornImageView.mas_right).offset(10);
        make.right.equalTo(self.newsView).offset(-10);
        make.top.bottom.equalTo(self.newsView).offset(0);
    }];
    
    [self addSubview:self.plateView];
    [self.plateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.top.mas_equalTo(self.newsView.mas_bottom).offset(0);
        make.height.equalTo(@(100));
    }];
    
    [self addSubview:self.identityView];
    [self.identityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.top.mas_equalTo(self.plateView.mas_bottom).offset(10);
        make.height.equalTo(@(50));
    }];
    
    CGFloat buttonWidth = (kScreenWidth - 45) / 2;
    UIButton *agentButton = [self.identityView viewWithTag:100];
    [agentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@(buttonWidth));
        make.top.bottom.equalTo(self.identityView).offset(0);
    }];
    [agentButton layoutIfNeeded];
    agentButton.layer.cornerRadius = 5;
    
    UIButton *implementerButton = [self.identityView viewWithTag:101];
    [implementerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.width.equalTo(@(buttonWidth));
        make.top.bottom.equalTo(self.identityView).offset(0);
    }];
    [implementerButton layoutIfNeeded];
    implementerButton.layer.cornerRadius = 5;
    
    [self addSubview:self.materialView];
    [self.materialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.top.mas_equalTo(self.identityView.mas_bottom).offset(10);
        make.height.equalTo(@(100));
    }];
    
    UIImageView *demonstrationImageView = [self.materialView viewWithTag:200];
    [demonstrationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.materialView).offset(10);
        make.width.equalTo(@(50));
        make.centerY.mas_equalTo(self.materialView.mas_centerY);
        make.height.equalTo(@(50));
    }];
    [demonstrationImageView layoutIfNeeded];
    demonstrationImageView.layer.cornerRadius = demonstrationImageView.size.height / 2;
    
    UIButton *demonstrationButton = [self.materialView viewWithTag:201];
    [demonstrationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(demonstrationImageView.mas_right).offset(10);
        make.width.equalTo(@(70));
        make.centerY.mas_equalTo(self.materialView.mas_centerY);
        make.height.equalTo(@(20));
    }];
    
    UIView *lineViewOne = [self.materialView viewWithTag:202];
    [lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(demonstrationButton.mas_right).offset(10);
        make.width.equalTo(@(1));
        make.top.bottom.equalTo(self.materialView).offset(0);
    }];
    
    UIImageView *successCaseImageView = [self.materialView viewWithTag:203];
    [successCaseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineViewOne.mas_right).offset(30);
        make.width.equalTo(@(20));
        make.top.equalTo(self.materialView).offset(15);
        make.height.equalTo(@(20));
    }];
    [successCaseImageView layoutIfNeeded];
    successCaseImageView.layer.cornerRadius = successCaseImageView.size.height / 2;
    
    UIButton *successCaseButton = [self.materialView viewWithTag:204];
    [successCaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(successCaseImageView.mas_right).offset(10);
        make.width.equalTo(@(70));
        make.top.mas_equalTo(successCaseImageView.mas_top);
        make.height.mas_equalTo(successCaseImageView.mas_height);
    }];
    
    UIView *lineViewTwo = [self.materialView viewWithTag:205];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineViewOne.mas_right);
        make.right.equalTo(self.materialView).offset(0);
        make.top.mas_equalTo(successCaseButton.mas_bottom).offset(15);
        make.height.equalTo(@(1));
    }];
    
    UIImageView *failCaseImageView = [self.materialView viewWithTag:206];
    [failCaseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(successCaseImageView.mas_left);
        make.width.mas_equalTo(successCaseImageView.mas_width);
        make.top.mas_equalTo(lineViewTwo.mas_bottom).offset(15);
        make.height.mas_equalTo(successCaseImageView.mas_height);
    }];
    [failCaseImageView layoutIfNeeded];
    failCaseImageView.layer.cornerRadius = failCaseImageView.size.height / 2;
    
    UIButton *failCaseButton = [self.materialView viewWithTag:207];
    [failCaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(successCaseButton.mas_left);
        make.width.mas_equalTo(successCaseButton.mas_width);
        make.top.mas_equalTo(failCaseImageView.mas_top);
        make.height.mas_equalTo(successCaseButton.mas_height);
    }];
    
    [self addSubview:self.knowledgeLabel];
    [self.knowledgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.mas_equalTo(self.materialView.mas_bottom).offset(10);
        make.height.equalTo(@(20));
    }];
}

//刷新模板数据
- (void)refreshPlateWithArray:(NSArray *)plateArray {
    [self.plateView removeAllSubviews];
    self.tempPlateArray = plateArray;
    CGFloat buttonWidth = kScreenWidth / plateArray.count;
    for (NSInteger i = 0; i < plateArray.count; i++) {
        DDProductObj * obj = plateArray[i];
        UIButton *plateButton = [[UIButton alloc] init];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:obj.backImg] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            UIImage *targetImage = [self originImage:image scaleToSize:CGSizeMake(40, 40)];
            [plateButton setImage:targetImage forState:UIControlStateNormal];
        }];
        [plateButton setTitle:obj.productName forState:UIControlStateNormal];
        [plateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        plateButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [plateButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:2];
        plateButton.tag = i;
        [plateButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.plateView addSubview:plateButton];
        [plateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.plateView).offset(buttonWidth * i);
            make.width.equalTo(@(buttonWidth));
            make.top.equalTo(@(0));
            make.height.equalTo(@(100));
        }];
    }
}

//修改图片大小
- (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - ClickMethod
- (void)btnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFunction:)]) {
        [self.delegate clickFunction:btn.tag];
    }
}

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
- (UIView *)newsView {
    if (!_newsView) {
        _newsView = [[UIView alloc] init];
        _newsView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    }
    return _newsView;
}

- (UIImageView *)hornImageView {
    if (!_hornImageView) {
        _hornImageView = [[UIImageView alloc] init];
        _hornImageView.image = [UIImage imageNamed:@"icon_notice1"];
    }
    return _hornImageView;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        //只轮播文字
        _cycleScrollView.onlyDisplayText = YES;
        //轮播文字颜色
        _cycleScrollView.titleLabelTextColor = [UIColor blackColor];
        //轮播文字背景颜色
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _cycleScrollView.titlesGroup = @[@"11111",@"22222",@"33333",@"44444"];
    }
    return _cycleScrollView;
}

- (UIView *)plateView {
    if (!_plateView) {
        _plateView = [[UIView alloc] init];
    }
    return _plateView;
}

- (UIView *)identityView {
    if (!_identityView) {
        _identityView = [[UIView alloc] init];
        
        //代理方
        UIButton *agentButton = [[UIButton alloc] init];
        [agentButton setTitle:@"代理方" forState:UIControlStateNormal];
        [agentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        agentButton.titleLabel.font = [UIFont systemFontOfSize:16];
        agentButton.layer.borderWidth = 1.0;
        agentButton.layer.borderColor = [UIColor blackColor].CGColor;
        agentButton.tag = 100;
        [agentButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_identityView addSubview:agentButton];
        
        
        //实施方
        UIButton *implementerButton = [[UIButton alloc] init];
        [implementerButton setTitle:@"实施方" forState:UIControlStateNormal];
        [implementerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        implementerButton.titleLabel.font = [UIFont systemFontOfSize:16];
        implementerButton.layer.borderWidth = 1.0;
        implementerButton.layer.borderColor = [UIColor blackColor].CGColor;
        implementerButton.tag = 101;
        [implementerButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_identityView addSubview:implementerButton];
        
    }
    return _identityView;
}

- (UIView *)materialView {
    if (!_materialView) {
        _materialView = [[UIView alloc] init];
        
        
        //演示视频图片
        UIImageView *demonstrationImageView = [[UIImageView alloc] init];
//        demonstrationImageView.image = [UIImage imageNamed:@"icon_step1"];
        demonstrationImageView.backgroundColor = [UIColor redColor];
        demonstrationImageView.tag = 200;
        [_materialView addSubview:demonstrationImageView];
        
        //演示视频
        UIButton *demonstrationButton = [[UIButton alloc] init];
        [demonstrationButton setTitle:@"演示视频" forState:UIControlStateNormal];
        [demonstrationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        demonstrationButton.titleLabel.font = [UIFont systemFontOfSize:16];
        demonstrationButton.tag = 201;
        [demonstrationButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_materialView addSubview:demonstrationButton];
        
        //线
        UIView *lineViewOne = [[UIView alloc] init];
        lineViewOne.backgroundColor = [UIColor grayColor];
        lineViewOne.tag = 202;
        [_materialView addSubview:lineViewOne];
        
        //成功案例图片
        UIImageView *successCaseImageView = [[UIImageView alloc] init];
//        successCaseImageView.image = [UIImage imageNamed:@"icon_step2"];
        successCaseImageView.backgroundColor = [UIColor blueColor];
        successCaseImageView.tag = 203;
        [_materialView addSubview:successCaseImageView];
        
        //成功案例
        UIButton *successCaseButton = [[UIButton alloc] init];
        [successCaseButton setTitle:@"成功案例" forState:UIControlStateNormal];
        [successCaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        successCaseButton.titleLabel.font = [UIFont systemFontOfSize:16];
        successCaseButton.tag = 204;
        [successCaseButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_materialView addSubview:successCaseButton];
        
        //线
        UIView *lineViewTwo = [[UIView alloc] init];
        lineViewTwo.backgroundColor = [UIColor grayColor];
        lineViewTwo.tag = 205;
        [_materialView addSubview:lineViewTwo];
        
        //失败案例图片
        UIImageView *failCaseImageView = [[UIImageView alloc] init];
//        failCaseImageView.image = [UIImage imageNamed:@"icon_step3"];
        failCaseImageView.backgroundColor = [UIColor greenColor];
        failCaseImageView.tag = 206;
        [_materialView addSubview:failCaseImageView];
        
        //失败案例
        UIButton *failCaseButton = [[UIButton alloc] init];
        [failCaseButton setTitle:@"失败案例" forState:UIControlStateNormal];
        [failCaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        failCaseButton.titleLabel.font = [UIFont systemFontOfSize:16];
        failCaseButton.tag = 207;
        [failCaseButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_materialView addSubview:failCaseButton];
    }
    return _materialView;
}

- (UILabel *)knowledgeLabel {
    if (!_knowledgeLabel) {
        _knowledgeLabel = [[UILabel alloc] init];
        _knowledgeLabel.text = @"涨知识";
        _knowledgeLabel.textColor = [UIColor blackColor];
        _knowledgeLabel.font = [UIFont systemFontOfSize:18];
    }
    return _knowledgeLabel;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    _productContainerView.pagingEnabled = YES;
//}
//- (IBAction)moduleDidClick:(UIButton *)sender {
//    if (_moduleBlock) {
//        _moduleBlock(sender.tag);
//    }
//}
//
//- (void)setProductObjs:(NSArray *)productObjs{
//    _productObjs = productObjs;
//    [_productContainerView removeAllSubviews];
//    if (productObjs.count == 0) return;
//    CGFloat width = kScreenSize.width / 4;
//    for (NSInteger i =0; i < _productObjs.count; i++) {
//        DDProductObj * obj = _productObjs[i];
//        DDProductItemView * item = [[[NSBundle mainBundle] loadNibNamed:@"DDProductItemView" owner:nil options:nil] lastObject];
//        item.frame = CGRectMake(i* width, 0, width, 100);
//        item.nameLb.text = obj.productName;
//        if (obj.backImg) [item.iconView sd_setImageWithURL:[NSURL URLWithString:obj.backImg]];
//        item.tag = i;
//        item.itemBlock = _itemBlock;
//        [_productContainerView addSubview:item];
//    }
//    _productContainerView.contentSize = CGSizeMake(width * _productObjs.count, 0);
//}
//
//
//- (void)setMessages:(NSArray *)messages{
//    _messages = messages;
//    _messageContentView.scrollEnabled = NO;
//    [_messageContentView removeAllSubviews];
//    CGFloat left = 0;
//    for (NSInteger i =0; i < messages.count; i++) {
//        DDMessageModel * obj = messages[i];
//        UIButton * messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [messageButton setTitle:obj.messageContent forState:UIControlStateNormal];
//        messageButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [messageButton setTitleColor:UIColorHex(0x131313) forState:UIControlStateNormal];
//        CGFloat width = [obj.messageContent sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(10000, 44) mode:NSLineBreakByWordWrapping].width + 40;
//        messageButton.frame = CGRectMake(left, 0, width, 44);
//        left += width;
//        [_messageContentView addSubview:messageButton];
//        messageButton.tag = i;
//        [messageButton addTarget:self action:@selector(messageDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    _placeLb.hidden = _messages.count != 0;
//
//    _contentWidth = left + kScreenSize.width - 64;
//    _messageContentView.contentSize = CGSizeMake(_contentWidth, 0);
//    if (_contentWidth > kScreenSize.width - 65) {
//        _contentLeft = 0;
//        if (_timer) {
//            [_timer invalidate];
//            _timer = nil;
//        }
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scheduled) userInfo:nil repeats:YES];
//    }
//}
//
//- (void)scheduled{
//    _contentLeft += 0.5;
//    [_messageContentView setContentOffset:CGPointMake(_contentLeft, 0)];
//    if (_contentLeft > _contentWidth - kScreenSize.width  * 0.7) {
//        _contentLeft = 0;
//    }
//}
//
//- (void)messageDidClick:(UIButton *)btn{
//    if (_messageBlock) {
//        _messageBlock(btn.tag);
//    }
//}
@end
