//
//  GPSSignalView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/16.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "GPSSignalView.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"
@interface GPSSignalView ()

@property (strong, nonatomic) UILabel *gpsLabel;
@property (strong, nonatomic) UIImageView *status1Img;//强信号

@property (nonatomic,strong) UIImageView *status1ImageWeak;//若信号
@property (strong, nonatomic) UIImageView *status2Img;
@property (nonatomic,strong) UIImageView *status2ImageWeak;
@property (strong, nonatomic) UIImageView *status3Img;
@property (nonatomic,strong) UIImageView *status3ImageWeak;
@property (strong, nonatomic) UIImageView *status4Img;
@property (nonatomic,strong) UIImageView *status4ImageWeak;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation GPSSignalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}


- (void)setupCustomView {
    
    // 强信号  图标
    self.status1Img = [[UIImageView alloc]initWithFrame:CGRectMake720(96, 8 + 24 - 9, 4, 9)];
    self.status1Img.image = [UIImage imageNamed:@"GPSSignalStrength1strong"];
    [self addSubview:self.status1Img];
    
    self.status2Img = [[UIImageView alloc]initWithFrame:CGRectMake720(96 + 12, 8 + 24 - 14, 4, 14)];
    self.status2Img.image = [UIImage imageNamed:@"GPSSignalStrength2strong"];
    [self addSubview:self.status2Img];
    
    self.status3Img = [[UIImageView alloc]initWithFrame:CGRectMake720(96 + 24, 8 + 24 - 19, 4, 19)];
    self.status3Img.image = [UIImage imageNamed:@"GPSSignalStrength3strong"];
    [self addSubview:self.status3Img];
    
    self.status4Img = [[UIImageView alloc]initWithFrame:CGRectMake720(96 + 36, 8 + 24 - 24 , 4, 24)];
    self.status4Img.image = [UIImage imageNamed:@"GPSSignalStrength4strong"];
    [self addSubview:self.status4Img];
    
    self.gpsLabel = [UILabel qd_labelWithFrame:CGRectMake720(40, 8 + 24 - 18 , 60, 20) title:@"GPS" titleColor:UIColorFromRGB_16(0x35a4da) textAlignment:NSTextAlignmentCenter font:20];
    [self addSubview:self.gpsLabel];
    
}
- (void)currentGPS {
    self.locationManager = [LocationManager instance].locationManager;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun:) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)timeRun:(NSTimer *)timer {
    if (self.locationManager.location.horizontalAccuracy < 0) {
        
        // 无信号
        [self updateStatus:No_Signal];
        
    } else if (self.locationManager.location.horizontalAccuracy > 163) {
        
        // 信号差
        [self updateStatus:Poor_Signal];
        
    } else if (self.locationManager.location.horizontalAccuracy > 48) {
        
        // 信号一般
        [self updateStatus:Average_Signal];
        
    } else {
        
        // 信号强
        [self updateStatus:Full_Signal];
    }
}

- (void)updateStatus:(StatusLevel)level {
    switch (level) {
        case No_Signal:
//            self.status1Img.hidden = NO;
//            self.status2Img.hidden = NO;
//            self.status3Img.hidden = NO;
//            self.status4Img.hidden = NO;
            self.status1Img.image = [UIImage imageNamed:@"GPSSignalStrength1weak"];
            self.status2Img.image = [UIImage imageNamed:@"GPSSignalStrength2weak"];
            self.status3Img.image = [UIImage imageNamed:@"GPSSignalStrength3weak"];
            self.status4Img.image = [UIImage imageNamed:@"GPSSignalStrength4weak"];
            break;
        case Poor_Signal:
//            self.status1Img.hidden = NO;
//            self.status2Img.hidden = NO;
//            self.status3Img.hidden = NO;
//            self.status4Img.hidden = NO;
            self.status3Img.image = [UIImage imageNamed:@"GPSSignalStrength3weak"];
            self.status4Img.image = [UIImage imageNamed:@"GPSSignalStrength4weak"];
            break;
        case Average_Signal:
//            self.status1Img.hidden = NO;
//            self.status2Img.hidden = NO;
//            self.status3Img.hidden = NO;
//            self.status4Img.hidden = NO;
            self.status4Img.image = [UIImage imageNamed:@"GPSSignalStrength4weak"];
            break;
        case Full_Signal:
//            self.status1Img.hidden = NO;
//            self.status2Img.hidden = NO;
//            self.status3Img.hidden = NO;
//            self.status4Img.hidden = NO;
            break;
        default:
            break;
    }
}
@end
