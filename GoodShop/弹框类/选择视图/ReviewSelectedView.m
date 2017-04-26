//
//  ReviewSelectedView.m
//  ManageForMM
//
//  Created by MIAO on 16/11/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ReviewSelectedView.h"
#import "TypeSelectedCell.h"
#import "Header.h"
@implementation ReviewSelectedView
{
    UITableView *mainTableview;
    NSMutableArray *fenleiArray;
    NSInteger viewTag;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        fenleiArray = [NSMutableArray arrayWithCapacity:0];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
    }
    return self;
}

-(void)reloadDataWithViewTag:(NSInteger)index
{
    viewTag = index;
    if (index == 1) {
        [self getFenleiData];
    }
    else if (index == 2)
    {
        [self getHangyeMessageData];
    }
    
    [mainTableview reloadData];
}
#pragma mark 获取分类
-(void)getFenleiData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    mbHud.delegate = self;
    [mbHud show:YES];
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":_dianpuID,@"userid":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findfenlei.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"分类%@",json);
        [fenleiArray removeAllObjects];
        NSArray *listArr = [json valueForKey:@"fenlei"];
        [fenleiArray addObjectsFromArray:listArr];
        [fenleiArray insertObject:@"全部商品" atIndex:0];
        if ([[json valueForKey:@"rexiao"]integerValue] == 1) {
            [fenleiArray insertObject:@"热销专区" atIndex:1];
        }
        [mainTableview reloadData];
    }failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark 行业信息
-(void)getHangyeMessageData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    mbHud.delegate = self;
    [mbHud show:YES];

    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyhanghekaifu.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"行业信息%@",json);
        [fenleiArray removeAllObjects];
        if ([[json valueForKey:@"message"] integerValue] == 1) {
        NSArray *listArr = [json valueForKey:@"hangye"];
        [fenleiArray addObjectsFromArray:listArr];
        }
        [mainTableview reloadData];
    }failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(void)createUI
{
    mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 15*MCscale, self.width, self.height - 30*MCscale) style:UITableViewStylePlain];
    mainTableview.delegate = self;
    mainTableview.dataSource = self;
    mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:mainTableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (viewTag == 1||viewTag == 2) {
    return fenleiArray.count;
    }
    else if(viewTag == 3) return self.nameArray.count;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TypeSelectedCell";
    TypeSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TypeSelectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (viewTag == 1) {
        [cell reloadDataForFenleiWithIndexPath:indexPath AndArray:fenleiArray];
    }
    else if (viewTag == 2)
    {
        [cell reloadDataForHangyeWithIndexPath:indexPath AndArray:fenleiArray];
    }
    else if (viewTag == 3)
    {
        [cell reloadDataForHezuoWithIndexPath:indexPath AndArray:self.nameArray];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (viewTag == 1) {
        if ([self.selectedDelegate respondsToSelector:@selector(selectedFenleiWithString:)]) {
            [self.selectedDelegate selectedFenleiWithString:fenleiArray[indexPath.row]];
        }
    }
    else if (viewTag == 2)
    {
        if ([self.selectedDelegate respondsToSelector:@selector(selectedHangyeWithHangyeName:AndID:)])
        {
            [self.selectedDelegate selectedHangyeWithHangyeName:fenleiArray[indexPath.row][@"name"] AndID:fenleiArray[indexPath.row][@"id"]];
        }
    }
    else if (viewTag == 3)
    {
        if ([self.selectedDelegate respondsToSelector:@selector(selectedHezuoWithHezuoName:AndID:)])
        {
            [self.selectedDelegate selectedHezuoWithHezuoName:self.nameArray[indexPath.row][@"name"] AndID:self.nameArray[indexPath.row][@"id"]];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*MCscale;
}

-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1.5);
}

@end

