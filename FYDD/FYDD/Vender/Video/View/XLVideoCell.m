//
//  XLVideoCell.m
//  XLVideoPlayer
//


#import "XLVideoCell.h"
#import "DDVideoListModel.h"
#import "UIImageView+WebCache.h"

@interface XLVideoCell ()

@end

@implementation XLVideoCell

+ (XLVideoCell *)videoCellWithTableView:(UITableView *)tableview {
    static NSString *ID = @"XLVideoCell";
    XLVideoCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XLVideoCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setVideoItem:(DDVideoListModel *)videoItem {
    _videoItem = videoItem;
    self.videoTitle.text = videoItem.title;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:videoItem.coverUrl]];
}


@end
