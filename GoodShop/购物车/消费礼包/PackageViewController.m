//
//  PackageViewController.m
//  GoodShop
//
//  Created by MIAO on 2017/1/4.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PackageViewController.h"
#import "Header.h"
#import "PackageModel.h"
#import "PackageCell.h"
#import "GetPackageView.h"
@interface PackageViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,PackageCellDelagate,GetPackageViewDelegate>
@end

@implementation PackageViewController
{
    UITableView *mainTableView;
    UIImageView *footView;
    NSMutableArray *packageArray;
    GetPackageView *packageView;
    UIView *maskView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
     [self.navigationController.navigationBar setBarTintColor:txtColors(255,255,255, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textBlackColor,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:textBlackColor];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:naviBarTintColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    packageArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = txtColors(231,231,231,1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubviews];
    [self getPackageData];
    [self initMaskView];
    [self initNavigation];
}
-(void)initNavigation
{
    [self.navigationItem setTitle:@"消费礼包"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];

}
-(void)initSubviews
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];

    footView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,150*MCscale)];
    footView.backgroundColor = lineColor;
    footView.image = [UIImage imageNamed:@"消费礼包"];
}

-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    maskView.alpha = 0;
    maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
    
    packageView = [[GetPackageView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 200*MCscale)];
    packageView.getDelegate = self;
}
#pragma mark 获取礼包数据
-(void)getPackageData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    [mbHud show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbylibaoxianshi.action" params:nil success:^(id json) {
            [mbHud hide:YES];
            NSLog(@"礼包%@",json);
            if ([[json valueForKey:@"massages"]integerValue] == 1) {
                NSArray *listArray = [json valueForKey:@"list"];
                if (listArray>0) {
                    for (NSDictionary *dict in listArray) {
                        PackageModel *model = [[PackageModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        [packageArray addObject:model];
                    }
                    [self initArray];
                    mainTableView.tableFooterView = footView;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mainTableView reloadData];
                });
            }
            else
            {
                mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"站位图"]];
            }
        } failure:^(NSError *error) {
            [mbHud hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    });
}

-(void)initArray
{
    if (packageArray.count<3) {
        [packageArray addObject:@"0"];
        [self initArray];
    }
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return packageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    PackageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PackageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.packageDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reloadDataWithIndexpath:indexPath AndArray:packageArray];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150*MCscale;
}
#pragma mark PackageCellDelagate
-(void)getPackageWithDict:(NSDictionary *)dict
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 1;
        [self.view addSubview:maskView];
        packageView.alpha = 0.95;
        [self.view addSubview:packageView];
        [packageView reloadDataWithDict:dict];
    }];
}

#pragma mark GetPackageViewDelegate
-(void)goumailibaoSuccessWithIndex:(NSInteger)index
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeCustomView;
    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    if (index == 1) {
        mbHud.labelText = @"充值成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    }
    else
    {
        mbHud.labelText = @"订单交易失败";
    }
    [self maskViewDisMiss];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        packageView.alpha = 0;
        [packageView removeFromSuperview];
    }];
}
-(void)btnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
