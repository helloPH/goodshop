//
//  DianpuRecordViewController.m
//  GoodShop
//
//  Created by MIAO on 2017/1/9.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "DianpuRecordViewController.h"
#import "Header.h"
#import "DianpuRecordModel.h"
#import "DianpuRecordCell.h"
@interface DianpuRecordViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation DianpuRecordViewController
{
    UITableView *mainTableView;
    NSMutableArray *recordArray;
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

    recordArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setTitle:_dianpuName];
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
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"usertel":user_id,@"dianpuid":_dianpuId}];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"finddinapulibaoxiangqing.action" params:pram success:^(id json) {
            [mbHud hide:YES];
            NSLog(@"消费记录%@",json);
            if ([[json valueForKey:@"massages"]integerValue] == 1) {
                NSArray *listArray = [json valueForKey:@"list"];
                for (NSDictionary *dict in listArray) {
                    DianpuRecordModel *model = [[DianpuRecordModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [recordArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mainTableView reloadData];
                });
            }
            else
            {
                [self promptMessageWithString:@"暂无"];
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
    return recordArray.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    DianpuRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DianpuRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell reloadDataWithIndexPath:indexPath AndArray:recordArray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*MCscale;
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
