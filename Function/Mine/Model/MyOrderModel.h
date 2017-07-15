//
//  MyOrderModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  我的订单

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject <NSCopying>
/** 奖金*/
@property (nonatomic,copy) NSString *bonus;
/** 系列:link*/
@property (nonatomic,copy) NSString *series;
/** 品牌*/
@property (nonatomic,copy) NSString *brand;
/** 比如N8*/
@property (nonatomic,copy) NSString *model;
/** 比如:20寸8速铝合金车架*/
@property (nonatomic,copy) NSString *title;
/** 颜色*/
@property (nonatomic,copy) NSString *color;
/** 地址*/
@property (nonatomic,copy) NSString *address;
/** 品牌图片*/
@property (nonatomic,copy) NSString *brandImg;
/** 需要支付的钱*/
@property (nonatomic,copy) NSString *needPayMoney;
/** 车的图片*/
@property (nonatomic,copy) NSString *itemImg;
/** 订单id*/
@property (nonatomic,copy) NSString *orderId;
/** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 13 取消订单*/
@property (nonatomic,copy) NSString *status;
/** 商店的名字*/
@property (nonatomic,copy) NSString *shopName;
/** 活动信息*/
@property (nonatomic,copy) NSString *information;
/** 活动评价 是否评价 >=1 追加 评价，其他不可以评价*/
@property (nonatomic,copy) NSString *actiC;
//actiCItem
/** 商品评价是否评价 >=1  追加可以评价，其他不可以评价*/
@property (nonatomic,copy) NSString *actiCItem;

/** -----------------------------------------------*/ 
/** 活动id--评论需要*/
@property (nonatomic,copy) NSString *activity_id;
/** 商品id--评论需要*/
@property (nonatomic,copy) NSString *modelId;

/** 支付放弃*/
@property (nonatomic,copy) NSString *pay_type;

@property (nonatomic,copy) NSString *image;

@property (nonatomic,copy) NSString *c_time;


@end
