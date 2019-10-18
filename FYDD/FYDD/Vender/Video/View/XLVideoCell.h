//
//  XLVideoCell.h
//  XLVideoPlayer
//


#import <UIKit/UIKit.h>

@class DDVideoListModel;

@interface XLVideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;

@property (nonatomic, strong) DDVideoListModel *videoItem;

+ (XLVideoCell *)videoCellWithTableView:(UITableView *)tableview;

@end
