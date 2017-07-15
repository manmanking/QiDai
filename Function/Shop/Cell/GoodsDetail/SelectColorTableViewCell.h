//
//  SelectColorTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/6.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectColorTableViewCellDelegate <NSObject>

- (void)clickColorCellWithColor:(NSString *)color page:(NSInteger)page;

@end

@interface SelectColorTableViewCell : UITableViewCell

@property (nonatomic,weak) id<SelectColorTableViewCellDelegate>delegate;


@property (nonatomic,strong) NSString *selectedColour;
/**记录那种颜色 */
@property (nonatomic,strong) UIButton *colorButton;

/** 店铺拥有车的颜色*/
@property (nonatomic,strong) NSArray *selectColorArray;

/**
 *  输入颜色的数组，创建view
 *
 *  @param colorArray   颜色的数组
 */
- (void)setupSelectColorViewWithArray:(NSArray *)colorArray;

/**
 *  比较颜色
 *
 *  @param array      array
 *  @param totalArray 一共得
 */
- (void)compareColorArray:(NSArray *)array totalArray:(NSArray *)totalArray;

-(void)showDidSelected:(NSString *)selectedColour;
@end
