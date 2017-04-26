//
//  NewFunctionViewController.m
//  LifeForMM
//
//  Created by HUI on 16/3/29.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 新功能介绍

#import "NewFunctionViewController.h"
#import "Header.h"
#import "MainScrollView.h"
@interface NewFunctionViewController ()<UIGestureRecognizerDelegate>
@end

@implementation NewFunctionViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self functionImageData];
}
-(void)initNavigation
{
    self.navigationItem.title = @"新功能介绍";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
}
-(void)functionImageData
{
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"newFunction.action" params:nil success:^(id json) {
        NSArray *ary = [json valueForKey:@"xingongneng"];
        NSLog(@"-- %@",json);
        
        NSMutableArray *urlAry = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in ary) {
            NSString *url = [dic valueForKey:@"url"];
            [urlAry addObject:url];
        }
        [self loadScrolloview:urlAry];
    } failure:^(NSError *error) {
    }];
}
-(void)loadScrolloview:(NSArray *)imgAry
{
    MainScrollView *scrol = [[MainScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    scrol.ViewTag = 1;

//    for (int i =0; i<imgAry.count; i++) {
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth*i,0, kDeviceWidth, kDeviceHeight-64)];
//        image.backgroundColor = [UIColor clearColor];
//        [image sd_setImageWithURL:[NSURL URLWithString:imgAry[i]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
//        [scrol addSubview:image];
//    }
//        scrol.contentSize = CGSizeMake(imgAry.count*kDeviceWidth*MCscale, kDeviceHeight-64);
    [self.view addSubview:scrol];
    
    [scrol addImageViewForScrollViewWith:imgAry];
}

@end
