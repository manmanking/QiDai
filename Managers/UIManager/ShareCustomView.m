//
//  ShareCustomView.m
//  QiDai
//
//  Created by manman'swork on 16/11/18.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "UMSocial.h"
//#import "UMSocialCore/UMSocialCore.h"
//#import "UMSocialUIManager.h"
#import "ShareCustomView.h"

@interface ShareCustomView()

@property (nonatomic,strong)UIView *baseBackgroundView;

@property (nonatomic,strong)UIView *bottomShareButtonBackgroundView;

@property (nonatomic,strong)UIButton *wechatButton;

@property (nonatomic,strong)UIButton *sinaButton;

@property (nonatomic,strong)UIButton *qqButton;

@property (nonatomic,strong)UIButton *wechatTimeButton;

@property (nonatomic,strong)UIButton *cancelButton;





@end



@implementation ShareCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customUIViewAutolayout];
    }
    return self;
}

- (void)customUIViewAutolayout
{
    [self addSubview:self.baseBackgroundView];
    [self addSubview:self.bottomShareButtonBackgroundView];
    [self addSubview:self.cancelButton];
    [self addSubview:self.wechatButton];
    [self addSubview:self.wechatTimeButton];
    [self addSubview:self.qqButton];
    [self addSubview:self.sinaButton];
 
}


- (void)wechatButtonClick:(UIButton *)sender
{
    NSLog(@"wechatButtonClick ...");

//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    //设置文本
//    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            NSLog(@"response data is %@",data);
//        }
//    }];
    
//    
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建图片内容对象
//    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
//    [shareObject setShareImage:@"http://dev.umeng.com/images/tab2_1.png"];
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            NSLog(@"response data is %@",data);
//        }
//    }];
//    
}


- (void)wechatTimeButtonClick:(UIButton *)sender
{
    NSLog(@"wechatButtonClick ...");
//    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType)platformType
//messageObject:(UMSocialMessageObject *)messageObject
//currentViewController:(id)currentViewController
//completion:(UMSocialRequestCompletionHandler)completion]
    
}


- (void)sinaButtonClick:(UIButton *)sender
{
    NSLog(@"wechatButtonClick ...");
    
    
}


- (void)qqButtonClick:(UIButton *)sender
{
    NSLog(@"wechatButtonClick ...");
    
    
}

- (void)cancelButtonClick:(UIButton *)sender
{
    NSLog(@"取消...");
    [self removeFromSuperview];
    
    
    
    
}


- (void)shareImage:(NSString *) shareTypeStr andImage:(UIImage *)shareImage
{
    
    if ([shareTypeStr isEqualToString:@"wechat"])
    {
       
    }
    else if ([shareTypeStr isEqualToString:@"wechatTime"])
    {
        
    }
    else if ([shareTypeStr isEqualToString:@"sina"])
    {
        
    }
    else if ([shareTypeStr isEqualToString:@"qq"])
    {
        
    }
    
    
    
}



#pragma lazy load --------------


- (UIView *)baseBackgroundView
{
    if (!_baseBackgroundView) {
        _baseBackgroundView = [[UIView alloc]initWithFrame:MAIN_WINDOW.frame];
        _baseBackgroundView.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _baseBackgroundView;
    
    
    
    
}


- (UIView *)bottomShareButtonBackgroundView
{
    if (!_bottomShareButtonBackgroundView) {
        _bottomShareButtonBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(20, 1000, 710, 200)];
        _bottomShareButtonBackgroundView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _bottomShareButtonBackgroundView;
    
    
}

- (UIButton *)wechatButton
{
    if (!_wechatButton) {
        _wechatButton = [[UIButton alloc]initWithFrame:CGRectMake(100,100,100,100)];
        [_wechatButton setTitle:@"微信" forState:UIControlStateNormal];
        [_wechatButton addTarget:self action:@selector(wechatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatButton;
}
- (UIButton *)wechatTimeButton
{
    if (!_wechatTimeButton) {
        _wechatTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(100,100,100,100)];
        [_wechatTimeButton setTitle:@"朋友圈" forState:UIControlStateNormal];
        [_wechatTimeButton addTarget:self action:@selector(wechatTimeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatTimeButton;
}


- (UIButton *)qqButton
{
    if (!_qqButton) {
        _qqButton = [[UIButton alloc]initWithFrame:CGRectMake(100,100,100,100)];
        [_qqButton setTitle:@"微信" forState:UIControlStateNormal];
        [_qqButton addTarget:self action:@selector(wechatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqButton;
}
- (UIButton *)sinaButton
{
    if (!_sinaButton) {
        _sinaButton = [[UIButton alloc]initWithFrame:CGRectMake(100,100,100,100)];
        [_sinaButton setTitle:@"微信" forState:UIControlStateNormal];
        [_sinaButton addTarget:self action:@selector(wechatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sinaButton;
}


- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 1240, 710, 80)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
    
    
}



@end
