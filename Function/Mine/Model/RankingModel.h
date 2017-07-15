//
//  RankingModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingModel : NSObject

/**头像地址 */
@property (copy,nonatomic) NSString *foreImg;

/**昵称 */
@property (copy,nonatomic) NSString *nickName;

/**是否是自己 */
@property (copy,nonatomic) NSString *own;

/**排名 */
@property (copy,nonatomic) NSString *rank;

/**进度条的比例 */
@property (copy,nonatomic) NSString *percentBar;

/**总距离 */
@property (copy,nonatomic) NSString *distance;

/** 是否完成*/
@property (nonatomic,copy) NSString *complete;

@end
