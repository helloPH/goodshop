//
//  MoreViewController.m
//  LifeForMM
//
//  Created by HUI on 16/3/29.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "MoreViewController.h"
#import "Header.h"
#import "NewFunctionViewController.h"
#import "BusinessCooperationViewController.h"
#import "QRCodeViewController.h"
#import "PersonalCenterCell.h"
@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *banbenLabel;
@end

@implementation MoreViewController
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
    //初始化导航
    [self setNavigationItem];
    [self.view addSubview:self.mainTableView];
}

-(void)setNavigationItem
{
    self.navigationItem.title = @"关于妙店佳";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];    //初始化表头
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.backgroundColor= [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.scrollEnabled = NO;
        _mainTableView.tableHeaderView = self.headView;
    }
    return _mainTableView;
}
-(UIView *)headView
{
    if (!_headView) {
        _headView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth, 185*MCscale) backgroundColor:[UIColor whiteColor]];
        [_headView addSubview:self.iconImageView];
        [_headView addSubview:self.banbenLabel];
    }
    return _headView;
}
-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [BaseCostomer imageViewWithFrame:CGRectMake(0, 0, 80*MCscale, 80*MCscale) backGroundColor:[UIColor clearColor] image:@"logo"];
        _iconImageView.center = CGPointMake(kDeviceWidth/2.0, 60*MCscale);
    }
    return _iconImageView;
}
-(UILabel *)banbenLabel
{
    if (!_banbenLabel) {
        _banbenLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, self.iconImageView.bottom+10*MCscale, kDeviceWidth, 20*MCscale)];
        NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _banbenLabel.text = [NSString stringWithFormat:@"当前版本 %@",versionStr];
        _banbenLabel.textAlignment = NSTextAlignmentCenter;
        _banbenLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
        _banbenLabel.backgroundColor = [UIColor clearColor];
    }
    return _banbenLabel;
}
#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PersonalCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell reloadDataForMoreFromIndexPath:indexPath AndViewTag:2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*MCscale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (!user_dianpuId ||[user_dianpuId integerValue] == 0) {
            [self promptMessageWithString:@"暂无店铺二维码"];
        }
        else
        {
        QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc]init];
        QRCodeVC.hidesBottomBarWhenPushed = YES;
        QRCodeVC.viewTag = 2;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:QRCodeVC animated:YES];
        }
    }
    else if (indexPath.row==1) {
        NewFunctionViewController *NewVC = [[NewFunctionViewController alloc]init];
        NewVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:NewVC animated:YES];
    }
    else if (indexPath.row == 2) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stor_url]];
    else
    {
        BusinessCooperationViewController *BusinessCooperationVC = [[BusinessCooperationViewController alloc]init];
        BusinessCooperationVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:BusinessCooperationVC animated:YES];
    }
}

-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
