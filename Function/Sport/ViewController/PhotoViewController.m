//
//  PhotoViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/15.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PhotoViewController.h"
#import "UMSocial.h"
#import "SinaManager.h"
#import "QQManager.h"
#import "WeChatManager.h"
@interface PhotoViewController ()<UMSocialUIDelegate>

/** photo的容器*/
@property (nonatomic,strong) UIImageView *photoImageView;

/** 时候保存，默认不保存*/
//@property (nonatomic,assign) NSInteger isSave;

@end

@implementation PhotoViewController
{
    /** 是否保存到app本地*/
    BOOL _isSaveLocation;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    // Do any additional setup after loading the view.
}
#pragma mark --- ui
//创建视图,没用mvc
- (void)setupUI {
//    UIButton *cancelBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(40, 53, 80, 50) title:@"取消" titleColor:[UIColor blackColor] titleFont:36 backgroundColor:nil tapAction:^(UIButton *button) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [self.view addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(600, 53, 80, 50) title:@"完成" titleColor:[UIColor blackColor] titleFont:36 backgroundColor:nil tapAction:^(UIButton *button) {
        if (_isSaveLocation) {
            int pictureCount = [[kNSUSERDEFAULE objectForKey:kSportPhotoCount] intValue];
            [self saveImage:self.photo withName:[NSString stringWithFormat:@"picture%d.png",pictureCount + 1] withDirectoryStr:@"picture"];
            [kNSUSERDEFAULE setObject:@(pictureCount + 1) forKey:kSportPhotoCount];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:sureBtn];
    
    UIView *photoBgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 148, 720, 782)];
    photoBgView.backgroundColor = UIColorFromRGB_16(0xf2f2f2);
    [self.view addSubview:photoBgView];
    [photoBgView addSubview:self.photoImageView];
    
    //保存按钮 ---小红点
    UIButton *saveBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(66, 60 + 930, 58, 58) NormalBackgroundImageString:@"photo_save_btn" tapAction:^(UIButton *button) {
        button.selected = !button.selected;
        _isSaveLocation = button.selected;
    }];
    saveBtn.selected = YES;
    _isSaveLocation = YES;
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"photo_save_btn_p"] forState:UIControlStateSelected];
    [self.view addSubview:saveBtn];
    
    UILabel *textLabel1 = [UILabel qd_labelWithFrame:CGRectMake720(178, 55 + 930, 470, 35) title:@"图片同时保存到骑行记录中" titleColor:kColorFor000 textAlignment:NSTextAlignmentLeft font:34];
    [self.view addSubview:textLabel1];
    UILabel *textLabel2 = [UILabel qd_labelWithFrame:CGRectMake720(178, 90 + 930, 470, 35) title:@"(骑行记录最多保存4张图片)" titleColor:kColorFor000 textAlignment:NSTextAlignmentLeft font:34];
    int pictureCount = [[kNSUSERDEFAULE objectForKey:kSportPhotoCount] intValue];
    
    if (pictureCount >= 4) {
        pictureCount = 4;
        _isSaveLocation = NO;
        saveBtn.hidden = YES;
        textLabel1.hidden = NO;
        //modify by manman on 2016-09-12 excuse show BUG  214  start of line
        //textLabel1.centerX = self.view.centerX;
        [self.view addSubview:textLabel1];
        
        // end of line
        //textLabel2.centerX = self.view.centerX;
        [self.view addSubview:textLabel2];
    }
    else
    {
    
    
    //modify by manman on 2016-09-12 excuse show BUG  214  start of line
    //textLabel1.centerX = self.view.centerX;
    [self.view addSubview:textLabel1];
    // end of line
    textLabel2.text = [NSString stringWithFormat:@"(骑行记录最多保存%d张图片)",4 - pictureCount];
    [self.view addSubview:textLabel2];
        
    }
    
    [self setupShareView];
    
}
/** 分享有关视图的创建*/
- (void)setupShareView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 1108, 720, 172)];
    bgView.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    [self.view addSubview:bgView];
    //判断是否安装了客户端，没有则隐藏
    NSMutableArray *imageArrayM = @[].mutableCopy;
    if ([[WeChatManager instance] isWeChatInstalled]) {
        [imageArrayM addObject:@"sport_share_friend"];
        [imageArrayM addObject:@"sport_share_wechart"];
    }
    if ([[QQManager instance] isQQInstalled]) {
        [imageArrayM addObject:@"sport_share_qq"];
    }
    if ([[SinaManager instance] isSinaInstalled]) {
        [imageArrayM addObject:@"sport_share_sina"];
    }
    for (NSInteger i = 0; i < imageArrayM.count; i++) {
        UIButton *btn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(30 + i*(84+60), 44, 84, 84) NormalImageString:imageArrayM[i] tapAction:^(UIButton *button) {
            [self clickShareWithTag:i];
        }];
        [bgView addSubview:btn];
    }
}
#pragma mark --- private method
//保存图片到本地，返回路径
- (NSString *)saveImage:(UIImage *)currentImage withName:(NSString *)imageName withDirectoryStr:(NSString *)str {
    //判断有无pictureCount这个字段，没有就创建
    if(![kNSUSERDEFAULE objectForKey:@"pictureCount"]) {
        [kNSUSERDEFAULE setObject:@(0) forKey:@"pictureCount"];
        [kNSUSERDEFAULE synchronize];
    }
    int pictureCount = [[kNSUSERDEFAULE objectForKey:@"pictureCount"] intValue];
    imageName = [NSString stringWithFormat:@"picture%d.png",pictureCount + 1];
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.01);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectory stringByAppendingPathComponent:str];
    // 创建目录
    [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *fullPath;
    
    if (self.sportTimeStr) {
        
        NSString *patch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",str,self.sportTimeStr]];
        BOOL a = YES;
        if (![fileManager fileExistsAtPath:patch isDirectory:&a]) {
            [fileManager createDirectoryAtPath:patch withIntermediateDirectories:YES attributes:nil error:nil];
        }
        // 获取沙盒目录
        fullPath = [patch stringByAppendingPathComponent:imageName];
    } else {
        // 获取沙盒目录
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",str]] stringByAppendingPathComponent:imageName];
    }

    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    NSLog(@"路径%@",[NSString stringWithFormat:@"Documents/%@/%@",str,imageName]);
    return [NSString stringWithFormat:@"Documents/%@/%@",str,imageName];
}

#pragma mark --- click method
- (void)clickShareWithTag:(NSInteger)tag {
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    NSMutableArray *arrayM = @[].mutableCopy;
    if ([[WeChatManager instance] isWeChatInstalled]) {
        [arrayM addObject:UMShareToWechatTimeline];
        [arrayM addObject:UMShareToWechatSession];
    }
    if ([[QQManager instance] isQQInstalled]) {
        [arrayM addObject:UMShareToQQ];
    }
    if ([[SinaManager instance] isSinaInstalled]) {
        [arrayM addObject:UMShareToSina];
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[ arrayM[tag] ] content:@"" image:self.photo location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            //NSLog(@"分享成功！");
        }
    }];
}
#pragma mark --- set method
- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    self.photoImageView.image = photo;
}
#pragma mark --- lazy load
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(66, 0, 588, 782)];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _photoImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
