//
//  TermsViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()
{
    UITextView *_textView;
}
@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //上面的X号和新人注册
    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(60, 90, 35, 34) NormalImageString:@"login_X_img" tapAction:^(UIButton *button) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    //扩大作用域
    [backBtn setEnlargeEdge:20*SizeScaleSubjectTo720];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(235, 87, 250, 40) title:@"用户服务条款" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    [self.view addSubview:titleLabel];
    
    _textView = [[UITextView alloc] initWithFrame: CGRectMake(10, 64, CGRectGetWidth([UIScreen mainScreen].bounds)-15, CGRectGetHeight([UIScreen mainScreen].bounds)-64)];
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.editable = NO;
    _textView.text = @"骑待软件尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务,骑待软件会按照本隐私权政策的规定使用和披露您的个人信息。但骑待软件将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可的情况下，骑待软件不会将这些信息对外披露或向第三方提供。骑待软件会不时更新本隐私权政策。\n您在同意骑待软件服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于骑待软件服务使用协议不可分割的一部分。\n\n1. 适用范围：\na) 在您使用骑待软件时，骑待软件自动接收并记录的您的相关信息，包括但不限于您的访问日期和时间、软硬件特征信息及您需求的记录等数据；\nb) 骑待软件通过合法途径从商业伙伴处取得的用户个人数据。\n\n2. 信息使用：\na) 骑待软件不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息，除非事先得到您的许可，或该第三方和骑待软件单独或共同为您提供服务，且在该服务结束后，其将被禁止访问包括其以前能够访问的所有这些资料。\nb) 骑待软件亦不允许任何第三方以任何手段收集、编辑、出售或者无偿传播您的个人信息。任何骑待软件平台用户如从事上述活动，一经发现，我司有权立即终止与该用户的服务协议。\nc) 为服务用户的目的，骑待软件可能通过使用您的个人信息，向您提供您感兴趣的信息，包括但不限于向您发出产品和服务信息。\n\n3. 信息披露：\n在如下情况下，骑待软件将依据您的个人意愿或法律的规定全部或部分的披露您的个人信息：\na) 经您事先同意，向第三方披露；\nb) 为提供您所要求的产品和服务，而必须和第三方分享您的个人信息；\nc) 根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；\nd) 如您出现违反中国有关法律、法规或者骑待软件服务协议或相关规则的情况，需要向第三方披露；\ne) 如您是合资格的知识产权投诉人并已提起投诉，应被投诉人要求，向被投诉人披露，以便双方处理可能的权利纠纷；\nf) 其它骑待软件根据法律、法规或者网站政策认为合适的披露。\n\n4. 信息存储和交换：\n骑待软件收集的有关您的信息和资料将保存在骑待软件的服务器上，这些信息和资料可能传送至您所在国家、地区或收集信息和资料所在地的境外，并被访问、存储和展示。\n\n5. 信息安全：\n骑待软件帐号均有安全保护功能，请妥善保管您的用户名及密码信息。骑待软件将通过对用户密码进行加密等安全措施确保您的信息不丢失，不被滥用和变造。尽管有前述安全措施，但同时也请您注意在信息网络上不存在“完善的安全措施”。\n骑待软件版权所有者在法律允许最大范围对本协议拥有解释权与修改权。\n";
    [self.view addSubview:_textView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
