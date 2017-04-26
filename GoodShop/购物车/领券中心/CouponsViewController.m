//
//  CouponsViewController.m
//  GoodShop
//
//  Created by MIAO on 2016/12/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "CouponsViewController.h"
#import "Header.h"
#import "CouponsCell.h"
#import "CouponsModel.h"
@interface CouponsViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,CouponsCellDelagate>

@end

@implementation CouponsViewController
{
    UITableView *mainTableView;
    UIImageView *headView;
    NSMutableArray *couponsArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:txtColors(255,255,255, 1)];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    couponsArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubviews];
    [self getCouponsData];
    [self initNavigation];
}
-(void)initNavigation
{
    [self.navigationItem setTitle:@"领券中心"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textColors,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_5],NSFontAttributeName,nil]];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"灰色返回"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)initSubviews
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    headView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60*MCscale)];
    headView.backgroundColor = [UIColor greenColor];
    headView.image = [UIImage imageNamed:@"领劵中心1"];
    mainTableView.tableHeaderView = headView;
}
#pragma mark 获取优惠券数据
-(void)getCouponsData
{
    if (user_tel) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeIndeterminate;
        mbHud.labelText = @"请稍后...";
        [mbHud show:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"usertel":user_tel}];
            
            [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyyouhuixianshi.action" params:pram success:^(id json) {
                [mbHud hide:YES];
                NSLog(@"优惠券%@",json);
                if ([[json valueForKey:@"massages"]integerValue] == 1) {
                    NSArray *listArray = [json valueForKey:@"list"];
                    for (NSDictionary *dict in listArray) {
                        CouponsModel *model = [[CouponsModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        [couponsArray addObject:model];
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
                [self promptMessageWithString:@"网络连接错误1"];
            }];
        });
    }
    else
    {
        mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"站位图"]];
    }
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return couponsArray.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CouponsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.couponsDelegate = self;
    [cell reloadDataWithIndexPath:indexPath AndArray:couponsArray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*MCscale;
}
#pragma mark CouponsCellDelegate
-(void)getCouponsWithIndex:(NSInteger)index
{
    if (index == 1)
    {
        [self promptMessageWithString:@"优惠券领取成功"];
    }
    else if (index == 0)
    {
        [self promptMessageWithString:@"优惠券领取失败"];
    }
    else
    {
        [self promptMessageWithString:@"网络连接错误2"];
    }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
