//
//  BillFeeInfoView.h
//  QiDai
//
//  Created by manman'swork on 16/12/2.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBillConfirmView @"kBillConfirmView"

#define kBillDetailInfoView @"kBillDetailInfoView"


@interface BillFeeInfoView : UIView

@property (nonatomic,copy) NSDictionary *billFeeParameter;

@property (nonatomic,strong) NSString *useInViewStr;


/**
 *  订单状态
 */
@property (nonatomic,strong) NSString *orderStateStr;



- (void)fillDatasources;
@end
