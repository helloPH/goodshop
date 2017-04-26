//
//  ImageSelectedViewController.m
//  GoodShop
//
//  Created by MIAO on 16/11/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ImageSelectedViewController.h"
#import "Header.h"
@interface ImageSelectedViewController ()

@end

@implementation ImageSelectedViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}
-(void)createUI
{
    if (self.viewTag == 1)
    {
        [self.navigationItem setTitle:@"新人福利"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64*MCscale, kDeviceWidth, kDeviceHeight - 64*MCscale)];
        imageView.backgroundColor = [UIColor clearColor];
        NSString *imageStr = [NSString stringWithFormat:@"http://www.shp360.com/Store/images/dianpus/%@/dianpu/xinrenfuli.png",_dianpuID];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"shoucilunbo"]options:SDWebImageRefreshCached];
        [self.view addSubview:imageView];
    }
    else if (self.viewTag == 3)
    {
        [self.navigationItem setTitle:@"邀请有礼"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64*MCscale, kDeviceWidth, kDeviceHeight - 64*MCscale)];
        imageView.backgroundColor = [UIColor clearColor];
        NSString *imageStr = [NSString stringWithFormat:@"http://www.shp360.com/Store/images/dianpus/%@/dianpu/yaoqingyouli.png",_dianpuID];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"shoucilunbo"] options:SDWebImageRefreshCached];
        [self.view addSubview:imageView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
