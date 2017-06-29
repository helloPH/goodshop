//
//  helpCenterViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/22.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "helpCenterViewController.h"
#import "Header.h"
#import "OnlineServiceViewController.h"
#import "feedbackViewController.h"
@interface helpCenterViewController ()<UIGestureRecognizerDelegate>

@end

@implementation helpCenterViewController
{
//    UIImageView *caozuotishiImage;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self initWebView];
    [self bottomView];
}
-(void)judgeTheFirst
{
    
    
    UIImageView * img= [self showGuideImageWithUrl:@"images/caozuotishi/fankui.png"];

    img.height=img.height+13;
    img.top=-13;
    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstFankui"] integerValue] == 1) {
//        NSString *url = @"images/caozuotishi/fankui.png";
//        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
//        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,-10, kDeviceWidth, kDeviceHeight)];
//        caozuotishiImage.userInteractionEnabled = YES;
//        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
//        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden:)];
//        [caozuotishiImage addGestureRecognizer:imageTap];
//        [self.view addSubview:caozuotishiImage];
//    }
//}
//
//-(void)imageHidden:(UITapGestureRecognizer *)tap
//{
//    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstFankui"];
//    [caozuotishiImage removeFromSuperview];
}

-(void)initNavigation
{
    self.navigationItem.title = _titStr;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"反馈"] forState:UIControlStateNormal];
    rightButton.tag = 102;
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}
-(void)initWebView
{
    UIWebView *vb = [[UIWebView alloc]initWithFrame:self.view.bounds];
    vb.backgroundColor = [UIColor whiteColor];
    vb.scalesPageToFit = YES;//自动放缩适应屏幕
    vb.opaque = NO;
    [self.view addSubview:vb];
    NSURL *url =[NSURL URLWithString:_pageUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [vb loadRequest:request];
}
-(void)bottomView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    view.backgroundColor = naviBarTintColor;
    view.alpha = 0.95;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [view addGestureRecognizer:tap];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    label.text = @"在线客服";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:MLwordFont_15];
    label.center = CGPointMake(kDeviceWidth/2.0, 23);
    [view addSubview:label];
    [self.view addSubview:view];
    [self judgeTheFirst];
}
-(void)tapAction
{
    OnlineServiceViewController *OnlineServiceVC = [[OnlineServiceViewController alloc]init];
    OnlineServiceVC.isOrder = NO;
    OnlineServiceVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:OnlineServiceVC animated:YES];
}
//导航右侧按钮 事件
-(void)rightBtnAction
{
    feedbackViewController *feedbackVC = [[feedbackViewController alloc]init];
    feedbackVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:feedbackVC animated:YES];
}
@end
