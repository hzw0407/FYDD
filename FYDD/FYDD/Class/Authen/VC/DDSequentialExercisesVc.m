//
//  DDSequentialExercisesVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/10.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDSequentialExercisesVc.h"
#import "DDRequestMainObj.h"
#import "DDRequestionListCell.h"
#import "DDRequestionTitleCell.h"
#import "DDRequstionRecordObj.h"
#import "UIView+TYAlertView.h"
#import "DDRequestionAllView.h"
#import "DDAuthenVc.h"
@interface DDSequentialExercisesVc () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger _selectedIndex;
    NSMutableArray * _recordList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answeCons;

@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIButton *bottomRightBarButton;
@property (weak, nonatomic) IBOutlet UILabel *bianzhunLb;
@property (weak, nonatomic) IBOutlet UILabel *huidaLb;
@property (nonatomic,strong) DDRequestMainObj * currentObj;
@property (nonatomic,strong) DDRequestionAllView * questionView;
@property (nonatomic,strong) TYAlertController *alertController;
@end

@implementation DDSequentialExercisesVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"顺序练习";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _bottomBarView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bottomBarView.layer.shadowOffset = CGSizeMake(0,3);
    _bottomBarView.layer.shadowRadius = 12;
    _bottomBarView.layer.shadowOpacity = 1;

    [self getQuestionData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DDRequestionListCell" bundle:nil] forCellReuseIdentifier:@"DDRequestionListCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDRequestionTitleCell" bundle:nil] forCellReuseIdentifier:@"DDRequestionTitleCellId"];
    _selectedIndex = -1;
    
    _recordList = @[].mutableCopy;
    _cons.constant = 0;
    _answeCons.constant = 0;
}

- (void)setCurrentObj:(DDRequestMainObj *)currentObj{
    _currentObj = currentObj;
    if (yyTrimNullText(_currentObj.userAnswer).length > 0) {
        _answeCons.constant = 50;
        _bianzhunLb.text = _currentObj.result;
        _huidaLb.text = _currentObj.userAnswer;
        if ([yyTrimNullText(_currentObj.userAnswer) isEqualToString:yyTrimNullText(_currentObj.result)]) {
            _huidaLb.textColor = UIColorHex(0x00F900);
        }else {
            _huidaLb.textColor = [UIColor redColor];
        }
    }else {
        _answeCons.constant = 0;
    }
    if (_currentObj.sumNo == _currentObj.currentNo) {
        [self.nextButton setTitle:@"完成练习" forState:UIControlStateNormal];
    }else {
        [self.nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    }
}

- (void)getQuestionData{
    [DDHub hub:self.view];
    @weakify(self)
    NSString * url = [NSString stringWithFormat:@"%@/exam/question/bank/sequence/%@?identityType=%@&token=%@",DDAPP_URL,_isContinue ? @"getContinueQuestion" : @"getFirstQuestion", _userType == DDUserTypePromoter ? @"2" : @"1",[DDUserManager share].user.token];
    
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           self.currentObj = [DDRequestMainObj modelWithJSON:data];
                           [self.currentObj layoutHeight];
                           [self getQuestionList];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (void)getQuestionList{
    @weakify(self)
    NSString * url = [NSString stringWithFormat:@"%@:%@/%@/exam/question/bank/sequence/questionRecordList?identityType=%@&token=%@",DDAPP_URL,DDPort7001,DDT, _userType == DDUserTypePromoter ? @"2" : @"1",[DDUserManager share].user.token];
    
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                NSArray * data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           self->_recordList = [NSMutableArray new];
                           if (data && [data isKindOfClass:[NSArray class]]){
                               for (NSInteger i =0; i < data.count; i++) {
                                   NSDictionary * dic = data[i];
                                   [self->_recordList addObject:[DDRequstionRecordObj modelWithJSON:dic]];
                               }
                           }
                           self->_cons.constant = iPhoneXAfter ? 65 : 49;
                           [self.bottomRightBarButton setTitle:[NSString stringWithFormat:@"%zd/%zd",self.currentObj.currentNo ,self.currentObj.sumNo] forState:UIControlStateNormal];
                           [self.tableView reloadData];
                       }else {
                       }
                   }];
}

// 下一题
- (IBAction)nextButtonDidClick:(UIButton *)sender {
    if (_currentObj.sumNo == _currentObj.currentNo) {
        [self saveQuestion:NO];
        return;
    }
    if (self.currentObj.isASelect == 2 ||
       self.currentObj.isBSelect == 2 ||
       self.currentObj.isCSelect == 2||
       self.currentObj.isDSelect == 2 ) {
        [self saveQuestion:YES];
    }else {
        [self getNextQuestion:self.currentObj.nextNum];
    }
}

- (void)getNextQuestion:(NSInteger)nextId{
    [DDHub hub:self.view];
    @weakify(self)
    NSString * url = [NSString stringWithFormat:@"%@:%@/%@/exam/question/bank/sequence/getQuestionById?identityType=%@&token=%@&id=%zd",DDAPP_URL,DDPort7001,DDT, _userType == DDUserTypePromoter ? @"2" : @"1",[DDUserManager share].user.token,nextId];
    
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           self.currentObj = [DDRequestMainObj modelWithJSON:data];
                           [self.currentObj layoutHeight];
                           [self getQuestionList];
                           [self.tableView reloadData];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];

}

- (void)saveQuestion:(BOOL)getNextQuestion{
    [DDHub hub:self.view];
    @weakify(self)
    NSString * url = [NSString stringWithFormat:@"%@:%@/%@/exam/question/bank/sequence/saveQuestionRecord?token=%@",DDAPP_URL,DDPort7001,DDT, [DDUserManager share].user.token];
    NSMutableString * userAnswer = @"".mutableCopy;
    if (self.currentObj.isASelect == 2) [userAnswer appendString:@"a"];
    if (self.currentObj.isBSelect == 2) [userAnswer appendString:@"b"];
    if (self.currentObj.isCSelect == 2) [userAnswer appendString:@"c"];
    if (self.currentObj.isDSelect == 2) [userAnswer appendString:@"d"];
    NSDictionary * dic = @{
                           @"questionId" :self.currentObj.questionId,
                           @"identityType" : _userType == DDUserTypePromoter ? @"2" : @"1",
                           @"userAnswer" : userAnswer
                           };
    [[DDAppNetwork share] get:NO
                          url:url
                         body:[dic modelToJSONString]
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       [DDHub dismiss:self.view];
                       if (getNextQuestion) {
                           [self getNextQuestion:self.currentObj.nextNum];
                       }else {
                           [DDHub hubText:@"恭喜您已完成所有练习"];
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [DDAppManager popVc:@"DDAuthenVc" navigtor:self.navigationController];
                           });
                           
                       }
    }];;

}

- (DDRequestionAllView *)questionView{
    if (!_questionView) {
        _questionView = [DDRequestionAllView createViewFromNib];
        @weakify(self)
        _questionView.requestionBlock = ^(DDRequstionRecordObj *obj) {
            @strongify(self)
            if (!self) return ;
            [self.alertController dismissViewControllerAnimated:YES];
            [self getNextQuestion:[obj.recordId integerValue]];
        };
    }
    return _questionView;
}

- (IBAction)allQuestionClick:(UIButton *)sender {
    self.questionView.requestions = _recordList;
    [self.questionView.questionNumberView setTitle:[NSString stringWithFormat:@"%zd/%zd",self.currentObj.currentNo ,self.currentObj.sumNo] forState:UIControlStateNormal];
    _alertController = [TYAlertController alertControllerWithAlertView:self.questionView preferredStyle:TYAlertControllerStyleActionSheet];
    _alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:_alertController animated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentObj ?  5 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DDRequestionTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDRequestionTitleCellId"];
        cell.clipsToBounds = YES;
        cell.nameLb.text =self.currentObj.title;
        cell.typeLb.text = @"单选";
        if (self.currentObj.type == 2) {
            cell.typeLb.text = @"多选";
        }else if (self.currentObj.type == 3) {
            cell.typeLb.text = @"判断";
        }
        return cell;
    }else {
                DDRequestionListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDRequestionListCellId"];
        cell.clipsToBounds = YES;
        NSArray * texts = @[yyTrimNullText(self.currentObj.aSelect),
                            yyTrimNullText(self.currentObj.bSelect),
                            yyTrimNullText(self.currentObj.cSelect),
                            yyTrimNullText(self.currentObj.dSelect)];
        NSArray * values = @[@(self.currentObj.isASelect),
                             @(self.currentObj.isBSelect),
                             @(self.currentObj.isCSelect),
                             @(self.currentObj.isDSelect)];
        NSInteger obj= [values[indexPath.row - 1] integerValue];
        cell.nameLb.text = texts[indexPath.row - 1];
        if (yyTrimNullText(self.currentObj.userAnswer).length > 0) {
            // 回答正确
            if ([self.currentObj.userAnswer isEqualToString:self.currentObj.result]) {
                if ([self isAnsweContain:indexPath.row - 1 result:self.currentObj.result]) {
                    obj = 2;
                }else {
                    obj = 0;
                }
            }else {
                if ([self isAnsweContain:indexPath.row - 1 result:self.currentObj.result]) {
                    obj = 2;
                }else if ([self isAnsweContain:indexPath.row - 1 result:self.currentObj.userAnswer]){
                    obj = 1;
                }else {
                    obj = 0;
                }
            }
        }
        if (obj == 0) {
            cell.iconView.image = [UIImage imageNamed:@"icon_question_place"];
        }else if (obj == 1) {
            cell.iconView.image = [UIImage imageNamed:@"icon_question_error"];
        }else if (obj == 2) {
            cell.iconView.image = [UIImage imageNamed:@"icon_question_ok"];
        }
        return cell;
    }
}

- (BOOL)isAnsweContain:(NSInteger)index result:(NSString *)result{
    NSArray * contains = @[@"a",@"b",@"c",@"d"];
    NSString * curren = contains[index];
    if ([result rangeOfString:curren].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return self.currentObj.titleHeight;
    if (indexPath.row == 1) return self.currentObj.aSelectHeight;
    if (indexPath.row == 2) return self.currentObj.bSelectHeight;
    if (indexPath.row == 3) return self.currentObj.cSelectHeight;
    return self.currentObj.dSelectHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return;
    if (yyTrimNullText(self.currentObj.userAnswer).length > 0) return;
    // 单选
    if (self.currentObj.type != 2) {
        if (_selectedIndex == -1) {
            _selectedIndex = indexPath.row;
        }else if (_selectedIndex != indexPath.row) {
            if (_selectedIndex == 1)
               self.currentObj.isASelect = 0;
            if (_selectedIndex == 2)
               self.currentObj.isBSelect = 0;
            if (_selectedIndex == 3)
               self.currentObj.isCSelect = 0;
            if (_selectedIndex == 4)
               self.currentObj.isDSelect = 0;
        }
    }
    NSArray * values = @[@(self.currentObj.isASelect),
                         @(self.currentObj.isBSelect),
                         @(self.currentObj.isCSelect),
                         @(self.currentObj.isDSelect)];
    NSInteger obj= [values[indexPath.row - 1] integerValue];
    if (obj == 0 ){
        obj = 2;
    }else {
        obj = 0;
    }
    if (indexPath.row == 1)
       self.currentObj.isASelect = obj;
    if (indexPath.row == 2)
       self.currentObj.isBSelect = obj;
    if (indexPath.row == 3)
       self.currentObj.isCSelect = obj;
    if (indexPath.row == 4)
       self.currentObj.isDSelect = obj;
    
    _selectedIndex = indexPath.row;
    [self.tableView reloadData];
}

@end
