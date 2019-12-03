//
//  DDContactListVC.m
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDContactListVC.h"
#import "IQKeyboardManager.h"
#import "DDAlertView.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <YYKit/YYKit.h>
#import "DDChatModel.h"
#import "DDChatSendCell.h"
#import "DDChatReceveCell.h"
#import <MJRefresh/MJRefresh.h>
#import "DDSenderImageCell.h"
#import "YYPhotoGroupView.h"
@interface DDContactListVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _currentPage;
    NSArray <DDChatModel*>* _dataList;
    NSString * _contactPhone;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textTd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;
@property (weak, nonatomic) IBOutlet UIView *inutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contBottom;
@property (weak, nonatomic) IBOutlet UIButton *contactPhoneButton;
@end

@implementation DDContactListVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [DDHub hub:self.view];
    self.title = @"客服";
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _currentPage = 1;
//    [self.tableView registerNib:[UINib nibWithNibName:@"DDChatSendCell" bundle:nil] forCellReuseIdentifier:@"DDChatSendCellId"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"DDChatReceveCell" bundle:nil] forCellReuseIdentifier:@"DDChatReceveCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDSenderImageCell" bundle:nil] forCellReuseIdentifier:@"DDSenderImageCellId"];
    [self getContactList];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    @weakify(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (!self) return ;
        self->_currentPage += 1;
        [self getContactList];
    }];
    
    if (iPhoneXAfter) {
        _cons.constant = 30;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 获取客服
    [[DDAppNetwork share] get:YES
                         path:@"/fps/bank/card/getCompanyBankInfoConfig"
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       if (code == 200 ){
                           self->_contactPhone = yyTrimNullText(data[@"telephone"]);
                           [self.contactPhoneButton setTitle:[NSString stringWithFormat:@"客服热线: %@",self->_contactPhone] forState:UIControlStateNormal];
                       }
    }];
    
    [self destructionRed];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

//销毁客服红点
- (void)destructionRed {
    STHttpRequestManager *manager = [STHttpRequestManager shareManager];
    [manager addParameterWithKey:@"token" withValue:[DDUserManager share].user.token];
    [manager addParameterWithKey:@"type" withValue:@"1"];
    [manager addParameterWithKey:@"change" withValue:@"chat"];
    [manager requestDataWithUrl:[NSString stringWithFormat:@"%@:%@//fps/wallet/getHavChange",DDAPP_URL,DDPort7001] withType:RequestGet withSuccess:^(NSDictionary * _Nonnull dict) {
        if (dict && [dict[@"code"] integerValue] == 200) {
            
        }
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [DDHub hub:error.domain view:self.view];
    }];
}

-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    
    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.tableView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height + transformY -108);
        self.contBottom.constant = -transformY + 48;// tableView的bottom距父视图bottom的距离
        self.inutView.transform = CGAffineTransformMakeTranslation(0, transformY-60);
//        [self.tableView scrollToBottom];
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (IBAction)photoDidClick {
    [self.view endEditing:YES];
    [self showPhotoActionSheetCompletion:^(bool suc, NSString *url) {
        if (suc) {
            NSString * body = [NSString stringWithFormat:@"{\"message\" : \"%@\" , \"replyType\" : \"2\" }",url];
            [self sendContent:body];
        }else {
            [DDHub hub:@"发送图片失败" view:self.view];
        }
    }];
}

- (IBAction)sendDidClick {
    if (_textTd.text.length == 0) {
        return;
    }
    NSString * body = [NSString stringWithFormat:@"{\"message\" : \"%@\" , \"replyType\" : \"1\" }",_textTd.text];
    [self sendContent:body];
}

- (void)sendContent:(NSString *)content{
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/uas/im/chat/addUserReply?token=", [DDUserManager share].user.token)
                         body:content
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (code == 200) {
                           self.textTd.text = @"";
                           self->_currentPage = 1;
                           [self getContactList];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (IBAction)callPhone:(id)sender {
    [DDAlertView showTitle:@"提示"
                  subTitle:[NSString stringWithFormat:@"是否拨打%@",self->_contactPhone]
                 sureEvent:^{
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self->_contactPhone]]];
    } cancelEvent:^{
        
    }];
}

- (void)getContactList{
    NSString * url = [NSString stringWithFormat:@"/uas/im/chat/getUserChatList?token=%@&pageNo=%zd",[DDUserManager share].user.token,_currentPage];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:url
                         body:nil
                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                       @strongify(self)
                       if (!self)return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           NSInteger totalNum = [data[@"totalNum"] integerValue];
                           NSArray * chatList = data[@"chatList"];
                           // 总
                           NSMutableArray * dataList = @[].mutableCopy;
                           
                           NSMutableArray * currentPageList = @[].mutableCopy;
                           if (chatList && [chatList isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in chatList) {
                                   DDChatModel * model = [DDChatModel modelWithJSON:dic];
                                   [model layout];
                                   [currentPageList addObject:model];
                               }
                           }
                           [dataList addObjectsFromArray:currentPageList];
                           if (self->_currentPage != 1) {
                               [dataList addObjectsFromArray:self->_dataList];
                           }
                           [self.tableView.mj_header endRefreshing];
                           if (totalNum == dataList.count) {
                               
                           }
                           self->_dataList = dataList;
                           [self.tableView reloadData];
                           if (self->_currentPage == 1){
                               if (dataList.count > 0){
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0]-1) inSection:0];
                                   [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                               }
                           }
                       }else {
                           
                       }
                   }];
}



// 选择和上传图片
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

// 上传图片
- (void)uploadImage:(UIImage*)image completion:(void (^)(bool suc ,NSString * url ) )completion{
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
                            self->_currentPage = 1;
                             [self getContactList];
                        }else {
                            if(completion) completion(NO, nil);
                        }
                    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDChatModel * item = _dataList[indexPath.row];
    if (item.type == 1) {
//        DDChatReceveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDChatReceveCellId"];
//        cell.contentLb.text = item.message;
//        cell.dateLb.text = item.createDate;
        DDChatReceveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"receveCell"];
        if (cell == nil) {
            cell = [[DDChatReceveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"receveCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell refreshWithModel:item];
        return  cell;
    }else {
        if (item.replyType == 2) {
            DDSenderImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDSenderImageCellId"];
            if ([yyTrimNullText(item.message) hasPrefix:@"http"]) {
                [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:item.message]];
            }
            if ([yyTrimNullText([DDUserManager share].user.userHeadImage) hasPrefix:@"http"]){
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[DDUserManager share].user.userHeadImage]];
            }else {
                [cell.iconView setImage:[UIImage imageNamed:[DDUserManager share].userPlaceImage]];
            }
            cell.indexPath_row = indexPath.row;
            cell.dateLb.text = item.createDate;
            @weakify(self)
            cell.SenderImageBlock = ^(DDSenderImageCell * cellView) {
                @strongify(self)
                UIImageView *fromView = nil;
                NSMutableArray *items = [NSMutableArray new];
                UIImageView *imgView = cellView.contentImageView;
                YYPhotoGroupItem *groupItem = [YYPhotoGroupItem new];
                groupItem.thumbView = imgView;
                groupItem.largeImageURL = [NSURL URLWithString:yyTrimNullText(item.message)];
//              item.largeImageSize = img.mediaLarge.size;
                [items addObject:groupItem];
                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
                [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
            };
            return cell;
        }else {
//            DDChatSendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDChatSendCellId"];
//            cell.contentLb.text = item.message;
//            cell.dateLb.text = item.createDate;
//            if ([yyTrimNullText([DDUserManager share].user.userHeadImage) hasPrefix:@"http"]){
//                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[DDUserManager share].user.userHeadImage]];
//            }else {
//                [cell.iconView setImage:[UIImage imageNamed:[DDUserManager share].userPlaceImage]];
//            }
            DDChatSendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[DDChatSendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell refreshWithModel:item];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDChatModel * item = _dataList[indexPath.row];
    return item.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
