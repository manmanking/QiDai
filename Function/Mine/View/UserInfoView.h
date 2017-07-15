//
//  UserInfoView.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoModel;
@interface UserInfoView : UIView

@property (nonatomic,strong) UserInfoModel *userInfoModel;

@property (nonatomic,strong) UILabel *distanceLabel;

@property (nonatomic,strong) UILabel *durationLabel;

@property (nonatomic,copy) ClickView clickIconBlock;

@property (nonatomic,strong) UIImageView *bgImageView;

@end
