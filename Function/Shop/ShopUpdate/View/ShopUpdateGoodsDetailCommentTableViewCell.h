//
//  ShopUpdateGoodsDetailCommentTableViewCell.h
//  QiDai
//
//  Created by manman'swork on 16/11/29.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"


typedef void(^CommentForAllButtonAction)(NSDictionary * parameter);

@interface ShopUpdateGoodsDetailCommentTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString *commentTotalNumUpdateStr;

@property (nonatomic,strong) NSString *commentPerfectNumUpdateStr;

@property (nonatomic,strong) CommentModel *commentUpdateModel;


@property (nonatomic,strong) CommentForAllButtonAction commentForAllButtonAction;

@end
