//
//  PackagesRecordViewController.m
//  GoodShop
//
//  Created by MIAO on 2017/1/9.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PackagesRecordViewController.h"
#import "Header.h"
#import "PackagesRecordModel.h"
#import "PackagesRecordCell.h"
#import "DianpuRecordViewController.h"
@interface PackagesRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@end

@implementation PackagesRecordViewController
{
    UITableView *mainTableView;
    NSMutableArray *packagesArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }

    packagesArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setTitle:@"消费券"];
    [self initSubviews];
    [self getPackageData];
}

-(void)initSubviews
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}
#pragma mark 获取优惠券数据
-(void)getPackageData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    [mbHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"usertel":user_id}];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyuseridalllibao.action" params:pram success:^(id json) {
            [mbHud hide:YES];
            NSLog(@"消费券%@",json);
            if ([[json valueForKey:@"massages"]integerValue] == 1) {
                NSArray *listArray = [json valueForKey:@"list"];
                for (NSDictionary *dict in listArray) {
                    PackagesRecordModel *model = [[PackagesRecordModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [packagesArray addObject:model];
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
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return packagesArray.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    PackagesRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PackagesRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.couponsDelegate = self;
    [cell reloadDataWithIndexPath:indexPath AndArray:packagesArray];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PackagesRecordModel *model = packagesArray[indexPath.row];
    DianpuRecordViewController *dianpuRecordVC = [[DianpuRecordViewController alloc]init];
    dianpuRecordVC.dianpuId = model.dinapuid;
    dianpuRecordVC.dianpuName = model.dianpuname;
    dianpuRecordVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:dianpuRecordVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*MCscale;
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
