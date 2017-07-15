//
//  GuideView.h
//  Leqi
//
//  Created by Tianyu on 15/1/19.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageControl.h"



@interface GuideView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;

- (IBAction)clickGoBtn:(id)sender;

@end
