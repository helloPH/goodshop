//
//  UseDirectionViewController.m
//  LifeForMM
//
//  Created by HUI on 15/8/4.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "UseDirectionViewController.h"
#import "Header.h"
@interface UseDirectionViewController ()<UIGestureRecognizerDelegate>

@end

@implementation UseDirectionViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    [self initNavigation];
    [self initWebView];
}
-(void)initNavigation
{
    self.navigationItem.title = _titStr;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
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

@end
