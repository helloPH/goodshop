//
//  searchViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/22.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "searchViewController.h"
#import "Header.h"
//#import "mainController.h"
#import "searchCell.h"
#import "GoodDetailViewController.h"
#import "shopListModel.h"
#import "homePageCell.h"
@interface searchViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
{
    UITextField *searchFiled; // 搜索框
    NSString *filedTextValue;
    UITableView *searchTable;
    NSMutableArray *dataAry;
}
@end

@implementation searchViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    dataAry = [[NSMutableArray alloc]init];
    [self initNavigation];
    [self loadHeadView];
    [self loadTableView];
    
    [self getMorenShangpin];
}
-(void)initNavigation
{
    self.navigationItem.title = @"搜索商品";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.tag = 1001;
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        if (self.viewTag == 2) {
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isFirst"];
            CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
            [main setSelectedIndex:0];
            main.buttonIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark 获取默认商品
-(void)getMorenShangpin
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":_dianpuID}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbydianpurexiao.action" params:pram success:^(id json) {
            [HUD hide:YES];
            NSLog(@"默认商品%@",json);
            [dataAry removeAllObjects];
            NSArray *ary = [json valueForKey:@"shop"];
            if([[json valueForKey:@"massages"]integerValue]){
                searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索无数据.jpg"]];
            }
            if (ary.count >0) {
                searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
                for(NSDictionary *dc in ary){
                    searchGoodModel *model = [[searchGoodModel alloc]init];
                    [model setValuesForKeysWithDictionary:dc];
                    [dataAry addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [searchTable reloadData];
            });
        } failure:^(NSError *error) {
            [HUD hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    });
}
-(void)loadHeadView
{
    searchFiled = [[UITextField alloc]initWithFrame:CGRectMake(kDeviceWidth/10.0, 84, SEtxtfiledWidth, 30)];
    searchFiled.textAlignment = NSTextAlignmentLeft;
    filedTextValue = searchFiled.text;
    searchFiled.delegate = self;
    searchFiled.returnKeyType = UIReturnKeyDone;
    searchFiled.textColor = [UIColor blackColor];
    searchFiled.font = [UIFont systemFontOfSize:MLwordFont_4];
    searchFiled.backgroundColor = [UIColor clearColor];
    [self .view addSubview:searchFiled];
    
    UIView *btview = [[UIView alloc]initWithFrame:CGRectMake(searchFiled.right+20, SEbtnSpace, 60*MCscale, 25*SCscale)];
    btview.userInteractionEnabled = YES;
    btview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction)];
    [btview addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25*SCscale, 25*SCscale)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"灰色搜索"];
    [btview addSubview:imageView];
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(searchFiled.left-5, searchFiled.bottom, searchFiled.width+10, 1)];
    line0.backgroundColor = mainColor;
    [self.view addSubview:line0];
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(line0.left, searchFiled.bottom-2, 1, 3)];
    line1.backgroundColor = mainColor;
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(line0.right, searchFiled.bottom-2, 1, 3)];
    line2.backgroundColor = mainColor;
    [self.view addSubview:line2];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, searchFiled.bottom+9, kDeviceWidth, 1)];
    line3.backgroundColor = lineColor;
    [self.view addSubview:line3];
}
-(void)loadTableView
{
    searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, searchFiled.bottom+10, kDeviceWidth, kDeviceHeight-searchFiled.bottom-10) style:UITableViewStylePlain];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    searchTable.backgroundColor = [UIColor whiteColor];
    searchTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 30);
    searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
    [self.view addSubview:searchTable];
}
#pragma mark --UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    searchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[searchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.secmodel = dataAry[indexPath.row];
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![dataAry[indexPath.row] isEqual:nil]) {
        searchGoodModel *modl = dataAry[indexPath.row];
        GoodDetailViewController *vc = [[GoodDetailViewController alloc]init];
        vc.goodId = modl.god_id;
        vc.ViewTag = 1;
        vc.dianpuId = user_qiehuandianpu;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataAry.count == 0) return 40*MCscale;
    return 80*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void)searchAction
{
    if ([searchFiled.text isEqualToString:@""]) {
        [self promptMessageWithString:@"关键字不能为空!"];
    }
    else{
        [self.view endEditing:YES];
        filedTextValue = searchFiled.text;
        [self loadData];
    }
}

#pragma mark 搜索商品
-(void)loadData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shequid":_dianpuID,@"shangpinname":filedTextValue}];
    
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findShopByName.action" params:pram success:^(id json) {
        NSLog(@"搜索%@",json);
        [HUD hide:YES];
        [dataAry removeAllObjects];
        NSArray *ary = [json valueForKey:@"shop"];
        if([[json valueForKey:@"massages"]integerValue]){
            searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索无数据.jpg"]];
            [self promptMessageWithString:@"没有搜索到相关物品"];
        }
        if (ary.count >0) {
            searchTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
            for(NSDictionary *dc in ary){
                searchGoodModel *model = [[searchGoodModel alloc]init];
                [model setValuesForKeysWithDictionary:dc];
                [dataAry addObject:model];
            }
        }
        [searchTable reloadData];
    } failure:^(NSError *error) {
        [HUD hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (_viewTag == 3) {
        NSNotification *daohanglanHidden = [NSNotification notificationWithName:@"daohanglanHidden" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:daohanglanHidden];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"daohanglanHidden" object:nil];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    [searchFiled resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [searchFiled resignFirstResponder];
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
@end
