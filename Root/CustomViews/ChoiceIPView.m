//
//  ChoiceIPView.m
//  QiDai
//
//  Created by manman'swork on 16/11/14.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "ChoiceIPView.h"

@interface ChoiceIPView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *choiceTableView;

@property (nonatomic,strong) NSArray *choiceIPArr;



@end


static NSString *tableViewCellId = @"tableViewCellId";

@implementation ChoiceIPView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customUIViewAutolayout];
    }
    
    return self;
    
    
}



- (void)customUIViewAutolayout

{
    
    self.choiceIPArr = @[@"内网",@"北京正式",@"北京测试",@"正式"];
    [self addSubview:self.choiceTableView];
    
    
    
    
}



#pragma ------UITableViewDataSource -----mark ---start of line 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.choiceIPArr.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellId];
    
    UILabel *showIPLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0, 0, 750, 30)];
    showIPLabel.text = _choiceIPArr[indexPath.row];
    [cell.contentView addSubview:showIPLabel];
    return cell;
    
    
}





#pragma ------UITableViewDataSource -----mark ---end of line


- (UITableView *)choiceTableView
{
    if (!_choiceTableView) {
        _choiceTableView = [[UITableView alloc]initWithFrame:CGRectMake750(0, 0, 750, 1334)];
        _choiceTableView.delegate  = self;
        _choiceTableView.dataSource = self;
        
        [_choiceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellId];
        
        
    }
    
    return _choiceTableView;

}


@end
