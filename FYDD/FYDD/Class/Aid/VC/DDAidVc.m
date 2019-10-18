//
//  DDAidVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAidVc.h"
#import "BWPlanDeailVc.h"
#import "BWPlanAddVc.h"
#import "DDOpportunityDetailVc.h"
#import "DDAidCell.h"

@interface DDAidVc ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation DDAidVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftTitleLb]];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDAidCell" bundle:nil] forCellReuseIdentifier:@"DDAidCellId"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add_t"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidClick)];
}

- (void)rightButtonDidClick{
    BWPlanAddVc * vc = [BWPlanAddVc new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel * )leftTitleLb{
    UILabel * lab = [UILabel new];
    lab.text = @"互动";
    lab.font = [UIFont systemFontOfSize:24];
    lab.textColor = UIColorHex(0x131313);
    lab.bounds = CGRectMake(0, 0, 100, 44);
    return lab;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDAidCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDAidCellId"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
