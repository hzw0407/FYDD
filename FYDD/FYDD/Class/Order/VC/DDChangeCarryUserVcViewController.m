//
//  DDChangeCarryUserVcViewController.m
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDChangeCarryUserVcViewController.h"
#import <Masonry/Masonry.h>
#import "DDCarryUserCell1.h"
#import "DDCarryUserCell2.h"
#import "DDCarryUserCell3.h"
#import "YYPhotoGroupView.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>

@interface DDChangeCarryUserVcViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray * _urls;
    NSString * _reason;
    NSInteger _index;
    //
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDChangeCarryUserVcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换实施员";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
    _urls = @[].mutableCopy;
    [self getOrdePlanSet];
}

- (void)getOrdePlanSet{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          path:@"/uas/system/param/getOrderPlanSet"
                         body:nil completion:^(NSInteger code, NSString *message, id data) {
                             @strongify(self)
                             if (code == 200) {
                                 NSString * sequence = [NSString stringWithFormat:@"%@",data[@"sequence"]];
                                 NSArray * datas = [sequence componentsSeparatedByString:@";"];
                                 if (datas && datas.count > 0) {
                                     self->_index  = [datas[0] integerValue];
                                     [self.tableView reloadData];
                                 }
                             }
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"DDCarryUserCell1" bundle:nil] forCellReuseIdentifier:@"DDCarryUserCell1Id"];
        [self.tableView registerNib:[UINib nibWithNibName:@"DDCarryUserCell2" bundle:nil] forCellReuseIdentifier:@"DDCarryUserCell2Id"];
        [self.tableView registerNib:[UINib nibWithNibName:@"DDCarryUserCell3" bundle:nil] forCellReuseIdentifier:@"DDCarryUserCell3Id"];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2 + _plans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DDCarryUserCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCarryUserCell1Id"];
        cell.orderLb.text = yyTrimNullText(_order.orderNumber);
        cell.onlineUserLB.text = yyTrimNullText(_order.onlineName);
        cell.onlineUserPhoneLb.text = yyTrimNullText(_order.onlinePhone);
        cell.onlineContactAddressLb.text = yyTrimNullText(_order.orderArea);
        cell.changeUserLb.text = [NSString stringWithFormat:@"温馨提示：实施员在完成第%zd步工作做以后不能更换。",_index];
        return cell;
    }else if (indexPath.row <= _plans.count) {
        DDCarryUserCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCarryUserCell2Id"];
        DDOrderPlanModel * planModel = _plans[indexPath.row - 1];
        cell.stepLb.text = [NSString stringWithFormat:@"%zd",planModel.step];
        cell.stepNameLb.text = planModel.detailTitle;
        [cell.statusBtn setTitle:planModel.statusName forState:UIControlStateNormal];
        cell.statusBtn.selected = NO;
        if ([yyTrimNullText(planModel.status) isEqualToString:@"1"]) {
            cell.statusBtn.selected = YES;
        }
        return cell;
    }else {
        DDCarryUserCell3 * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCarryUserCell3Id"];
        cell.urls = _urls;
        cell.textView.text = yyTrimNullText(_reason);
        @weakify(self)
        cell.removeBlock = ^(NSInteger index) {
            @strongify(self)
            [self->_urls removeObjectAtIndex:index];
            cell.urls = self->_urls;
        };
        cell.addBlock = ^{
            @strongify(self)
            [self uploadImage];
        };
        cell.showBlock = ^(UIImageView * _Nonnull originView, NSString * _Nonnull url) {
            @strongify(self)
            NSMutableArray *items = [NSMutableArray new];
            YYPhotoGroupItem *groupItem = [YYPhotoGroupItem new];
            groupItem.thumbView = originView;
            groupItem.largeImageURL = [NSURL URLWithString:url];
            [items addObject:groupItem];
            YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
            [v presentFromImageView:originView toContainer:self.navigationController.view animated:YES completion:nil];
        };
        cell.textChangeBlock = ^(NSString * _Nonnull text) {
            @strongify(self)
            self->_reason = text;
        };
        cell.commitBlock = ^{
            @strongify(self);
            [self commitButtonDidClick];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 275;
    if (indexPath.row <= _plans.count) {
        return 40;
    }
    NSInteger line = (_urls.count + 3) / 3;
    double width = (kScreenSize.width - 120) / 3;
    return 268 + (line) * (width + 10);
}

- (void)commitButtonDidClick{
    if (yyTrimNullText(_reason).length == 0) {
        [DDHub hub:@"请输入更换理由" view:self.view];
        return;
    }
    NSMutableString * urlTexts = @"".mutableCopy;
    for (NSString * url in _urls) {
        [urlTexts appendFormat:@"%@", url];
        [urlTexts appendFormat:@";"];
    }
    NSDictionary * dic= @{
                          @"someThing" : yyTrimNullText(_reason),
                          @"id" : yyTrimNullText(_order.orderId),
                          @"orderNumber" : _order.orderNumber,
                          @"imagePaths " :urlTexts,
                          };
    @weakify(self)
    [[DDAppNetwork share] get:NO path:[NSString stringWithFormat:@"/t-phase/orderOnline/changeRecord/add?token=%@",[DDUserManager share].user.token] body:[dic modelToJSONString] completion:^(NSInteger code, NSString *message, id data) {
        @strongify(self)
        if (!self) return ;
        if(code == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [DDHub hub:message view:self.view];
        }
    }];
}


- (void)uploadImage{
    [self showPhotoActionSheetCompletion:^(bool suc,
                                           NSString *url) {
        if(suc) {
            [self->_urls addObject:yyTrimNullText(url)];
        }
        [self.tableView reloadData];
    }];
}

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


- (void)uploadImage:(UIImage*)image
         completion:(void (^)(bool suc ,NSString * url ) )completion{
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
                            
                        }else {
                            [DDHub hub:message view:self.view];
                            if(completion) completion(NO, nil);
                        }
                    }];
}


@end
