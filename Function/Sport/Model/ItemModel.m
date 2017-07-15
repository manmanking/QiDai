//
//  ItemModel.m
//  Leqi
//
//  Created by Tianyu on 15/1/17.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_latitude]      forKey:@"latitude"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_longitude] forKey:@"longitude"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_altitude] forKey:@"altitude"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",_speed] forKey:@"speed"];
    [aCoder encodeObject:_currentDate      forKey:@"currentDate"];
    [aCoder encodeObject:_itemId      forKey:@"itemId"];
    [aCoder encodeObject:_sid  forKey:@"sid"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super init])) {
        _latitude = [[aDecoder decodeObjectForKey:@"latitude"] floatValue];
        _longitude = [[aDecoder decodeObjectForKey:@"longitude"] floatValue];
        _altitude = [[aDecoder decodeObjectForKey:@"altitude"] floatValue];
        _speed = [[aDecoder decodeObjectForKey:@"speed"] floatValue];
        self.itemId = [aDecoder decodeObjectForKey:@"itemId"];
        self.sid = [aDecoder decodeObjectForKey:@"sid"];
        self.currentDate = [aDecoder decodeObjectForKey:@"currentDate"];
    }
    return self;
}
- (NSString *)description {
    NSString *selfDes = [NSString stringWithFormat:@"self.altitude=%f,self.longitude=%f,", self.altitude,self.longitude];
    return selfDes;
}
@end
