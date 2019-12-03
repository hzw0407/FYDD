//
//  DDChatReceveCell.m
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDChatReceveCell.h"
#import "STTool.h"

@interface DDChatReceveCell ()

@property (nonatomic, strong) UILabel *dateLabel;//时间
@property (nonatomic, strong) UIImageView *iconImageView;//头像
@property (nonatomic, strong) UIImageView *chatImageView;//聊天背景图片
@property (nonatomic, strong) UILabel *chatLabel;//聊天内容

@end

@implementation DDChatReceveCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.top.equalTo(self).offset(5);
            make.height.equalTo(@(20));
        }];
        
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@(50));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.equalTo(@(50));
        }];
        [self.iconImageView layoutIfNeeded];
        self.iconImageView.layer.cornerRadius = 25;
        self.iconImageView.clipsToBounds = YES;
        
        [self addSubview:self.chatImageView];
        [self.chatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(70);
            make.width.equalTo(@(0));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.equalTo(@(0));
        }];

        [self addSubview:self.chatLabel];
        [self.chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.chatImageView.mas_left).offset(10);
            make.width.equalTo(@(0));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.equalTo(@(0));
        }];
    }
    return self;
}

- (void)refreshWithModel:(DDChatModel *)model {
    CGFloat width = [STTool calculateWidth:model.message fontSize:12 height:20];
    CGFloat height = [STTool calculateHeight:model.message fontSize:12 width:170];
    self.chatLabel.text = model.message;
    self.dateLabel.text = model.createDate;
    [self.chatImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(70);
        make.width.equalTo(@(width + 30 > 200 ? 200 : width + 30));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.equalTo(@(height < 20 ? 20 : height));
    }];
    [self.chatLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chatImageView.mas_left).offset(10);
        make.width.mas_equalTo(self.chatImageView.mas_width).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.chatImageView.mas_height);
    }];
    if ([yyTrimNullText([DDUserManager share].user.userHeadImage) hasPrefix:@"http"]){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[DDUserManager share].user.userHeadImage]];
    }else {
        [self.iconImageView setImage:[UIImage imageNamed:[DDUserManager share].userPlaceImage]];
    }
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)chatImageView {
    if (!_chatImageView) {
        _chatImageView = [[UIImageView alloc] init];
        _chatImageView.image = [UIImage imageNamed:@"icon_receve_chat"];
    }
    return _chatImageView;
}

- (UILabel *)chatLabel {
    if (!_chatLabel) {
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.textColor = [UIColor blackColor];
        _chatLabel.font = [UIFont systemFontOfSize:12];
        _chatLabel.numberOfLines = 0;
    }
    return _chatLabel;
}


@end
