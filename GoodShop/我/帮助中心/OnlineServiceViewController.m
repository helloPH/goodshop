//
//  OnlineServiceViewController.m
//  LifeForMM
//
//  Created by HUI on 16/3/29.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "OnlineServiceViewController.h"
#import "Header.h"
@interface OnlineServiceViewController ()<UIGestureRecognizerDelegate>

@end

@implementation OnlineServiceViewController
{
    UIWebView *vb;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   }
- (void)viewDidLoad {
    [super viewDidLoad];
    /*  --- 手势返回 (系统) --- */
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    //初始化导航栏
    [self initNavigation];
    //获取数据
    [self reloadData];
}

//初始化导航
-(void)initNavigation
{
    self.navigationItem.title = @"在线客服";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    
}
//获取数据
-(void)reloadData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@zaixiankefu.jsp?userid=733",HTTPHEADER];
    vb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    vb.backgroundColor = [UIColor whiteColor];
    vb.scalesPageToFit = YES;//自动放缩适应屏幕
    vb.opaque = NO;
    [self.view addSubview:vb];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [vb loadRequest:request];
    }


@end
