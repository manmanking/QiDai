//
//  FeedbackViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/31.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "FeedbackViewController.h"
#import "QDTextView.h"
@interface FeedbackViewController ()<UITextViewDelegate>

@property (strong, nonatomic)  UIButton *submitBtn;
@property (strong, nonatomic)  UIView *textViewBGView;
@property (strong, nonatomic)  QDTextView *textView;
@property (strong, nonatomic)  UILabel *countLabel;
@property (strong, nonatomic)  UILabel *placehodeerLabel;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTitleViewWithString:@"意见反馈"];
    
    [self.view addSubview:self.textView];
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setFrame:CGRectMake720(200, 1300, 320, 84)];
    [self.submitBtn setRoundedCorners:UIRectCornerAllCorners radius:8*SizeScale];
    self.submitBtn.top = HCDH - 150*SizeScale - 64;
    [self.submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:30*SizeScale];
    self.submitBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"good_selece_color_red"] forState:UIControlStateNormal];
    //[self.submitBtn setBackgroundImage:[UIImage imageNamed:@"address_default_sure"] forState:UIControlStateSelected];
    [self.submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickSubmitBtn:(id)sender {
    
    if (![self.textView.text isExist]) {
        [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:@"请输入您的宝贵意见"];
        return;
    }
    
    NSDictionary *parame = @{@"content":self.textView.text,
                             @"userId":[[LoginManager instance] getUserId]};
    [QDHttpTool getWithURL:kUrl_addFeedback params:parame success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (isSuccess) {
            [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:@"提交成功,谢谢您的宝贵意见"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clickBackBtn];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - TextView Delegate



- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 5000) {
        textView.text = [textView.text substringToIndex:5000];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/5000", (unsigned long)textView.text.length];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark --- lazy load
- (QDTextView *)textView {
    if (!_textView) {
        _textView = [[QDTextView alloc]initWithFrame:CGRectMake(10, 50, HCDW - 20, 225)];
        //1.设置提醒文字
        _textView.myPlaceholder=@"骑待感谢有你一路相伴，你的每一次反馈，我们都会认真聆听并改进。";
        //2.设置提醒文字颜色
        _textView.myPlaceholderColor= kColorForccc;
        _textView.textColor = [UIColor blackColor];
        _textView.delegate = self;//设置它的委托方法
        _textView.backgroundColor = [UIColor whiteColor];
        [_textView addSubview:self.countLabel];
    }
    return _textView;
}
- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(HCDW - 110, 205, 80, 20)];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.text = @"0/5000";
        _countLabel.textColor = kColorForccc;
    }
    return _countLabel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
