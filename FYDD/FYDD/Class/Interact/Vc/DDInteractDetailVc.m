//
//  DDInteractDetailVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDInteractDetailVc.h"
#import "DDTraceDetailCell.h"
#import "DDTraceCommentCell.h"
#import "YYPhotoGroupView.h"
#import "DDTraceCommentCell.h"
#import "DDFootstripObj.h"

@interface DDInteractDetailVc ()<UITableViewDelegate,
UITableViewDataSource,UITextFieldDelegate> {
    NSInteger _currentPage;
    NSArray * _comments;
}
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarCons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFeild;
@end

@implementation DDInteractDetailVc
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
    [_tableView registerNib:[UINib nibWithNibName:@"DDTraceCommentCell" bundle:nil] forCellReuseIdentifier:@"DDTraceCommentCellId"];
    _textFeild.delegate = self;
    _textFeild.returnKeyType =  UIReturnKeySend;
    _currentPage = 1;
    [self getMoreComments];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 发送评论
    if (textField.text.length > 0) {
        [DDHub hub:self.view];
        NSString * url = [NSString stringWithFormat:@"%@/helpEachOther/replyByid?token=%@",DDAPP_2T_URL,[DDUserManager share].user.token];
        NSDictionary * dic = @{@"helpId" : @([_footstripObj.objId integerValue]) ,
                               @"commnet" : textField.text,
                               @"isPublic" : @(0)
                               };
        @weakify(self)
        [[DDAppNetwork share] get:NO url:url body:[dic modelToJSONString] completion:^(NSInteger code, NSString *message, id data) {
            @strongify(self)
            if(!self) return ;
            if (code == 200) {
                [DDHub hub:@"评论成功" view:self.view];
                [self.view endEditing:YES];
                self.textFeild.text = @"";
                [self getMoreComments];
            }else {
                [DDHub dismiss:self.view];
            }
        }];
    }
    return YES;
}


- (void)getMoreComments{
    NSString * url = [NSString stringWithFormat:@"%@/helpEachOther/getByid?token=%@&id=%@",DDAPP_2T_URL,[DDUserManager share].user.token,_footstripObj.objId];
    
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:url
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if(!self) return ;
                       if (code == 200) {
                           NSArray * comments = data[@"comments"];
                           if(comments && [comments isKindOfClass:[NSArray class]]) {
                               NSMutableArray * dataLists = @[].mutableCopy;
                               for (NSDictionary * dic in comments) {
                                   DDFootstripComment * model = [DDFootstripComment modelWithJSON:dic];
                                   [model layout];
                                   [dataLists addObject:model];
                               }
                               self->_comments = dataLists;
                               [self.tableView reloadData];
                           }
                       }
                   }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 + _comments.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DDTraceDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDTraceDetailCellId"];
        cell.interactObj = _footstripObj;
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
        DDTraceCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDTraceCommentCellId"];
        cell.stripments = _comments[indexPath.row - 1];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        DDFootstripComment * comments = _comments[indexPath.row - 1];
        return comments.titleHeight;
    }
    return _footstripObj.cellHeight;
}

@end
