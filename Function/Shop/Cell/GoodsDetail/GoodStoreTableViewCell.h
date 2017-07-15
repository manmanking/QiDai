//
//  GoodStoreTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  商品详情-提车店铺的cell

#import <UIKit/UIKit.h>
@class ShopAddressModel;

@protocol GoodStoreTableViewCellDelegate <NSObject>

/** 点击选择店铺*/
- (void)clickStoreCellWithPage:(NSInteger)page;
/** 点击电话*/
- (void)clickPhoneBtnWithPage:(NSInteger)page;
/** 地址*/
- (void)clickAddressBtnWithPage:(NSInteger)page;

@end

@interface GoodStoreTableViewCell : UITableViewCell

@property (nonatomic,strong) ShopAddressModel *model;

/** 时候被选中*/
@property (nonatomic,assign) BOOL isSelect;


/** 当前的page,来源是index.row*/
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,weak) id<GoodStoreTableViewCellDelegate>delegate;

/** 标记作用*/
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) NSString *activityId;

/** 点击*/
@property (nonatomic,copy) ClickViewWithParameter clickDetailBlock;
@end
