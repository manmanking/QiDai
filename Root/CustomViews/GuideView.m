//
//  GuideView.m
//  Leqi
//
//  Created by Tianyu on 15/1/19.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "GuideView.h"


@implementation GuideView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addCustomSubView];
    
}

- (void)addCustomSubView
{
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*4, self.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = 4;
    [self.pageControl setCurrentPage:0];
    
    CGFloat weight = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*weight, 0, weight, height+20)];
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_image%d",i+1]]];
        [self.scrollView addSubview:imgView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.pageControl setCurrentPage: scrollView.contentOffset.x/self.frame.size.width];
    if (scrollView.contentOffset.x/self.frame.size.width == 3) {
        self.pageControl.hidden = YES;
        self.goBtn.hidden = NO;
        [self.goBtn setImage:[UIImage imageNamed:@"guide_go_btn"] forState:UIControlStateNormal];
    } else {
        self.goBtn.hidden = YES;
        self.pageControl.hidden = NO;
    }
}

- (IBAction)clickGoBtn:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [kNSUSERDEFAULE setBool:YES forKey:kGUIDEISFIRSTSHOW];
        [kNSUSERDEFAULE synchronize];
    }];
}
@end
