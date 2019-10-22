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
@property (nonatomic, strong) UIImageView *userImabeView;//作者头像
@property (nonatomic, strong) UILabel *userNameLabel;//作者名称
@property (nonatomic, strong) UILabel *countLabel;//评论数
@property (nonatomic, strong) UILabel *timeLabel;//发布时间
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
        make.right.equalTo(self).offset(-110);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@(60));
    }];
    
    [self addSubview:self.userImabeView];
    [self.userImabeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.width.equalTo(@(20));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@(20));
    }];
    [self.userImabeView layoutIfNeeded];
    self.userImabeView.layer.cornerRadius = self.userImabeView.size.height / 2;
    
    [self addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userImabeView.mas_right).offset(5);
        make.width.equalTo(@(80));
        make.top.mas_equalTo(self.userImabeView.mas_top);
        make.height.mas_equalTo(self.userImabeView.mas_height);
    }];
    
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameLabel.mas_right).offset(5);
        make.width.equalTo(@(50));
        make.top.mas_equalTo(self.userNameLabel.mas_top);
        make.height.mas_equalTo(self.userNameLabel.mas_height);
    }];
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.countLabel.mas_right).offset(5);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.countLabel.mas_top);
        make.height.mas_equalTo(self.countLabel.mas_height);
    }];
    
    [self addSubview:self.articleImageView];
    [self.articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@(90));
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.height.equalTo(@(90));
    }];
}

- (void)refreshWithModel:(DDFootstripObj *)model {
    self.titleLabel.text = model.title;
    if (yyTrimNullText(model.createUserLogo).length > 0) {
        [self.userImabeView sd_setImageWithURL:[NSURL URLWithString:yyTrimNullText(model.createUserLogo)]];
    }else {
        self.userImabeView.image = [UIImage imageNamed:[[DDUserManager share] userPlaceImage]];
    }
    self.userNameLabel.text = model.createUserName;
    self.countLabel.text = [NSString stringWithFormat:@"评论数:%zd",model.commentNumber];
    NSDateFormatter * formater = [NSDateFormatter new];
    formater.dateFormat = @"yyyy-MM-ddTHH:mm:ss";
    model.updateTime = [model.updateTime stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
    if ([model.updateTime componentsSeparatedByString:@"T"].count > 0) {
        self.timeLabel.text = [model.updateTime componentsSeparatedByString:@"T"][0];
    }
    if (model.showImage) {
        [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:model.showImage] placeholderImage:[UIImage imageNamed:@"index_place"]];
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
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)userImabeView {
    if (!_userImabeView) {
        _userImabeView = [[UIImageView alloc] init];
    }
    return _userImabeView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = [UIColor grayColor];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _userNameLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor grayColor];
        _countLabel.font = [UIFont systemFontOfSize:12];
    }
    return _countLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
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
