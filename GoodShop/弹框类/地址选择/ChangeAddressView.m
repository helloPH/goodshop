//
//  ChangeAddressView.m
//  GoodShop
//
//  Created by MIAO on 2016/12/2.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ChangeAddressView.h"
#import "addressCell.h"
@implementation ChangeAddressView
{
    UITableView *addressTable;
    NSMutableArray *addressArray;
    NSInteger lastChooseAddress;//上次选中地址
    NSString *defaultdizId;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        addressArray = [NSMutableArray arrayWithCapacity:0];
        lastChooseAddress = -1;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        
        addressTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 15*MCscale, self.width, self.height-30*MCscale) style:UITableViewStylePlain];
        addressTable.delegate = self;
        addressTable.dataSource = self;
        addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:addressTable];
    }
    return self;
}

-(void)relodaDataWithDianpuID:(NSString *)dianpuId AndDefaultAddress:(NSString *)defaultStr
{
    defaultdizId = defaultStr;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    [addressArray removeAllObjects];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.tel":user_id,@"dianpuid":dianpuId}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findshowAddress.action" params:pram success:^(id json) {
        [HUD hide:YES];
        NSLog(@"更换地址%@",json);
        
        if(![[json valueForKey:@"address"]isEqual:[NSNull null]]){
            NSArray *ary = (NSArray *)[json valueForKey:@"address"];
            if (ary.count>0) {
                NSInteger i= 0;
                for(NSDictionary *dic in ary){
                    userAddressModel *modl = [[userAddressModel alloc]init];
                    [modl setValuesForKeysWithDictionary:dic];
                    NSString *dzid = [NSString stringWithFormat:@"%@",modl.dizhiId];
                    NSString *dzidasdf = [NSString stringWithFormat:@"%@",defaultStr];
                    if ([dzid isEqualToString:dzidasdf]) {
                        lastChooseAddress = i;
                    }
                    i++;
                    [addressArray addObject:modl];
                }
            }
        }
        [addressTable reloadData];
    } failure:^(NSError *error) {
        [HUD hide:YES];
        [self promptMessageWithString:@"网络连接错误3"];
    }];
}
#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    addressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[addressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    cell.modl = addressArray[indexPath.row];
    cell.delImage.tag = indexPath.row+1;
    if (indexPath.row == lastChooseAddress) {
        cell.choseImage.image = [UIImage imageNamed:@"选中"];
        cell.delImage.hidden = YES;
    }
    else{
        cell.choseImage.image = [UIImage imageNamed:@"选择"];
        cell.delImage.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    addressCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *lastIndePath = [NSIndexPath indexPathForRow:lastChooseAddress inSection:0];
    addressCell *lastCell = [tableView cellForRowAtIndexPath:lastIndePath];
    if(indexPath !=lastIndePath){
        newCell.choseImage.image = [UIImage imageNamed:@"选中"];
        newCell.delImage.hidden = YES;
        lastCell.choseImage.image = [UIImage imageNamed:@"选择"];
        lastCell.delImage.hidden = NO;
    }
    userAddressModel *model = addressArray[indexPath.row];
    if ([self.changeDelegate respondsToSelector:@selector(changeAddressSuccessWithModel:AndArrayCount:)]) {
        [self.changeDelegate changeAddressSuccessWithModel:model  AndArrayCount:addressArray.count];
    }
    defaultdizId = [NSString stringWithFormat:@"%@",model.dizhiId];
    lastChooseAddress = indexPath.row;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85*MCscale;
}
-(void)addressCell:(addressCell *)adresCell tapIndex:(NSInteger)index
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    bud.mode = MBProgressHUDModeIndeterminate;
    bud.delegate = self;
    bud.labelText = @"请稍等...";
    [bud show:YES];
    userAddressModel *modl = addressArray[index-1];
    NSString *dizhiId = [NSString stringWithFormat:@"%@",modl.dizhiId];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.id":dizhiId}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"deletedizhis.action" params:pram success:^(id json) {
        [bud hide:YES];
        NSLog(@"删除地址%@",json);
        if ([[json valueForKey:@"massage"]integerValue]==1) {
            [addressArray removeObjectAtIndex:index-1];
            if (index-1 == lastChooseAddress) {
                lastChooseAddress = 0;
                userAddressModel *model = addressArray[0];
                if ([self.changeDelegate respondsToSelector:@selector(changeAddressSuccessWithModel:AndArrayCount:)]) {
                    [self.changeDelegate changeAddressSuccessWithModel:model AndArrayCount:addressArray.count];
                }
            }
            else{
                if (lastChooseAddress != addressArray.count) {
                    for (int i =0; i<addressArray.count; i++) {
                        userAddressModel *modl = addressArray[i];
                        NSString *dzId = [NSString stringWithFormat:@"%@",modl.dizhiId];
                        if ([dzId isEqualToString:defaultdizId]) {
                            lastChooseAddress = i;
                            continue;
                        }
                    }
                }
                else{
                    lastChooseAddress = lastChooseAddress-1;
                }
            }
            [addressTable reloadData];
            [self promptMessageWithString:@"删除成功"];
        }
        else{
            [self promptMessageWithString:@"删除失败"];
        }
    } failure:^(NSError *error) {
        [bud hide:YES];
        [self promptMessageWithString:@"网络连接错误7"];
    }];
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
