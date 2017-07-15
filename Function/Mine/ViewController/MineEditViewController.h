//
//  MineEditViewController.h
//  Leqi
//  用户资料编辑的VC
//  Created by 张汇丰 on 16/1/11.
//  Copyright © 2016年 com.hoolai. All rights reserved.
//

#import "QDRootViewController.h"

@class UserInfoModel;

typedef NS_ENUM(NSInteger,EditType) {
    EditName,       //修改名字，邮箱，手机
    EditPassword    //修改密码
};


@interface MineEditViewController : QDRootViewController

@property (nonatomic,assign) EditType editType;
/** 例如:昵称*/
@property (nonatomic,copy) NSString *leftKey;
/** 例如:张汇丰*/
@property (nonatomic,copy) NSString *rightValue;
/** 用户信息的model*/
@property (nonatomic,strong) UserInfoModel *userInfoModel;

@end
