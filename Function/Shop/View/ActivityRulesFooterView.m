//
//  ActivityRulesFooterView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ActivityRulesFooterView.h"

@implementation ActivityRulesFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setupCustomView {
    UILabel *ruleTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(30, 0, 200, 88) title:@"注意事项" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:28];
    ruleTextLabel.font = [UIFont boldSystemFontOfSize:20*SizeScaleSubjectTo720];
    [self addSubview:ruleTextLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(0, 88, 720, 1)];
    lineView.backgroundColor = kColorFor83;
    [self addSubview:lineView];
    
    NSString *str = @"1.排名方式:达标者按照每日骑行里程相加计算的总里程进行排名。 \n2.在活动开始前进行报名。\n3.如出现账号转借他人、代骑、替骑、非骑车记录数据等行为,经发现视为挑战失败。\n4.活动结束一周内,将公布获奖名单,请注意查看。\n5.活动过程中请注意安全骑行,文明骑行。\n6.此活动最终解释权归北京趣骑科技有限公司。";
    UILabel *ruleLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 0, 652, 0) title:str titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:22];
    ruleLabel.top = ruleTextLabel.bottom + 24*SizeScaleSubjectTo720;
    ruleLabel.numberOfLines = 0;
    
    //调整行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:0];
    
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(ruleLabel.bounds), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:(22*SizeScaleSubjectTo720)],                                                                                          NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    ruleLabel.height = titleSize.height;
    [self addSubview:ruleLabel];
    
    self.dynamicHeight = ruleLabel.bottom + 24*SizeScaleSubjectTo720;
    
}
@end
