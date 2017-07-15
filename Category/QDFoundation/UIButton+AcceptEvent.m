//
//  UIButton+AcceptEvent.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/14.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "UIButton+AcceptEvent.h"
#import <objc/runtime.h>
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";
@implementation UIButton (AcceptEvent)

- (NSTimeInterval)qd_acceptEventInterval {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}
- (void)setQd_acceptEventInterval:(NSTimeInterval)qd_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(qd_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)qd_acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}
- (void)setQd_acceptEventTime:(NSTimeInterval)qd_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(qd_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    //在UITabbarButton 上会crash，因为系统的uitabbarbutton 是只读的，不能把delay属性动态添加进去
//    Method before = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method after = class_getInstanceMethod(self, @selector(qd_sendAction:to:forEvent:));
//    method_exchangeImplementations(before, after);
    
    //获取着两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method myMethod = class_getInstanceMethod(self, @selector(qd_sendAction:to:forEvent:));
    SEL mySEL = @selector(qd_sendAction:to:forEvent:);
    
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    
    //如果方法已经存在了
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
        
    }
    
    //----------------以上主要是实现两个方法的互换,load是gcd的只shareinstance，果断保证执行一次

    
}
- (void)qd_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSDate date].timeIntervalSince1970 - self.qd_acceptEventTime < self.qd_acceptEventInterval) {
        return;
    }
    
    if (self.qd_acceptEventInterval > 0) {
        self.qd_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    
    [self qd_sendAction:action to:target forEvent:event];
}
@end
