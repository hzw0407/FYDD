//
//  STAdvertorialsCell.m
//  FYDD
//
//  Created by 何志武 on 2019/10/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//  --软文

#import "STAdvertorialsCell.h"
#import <SDWebImage/SDWebImage.h>

@interface STAdvertorialsCell ()

@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *contentLabel;//内容
@property (nonatomic, strong) UILabel *timeLabel;//发布时间
@property (nonatomic, strong) UIImageView *browseImageView;//浏览量图片
@property (nonatomic, strong) UILabel *browseLabel;//浏览量
@property (nonatomic, strong) UIImageView *articleImageView;//文章图片

@end

@implementation STAdvertorialsCell
#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
        
    }
    return self;
}

#pragma mark - CustomMethod
- (void)creatUI {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-130);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@(20));
    }];
    
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@(50));
    }];
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLabel.mas_left);
        make.right.mas_equalTo(self.contentLabel.mas_right).offset(-80);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@(20));
    }];
    
    [self addSubview:self.browseImageView];
    [self.browseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentLabel.mas_right).offset(-22);
        make.width.equalTo(@(21.5));
        make.bottom.mas_equalTo(self.timeLabel.mas_bottom);
        make.height.equalTo(@(13));
    }];
    
    [self addSubview:self.browseLabel];
    [self.browseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentLabel.mas_right);
        make.width.equalTo(@(17));
        make.bottom.mas_equalTo(self.browseImageView.mas_bottom);
        make.height.mas_equalTo(self.browseImageView.mas_height);
    }];
    
    [self addSubview:self.articleImageView];
    [self.articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@(110));
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (void)refreshWithModel:(STAdvertorialsModel *)model {
    self.browseImageView.hidden = NO;
            self.titleLabel.text = model.title;
            if (model.standby1) {
                self.contentLabel.text = model.standby1;
            }
    //        NSDateFormatter * formater = [NSDateFormatter new];
    //        formater.dateFormat = @"yyyy-MM-ddTHH:mm:ss";
    //        model.updateTime = [model.updateTime stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
    //        if ([model.updateTime componentsSeparatedByString:@"T"].count > 0) {
    //            self.timeLabel.text = [NSString stringWithFormat:@"发布时间:%@",[model.updateTime componentsSeparatedByString:@"T"][0]];
    //        }
            self.timeLabel.text = [NSString stringWithFormat:@"发布时间:%@",[STTool getTimeFromTimestamp:model.createTimeF]];
            self.browseLabel.text = [NSString stringWithFormat:@"%zd",model.browserNum];
            if (model.titleImg) {
            [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:model.titleImg] placeholderImage:[UIImage imageNamed:@"index_place"]];
            }
}

#pragma mark - ClickMethod

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [STTool colorWithHexString:@"#ABAEB1" alpha:1];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [STTool colorWithHexString:@"#ABAEB1" alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UIImageView *)browseImageView {
    if (!_browseImageView) {
        _browseImageView = [[UIImageView alloc] init];
        _browseImageView.image = [UIImage imageNamed:@"Home_Eye"];
    }
    return _browseImageView;
}

- (UILabel *)browseLabel {
    if (!_browseLabel) {
        _browseLabel = [[UILabel alloc] init];
        _browseLabel.textColor = [STTool colorWithHexString:@"#ABAEB1" alpha:1];
        _browseLabel.font = [UIFont systemFontOfSize:12];
        _browseLabel.textAlignment = NSTextAlignmentRight;
    }
    return _browseLabel;
}

- (UIImageView *)articleImageView {
    if (!_articleImageView) {
        _articleImageView = [[UIImageView alloc] init];
    }
    return _articleImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
