//
//  DDCityListVC.m
//  FYDD
//
//  Created by mac on 2019/4/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDCityListVC.h"
#import "DDMessageCell.h"
#import "DDTimeCell.h"
#import "DDMessageTopView.h"
#import "DDLocationHeaderView.h"
#import "DDLocationTopCell.h"
#import "DDCityNameCell.h"
#import "DDCityModel.h"

@interface DDCityListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSArray <DDAreaModel *>*_areaList;
    NSArray <DDCityModel *>*_cityList;
    // 搜索结果
    NSMutableArray * _searhModels;
    BOOL _search;
}
// 获取位置
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UISearchBar * searchBar;
@end

@implementation DDCityListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelCityList)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    [self getCityListData];
    
    _areaList = @[].mutableCopy;
    _cityList = @[].mutableCopy;
}


- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"请输入所在城市和区域";
        _searchBar.delegate = self;
        _searchBar.frame = CGRectMake(70, 0, kScreenSize.width - 140, 44);
    }
    return _searchBar;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        _searhModels = @[].mutableCopy;
        _search = NO;
    }else {
        _searhModels = @[].mutableCopy;
        for (DDAreaModel * are in _areaList) {
            if ([are.areaName rangeOfString:searchText].location != NSNotFound){
                [_searhModels addObject:are];
            }
        }
        for (DDCityModel * are in _cityList) {
            if ([are.cityName rangeOfString:searchText].location != NSNotFound){
                [_searhModels addObject:are];
            }
        }
        _search = YES;
    }
    [self.tableView reloadData];
}

- (void)cancelCityList{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// 获取城市
- (void)getCityListData{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/uas/online/area/getAreaAndCityList"
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           NSMutableArray * dataList1 = @[].mutableCopy;
                           NSMutableArray * dataList2 = @[].mutableCopy;
                           NSArray * dicts1 = data[@"cityList"];
                           NSArray * dicts2 = data[@"areaList"];
                           for (NSDictionary * dic in dicts1) {
                               DDCityModel * model = [DDCityModel modelWithJSON:dic];
                               [dataList1 addObject:model];
                           }
                           self->_cityList = dataList1;
                           
                           for (NSDictionary * dic in dicts2) {
                               DDAreaModel * model = [DDAreaModel modelWithJSON:dic];
                               [dataList2 addObject:model];
                           }
                           self->_areaList = dataList2;
                           [self.tableView reloadData];
                       }
                   }];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xeeeeee);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDLocationTopCell" bundle:nil] forCellReuseIdentifier:@"DDLocationTopCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDCityNameCell" bundle:nil] forCellReuseIdentifier:@"DDCityNameCellId"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_search) {
        return 1;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_search) {
        return _searhModels.count;
    }
    if (section == 0) return 1;
    if (section == 1) return _cityList.count;
    return _areaList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_search) {
        DDCityNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCityNameCellId"];
        id model = _searhModels[indexPath.row];
        if ([model isKindOfClass:[DDCityModel class]]) {
            DDCityModel * city = (DDCityModel *)model;
            cell.nameLb.text = city.cityName;
        }else {
            DDAreaModel * area = (DDAreaModel *)model;
            cell.nameLb.text = area.areaName;
        }
        return cell;
    }else {
        if (indexPath.section == 0) {
            DDLocationTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDLocationTopCellId"];
            cell.cityLb.text = [NSString stringWithFormat:@"当前定位城市: %@",yyTrimNullText(_city)];
            return cell;
        }else {
            
            DDCityNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCityNameCellId"];
            if (indexPath.section == 1) {
                DDCityModel * city = _cityList[indexPath.row];
                cell.nameLb.text = city.cityName;
            }else {
                DDAreaModel * area = _areaList[indexPath.row];
                cell.nameLb.text = area.areaName;
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    DDLocationHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"DDLocationHeaderView" owner:nil options:nil] lastObject];
    headerView.nameLb.text = section == 1 ? @"已开通城市" : @"其他区域";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.01 : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * codeName = @"";
    if (_search) {
        id model = _searhModels[indexPath.row];
        if ([model isKindOfClass:[DDCityModel class]]) {
            DDCityModel * city = (DDCityModel *)model;
            codeName = city.cityName;
        }else {
            DDAreaModel * area = (DDAreaModel *)model;
            codeName = area.areaName;
        }
    }else {
        if (indexPath.section == 0){
            codeName = [[DDAppManager share] getCityCode:_city];
        }else if (indexPath.section == 1) {
            DDCityModel * city = _cityList[indexPath.row];
            codeName = city.cityName;
        }else {
            DDAreaModel * area = _areaList[indexPath.row];
            codeName = area.areaName;
        }
    }
    // 设置区域
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"area\" : \"%@\" }",codeName];
    [self updateUserNetwork:body];
}

- (void)updateUserNetwork:(NSString *)body{
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/uas/user/user/userInfo/updateUserInfo?token=",
                                       [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [self dismissViewControllerAnimated:YES completion:^{
                                   
                               }];
                           });
                       }else {
                           [DDHub hub:@"设置失败！" view:self.view];
                       }
                   }];
}

@end
