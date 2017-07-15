//
//  ExpressAssembleTableViewCell.h
//  QiDai
//
//  Created by manman'swork on 16/12/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SelectedExpressAssembleAction)(NSDictionary *parameter);

@interface ExpressAssembleTableViewCell : UITableViewCell


@property (nonatomic,copy) SelectedExpressAssembleAction selectedExpressAssembleAction;

@property (nonatomic,assign) BOOL isSelectedSuccess;


@property (nonatomic,strong) NSString *indexRowStr;

// 暂时 放到外面  数据 内容 应变吗
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subtitleLabel;


@end
