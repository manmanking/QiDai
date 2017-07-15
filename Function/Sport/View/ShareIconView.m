//
//  ShareIconView.m
//  QiDai
//
//  Created by 张汇丰 on 16/8/4.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShareIconView.h"
#import "UserInfoModel.h"
#import "UserInfoDBManager.h"
#import "UIImageView+WebCache.h"
@implementation ShareIconView
{
    /** 头像*/
    UIImageView *_foreImgView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self creatIconView];
    }
    return self;
}

- (void)creatIconView {

    _foreImgView = [[UIImageView alloc]initWithFrame:CGRectMake1(62, 207-192, 194, 194)];
    [_foreImgView.layer setCornerRadius:194/2*SizeScale1];
    [_foreImgView.layer setMasksToBounds:YES];
    [self addSubview:_foreImgView];
    
    UserInfoModel *userInfo = [UserInfoDBManager getUserInfoWithUserId:kUserId];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(331, 289-192, 300, 60)];
    nameLabel.text = userInfo.nickName;
    nameLabel.textColor = UIColorFromRGB_10(230, 0, 18);
    nameLabel.font = [UIFont systemFontOfSize:54*SizeScale1];
    [self addSubview:nameLabel];
    
    
    if ([userInfo.foreImg isExist]) {
        if ([userInfo.foreImg hasPrefix:@"http"]) {
            
            [_foreImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.foreImg] placeholderImage:[UIImage imageNamed:@"head_portrait_btn"]];
        } else {
            
            _foreImgView.image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:userInfo.foreImg]];
            
        }
    } else {
        [_foreImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.foreImg] placeholderImage:[UIImage imageNamed:@"head_portrait_btn"]];
    }
}


@end
