//
//  CancleActionAlertView.h
//  QiDai
//
//  Created by manman'swork on 16/12/15.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  确定
 *
 *  @param parameter
 *
 *  @return
 */
typedef  void(^CancleAlertViewConfirmAction)(NSDictionary * parameter);


/**
 *  取消
 *
 *  @param parameter
 *
 *  @return
 */
typedef  void(^CancleAlertViewCancleAction)(NSDictionary * parameter);


/**
 *  关闭按钮
 *
 *  @param parameter
 *
 *  @return
 */
typedef  void(^CancleAlertViewCloseAction)(NSDictionary * parameter);


@interface CancleActionAlertView : UIView

@property (nonatomic,copy) CancleAlertViewConfirmAction confirmAction;

@property (nonatomic,copy) CancleAlertViewConfirmAction cancleAction;

@property (nonatomic,copy) CancleAlertViewConfirmAction closeAction;




@end
