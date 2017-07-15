//
//  UserDefaultConstant.h
//  QiDai
//
//  Created by 张汇丰 on 16/4/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//
//  UserDefaultConstant里放NSUserDefault相关的key


#ifndef UserDefaultConstant_h
#define UserDefaultConstant_h


#endif /* UserDefaultConstant_h */


#define kOFFLINEMAP_NEEDRELOAD @"NSUSERDEFAULT_OFFLINEMAP_ALLFINISH" // 离线地图是否需加载的状态

#define kLOGIN_TELEPHONE_USERID @"telephone_login_userid" // 手机号登录，后台返回的userid
#define kNSUSERDEFAULT_SINALOGIN_USERID @"sina_login_userid" // 新浪微博登录，后台返回的userId
#define kNSUSERDEFAULT_QQLOGIN_USERID @"qq_login_userid" // qq登录，后台返回的userid
#define kNSUSERDEFAULT_WECHATLOGIN_USERID @"weChat_login_userid" // 微信登录，后台返回的userid

#define kNSUSERDEFAULT_BICYCLEBRAND @"bicycle_brand" // 储存单车字符串

#define kCLOCKOPEN          @"clock_open"           // 是否打开码表
#define kCLOCKWEIGHT        @"clock_weight"         // 码表设置的重量
#define kCLOCKPERIMETER     @"clock_perimeter"      // 码表设置的周长
#define kCLOCKINDETIFIER    @"clock_identifier"     // 上次配对的码表标示

/**************** 运动有关 ****************/
#define kSportData          @"sport_data"           // 运动数据
#define kSportPoint         @"sport_point"           // 运动的点
static NSString *const kSportPhotoCount = @"sport_photo_count";     //运动的时候保存照片的数量，最多4张，运动结束清零
/**************** 运动有关 ****************/

/**************** 活动有关 ****************/
#define kAddTaskSuccess       @"AddTaskSuccess"    //成功添加任务  二维码添加任务 三个相关操作
#define kAddTaskSuccessUpdateTaskHome       @"AddTaskSuccessUpdateTaskHome"    //成功添加任务  任务页面更新
#define kAddTaskSuccessUpdateSportHome       @"AddTaskSuccessUpdateSportHome"    //成功添加任务 骑行页面更新

#define kHaveTask       @"have_task"    //是否参加了活动
#define kTaskInformation @"task_information"    //活动的信息
#define kTaskDistancePerDay @"task_distance_per_day"    //活动每天需要骑多少公里
#define kTaskDistanceDay @"task_distance_day"    //活动今天骑多少公里

#define kTaskModelInfo @"task_model_info"    //活动的相关信息

/**************** 活动有关 ****************/

#define kFind_cityCode        @"find_cityCode"           // 城市
#define kFind_city        @"find_city"
#define kFind_longitude        @"find_longitude"           // 经度
#define kFind_latitude        @"find_latitude"           // 维度

#define kOpenDebug        @"open_debug"           // 打印网络请求的开关

#define kSHOPSEACHHISTORY         @"shop_seach_history"           // 搜索历史

#define kGUIDEISFIRSTSHOW @"GUIDEISFIRSTSHOW"   //是否第一次登陆，显示引导页


/**************** 登录成功 刷新界面 ****************/

#define kLoginSuccessUpdateTaskHome       @"LoginSuccessUpdateTaskHome"    //登录成功  任务页面更新
#define kLoginSuccessUpdateSportHome       @"LoginSuccessUpdateSportHome"    //登录成功  骑行页面更新
