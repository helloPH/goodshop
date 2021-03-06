//
//  CarViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "CarViewController.h"
#import "carViewCell.h"
#import "Header.h"
//#import "lifeCityViewController.h"
#import "UserOrderViewController.h"
#import "NewAddresPopView.h"
#import "OrderPromptView.h"
#import "DianCanOrderViewController.h"


@interface CarViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,carCellViewDelegate,MBProgressHUDDelegate,UITextViewDelegate,newAddresPopDelegate,UITextFieldDelegate,OrderPromptViewDelegate>
{
    UILabel *coupon,*moneyLabel;//以优惠  总价钱
    UIButton *goToOrder;//去下单
    CGFloat countMoney;
    UIView *deleatView;
    NSMutableArray *listDataAry;//数据数组
    UILabel *youHuiLabel;//优惠
    NSMutableArray *dianpuArray;
    NSMutableArray *sectAry;//店铺
    NSInteger sectHeadChoose;//上次选择的店铺
    NewAddresPopView *newAddressPop;//新地址
    UIView *maskView;//弹框遮罩层
    MBProgressHUD *allBub;
    BOOL isdel;//
    NSMutableArray *selectGoodsAry;
    OrderPromptView *orderPrompt;
//    UIImageView *caozuotishiImage;
    NSString *dianpuID;
 
    
}
@end

@implementation CarViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    listDataAry = [[NSMutableArray alloc]init];
    sectAry = [[NSMutableArray alloc]init];
    dianpuArray = [[NSMutableArray alloc]init];
    selectGoodsAry = [[NSMutableArray alloc]init];

    
    sectHeadChoose = 0;
    isdel = 0;
    dianpuID = user_qiehuandianpu;
    [self initNavigation];
    [self loadTableView];
    [self loadListData];
    [self loadFootView];
    [self initNewAddressPop];
    [self initMaskView];
    [self judgeTheFirst];
}
-(void)judgeTheFirst
{
    [self showGuideImageWithUrl:@"images/caozuotishi/gouwuche.png"];
//    
//    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstShopCar"] integerValue] == 1) {
//        NSString *url = @"images/caozuotishi/gouwuche.png";
//        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
//        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
//        caozuotishiImage.userInteractionEnabled = YES;
//        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
//        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
//        [caozuotishiImage addGestureRecognizer:imageTap];
//        [self.view addSubview:caozuotishiImage];
//    }
//}
//
//-(void)imageHidden
//{
//    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstShopCar"];
//    [caozuotishiImage removeFromSuperview];
}
-(void)orderSuccessReload
{
    [self loadListData];
    dianpuID = user_qiehuandianpu;
    [self reloadMoney];
}
#pragma mark -- 购物车数据
-(void)loadListData
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bud.mode = MBProgressHUDModeIndeterminate;
    bud.delegate = self;
    bud.labelText = @"请稍等...";
    [bud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findcarshow.action" params:pram success:^(id json) {
        
        [bud hide:YES];
        NSLog(@"购物车数据 %@",json);
        
        NSArray *totlAry = [json valueForKey:@"carxinxi"];
        [listDataAry removeAllObjects];
        [dianpuArray removeAllObjects];
        if (totlAry.count>0) {
            _table.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            
            for(NSArray *ary in totlAry){
                NSMutableArray *modAry = [[NSMutableArray alloc]init];
                //                NSString *dianpuname;
                NSMutableDictionary *dictionAry = [[NSMutableDictionary alloc]init];
                for(NSDictionary *dic in ary){
                    carDataModel *model = [[carDataModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [modAry addObject:model];
                    [dictionAry setValue:model.dianpuname forKey:@"dianpuname"];
                    [dictionAry setValue:model.dianpuid forKey:@"dianpuid"];
                    //                    dianpuname = model.dianpuname;
                }
                [listDataAry addObject:modAry];
                [dianpuArray addObject:dictionAry];
                if (dianpuArray.count == 1) {
                    NSDictionary *dc = dianpuArray[0];
                    NSString *sqid =  [NSString stringWithFormat:@"%@",[dc valueForKey:@"dianpuid"]];
                    sectHeadChoose = 0;
                    [[NSUserDefaults standardUserDefaults] setValue:sqid forKey:@"choosePaydianpuId"];
                }
                for (int i = 0; i<dianpuArray.count; i++) {
                    NSDictionary *dc = dianpuArray[i];
                    NSString *dpid =  [NSString stringWithFormat:@"%@",[dc valueForKey:@"dianpuid"]];
                    if ([[NSString stringWithFormat:@"%@",user_qiehuandianpu] isEqualToString:dpid]) {
                        sectHeadChoose = i;
                        [[NSUserDefaults standardUserDefaults] setValue:dpid forKey:@"choosePaydianpuId"];
                    }
                }
            }
            [self reoladDianpu];
        }
        else{
            _table.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购物车无数据.jpg"]];
            moneyLabel.text = [NSString stringWithFormat:@"¥0.00"];
        }
        [_table reloadData];
    } failure:^(NSError *error) {
        [bud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//设置默认社区
-(void)reoladDianpu
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dianpuid":user_qiehuandianpu}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"selectshequ.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"massages"] integerValue]==1) {
            dianpuID = user_qiehuandianpu;
            [self reloadMoney];
            for (int i = 0; i<dianpuArray.count; i++) {
                NSDictionary *dic = dianpuArray[i];
                NSString *dianpuId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"dianpuid"]];
                NSString *nowDianpuId = [NSString stringWithFormat:@"%@",user_qiehuandianpu];
                if ([dianpuId isEqualToString:nowDianpuId]) {
                    NSArray *ary = listDataAry[i];
                    [self initSelectAry:ary];
                }
            }
        }
        else{
            NSDictionary *dic = dianpuArray[0];
            NSArray *ary = listDataAry[0];
            dianpuID = [dic valueForKey:@"dianpuid"];
            [self reloadMoney];
            [self initSelectAry:ary];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//根据社区获取当前选择结算社区的总金额
-(void)reloadMoney
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dianpuid":dianpuID}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findtotaprice.action" params:pram success:^(id json) {
        NSLog(@"金额%@",json);
        NSString *money = [NSString stringWithFormat:@"¥%.2f",[[json valueForKey:@"totalPrice"] floatValue]];
        NSString *youh =[NSString stringWithFormat:@"已优惠¥ %@",[json valueForKey:@"youhui"]];
        CGSize moneyLabSize =[money boundingRectWithSize:CGSizeMake(140*MCscale, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_15],NSFontAttributeName, nil] context:nil].size;
        moneyLabel.frame = CGRectMake(25*MCscale, 12, moneyLabSize.width+10, 30);
        moneyLabel.text = money;
        CGSize youhLabSize =[youh boundingRectWithSize:CGSizeMake(120*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
        youHuiLabel.frame = CGRectMake(moneyLabel.right, 18, youhLabSize.width, 20);
        youHuiLabel.text = youh;
        if ([[json valueForKey:@"youhui"] floatValue]>0) {
            youHuiLabel.alpha = 1;
        }
        else
            youHuiLabel.alpha = 0;
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
//导航
-(void)initNavigation
{
    self.navigationItem.title = @"购物车";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
}
//初始化表格
-(void)loadTableView
{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    

}

-(void)initSelectAry:(NSArray *)ary
{
    [selectGoodsAry removeAllObjects];
    for(carDataModel *carModel in ary){
        NSString *selBolStr = [NSString stringWithFormat:@"%@",carModel.xuangzhongzhuangtai];
        [selectGoodsAry addObject:selBolStr];
    }
}
#pragma mark -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dianpuArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *ary = listDataAry[section];
    return ary.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    carViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[carViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0, 200, 100*SCscale)];
        btnView.backgroundColor = txtColors(206, 207, 208, 1);
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(18/SCscale, 35*SCscale, 35*SCscale, 35*SCscale)];
        image.image = [UIImage imageNamed:@"红色删除"];
        [btnView addSubview:image];
        [cell.contentView addSubview:btnView];
    }
    NSArray *secDataAry = listDataAry[indexPath.section];
    
    [cell reloadDataWithIndexPath:indexPath AndArray:secDataAry];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectBool = 1;
    if(indexPath.section != sectHeadChoose){
        cell.userInteractionEnabled = NO;
        cell.selectImageView.image = [UIImage imageNamed:@"选择"];
        cell.selectBool = 0;
    }
    else{
        cell.userInteractionEnabled = YES;
        if (selectGoodsAry.count>0) {
            NSString *num = selectGoodsAry[indexPath.row];
            if ([num isEqualToString:@"1"]) {
                cell.selectImageView.image = [UIImage imageNamed:@"选中"];
                cell.selectBool = 1;
            }
            else{
                cell.selectImageView.image = [UIImage imageNamed:@"选择"];
                cell.selectBool = 0;
            }
        }
        else{
            cell.userInteractionEnabled = YES;
            cell.selectImageView.image = [UIImage imageNamed:@"选中"];
            cell.selectBool = 1;
        }
        
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCcellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.tag = section + 100;
    NSString *dianpuname = [dianpuArray[section] valueForKey:@"dianpuname"];
    CGSize titSize = [dianpuname boundingRectWithSize:CGSizeMake(150, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, titSize.width, 20)];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:MLwordFont_5];
    title.text = [dianpuArray[section] valueForKey:@"dianpuname"];
    [view addSubview:title];
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(title.right+20, 10, 120, 20)];
    subLabel.textColor = textBlackColor;
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [view addSubview:subLabel];
    
    UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-48, 10, 24, 24)];
    if(section == sectHeadChoose){
        selectImage.image = [UIImage imageNamed:@"选中"];
        subLabel.text = @"当前选择店铺";
    }
    else{
        selectImage.image = [UIImage imageNamed:@"选择"];
        subLabel.text = @"";
    }
    selectImage.backgroundColor = [UIColor clearColor];
    selectImage.tag = 11;
    selectImage.userInteractionEnabled = YES;
    [view addSubview:selectImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSect:)];
    [view addGestureRecognizer:tap];
    [sectAry addObject:view];
    return view;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self delData:indexPath];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)chooseSect:(UITapGestureRecognizer *)tap
{
    NSInteger tpTag = tap.view.tag-100;
    if (tpTag != sectHeadChoose) {
        sectHeadChoose = tpTag;
        [_table reloadData];
        carDataModel *carModel = listDataAry[tpTag][0];
        NSArray *ary = listDataAry[tpTag];
        [self initSelectAry:ary];
        NSString *dianpuId = [NSString stringWithFormat:@"%@",carModel.dianpuid];
        
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dianpuid":dianpuId}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"selectshequ.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"massages"] integerValue]==1) {
                [[NSUserDefaults standardUserDefaults] setValue:dianpuId forKey:@"choosePaydianpuId"];
                dianpuID = dianpuId;
                [self reloadMoney];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}
#pragma footView
-(void)loadFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    footView.backgroundColor = mainColor;
    
    youHuiLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    youHuiLabel.textColor = txtColors(237, 58, 76, 1);
    youHuiLabel.alpha = 0;
    youHuiLabel.textAlignment = NSTextAlignmentLeft;
    youHuiLabel.backgroundColor = [UIColor clearColor];
    youHuiLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
    [footView addSubview:youHuiLabel];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyLabel.textColor = txtColors(237, 58, 76, 1);;
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:MLwordFont_15];
    [footView addSubview:moneyLabel];
    
    goToOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    goToOrder.frame = CGRectMake(kDeviceWidth-120, 10, 100, 30);
    goToOrder.backgroundColor = [UIColor clearColor];
    [goToOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goToOrder setTitle:@"去下单" forState:UIControlStateNormal];
    [goToOrder setBackgroundImage:[UIImage imageNamed:@"去下单"] forState:UIControlStateNormal];
    [goToOrder addTarget:self action:@selector(goToCheck) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:goToOrder];
    [self.view addSubview:footView];
}
#pragma mark -- carViewCellDelegate
//改变数据 数量
-(void)carViewCell:(carViewCell *)cellView atIndex:(NSInteger)index addoOrCut:(NSInteger)bol numCount:(NSInteger)num cellSelect:(NSInteger)sel
{
    if (sel!=2) {
        NSString *nextNum;
        if (bol) {
            nextNum = [NSString stringWithFormat:@"%ld",(long)num-1];
        }
        else{
            nextNum = [NSString stringWithFormat:@"%ld",(long)num+1];
        }
        NSIndexPath *indexpath = [_table indexPathForCell:cellView];
        carDataModel *carModel = listDataAry[indexpath.section][indexpath.row];
        NSString *goid = carModel.shangpiid;
        if (!sel) {
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"car.id":goid,@"car.type":@"1"}];
            [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"selectgouwuid.action" params:pram success:^(id json) {
                
                if ([[json valueForKey:@"massages"]integerValue] == 1) {
                    dianpuID = carModel.dianpuid;
                    [self reloadMoney];
                    NSMutableDictionary *prams = [[NSMutableDictionary alloc]initWithDictionary:@{@"car.id":goid,@"car.shuliang":[NSString stringWithFormat:@"%ld",(long)num]}];
                    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"uqdatenum.action" params:prams success:^(id json) {
                        
                        NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] ;
                        if ([message isEqualToString:@"1"]) {
                            dianpuID = carModel.dianpuid;
                            
                            [self reloadMoney];
                            if (bol) {
                                carModel.shuliang=[NSString stringWithFormat:@"%ld",(long)([carModel.shuliang integerValue]+1)];
                            }
                            else
                                carModel.shuliang =[NSString stringWithFormat:@"%ld",(long)([carModel.shuliang integerValue]-1)];
                            [listDataAry[indexpath.section] replaceObjectAtIndex:indexpath.row withObject:carModel];
                        }
                        else if ([message isEqualToString:@"3"])
                        {
                            cellView.numData=num-1;
                            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            bud.mode = MBProgressHUDModeCustomView;
                            bud.labelText = @"当前商品库存不足";
                            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                        }
                        else if ([message isEqualToString:@"4"])
                        {
                            cellView.numData=num-1;
                            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            bud.mode = MBProgressHUDModeCustomView;
                            bud.labelText = @"当前数量已达到活动上限";
                            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                        }
                        else{
                            cellView.goodNum.text = nextNum;
                        }
                    } failure:^(NSError *error) {
                        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        bud.mode = MBProgressHUDModeCustomView;
                        bud.labelText = @"网络连接错误";
                        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    }];
                }
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
            cellView.selectImageView.image = [UIImage imageNamed:@"选中"];
            [self carViewcell:cellView shooseGood:1];
        }
        else{
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"car.id":goid,@"car.shuliang":[NSString stringWithFormat:@"%ld",(long)num]}];
            [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"uqdatenum.action" params:pram success:^(id json) {
                
                NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] ;
                if ([message isEqualToString:@"1"]) {
                    dianpuID = carModel.dianpuid;
                    
                    [self reloadMoney];
                    if (bol) {
                        carModel.shuliang=[NSString stringWithFormat:@"%ld",(long)[carModel.shuliang integerValue]+1];
                    }
                    else
                        carModel.shuliang =[NSString stringWithFormat:@"%ld",(long)[carModel.shuliang integerValue]-1];
                    [listDataAry[indexpath.section] replaceObjectAtIndex:indexpath.row withObject:carModel];
                }
                else if ([message isEqualToString:@"3"])
                {
                    cellView.numData=num-1;

                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"当前商品库存不足";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                else if ([message isEqualToString:@"4"])
                {
                    cellView.numData=num-1;
                    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    bud.mode = MBProgressHUDModeCustomView;
                    bud.labelText = @"当前数量已达到活动上限";
                    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
                else{
                    cellView.goodNum.text = nextNum;
                }
            } failure:^(NSError *error) {
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
    }
    else{
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"抱歉，商家休息中无法接受订单";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
//改变选中
-(void)carViewcell:(carViewCell *)cellView shooseGood:(NSInteger)chbol
{
    if (chbol != 2) {
        NSString *cartype = [NSString stringWithFormat:@"%ld",(long)chbol];
        NSIndexPath *indexpath = [_table indexPathForCell:cellView];
        carDataModel *carModel = listDataAry[indexpath.section][indexpath.row];
        NSString *goid = carModel.shangpiid;
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"car.id":goid,@"car.type":cartype}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"selectgouwuid.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"massages"]integerValue] == 1) {
                [[NSUserDefaults standardUserDefaults]setValue:carModel.dianpuid forKey:@"choosePaydianpuId"];
                [selectGoodsAry replaceObjectAtIndex:indexpath.row withObject:cartype];
                dianpuID = carModel.dianpuid;
                
                [self reloadMoney];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
    else{
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"抱歉，商家休息中无法接受订单";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
-(void)goToCheck
{
    BOOL isgo = 0;
    if (listDataAry.count<=0) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"购物车还是空的!先加件商品再试试!";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        for (NSString *str in selectGoodsAry) {
            if ([str isEqualToString:@"1"]) {
                isgo = 1;
                break;
            }
        }
        if (isgo==1) {
            allBub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            allBub.mode = MBProgressHUDModeIndeterminate;
            allBub.delegate = self;
            allBub.labelText = @"请稍等...";
            [allBub show:YES];
            
            NSString *dianpuId = [[NSUserDefaults standardUserDefaults] valueForKey:@"choosePaydianpuId"];
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.tel":user_id,@"dianpuid":dianpuId}];
            
            [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyAddress.action" params:pram success:^(id json) {
                [allBub hide:YES];
                if ([isPeiSong isEqualToString:@"0"]) {// 如果是 本地购买
                    DianCanOrderViewController * dianCan = [[DianCanOrderViewController alloc]init];
                    dianCan.dianpuID  = dianpuId;
                    dianCan.hidesBottomBarWhenPushed = YES;
                    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                    bar.title=@"";
                    self.navigationItem.backBarButtonItem=bar;
                    [self.navigationController pushViewController:dianCan animated:YES];
                    
                    
                    return ;
                }
                
                
                if (![[json valueForKey:@"address"]isEqual:[NSNull null]]) {
                    NSArray *ary = [json valueForKey:@"address"];
                    userAddressModel * addressModel = [[userAddressModel  alloc]init];
                    NSDictionary *addDic = ary[0];
                    [addressModel setValuesForKeysWithDictionary:addDic];
                    addressModel.qiehuan = [json valueForKey:@"qiehuan"];
                    [UIView animateWithDuration:0.3 animations:^{
                        maskView.alpha = 0;
                        [maskView removeFromSuperview];
                        newAddressPop.alpha = 0;
                        [newAddressPop removeFromSuperview];
                    }];
                    
                    
                    
                    UserOrderViewController *orderVC = [[UserOrderViewController alloc]init];
                    orderVC.dianpuID  = dianpuId;
                    orderVC.hidesBottomBarWhenPushed = YES;
                    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                    bar.title=@"";
                    self.navigationItem.backBarButtonItem=bar;
                    [self.navigationController pushViewController:orderVC animated:YES];
                }
                else{
                    [UIView animateWithDuration:0.3 animations:^{
                        maskView.alpha = 1;
                        [self .view addSubview:maskView];
                        newAddressPop.dianpuID = dianpuId;
                        newAddressPop.alpha = 0.95;
                        [self.view addSubview:newAddressPop];
                    }];
                }
            } failure:^(NSError *error) {
                [allBub hide:YES];
                MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                bud.mode = MBProgressHUDModeCustomView;
                bud.labelText = @"网络连接错误";
                [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        else{
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"没有选中任何商品,无法下单!";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    }
}
//使用新地址
-(void)initNewAddressPop
{
    newAddressPop = [[NewAddresPopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 120*MCscale, kDeviceWidth*9/10.0,340*MCscale)];
    newAddressPop.alpha = 0;
    newAddressPop.addresPopdelegate = self;
    //    [self.view addSubview:newAddressPop];
}

#pragma mark -- NewAddresDelegate
-(void)newAddressView:(NewAddresPopView *)popView Andvalue:(NSInteger)index
{
    if (index == 2) {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"地址添加成功";
        [hub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            newAddressPop.alpha = 0;
            [newAddressPop removeFromSuperview];
        }];
        
        UserOrderViewController *orderVC = [[UserOrderViewController alloc]init];
        orderVC.dianpuID = dianpuID;
        orderVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    else if (index == 3)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self .view addSubview:maskView];
            orderPrompt.alpha = 0.95;
            orderPrompt = [[OrderPromptView alloc]initWithFrame:CGRectMake(kDeviceWidth/25.0, 170*MCscale, kDeviceWidth*9/11.0,155*MCscale)];
            orderPrompt.center =  CGPointMake(kDeviceWidth/2.0,270*MCscale);
            orderPrompt.cancalBtn.hidden = YES;
            orderPrompt.line2.hidden = YES;
            orderPrompt.orderPromptViewDelegate = self;
            [self.view addSubview:orderPrompt];
        }];
    }
    else if (index == 4)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self .view addSubview:maskView];
            orderPrompt.alpha = 0.95;
            orderPrompt = [[OrderPromptView alloc]initWithFrame:CGRectMake(kDeviceWidth/25.0, 170*MCscale, kDeviceWidth*9/11.0,220*MCscale)];
            orderPrompt.center =  CGPointMake(kDeviceWidth/2.0,270*MCscale);
            //                    orderPrompt.alpha = 0;
            orderPrompt.orderPromptViewDelegate = self;
            [self.view addSubview:orderPrompt];
        }];
    }
}

//弹框遮罩
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        newAddressPop.alpha = 0;
        orderPrompt.alpha = 0;
        [self.view endEditing:YES];
        [newAddressPop removeFromSuperview];
        [orderPrompt removeFromSuperview];
    }];
}
#pragma mark -- UITextFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1 || textField.tag == 2) {
        if (textField.text.length == 0) {
            return YES;
        }
        NSInteger exitLength = textField.text.length;
        NSInteger selectLength = range.length;
        NSInteger replaceLength = string.length;
        if (exitLength - selectLength +replaceLength>6) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -- 确认下单上传数据
-(void)checkChangeData
{
    MBProgressHUD *hubd = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubd.delegate = self;
    hubd.mode = MBProgressHUDModeIndeterminate;
    hubd.labelText = @"请稍等...";
    [hubd show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"shop!findCar.action" params:pram success:^(id json) {
        NSArray *ary = (NSArray * )json;
        if (ary.count >0) {
            [hubd hide:YES];
        }
    } failure:^(NSError *error) {
        [hubd hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
#pragma mark -- 删除数据
-(void)delData:(NSIndexPath *)indexPath
{
    MBProgressHUD *hubd = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubd.delegate = self;
    hubd.mode = MBProgressHUDModeIndeterminate;
    hubd.labelText = @"请稍等...";
    [hubd show:YES];
    carDataModel *carModel = listDataAry[indexPath.section][indexPath.row];
    NSString *goid = carModel.shangpiid;
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"car.id":goid}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"deletebyid.action" params:pram success:^(id json) {
        [hubd hide:YES];
        NSString *massage = [json valueForKey:@"massages"];
        if ([massage integerValue]==1) {
            NSNotification *cardelNotification = [NSNotification notificationWithName:@"cardelNotification" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:cardelNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cardelNotification" object:nil];

            [listDataAry[indexPath.section] removeObjectAtIndex:indexPath.row];
            
            [selectGoodsAry removeObjectAtIndex:indexPath.row];
            NSArray *ary = listDataAry[indexPath.section];
            dianpuID = carModel.dianpuid;
            
            [self reloadMoney];
            if (ary.count==0) {
                [dianpuArray removeObjectAtIndex:indexPath.section];
                [listDataAry removeObjectAtIndex:indexPath.section];
                isdel = 1;
                if(dianpuArray.count > 0){
                    carDataModel *carModel = listDataAry[0][0];
                    [self initSelectAry:listDataAry[0]];
                    NSString *dianpuId = carModel.dianpuid;
                    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dianpuId":dianpuId}];
                    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"selectshequ.action" params:pram success:^(id json) {
                        NSLog(@"-- %@",[json valueForKey:@"massages"]);
                        if ([[json valueForKey:@"massages"] integerValue]==1) {
                            sectHeadChoose = 0;
                            [[NSUserDefaults standardUserDefaults] setValue:dianpuId forKey:@"choosePaydianpuId"];
                            dianpuID = dianpuId;
                            
                            [self reloadMoney];
                            [_table reloadData];
                        }
                    } failure:^(NSError *error) {
                        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        bud.mode = MBProgressHUDModeCustomView;
                        bud.labelText = @"网络连接错误";
                        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    }];
                }
            }
            if(listDataAry.count <= 0){
                _table.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购物车无数据.jpg"]];
            }
            [_table reloadData];
        }
    } failure:^(NSError *error) {
        [hubd hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
-(void)startOrder
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":userId}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"shop!PlaceCar.action" params:pram success:^(id json) {
        NSArray *ary = (NSArray * )json;
        if (ary.count >0) {
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
#pragma mark -- 键盘
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    NSDictionary *userInfo = [notifaction userInfo];
    NSValue *userValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [userValue CGRectValue];
    CGRect fram = newAddressPop.frame;
    fram.origin.y = keyboardRect.origin.y-fram.size.height+20*MCscale;
    newAddressPop.frame = fram;
}
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    CGRect fram = newAddressPop.frame;
    fram.origin.y = 120*MCscale;
    newAddressPop.frame = fram;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotification *userLoginNotification = [NSNotification notificationWithName:@"changeGoodsAnying" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:userLoginNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeGoodsAnying" object:nil];
}

#pragma mark OrderPromptViewDelegate
-(void)OrderPromptView:(OrderPromptView *)orderView AndButton:(UIButton *)button
{
    if (button == orderView.sureBtn) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            newAddressPop.alpha = 0;
            orderPrompt.alpha = 0;
            [newAddressPop removeFromSuperview];
            [orderPrompt removeFromSuperview];
        }];
    }
    else
    {
        //2.1  修改购物车中特惠商品选中状态
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.tel":user_id}];
        [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:@"updateCarTehui.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue]==1) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 0;
                    [maskView removeFromSuperview];
                    newAddressPop.alpha = 0;
                    [orderPrompt removeFromSuperview];
                    [newAddressPop removeFromSuperview];
                }];
                NSNotification *newAddressPopSave = [NSNotification notificationWithName:@"newAddressPop" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:newAddressPopSave];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"newAddressPop" object:nil];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}


@end
