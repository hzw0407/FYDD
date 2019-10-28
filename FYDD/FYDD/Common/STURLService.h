//
//  STURLService.h
//  FYDD
//
//  Created by 何志武 on 2019/10/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#ifndef STURLService_h
#define STURLService_h

#define InterfaceBaseDebug 1 //0表示正式环境，1表示测试环境

// 1期接口地址
#if InterfaceBaseDebug
//测试环境
#define DDAPP_URL @"http://47.107.166.105"
#else
//正式环境
#define DDAPP_URL @"http://app.3tmall.com"
#endif

#define DDPort7001 @"7001"
#define DDPort8003 @"8003"

// 二期接口地址
#define DDAPP_2T_URL @"http://47.107.166.105:8004"


//获取版本
#define GETVERSION @"/uas/t/version/getIosVersion"
//软文列表
#define ADVERTORIALSLIST @"/t-phase/advertorial/listByType"
//增加浏览量
#define ADDBROWSER @"/t-phase/advertorial/addBrowserNum"
//获取邀请码
#define GETINVITATIONCODE @"/uas/user/extension/user/extensionAgent/getUserAgentCode"

#endif /* STURLService_h */
