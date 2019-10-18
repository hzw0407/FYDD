//
//  ExampleViewController.m
//  XLVideoPlayer




#import "ExampleViewController.h"
#import "VideoDetailViewController.h"
#import "XLVideoCell.h"
#import "XLVideoPlayer.h"
#import "XLVideoItem.h"
#import "AFNetworking.h"
#import "DDVideoListModel.h"

@interface ExampleViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    NSIndexPath *_indexPath;
    XLVideoPlayer *_player;
    CGRect _currentPlayCellRect;
    
    NSArray <DDVideoListModel*>* _dataList;
}

@property (weak, nonatomic) IBOutlet UITableView *exampleTableView;
@end

@implementation ExampleViewController

- (instancetype)init {
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ExampleViewController" owner:nil options:nil].lastObject;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = @"演示视频";
    }
    return self;
}

#pragma mark - lazt loading

- (XLVideoPlayer *)player {
    if (!_player) {
        _player = [[XLVideoPlayer alloc] init];
        _player.frame = CGRectMake(0, 64, self.view.frame.size.width, 250);
    }
    return _player;
}


#pragma mark - life cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.exampleTableView.estimatedRowHeight = 100;

    [self fetchVideoListData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player destroyPlayer];
    _player = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - network

- (void)fetchVideoListData {
    
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/uas/home/article/getVideoDemoList"
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSArray * datas) {
                       @strongify(self)
                       if (!self) return ;
                       NSMutableArray * dataList = @[].mutableCopy;
                       if (code == 200) {
                           if (datas && [datas isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in datas) {
                                   DDVideoListModel * videos = [DDVideoListModel modelWithJSON:dic];
                                   [dataList addObject:videos];
                               }
                               self->_dataList = dataList;
                           }
                       }
                       [self.exampleTableView reloadData];
                   }];
}

- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    
    UIView *view = tapGesture.view;
    DDVideoListModel *item = _dataList[view.tag - 100];

    _indexPath = [NSIndexPath indexPathForRow:view.tag - 100 inSection:0];
    XLVideoCell *cell = [self.exampleTableView cellForRowAtIndexPath:_indexPath];
    
    _player = [[XLVideoPlayer alloc] init];
    _player.videoUrl = item.content;
    [_player playerBindTableView:self.exampleTableView currentIndexPath:_indexPath];
    _player.frame = view.frame;

    [cell.contentView addSubview:_player];  
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        [player destroyPlayer];
        self->_player = nil;
    };
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLVideoCell *cell = [XLVideoCell videoCellWithTableView:tableView];
    DDVideoListModel *item = _dataList[indexPath.row];
    cell.videoItem = item;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    [cell.videoImageView addGestureRecognizer:tap];
    cell.videoImageView.tag = indexPath.row + 100;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    DDVideoListModel *item = _dataList[indexPath.row];
//    VideoDetailViewController *videoDetailViewController = [[VideoDetailViewController alloc] init];
//    videoDetailViewController.videoTitle = item.title;
//    videoDetailViewController.mp4_url = item.content;
//    [self.navigationController pushViewController:videoDetailViewController animated:YES];
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.exampleTableView]) {
        
        [_player playerScrollIsSupportSmallWindowPlay:YES];
    }
}

@end
