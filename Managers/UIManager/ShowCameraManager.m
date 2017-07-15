//
//  ShowCameraManager.m
//  Leqi
//
//  Created by Tianyu on 15/1/13.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "ShowCameraManager.h"

#import "NSString+Tools.h"

#import "PhotoViewController.h"

typedef void(^GetImageBlock)(NSString *imgStr);

@interface ShowCameraManager ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AMapSearchDelegate>

@property (strong, nonatomic) UIViewController *viewControll;
@property (copy, nonatomic) GetImageBlock getImgBlock;
@property (assign, nonatomic) int actionTag;
@property (strong, nonatomic) AMapSearchAPI *amapSearch;
@property (strong, nonatomic) NSString *directoryPath;
@property (strong, nonatomic) NSString *geoKey;

@end

@implementation ShowCameraManager

+ (instancetype)instance
{
    static id pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc] init];
    });
    return pRet;
}

- (void)showActionSheetInTabbar:(UITabBar *)tabbar inViewController:(UIViewController *)vc compate:(void(^)(NSString *imgStr))comapte
{
    UIActionSheet *actionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", nil];
        
    }
    self.actionTag = 100;
    [actionSheet showFromTabBar:tabbar];
    self.getImgBlock = comapte;
    self.viewControll = vc;
}
//运动拍照
- (void)showActionSheetInView:(UIView *)view inViewController:(UIViewController *)vc
{
    self.actionTag = 200;
    self.viewControll = vc;
    [self showCameraWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

//点击头像
- (void)showActionForForeSheetInTabbar:(UITabBar *)tabbar inViewController:(UIViewController *)vc compate:(void(^)(NSString *imgStr))comapte
{
    UIActionSheet *actionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"从相册选择", nil];
        
    }

    self.actionTag = 300;
    [actionSheet showFromTabBar:tabbar];
    self.getImgBlock = comapte;
    self.viewControll = vc;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
                break;
            default:
                break;
        }
        
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    [self showCameraWithSourceType:sourceType];
    
}
#pragma -mark - 是否截取
- (void)showCameraWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
#pragma -mark --正方形
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        imagePickerController.allowsEditing = YES;
    }else{
        if (self.actionTag == 300) {
            imagePickerController.allowsEditing = YES;
        }else{
            imagePickerController.allowsEditing = NO;
        }
    }
    imagePickerController.sourceType = sourceType;
    
    if([[[UIDevice
          currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.viewControll.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }
    [self.viewControll presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
     willShowViewController:(UIViewController *)viewController
                   animated:(BOOL)animated {
         QDLog(@"show camera statusbar:%d",[UIApplication sharedApplication].statusBarHidden);
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
         QDLog(@"show camera statusbar :%d",[UIApplication sharedApplication].statusBarHidden);
}

- (BOOL)prefersStatusBarHidden   // iOS8 definitely needs this one. checked.
{
    QDLog(@"show camera statusbar 3:%d",[UIApplication sharedApplication].statusBarHidden);

    return YES;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return nil;
}
//完成
#pragma mark --- 点击完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //[picker dismissViewControllerAnimated:YES completion:nil];
    //弃用
    if (self.actionTag == 100) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (self.getImgBlock) {
            self.getImgBlock([self saveImage:image withName:@"equipImage.png" withDirectoryStr:@"userImage"]);
        }
    } else if (self.actionTag == 200) {
        
        //照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        

        //CGFloat proportion = image.size.width/HCDW;
        CGFloat height = HCDW*image.size.height/image.size.width;
        CGSize offScreenSize = CGSizeMake(HCDW, height);
        UIGraphicsBeginImageContextWithOptions(offScreenSize,NO,0);
        [image drawInRect:CGRectMake(0, 0, HCDW, height)];
        UIImage *image1 = [UIImage imageNamed:@"photo_watermark"];
        //四个参数为水印图片的位置
        [[UIImage imageNamed:@"photo_watermark"] drawInRect:CGRectMake(38*SizeScale, height - 79*SizeScale, image1.size.width, image1.size.height)];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if(![kNSUSERDEFAULE objectForKey:@"pictureCount"]) {
            [kNSUSERDEFAULE setObject:@(0) forKey:@"pictureCount"];
            [kNSUSERDEFAULE synchronize];
        }
        int pictureCount = [[kNSUSERDEFAULE objectForKey:@"pictureCount"] intValue];
        
        //[self saveImage:image withName:[NSString stringWithFormat:@"picture%d.png",pictureCount + 1] withDirectoryStr:@"picture"];
        [kNSUSERDEFAULE setObject:@(pictureCount + 1) forKey:@"pictureCount"];
        [kNSUSERDEFAULE synchronize];
        UIImageWriteToSavedPhotosAlbum(resultingImage, nil, nil, nil);//保存到相簿
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
        
        PhotoViewController *vc = [[PhotoViewController alloc]init];
        vc.photo = resultingImage;
        vc.sportTimeStr = self.sportTimeStr;
        //[picker presentViewController:vc animated:YES completion:nil];
        [picker pushViewController:vc animated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
        //头像
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (self.getImgBlock) {
            self.getImgBlock([self saveImage:image withName:@"foreImage.png" withDirectoryStr:@"foreImage"]);
        }
    }
    
    
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    
}

//点击取消的过程
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片到本地，返回路径
- (NSString *)saveImage:(UIImage *)currentImage withName:(NSString *)imageName withDirectoryStr:(NSString *)str {
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.01);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectory stringByAppendingPathComponent:str];
    // 创建目录
    [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *fullPath;
    
    if (self.sportTimeStr && self.actionTag == 200) {
        
        NSString *patch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",str,self.sportTimeStr]];
        BOOL a = YES;
        if (![fileManager fileExistsAtPath:patch isDirectory:&a]) {
            [fileManager createDirectoryAtPath:patch withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _directoryPath = patch;
        _geoKey = [[imageName componentsSeparatedByString:@"."] firstObject];
        // 获取沙盒目录
        fullPath = [patch stringByAppendingPathComponent:imageName];
        
        //[self requestGeoWithLon:_lon lat:_lat];
    
    } else {
        // 获取沙盒目录
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",str]] stringByAppendingPathComponent:imageName];
    }
    
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
    return [NSString stringWithFormat:@"Documents/%@/%@",str,imageName];
}

//给照片添加水印
- (void)addWatermark {
    
}

#pragma mark kGAODELBS_KEY

//-(void)requestGeoWithLon:(float)lon lat:(float)lat{
//    
//    if (!_amapSearch) {
//        _amapSearch = [[AMapSearchAPI alloc] initWithSearchKey:kGAODELBS_KEY Delegate:self];
//    }
//    
//    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
//    request.searchType =  AMapSearchType_ReGeocode;
//    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
//    request.location = point;
//    [_amapSearch AMapReGoecodeSearch:request];
//}


- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    /*
     
     @property (nonatomic, strong) NSString *province; // 省
     @property (nonatomic, strong) NSString *city; // 市
     @property (nonatomic, strong) NSString *district; // 区
     @property (nonatomic, strong) NSString *township; // 乡镇
     @property (nonatomic, strong) NSString *neighborhood; // 社区
     @property (nonatomic, strong) NSString *building; // 建筑
     @property (nonatomic, strong) NSString *citycode; // 城市编码
     @property (nonatomic, strong) NSString *adcode; // 区域编码
     @property (nonatomic, strong) AMapStreetNumber *streetNumber; // 门牌信息
     */
    NSLog(@"city = %@",response.regeocode.addressComponent);
    

    NSString* dataPlistPath = [_directoryPath stringByAppendingPathComponent:geo_plist_name];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPlistPath]) {
        dictionary = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:dataPlistPath]];
    }
    
    NSString *geoValue = [NSString stringWithFormat:@"%@",response.regeocode.addressComponent.district];
    if ([response.regeocode.addressComponent.neighborhood isExist]) {
        geoValue = [geoValue stringByAppendingFormat:@"%@",response.regeocode.addressComponent.neighborhood];
    }else if ([response.regeocode.addressComponent.township isExist]) {
        geoValue = [geoValue stringByAppendingFormat:@"%@",response.regeocode.addressComponent.township];
    }
    
    [dictionary setValue:geoValue forKey:_geoKey];
    [dictionary writeToFile:dataPlistPath atomically:YES];
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"error = %@",error);
}
@end
