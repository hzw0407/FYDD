//
//  DDTradeDetailVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDTradeDetailVc.h"
#import "DDTraceDetailCell.h"
#import "DDTraceCommentCell.h"
#import "YYPhotoGroupView.h"
#import "DDTraceCommentCell.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "DDTraceSubCommentCell.h"

@interface DDTradeDetailVc ()<UITableViewDelegate,
UITableViewDataSource,UITextFieldDelegate> {
    NSInteger _currentPage;
    NSArray * _comments;
    DDFootstripComment * _subFoot;
}
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarCons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFeild;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;
@end

@implementation DDTradeDetailVc

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bottomBarCons.constant = iPhoneXAfter ? 70 : 60;
    _bottomBarView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bottomBarView.layer.shadowOffset = CGSizeMake(0,3);
    _bottomBarView.layer.shadowRadius = 6;
    _bottomBarView.layer.shadowOpacity = 1;
    _bottomBarView.clipsToBounds = YES;
    _bottomBarView.hidden = _isMe;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_footstripObj layout];
    [_tableView registerNib:[UINib nibWithNibName:@"DDTraceDetailCell" bundle:nil
                             ] forCellReuseIdentifier:@"DDTraceDetailCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDTraceCommentCell" bundle:nil
                             ] forCellReuseIdentifier:@"DDTraceCommentCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDTraceSubCommentCell" bundle:nil
                             ] forCellReuseIdentifier:@"DDTraceSubCommentCellId"];
    //DDTraceSubCommentCell
    _textFeild.delegate = self;
    _textFeild.returnKeyType =  UIReturnKeySend;
    _currentPage = 1;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%zd",_footstripObj.likesNumber] forState:UIControlStateNormal];
    self.likeButton.selected = _footstripObj.liked;
    self.likeView.image = [UIImage imageNamed:self.footstripObj.liked ? @"icon_like" : @"icon_like_it"];
    [self getMoreComments];
    
    if(!_isMe) {
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_reward"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnDidClick)];
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewHeightChange) name:@"WebViewHeightChange" object:nil];
}

- (void)webViewHeightChange{
    [self.tableView reloadData];
}

-(void)shareBtnDidClick{
    @weakify(self)
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,
                                                                             NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:yyTrimNullText(self.footstripObj.title)
                                                                                 descr:self.footstripObj.contents
                                                                             thumImage:[UIImage imageNamed:@"index_place"]];
//        shareObject.webpageUrl = self->_extensionURL;
        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            @strongify(self)
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                [DDHub hub:@"分享成功" view:self.view];
            }
        }];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 发送评论
    if (textField.text.length > 0) {
        [DDHub hub:self.view];
        NSString * url = [NSString stringWithFormat:@"%@/footprint/replyByid?token=%@",DDAPP_2T_URL,[DDUserManager share].user.token];
        NSDictionary * dic = @{@"indexFootId" : @(_footstripObj.objId ),
                               @"commnet" : textField.text
                               };
        if (_subFoot) {
            dic =           @{
                                        @"indexFootId" : @(_footstripObj.objId ),
                                        @"commnet" : textField.text,
                                        @"commentParentId" : _subFoot.commentId,
                                   };
        }

        @weakify(self)
        [[DDAppNetwork share] get:NO url:url body:[dic modelToJSONString] completion:^(NSInteger code, NSString *message, id data) {
            @strongify(self)
            if(!self) return ;
            [DDHub dismiss:self.view];
            if (code == 200) {
                [self.view endEditing:YES];
                self.textFeild.text = @"";
                [DDHub hub:@"评论成功" view:self.view];
                [self.view endEditing:YES];
                self->_subFoot = nil;
                [self getMoreComments];
            }else {
                
            }
        }];
    }
    return YES;
}


- (void)getMoreComments{
    NSString * url = [NSString stringWithFormat:@"%@/footprint/getIndexByid?token=%@&id=%zd&page=%zd&size=20",DDAPP_2T_URL,[DDUserManager share].user.token,_footstripObj.objId,_currentPage];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:url
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
        @strongify(self)
        if(!self) return ;
        if (code == 200) {
            NSArray * comments = data[@"comments"];
            if (comments && [comments isKindOfClass:[NSArray class]]) {
                NSMutableArray * commentLists = @[].mutableCopy;
                for (NSDictionary * dic  in comments) {
                    DDFootstripComment * model = [DDFootstripComment modelWithJSON:dic];
                    [model layout];
                    for ( DDFootstripComment * item in model.comments) {
                        [item layout];
                    }
                    [commentLists addObject:model];
                    
                }
                self->_comments = commentLists;
                [self.commentButton setTitle:[NSString stringWithFormat:@"%zd",commentLists.count] forState:UIControlStateNormal];
            }
            [self.tableView reloadData];
        }
    }];

}
- (IBAction)likeButtonDidClick:(UIButton *)sender {
    NSString * url = [NSString stringWithFormat:@"%@/footprint/likeNumberByid?token=%@&footprintId=%zd&type=%@",DDAPP_2T_URL,[DDUserManager share].user.token,_footstripObj.objId,_footstripObj.liked ? @(0) : @(1)];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:url
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if(!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           if (self.footstripObj.liked) {
                               self.footstripObj.likesNumber -= 1;
                               self.footstripObj.liked = NO;
                           }else {
                               self.footstripObj.likesNumber += 1;
                               self.footstripObj.liked = YES;
                           }
                           [self.likeButton setTitle:[NSString stringWithFormat:@"%zd",self.footstripObj.likesNumber] forState:UIControlStateNormal];
                           self.likeButton.selected = self.footstripObj.liked;
                           self.likeView.image = [UIImage imageNamed:self.footstripObj.liked ? @"icon_like" : @"icon_like_it"];
                           [self.tableView reloadData];
                       }
                   }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + _comments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 1;
    DDFootstripComment * comme = _comments[section - 1];
    return comme.comments.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DDTraceDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDTraceDetailCellId"];
        cell.stripObj = _footstripObj;
        @weakify(self)
        cell.contentImageDidClick = ^(UIButton *originButton, NSString *url) {
            @strongify(self)
            NSMutableArray *items = [NSMutableArray new];
            YYPhotoGroupItem *groupItem = [YYPhotoGroupItem new];
            groupItem.thumbView = originButton;
            groupItem.largeImageURL = [NSURL URLWithString:url];
            [items addObject:groupItem];
            YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
            [v presentFromImageView:originButton toContainer:self.navigationController.view animated:YES completion:nil];
        };
        return cell;
    }else {
        if (indexPath.row == 0) {
            DDTraceCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDTraceCommentCellId"];
            cell.stripments = _comments[indexPath.section - 1];
            return cell;
        }else {
            DDTraceSubCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDTraceSubCommentCellId"];
            DDFootstripComment * stripments = _comments[indexPath.section - 1];
            cell.stripments = stripments.comments[indexPath.row - 1];
            return cell;
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0) {
        if (indexPath.row == 0) {
            [self.textFeild becomeFirstResponder];
            _subFoot = _comments[indexPath.section - 1];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return _footstripObj.cellHeight;
    }
    if (indexPath.row == 0) {
        DDFootstripComment * comment = _comments[indexPath.section - 1];
        return comment.titleHeight;
    }else {
        DDFootstripComment * stripments = _comments[indexPath.section - 1];
        DDFootstripComment * cm = stripments.comments[indexPath.row - 1];
        return cm.laxHeight;
    }
}

@end
