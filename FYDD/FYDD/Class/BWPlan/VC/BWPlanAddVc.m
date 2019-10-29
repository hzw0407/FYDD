//
//  BWPlanAddVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "BWPlanAddVc.h"
#import "DDUserManager.h"
#import "BRStringPickerView.h"
#import "DDIndustryModel.h"

@interface BWPlanAddVc ()<UITextFieldDelegate>
{
    NSArray * _industrys;
    NSArray * _industryNames;
    NSString *_currentIndustryname;
    NSString *_currentIndustryId;
}
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;

@end

@implementation BWPlanAddVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加我的客户";
    
    self.phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextfield.delegate = self;
    
    [self getIndustryData];
}

- (void)getIndustryData{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/enterprise/industry/getIndustryList?token=", [DDUserManager share].user.token)
                         body:@""
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           NSMutableArray * industry = @[].mutableCopy;
                           NSMutableArray * industryName = @[].mutableCopy;
                           if ([data isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in (NSArray *)data) {
                                   DDIndustryModel * model = [DDIndustryModel modelWithJSON:dic];
                                   [industryName addObject:yyTrimNullText(model.name)];
                                   [industry addObject:model];
                               }
                           }
                           self->_industrys = industry;
                           self->_industryNames = industryName;
                       }
                   }];
}


- (IBAction)chooseHanyebutton:(id)sender {
    [self.view endEditing:YES];
    if (_industryNames.count == 0) {
        return;
    }
    @weakify(self)
    [BRStringPickerView showStringPickerWithTitle:@"所属行业"
                                       dataSource:_industryNames
                                  defaultSelValue:nil
                                      resultBlock:^(NSString * selectValue) {
                                          @strongify(self)
                                          if (!self) return ;
                                          for (DDIndustryModel * model in self->_industrys){
                                              if ([selectValue isEqualToString: model.name]){
                                                  self->_currentIndustryname = selectValue;
                                                  self->_currentIndustryId = model.ddId;
                                                  UITextField * td = self.textFields[2];
                                                  td.text = selectValue;
                                                  break;
                                              }
                                          }
                                      }];

}

- (void)checkCompany:(void (^)(BOOL suc))completion{
    NSString * userName = [self getTextFieldFromText:0];
    NSString * soialCode = [self getTextFieldFromText:1];
    if (userName.length == 0) {
        [DDHub hub:@"请输入企业名称" view:self.view];
        return;
    }
//    if (soialCode.length != 18) {
//        [DDHub hub:@"请输入18位社会信用代码" view:self.view];
//        return;
//    }
    @weakify(self)
    [DDHub hub:self.view];
    [[DDAppNetwork share] get:YES
                          url:[NSString stringWithFormat:@"%@/million/plan/checkCompony?token=%@&code=%@",DDAPP_2T_URL,[DDUserManager share].user.token,soialCode]
                         body:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       BOOL checkOK = [data boolValue];
                       if (code  == 200 && checkOK) {
                           if (completion) {
                               completion(YES);
                           }
                       }else {
                           if (completion) {
                               completion(NO);
                           }
                       }
                   }];

}

- (IBAction)commitPlan {
    @weakify(self)
    
    [self checkCompany:^(BOOL suc) {
        @strongify(self)
        if (!self) return ;
        if (suc) {
            NSString * userName = [self getTextFieldFromText:0];
            NSString * soialCode = [self getTextFieldFromText:1];
            NSString * number = [self getTextFieldFromText:3];
            NSString * daibiao = [self getTextFieldFromText:4];
            NSString * contactUser = [self getTextFieldFromText:5];
            NSString * phone = [self getTextFieldFromText:6];
            if (self->_currentIndustryname.length == 0) {
                [DDHub hub:@"请输入行业" view:self.view];
                return;
            }
//            if (soialCode.length == 0) {
//                [DDHub hub:@"请输入18位社会信用代码" view:self.view];
//                return;
//            }
            if (number.length == 0) {
                [DDHub hub:@"请输入人数" view:self.view];
                return;
            }
            if (daibiao.length == 0) {
                [DDHub hub:@"请输入法定代表" view:self.view];
                return;
            }
            if (contactUser.length == 0) {
                [DDHub hub:@"请输入联系人" view:self.view];
                return;
            }
            if (phone.length != 11) {
                [DDHub hub:@"请输入有效的联系方式" view:self.view];
                return;
            }
            
            NSDictionary * dic = @{@"customerName" : userName,
                                   @"customerCreditCode" : soialCode,
                                   @"customerIndustry" : self->_currentIndustryname,
                                   @"companyNumber" : @([number integerValue]),
                                   @"contactsName" : contactUser,
                                   @"contactsTelephone" : phone,
                                   @"legalUser": daibiao,
                                   };
            [DDHub hub:self.view];
            [[DDAppNetwork share] get:NO
                                  url:[NSString stringWithFormat:@"%@/million/plan/addMillinPlan?token=%@",DDAPP_2T_URL,[DDUserManager share].user.token]
                                 body:[dic modelToJSONString]
                           completion:^(NSInteger code,
                                        NSString *message,
                                        id data) {
//                               [DDHub hub:message view:self.view];
                                 [DDHub dismiss:self.view];
                               if (code  == 200) {
                                   [DDHub hub:@"添加我的客户成功" view:self.view];
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       [self.navigationController popViewControllerAnimated:YES];
                                   });
                               }
                           }];
        }
    }];
}

- (NSString *)getTextFieldFromText:(NSInteger)start{
    UITextField * td = _textFields[start];
    return td.text;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField == self.phoneTextfield) {
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

@end
