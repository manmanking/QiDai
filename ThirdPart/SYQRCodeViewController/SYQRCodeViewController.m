//
//  SYQRCodeViewController.m
//  SYQRCodeDemo
//
//  Created by sunbb on 15-1-9.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "SYQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds



// modify by manman
//
//static const float kReaderViewWidth = 224;
//static const float kReaderViewHeight = 224;
//static const float kLineMinY = 334;
//static const float kLineMaxY = 334 +kReaderViewWidth ;


// 原数据
static const float kLineMinY = 185;
static const float kLineMaxY = 385;
static const float kReaderViewWidth = 200;
static const float kReaderViewHeight = 200;


// 现在将要添加 相册识别二维码的工程 现在native


@interface SYQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *qrSession;//回话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;//读取
@property (nonatomic, strong) UIImageView *line;//交互线
@property (nonatomic, strong) NSTimer *lineTimer;//交互线控制

@end

@implementation SYQRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.view.backgroundColor = UIColorFromRGB_10(22,25,33);
    
    [self initUI];
    [self setOverlayPickerView];
    [self startSYQRCodeReading];
    //[self initTitleView];
    [self setupNavigationBar];
    //[self createBackBtn];
    //[self createPhotoAlbumButton];
}
- (void)viewWillAppear:(BOOL)animated
{
     QDLog(@"prefersStatusBarHidden ... %d",animated);
    // [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

- (BOOL)prefersStatusBarHidden   // iOS8 definitely needs this one. checked.
{
    QDLog(@"prefersStatusBarHidden ... ");
    return NO;
}

- (void)dealloc
{
    if (_qrSession) {
        [_qrSession stopRunning];
        _qrSession = nil;
    }
    
    if (_qrVideoPreviewLayer) {
        _qrVideoPreviewLayer = nil;
    }
    
    if (_line) {
        _line = nil;
    }
    
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
}

#pragma -mark -导航栏 自定义导航条
- (void)initTitleView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth, 64)];
    bgView.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    [self.view addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100) / 2.0, 28, 100, 20)];
    titleLab.text = @"扫一扫";
    titleLab.shadowColor = [UIColor lightGrayColor];
    titleLab.shadowOffset = CGSizeMake(0, - 1);
    titleLab.font = [UIFont boldSystemFontOfSize:36*SizeScale];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
}


#pragma -mark -导航栏 系统导航条
- (void)setupNavigationBar
{
    self.title =  @"扫一扫";
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reset_back_image"] style:UIBarButtonItemStylePlain target:self action:@selector(cancleSYQRCodeReading)];
    leftBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(photoAlbumButtonClick:)];
//    rightBarButton.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    
}


- (void)createPhotoAlbumButton
{
    UIButton *photoAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoAlbumBtn setFrame:CGRectMake(kDeviceWidth -100, 28, 90, 24)];
    [photoAlbumBtn setTitle:@"相册" forState:UIControlStateNormal];
    //[photoAlbumBtn setImage:[UIImage imageNamed:@"reset_back_image"] forState:UIControlStateNormal];
    [photoAlbumBtn addTarget:self action:@selector(photoAlbumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoAlbumBtn];
    
}

- (void)createBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(10, 28, 40, 24)];
    [btn setImage:[UIImage imageNamed:@"reset_back_image"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleSYQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)leftBarButtonClick:(UIButton *) sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)initUI
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //摄像头判断
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        
        return;
    }
    
    //设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kReaderViewWidth, kReaderViewHeight)]];
    
    //拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 读取质量，质量越高，可读取小尺寸的二维码
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else
    {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
#pragma -mark -二维码和条形码
    //设置输出的格式
    //一定要先设置会话的输出为output之后，再指定输出的元数据类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    
    //设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    //设置preview图层的属性
//    preview.borderColor = [UIColor redColor].CGColor;
//    preview.borderWidth = 1.5;
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置preview图层的大小
    preview.frame = self.view.layer.bounds;
    //[preview setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    //将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    //[self.view.layer addSublayer:preview];
    self.qrVideoPreviewLayer = preview;
    self.qrSession = session;
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(kLineMinY / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
}


#warning 这个方法是扫描视图布局 以前的

- (void)setOverlayPickerView
{
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 300) / 2.0, kLineMinY, 300, 12 * 300 / 320.0)];
    [_line setImage:[UIImage imageNamed:@"QRCodeLine"]];
    [self.view addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kLineMinY)];//80
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (kDeviceWidth - kReaderViewWidth) / 2.0, kReaderViewHeight)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = KDeviceHeight - kLineMaxY;
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, kDeviceWidth, space_h)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"QRCodeTopLeft"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodeTopRight"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodebottomLeft"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodebottomRight"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:25*SizeScale];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"请将二维码/条形码置于框内";
    [self.view addSubview:labIntroudction];
    
#pragma -mark -边框颜色
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,kLineMinY,self.view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame) + 2, kReaderViewHeight + 2)];
    scanCropView.layer.borderColor = [UIColor grayColor].CGColor;
    scanCropView.layer.borderWidth = 2.0;
    [self.view addSubview:scanCropView];
    
    //添加相册按钮
    UIButton *photoAlbumButton = [[UIButton alloc]initWithFrame:CGRectMake720(190,334+448+44+78+94,340,80)];
    [photoAlbumButton setTitle:@"从相册选取二维码" forState:UIControlStateNormal];
    photoAlbumButton.font = [UIFont boldSystemFontOfSize:25*SizeScale];
    photoAlbumButton.layer.cornerRadius = 5.0;
    [photoAlbumButton addTarget:self action:@selector(photoAlbumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    photoAlbumButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:photoAlbumButton];
    
    
}

#warning 这个方法是扫描视图布局 我更改过的

- (void)setOverlayPickerViewS
{
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 300) / 2.0, kLineMinY, 300, 12 * 300 / 320.0)];
    [_line setImage:[UIImage imageNamed:@"QRCodeLine"]];
    [self.view addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake720(0, 0, kDeviceWidth * SizeScale, kLineMinY *SizeScale)];//80
    //upView.transform = CGAffineTransformMakeRotation(M_PI);
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor redColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (kDeviceWidth - kReaderViewWidth) / 2.0, kReaderViewHeight + 1)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight + 1)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = KDeviceHeight - kLineMaxY;
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, kDeviceWidth, space_h)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:downView];
    
#pragma -mark -边框颜色
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,kLineMinY,self.view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame) + 2, kReaderViewHeight + 1)];
    scanCropView.layer.borderColor = [UIColor grayColor].CGColor;
    scanCropView.layer.borderWidth = 1.0;
    [self.view addSubview:scanCropView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"QRCodeTopLeft"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)-1, CGRectGetMaxY(upView.frame)-1, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodeTopRight"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width +1, CGRectGetMaxY(upView.frame) - 1, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodebottomLeft"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)-0.5 , CGRectGetMinY(downView.frame) - cornerImage.size.height +1, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodebottomRight"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.height +1, CGRectGetMinY(downView.frame) - cornerImage.size.height, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:25*SizeScale];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"请将二维码/条形码置于框内";
    [self.view addSubview:labIntroudction];
    

    
    //添加相册按钮
    UIButton *photoAlbumButton = [[UIButton alloc]initWithFrame:CGRectMake720(190,334+448+44+78+94,340,80)];
    [photoAlbumButton setTitle:@"从相册选取二维码" forState:UIControlStateNormal];
    photoAlbumButton.font = [UIFont boldSystemFontOfSize:25*SizeScale];
    photoAlbumButton.layer.cornerRadius = 5.0;
    [photoAlbumButton addTarget:self action:@selector(photoAlbumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    photoAlbumButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:photoAlbumButton];
    
    
}


#pragma mark -
#pragma mark 输出代理方法

//此方法是在识别到QRCode，并且完成转换
//如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    if (metadataObjects.count > 0)
    {
        [self stopSYQRCodeReading];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0)
        {
            NSLog(@"---------%@",obj.stringValue);
            //[obj.stringValue containsString:@"http"]
            if (obj.stringValue)
            {
                if (self.SYQRCodeSuncessBlock) {
                    self.SYQRCodeSuncessBlock(self,obj.stringValue);
                }
            }
            else
            {
                if (self.SYQRCodeFailBlock) {
                    self.SYQRCodeFailBlock(self);
                }
            }
        }
        else
        {
            if (self.SYQRCodeFailBlock) {
                self.SYQRCodeFailBlock(self);
            }
        }
    }
    else
    {
        if (self.SYQRCodeFailBlock) {
            self.SYQRCodeFailBlock(self);
        }
    }
}


#pragma mark -
#pragma mark 交互事件

- (void)startSYQRCodeReading
{
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
    [self.qrSession startRunning];
    
    //NSLog(@"start reading");
}

- (void)stopSYQRCodeReading
{
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    
    [self.qrSession stopRunning];
    
    //NSLog(@"stop reading");
}

//取消扫描
- (void)cancleSYQRCodeReading
{
    [self stopSYQRCodeReading];
    
    if (self.SYQRCodeCancleBlock)
    {
        self.SYQRCodeCancleBlock(self);
    }
    NSLog(@"cancle reading");
}


#pragma mark -
#pragma mark 上下滚动交互线

- (void)animationLine
{
    __block CGRect frame = _line.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = kLineMinY;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _line.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_line.frame.origin.y >= kLineMinY)
        {
            if (_line.frame.origin.y >= kLineMaxY - 12)
            {
                frame.origin.y = kLineMinY;
                _line.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _line.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
    
    //NSLog(@"_line.frame.origin.y==%f",_line.frame.origin.y);
}


#warning 相册识别二维码－－－－－－－－－start

- (void)photoAlbumButtonClick:(UIButton *)sender
{
    
    NSLog(@"我的相册");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        //1.初始化相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //2.设置代理
        controller.delegate = self;
        //3.设置资源：
        /**
         UIImagePickerControllerSourceTypePhotoLibrary,相册
         UIImagePickerControllerSourceTypeCamera,相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库
         */
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //4.随便给他一个转场动画
        controller.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}



#warning 相册识别二维码－－－－－－－－－end



#pragma mark -------UIImagePickerControllerDelegate ----- start
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block NSString *scannedResult = nil;
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            scannedResult = feature.messageString;
             QDLog(@"scan result code --------%@",scannedResult);
            QDLog(@"---------%@",scannedResult);
            //[obj.stringValue containsString:@"http"]
            if (scannedResult)
            {
                if (self.SYQRCodeSuncessBlock) {
                    self.SYQRCodeSuncessBlock(self,scannedResult);
                }
            }
            else
            {
                if (self.SYQRCodeFailBlock) {
                    self.SYQRCodeFailBlock(self);
                }
            }
            
//           
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
            
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        
    }];
    
   
    
    
}
#pragma mark -------UIImagePickerControllerDelegate -----end



#pragma mark -------UINavigationControllerDelegate -----start

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark -------UINavigationControllerDelegate -----end
@end
