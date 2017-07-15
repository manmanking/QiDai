//
//  SportModel.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportModel.h"
#import "PublicTool.h"
#import "UserInfoModel.h"
#import "UserInfoDBManager.h"
#import "LoginManager.h"
@interface SportModel ()
/** 体重---之前用码表的时候需要，已废弃*/
@property (assign, nonatomic) int weight;
@end

@implementation SportModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        self.uId = [dictionary objectForKey:@"userId"];
        self.sId = [dictionary objectForKey:@"sid"];
        self.startTime = [PublicTool dateFromString:[dictionary objectForKey:@"startTime"] format:@"yyyy-MM-dd HH:mm:ss"];
        self.sumTime = [[dictionary objectForKey:@"time"] intValue];
        if ([dictionary objectForKey:@"endTime"]) {
            
            double startime = [self.startTime timeIntervalSince1970];
            startime = startime + self.sumTime;
            
            NSDate  *date = [NSDate dateWithTimeIntervalSince1970:startime];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate: date];
            NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
            self.endTime =localeDate;
        }
        
        self.totalDistance = [[dictionary objectForKey:@"distance"] floatValue];
        self.calorie = [[dictionary objectForKey:@"energy"] floatValue];
        
        self.averageSpeed = [[dictionary objectForKey:@"averageSd"] floatValue];
        self.maxSpeed = [[dictionary objectForKey:@"fastestSd"] floatValue];
        self.maxAltitude = [[dictionary objectForKey:@"highestAlt"] floatValue];
        self.averageAltitude = [[dictionary objectForKey:@"averageAlt"] floatValue];
        self.upAltitude = [[dictionary objectForKey:@"upAlt"] floatValue];
        self.downAltitude = [[dictionary objectForKey:@"downAlt"] floatValue];
        if ([_sId isKindOfClass:[NSNull class]] || _sId.length == 0) {
            self.sId = [NSString stringWithFormat:@"%.0f",[_startTime timeIntervalSince1970]*1000];
        }
        self.ridingName = [dictionary objectForKey:@"ridingName"];
        self.clockFrequency = [[dictionary objectForKey:@"frequency"] floatValue];
        if (self.clockFrequency > .0) {
            NSLog(@"上传 踏频成功");
        }
        self.totalPoints = [[dictionary objectForKey:@"totalPoints"] intValue];
    }
    
    return self;
}

-(NSDictionary *)dictionary{
    
    if ([_sId isExist] && [_uId isExist]) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:_uId forKey:@"userId"];
        [dict setValue:_sId forKey:@"sid"];
        [dict setValue:self.ridingName forKey:@"ridingName"];
        [dict setValue:[PublicTool stringFromDate:_startTime format:@"yyyy-MM-dd HH:mm:ss"] forKey:@"startTime"];
        [dict setValue:[PublicTool stringFromDate:_endTime format:@"yyyy-MM-dd HH:mm:ss"] forKey:@"endTime"];
        [dict setValue:[NSString stringWithFormat:@"%f",_totalDistance] forKey:@"distance"];
        [dict setValue:[NSString stringWithFormat:@"%f",_calorie] forKey:@"energy"];
        [dict setValue:[NSString stringWithFormat:@"%d",_sumTime] forKey:@"time"];
        [dict setValue:[NSString stringWithFormat:@"%f",_averageSpeed] forKey:@"averageSd"];
        [dict setValue:[NSString stringWithFormat:@"%f",_maxSpeed] forKey:@"fastestSd"];
        [dict setValue:[NSString stringWithFormat:@"%f",_averageAltitude] forKey:@"averageAlt"];
        [dict setValue:[NSString stringWithFormat:@"%f",_maxAltitude] forKey:@"highestAlt"];
        [dict setValue:[NSString stringWithFormat:@"%f",_upAltitude] forKey:@"upAlt"];
        [dict setValue:[NSString stringWithFormat:@"%f",_downAltitude] forKey:@"downAlt"];
        [dict setValue:[NSString stringWithFormat:@"%f",_clockFrequency] forKey:@"frequency"];
        [dict setValue:[NSString stringWithFormat:@"%d",[self totalPoints]] forKey:@"points"];
        return dict;
    }else{
        
        return nil;
    }
}

- (NSString *)string {
    if ([_sId isExist] && [_uId isExist]) {
        
        NSString *str  = [NSString stringWithFormat:@"userId=%@",_uId];
        str = [NSString stringWithFormat:@"%@&sid=%@",str,_sId];
        str = [NSString stringWithFormat:@"%@&ridingName=nil",str];
        str = [NSString stringWithFormat:@"%@&startTime=%@",str,[PublicTool stringFromDate:_startTime format:@"yyyy-MM-dd HH:mm:ss"]];
        str = [NSString stringWithFormat:@"%@&endTime=%@",str,[PublicTool stringFromDate:_endTime format:@"yyyy-MM-dd HH:mm:ss"]];
        str = [NSString stringWithFormat:@"%@&distance=%@",str,[NSString stringWithFormat:@"%f",_totalDistance]];
        str = [NSString stringWithFormat:@"%@&energy=%@",str,[NSString stringWithFormat:@"%f",_calorie]];
        str = [NSString stringWithFormat:@"%@&time=%@",str,[NSString stringWithFormat:@"%d",_sumTime]];
        
        str = [NSString stringWithFormat:@"%@&averageSd=%@",str,[NSString stringWithFormat:@"%f",_averageSpeed]];
        str = [NSString stringWithFormat:@"%@&fastestSd=%@",str,[NSString stringWithFormat:@"%f",_maxSpeed]];
        
        str = [NSString stringWithFormat:@"%@&averageAlt=%@",str,[NSString stringWithFormat:@"%f",_averageAltitude]];
        str = [NSString stringWithFormat:@"%@&highestAlt=%@",str,[NSString stringWithFormat:@"%f",_maxAltitude]];
        
        str = [NSString stringWithFormat:@"%@&upAlt=%@",str,[NSString stringWithFormat:@"%f",_upAltitude]];
        str = [NSString stringWithFormat:@"%@&downAlt=%@",str,[NSString stringWithFormat:@"%f",_downAltitude]];
        str = [NSString stringWithFormat:@"%@&frequency=%@",str,[NSString stringWithFormat:@"%f",_clockFrequency]];
        str = [NSString stringWithFormat:@"%@&points=%@",str,[NSString stringWithFormat:@"%d",[self totalPoints]]];
        
        return str;
    }else{
        
        return nil;
    }
    
}
- (int)totalPoints {
    double temp = _totalDistance/1000;
    if (temp == 0) {
        return 0;
    } else {
        return (int)(temp + 0.5);
    }
}
- (void)endSport {
    [self calculateCalorie];
    
    self.endTime = [NSDate date];
    
}
- (void)calculateCalorie
{
    UserInfoModel *userInfo = [UserInfoDBManager getUserInfoWithUserId:[[LoginManager instance] getUserId]];
    self.weight =  userInfo.weight ? [userInfo.weight intValue] : 0;
    
    CGFloat t = self.sumTime / 60.0;
    CGFloat u = 0.01 * t + 0.8;
    CGFloat v = self.totalDistance / self.sumTime * 3.6;
    
    // 卡路里 = t(分钟) * v(速度km/h) / 3 * u * (1 + 体重(kg) / 1200)
    self.calorie = t * v / 3 * u * (1 + self.weight / 1200);
    
    //    self.testDataLabel.adjustsFontSizeToFitWidth = YES;
    //    self.testDataLabel.text = [NSString stringWithFormat:@"平均速度：%f，总路程：%f，体重：%d，卡路里：%f",self.sportModel.averageSpeed, _totalDistance, self.weight, self.sportModel.calorie];
}

- (NSString *)description {
    NSString *selfDes = [NSString stringWithFormat:@"SportModel:_totalDistance=%f,_averageSpeed=%f,_maxSpeed=%f,date%@", _totalDistance,_averageSpeed,_maxSpeed,_startTime];
    return selfDes;
}

#pragma mark --- coder delegate
-(void)encodeWithCoder:(NSCoder *)aCoder {
    //encode properties/values
    [aCoder encodeObject:_uId      forKey:@"userId"];
    [aCoder encodeObject:_sId  forKey:@"sid"];
    [aCoder encodeObject:_startTime      forKey:@"startTime"];
    [aCoder encodeObject:_endTime     forKey:@"endTime"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_totalDistance]     forKey:@"distance"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_calorie] forKey:@"energy"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",_sumTime] forKey:@"time"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_averageSpeed] forKey:@"averageSd"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_maxSpeed] forKey:@"fastestSd"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_averageAltitude] forKey:@"averageAlt"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_maxAltitude] forKey:@"highestAlt"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_upAltitude] forKey:@"upAlt"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_downAltitude] forKey:@"downAlt"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_clockFrequency] forKey:@"frequency"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",[self totalPoints]] forKey:@"points"];
    [aCoder encodeObject:self.ridingName forKey:@"ridingName"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super init])) {
        //decode properties/values
        _uId = [aDecoder decodeObjectForKey:@"userId"];
        _sId = [aDecoder decodeObjectForKey:@"sid"];
        
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.sumTime = [[aDecoder decodeObjectForKey:@"time"] intValue];
        
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        _totalDistance = [[aDecoder decodeObjectForKey:@"distance"] floatValue];
        self.calorie = [[aDecoder decodeObjectForKey:@"energy"] floatValue];
        
        self.averageSpeed = [[aDecoder decodeObjectForKey:@"averageSd"] floatValue];
        
        self.maxSpeed = [[aDecoder decodeObjectForKey:@"fastestSd"] floatValue];
        
        self.maxAltitude = [[aDecoder decodeObjectForKey:@"highestAlt"] floatValue];
        self.averageAltitude = [[aDecoder decodeObjectForKey:@"averageAlt"] floatValue];
        self.upAltitude = [[aDecoder decodeObjectForKey:@"upAlt"] floatValue];
        self.downAltitude = [[aDecoder decodeObjectForKey:@"downAlt"] floatValue];
        if ([_sId isKindOfClass:[NSNull class]] || _sId.length == 0) {
            self.sId = [NSString stringWithFormat:@"%.0f",[_startTime timeIntervalSince1970]*1000];
        }
        self.clockFrequency = [[aDecoder decodeObjectForKey:@"frequency"] floatValue];
        if (self.clockFrequency > .0) {
            NSLog(@"上传 踏频成功");
        }
        self.ridingName = [aDecoder decodeObjectForKey:@"ridingName"];
        self.totalPoints = [[aDecoder decodeObjectForKey:@"totalPoints"] intValue];
    }
    
    return self;
}




@end
