//
//  ToolMacro.h
//  QiDai
//
//  Created by 张汇丰 on 16/4/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#ifndef ToolMacro_h
#define ToolMacro_h


#endif /* ToolMacro_h */

#define kUserId [[LoginManager instance] getUserId]


/** 弱指针*/
#define SXWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

/** 字符串为空*/
#define STR_IS_NIL(key) (([@"<null>" isEqualToString:(key)] || [@"" isEqualToString:(key)] || key == nil || [key isKindOfClass:[NSNull class]]) ? 1: 0)
/** 数组为空*/
#define ARRAY_IS_EMPTY(array) ((!array ||[array count] == 0)? 1: 0)

#pragma mark ---
#pragma mark --- 适配相关
#define IOS8_OR_LATER [[UIDevice currentDevice].systemVersion floatValue] >= 8.0
// 屏幕宽高常量
#define HCDW [UIScreen mainScreen].bounds.size.width
#define HCDH [UIScreen mainScreen].bounds.size.height
#define MAIN_WINDOW [[[UIApplication sharedApplication] delegate] window]
//view的宽高
#define view_width (self.view.frame.size.width)
#define view_height (self.view.frame.size.height)
#define view_x (self.view.frame.origin.x)
#define view_y (self.view.frame.origin.y)
//自定义导航条高度
#define Nav_View_Height 64
//比例，以6p为模板 --基本弃用
#define SizeScale1 [UIScreen mainScreen].bounds.size.width/1125
#define FontScale1 [UIScreen mainScreen].bounds.size.width/414 //没用的
CG_INLINE CGRect CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x *SizeScale1;
    rect.origin.y = y *SizeScale1;
    rect.size.width = width *SizeScale1;
    rect.size.height = height *SizeScale1;
    return rect;
}

//比例，以5为模板 720为宽 1280为高
#define SizeScale [UIScreen mainScreen].bounds.size.width/720
#define SizeScaleSubjectTo720 [UIScreen mainScreen].bounds.size.width/720
CG_INLINE CGRect CGRectMake720(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    CGRect rect;
    rect.origin.x = x *SizeScaleSubjectTo720;
    rect.origin.y = y *SizeScaleSubjectTo720;
    rect.size.width = width *SizeScaleSubjectTo720;
    rect.size.height = height *SizeScaleSubjectTo720;
    return rect;
}



#define UIFontOfSize720(size) [UIFont systemFontOfSize:size*SizeScaleSubjectTo720];


#pragma --------------比例，以6为模板


// 比例  以6 为模版 宽750

#define SizeScale750 [UIScreen mainScreen].bounds.size.width/750
#define SizeScaleSubjectTo750 [UIScreen mainScreen].bounds.size.width/750
CG_INLINE CGRect CGRectMake750(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    CGRect rect;
    rect.origin.x = x *SizeScaleSubjectTo750;
    rect.origin.y = y *SizeScaleSubjectTo750;
    rect.size.width = width *SizeScaleSubjectTo750;
    rect.size.height = height *SizeScaleSubjectTo750;
    return rect;
}

#define UIFontOfSize750(size) [UIFont systemFontOfSize:size*SizeScaleSubjectTo750];



#pragma mark --- color
// 10进制与16进制颜色值设置
#define UIColorFromRGB_10(r,g,b) \
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define UIColorFromRGB_16(rgbValue) \
([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define UIColorFromAlphaRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#pragma mark --- 
#pragma mark --- 归档路径
//归档路径
#define kGetCityCode  [kNSUSERDEFAULE valueForKey:kFind_cityCode]
#define kGetLat  [kNSUSERDEFAULE valueForKey:kFind_latitude]
#define kGetLng  [kNSUSERDEFAULE valueForKey:kFind_longitude]

#pragma mark --- NSUserDefaults
//同步
#define USER_DEFAULT_SYNCHRONIZE [[NSUserDefaults standardUserDefaults] synchronize]
//set
#define USER_DEFAULT_SET(_obj_,_key_) [[NSUserDefaults standardUserDefaults] setObject:_obj_ forKey:_key_];USER_DEFAULT_SYNCHRONIZE
//get
#define USER_DEFAULT_GET(_key_) [[NSUserDefaults standardUserDefaults] objectForKey:_key_]
//remove
#define USER_DEFAULT_REMOVE(_key_) [[NSUserDefaults standardUserDefaults] removeObjectForKey:_key_];USER_DEFAULT_SYNCHRONIZE

#pragma mark --- 通知
/***注册通知*/
#define ADD_OBSERVER(target,_selector,_name,_obj) [[NSNotificationCenter defaultCenter] addObserver: target selector:_selector name: _name object: _obj]
//发送通知
#define POST_NOTIFICATION(_notificationName,_obj,_userInfo) [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:_obj userInfo:_userInfo]
//移除对象所有通知
#define REMOVE_ALL_OBSERVER(_id_) [[NSNotificationCenter defaultCenter] removeObserver:_id_]
//移除对象指定通知
#define REMOVE_OBSERVER(_id_,_name_,_obj_) [[NSNotificationCenter defaultCenter] removeObserver:_id_ name:_name_ object:_obj_];

//-----------------------数组相关-------------------------//
//取数据-无返回
#define OBJECT_OF_ARRAY_ATINDEX(_OBJ_,_ARRAY_,_INDEX_) ({if(_ARRAY_ && _INDEX_<[_ARRAY_ count]){ _OBJ_ = [_ARRAY_ objectAtIndex:_INDEX_];}})
//取数据-返回nil
#define OBJECT_OF_ATINDEX(_ARRAY_,_INDEX_) ((_ARRAY_)&&(_INDEX_>=0)&&(_INDEX_<[_ARRAY_ count])?([_ARRAY_ objectAtIndex:_INDEX_]):(nil))
//数组添加数据
#define ADD_OBJECTINTOARRAY_(_OBJ_,_ARRAY_) ( {if(_OBJ_){[_ARRAY_ addObject:_OBJ_];}})
//清空数组的数据
#define ARRAYM_REMOVW_ALLOBJECTS_(_ARRAY_) ({if(_ARRAY_.count && _ARRAY_){[_ARRAY_ removeAllObjects];}})
#pragma mark --- 基本类型转换
//便捷方式创建NSNumber类型
#undef	__INT
#define __INT( __x )			[NSNumber numberWithInt:(NSInteger)__x]

#undef	__UINT
#define __UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)__x]

#undef	__FLOAT
#define	__FLOAT( __x )			[NSNumber numberWithFloat:(float)__x]

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]

//便捷创建NSString
#undef  STR_FROM_INT
#define STR_FROM_INT( __x )     [NSString stringWithFormat:@"%d", (__x)]


#pragma mark --- 线程
//线程执行方法
#define Foreground_Begin  dispatch_async(dispatch_get_main_queue(), ^{
#define Foreground_End    });

#define Background_Begin  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
@autoreleasepool {
#define Background_End          }\
});

#pragma mark --- Log
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

// 打印 类名_行数_方法名_log
#define Clog(format, ...) \
do{                                                                         \
fprintf(stderr, "<ClassName_%s : LineNumber_%d> %s\n",                      \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

#define kGetKeyWindow [[UIApplication sharedApplication].delegate window]

#define kNSUSERDEFAULE [NSUserDefaults standardUserDefaults]

#pragma -mark block
/**
 * 强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 * 调用方式: `@weakify_self`实现弱引用转换，`@strongify_self`实现强引用转换
 *
 * 示例：
 * @weakify_self
 * [obj block:^{
 * @strongify_self
 * self.property = something;
 * }];
 */
#ifndef    weakify_self
#if __has_feature(objc_arc)
#define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
#else
#define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif
#ifndef    strongify_self
#if __has_feature(objc_arc)
#define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
#else
#define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif
/**
 * 强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 * 调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换
 *
 * 示例：
 * @weakify(object)
 * [obj block:^{
 * @strongify(object)
 * strong_object = something;
 * }];
 */
#ifndef    weakify
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#endif
#ifndef    strongify
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
#endif
#endif

