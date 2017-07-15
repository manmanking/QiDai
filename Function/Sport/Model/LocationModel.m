//
//  locationModel.m
//  Leqi
//
//  Created by Tianyu on 14/12/18.
//  Copyright (c) 2014年 com.hoolai. All rights reserved.
//

#import "LocationModel.h"
#import "ItemModel.h"

@implementation LocationModel

@synthesize horizontalAccuracy  = _horizontalAccuracy;
@synthesize verticalAccuracy    = _verticalAccuracy;
@synthesize course              = _course;

- (id)initWithLocation:(CLLocation *)location
{
    if (self = [super init]) {
        
        self.itemModel = [[ItemModel alloc] init];
        self.itemModel.latitude = location.coordinate.latitude;
        self.itemModel.longitude = location.coordinate.longitude;
        self.itemModel.altitude = location.altitude;
        self.itemModel.speed = location.speed;
        self.itemModel.currentDate = location.timestamp;
        
        self.horizontalAccuracy = location.horizontalAccuracy;
        self.verticalAccuracy   = location.verticalAccuracy;
        self.course             = location.course;
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_horizontalAccuracy]      forKey:@"horizontalAccuracy"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_verticalAccuracy] forKey:@"verticalAccuracy"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_course] forKey:@"course"];
    
    [aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:self.itemModel]      forKey:@"itemModel"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        self.horizontalAccuracy = [[aDecoder decodeObjectForKey:@"horizontalAccuracy"] floatValue];
        self.verticalAccuracy = [[aDecoder decodeObjectForKey:@"verticalAccuracy"] floatValue];
        self.course = [[aDecoder decodeObjectForKey:@"course"] floatValue];
        self.itemModel = [NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObjectForKey:@"itemModel"]];
    }
    return self;
}

- (NSString *)description {
    NSString *selfDes = [NSString stringWithFormat:@"self=%@", self.itemModel];
    return selfDes;
}
@end
