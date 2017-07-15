//
//  BrandListSectionCollectionReusableView.h
//  QiDai
//
//  Created by manman'swork on 16/9/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandListSectionCollectionReusableView : UICollectionReusableView

@property (nonatomic,copy) ClickView synthesizeBtnClick;

//传近一个参数 代表 上或者下
@property (nonatomic,copy) ClickViewWithParameter priceBtnClick;




@end
