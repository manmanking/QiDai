//
//  ShopUpdateGoodsDetailCommentTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/11/29.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "ShopUpdateGoodsDetailCommentTableViewCell.h"
#import "MJExtension.h"

@interface ShopUpdateGoodsDetailCommentTableViewCell()

@property (nonatomic,strong) UILabel *commentNumberLable;

@property (nonatomic,strong) UILabel *commentPerfectFloatLabel;

@property (nonatomic,strong) UILabel *commentUserNameLabel;

@property (nonatomic,strong) UIImageView *commentPerfectImageView;

@property (nonatomic,strong) UILabel *commentForBikeLabel;

@property (nonatomic,strong) UILabel *commentDateLabel;

@property (nonatomic,strong) UILabel *commentBikeColorLable;

@property (nonatomic,strong) UIButton *commentForAllButton;




@end



@implementation ShopUpdateGoodsDetailCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [ super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self customUIViewAutolayout];
        self.contentView.backgroundColor = [UIColor blackColor];
        
    }
    
    return self;
 
}

- (void)customUIViewAutolayout
{
    [self.contentView addSubview:self.commentNumberLable];
    [self.contentView addSubview:self.commentPerfectFloatLabel];
    
    [self.contentView addSubview:self.commentUserNameLabel];
    //[self.contentView addSubview:self.commentPerfectImageView];
    [self.contentView addSubview:self.commentForBikeLabel];
    [self.contentView addSubview:self.commentDateLabel];
    [self.contentView addSubview:self.commentBikeColorLable];
    [self.contentView addSubview:self.commentForAllButton];
    
}


- (void)setCommentUpdateModel:(CommentModel *)commentUpdateModel
{
    NSLog(@"commentUpdateModel %@",commentUpdateModel.mj_keyValues);
    _commentUpdateModel = commentUpdateModel;
    self.commentNumberLable.text = [NSString stringWithFormat:@"评价(%@)",self.commentTotalNumUpdateStr];
    int perfectInt = 0;
    if (self.commentPerfectNumUpdateStr.integerValue >0) {
     perfectInt = (int)self.commentPerfectNumUpdateStr.integerValue/self.commentTotalNumUpdateStr.integerValue *100;
    }
    
    self.commentPerfectFloatLabel.text = [NSString stringWithFormat:@"好评率%d％",perfectInt];
    self.commentForBikeLabel.text = commentUpdateModel.common;
    self.commentUserNameLabel.text = commentUpdateModel.username;
    self.commentDateLabel.text = commentUpdateModel.c_time;
    self.commentBikeColorLable.text = [NSString stringWithFormat:@"颜色:%@",commentUpdateModel.color];
    
    
    [self commentPerfectLevel:commentUpdateModel.level];
    
    
}


- (void)commentPerfectLevel:(NSString *) levelStr
{
    //CGRect startFrame = CGRectMake(606, 86,24 , 24);
    if (levelStr.integerValue >5 || levelStr.integerValue <=0) {
        return;
    }
    for (int i = 0; i <levelStr.integerValue; i ++) {
    CGRect startFrame = CGRectMake750(550 + i*24, 86,24 , 24);
        UIImageView *startImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment_star_image"]];
        startImageView.frame = startFrame;
        [self.contentView addSubview:startImageView];
        
    }
    
    
    
    
}




- (void)commentForAllButtonClick:(UIButton *)sender
{
    
    NSLog(@"点击 查看全部评论 ...");
    
    self.commentForAllButtonAction(nil);
    
    
}


- (UILabel *)commentNumberLable
{
    if (!_commentNumberLable) {
        _commentNumberLable = [[UILabel alloc]initWithFrame:CGRectMake750(20, 20, 200, 24)];
        _commentNumberLable.text = @"评价(20)";
        _commentNumberLable.textColor = [UIColor grayColor];
    }
    
    return _commentNumberLable;
    
}

- (UILabel *)commentPerfectFloatLabel
{
    if (!_commentPerfectFloatLabel) {
        _commentPerfectFloatLabel = [[UILabel alloc]initWithFrame:CGRectMake750(750 - 200, 23,200, 24)];
        _commentPerfectFloatLabel.text = @"好评率98%";
        _commentPerfectFloatLabel.font = [UIFont systemFontOfSize:22*SizeScale750];
        _commentPerfectFloatLabel.textColor = UIColorFromRGB_16(0x35a4da);
    }
    
    return _commentPerfectFloatLabel;
    
}

- (UILabel *)commentUserNameLabel
{
    if (!_commentUserNameLabel) {
        _commentUserNameLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20, 90, 300,24)];
        _commentUserNameLabel.text = @"卖火柴的小女孩";
        _commentUserNameLabel.textColor = [UIColor grayColor];
    }
    
    return _commentUserNameLabel;
    
}

- (UIImageView *)commentPerfectImageView
{
    if (!_commentPerfectImageView) {
        _commentPerfectImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(750 - 150, 90,24,24)];
        _commentPerfectImageView.image = [UIImage imageNamed:@"commentFlagStar"];
        
    }
    
    return _commentPerfectImageView;
    
}

- (UILabel *)commentForBikeLabel
{
    if (!_commentForBikeLabel) {
        _commentForBikeLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20, 150, 710,29)];
        _commentForBikeLabel.text = @"大品牌很放心";
        _commentForBikeLabel.font = [UIFont systemFontOfSize:27 *SizeScale750];
        _commentForBikeLabel.textColor = [UIColor whiteColor];
    }
    
    return _commentForBikeLabel;
    
}

- (UILabel *)commentDateLabel
{
    if (!_commentDateLabel) {
        _commentDateLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20,350,200,24)];
        _commentDateLabel.text = @"2016.11.11";
        _commentDateLabel.font = [UIFont systemFontOfSize:20*SizeScale750];
        _commentDateLabel.textColor = [UIColor grayColor];
    }
    
    return _commentDateLabel;
    
}

- (UILabel *)commentBikeColorLable
{
    if (!_commentBikeColorLable) {
        _commentBikeColorLable = [[UILabel alloc]initWithFrame:CGRectMake750(200, 350, 200,24)];
        _commentBikeColorLable.text = @"颜色:炫黑";
        _commentBikeColorLable.font = [UIFont systemFontOfSize:22*SizeScale750];
        _commentBikeColorLable.textColor = [UIColor grayColor];
        
    }
    
    return _commentBikeColorLable;
    
}

- (UIButton *)commentForAllButton
{
    if (!_commentForAllButton) {
        _commentForAllButton = [[UIButton alloc]initWithFrame:CGRectMake750(0,430,750,30)];
        [_commentForAllButton setTitle:@"查看全部评论" forState:UIControlStateNormal];
        [_commentForAllButton setTitleColor:UIColorFromRGB_16(0x35a4da) forState:UIControlStateNormal];
        //[_commentForAllButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_commentForAllButton addTarget:self action:@selector(commentForAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentForAllButton;

}








@end
