//
//  SportShareView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/16.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportShareView.h"
#import "SinaManager.h"
#import "QQManager.h"
#import "WeChatManager.h"
@implementation SportShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    self.backgroundColor = [UIColor blackColor];
    
    //如果本地没有安装客户端，则隐藏/
    NSMutableArray *imageArrayM = @[].mutableCopy;
    NSMutableArray *platformArrayM = @[].mutableCopy;
    if ([[WeChatManager instance] isWeChatInstalled]) {
        [imageArrayM addObject:@"sport_share_friend"];
        [imageArrayM addObject:@"sport_share_wechart"];
        [platformArrayM addObject:@"朋友圈"];
        [platformArrayM addObject:@"微信"];
    }
    //qq空间不支持长图分享
    if ([[QQManager instance] isQQInstalled]) {
        //[imageArrayM addObject:@"sport_share_zone"];
        [imageArrayM addObject:@"sport_share_qq"];
        //[platformArrayM addObject:@"QQ空间"];
        [platformArrayM addObject:@"QQ好友"];
    }
    // modify by manman   BUG 207 修改为若微博没有安装则改为网页版分享
    // start of line
    //if ([[SinaManager instance] isSinaInstalled]) {
        [imageArrayM addObject:@"sport_share_sina"];
        [platformArrayM addObject:@"微博"];
    //}
    
    
    // end of line
    for (NSInteger i = 0; i < imageArrayM.count; i++) {
        NSInteger a = i/3;
        NSInteger b = i%3;
        UIButton *btn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(66 + b*(110+129), 522 + a*208, 110, 110) NormalImageString:imageArrayM[i] tapAction:^(UIButton *button) {
            //[self clickShareWithTag:i];
            self.clickShareBtnBlock(i);
        }];
        [self addSubview:btn];
        
        UILabel *platformLabel = [UILabel qd_labelWithFrame:CGRectMake720(b * 240, 650 + 212*a, 240, 24) title:platformArrayM[i] titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:24];
        [self addSubview:platformLabel];
    }

    
    UIButton *closeBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(335, 0, 50, 50) NormalImageString:@"share_close_btn" tapAction:^(UIButton *button) {
        self.clickCloseBlock();
        [self deallocSelf];
    }];
    //closeBtn.top = self.height - 150*SizeScale - kNavigationViewHeight;
    closeBtn.top = (522+208+116)*SizeScale + 64;
    [self addSubview:closeBtn];
    
}
- (void)deallocSelf {
    [self removeFromSuperview];
}
@end
