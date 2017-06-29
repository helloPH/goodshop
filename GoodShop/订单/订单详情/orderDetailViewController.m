//
//  orderDetailViewController.m
//  GoodShop
//
//  Created by MIAO on 2016/12/12.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "orderDetailViewController.h"
#import "Header.h"
#import "detailViewCell.h"
#import "orderMoreArginController.h"
#import "orderDetailModel.h"
#import "ReceiveBenefitsView.h"
#import "FuliModel.h"
#import "ShareRedPackView.h"
#import "DetailTableHeadView.h"
#import "DetailTableFootView.h"
@interface orderDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,DetailTableHeadViewDelegate,ReceiveBenefitsViewDelegate,ShareRedPackViewDelegate>
@end

@implementation orderDetailViewController
{
    UITableView *detailTableView;
    ShareRedPackView *shareRedPack;//分享红包弹框
    UIImageView *redPack;
    NSMutableArray *moneyArray;
    NSMutableArray *orderMessageAry;
    NSMutableArray *fuliAry;
    
    NSInteger cellNum;
    ReceiveBenefitsView *receiveBenefits;
    UIView *maskView;
    orderDetailModel *model;
    DetailTableHeadView *headView;
    DetailTableFootView *footView;
    UIView *fotView;
    CGFloat mainHeight;//高度
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_isOrderAgn) {
        __weak typeof (self) weakSelf = self;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
        }
    }
    else
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    moneyArray = [[NSMutableArray alloc]init];
    orderMessageAry = [[NSMutableArray alloc]init];
    fuliAry = [NSMutableArray array];
    [self initNavigation];
    [self initSubviews];
    [self initFootView];
    [self maskViewView];
    [self initPopView];
    [self initFulilingqu];
}

-(void)initNavigation
{
    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"主页"] forState:UIControlStateNormal];
    rightButton.tag = 1002;
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}

-(void)initSubviews
{
    detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64*MCscale, kDeviceWidth, kDeviceHeight-113*MCscale) style:UITableViewStylePlain];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.backgroundColor = [UIColor whiteColor];
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:detailTableView];
    [self tabelHeadView];
    [self tableFootView];
}

-(void)tabelHeadView
{
    headView = [[DetailTableHeadView alloc]initWithFrame:CGRectZero];
    headView.headerDelegate = self;
    detailTableView.tableHeaderView = headView;
}
-(void)tableFootView
{
    footView = [[DetailTableFootView alloc]initWithFrame:CGRectZero];
    detailTableView.tableFooterView = footView;
}
-(void)initFootView
{
    fotView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    fotView.userInteractionEnabled = YES;
    fotView.backgroundColor = mainColor;
    UIButton *orderAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    orderAgain.frame = CGRectMake(kDeviceWidth/2.0 -50*MCscale, 9*MCscale, 100*MCscale, 32*MCscale);
    [orderAgain setTintColor:[UIColor whiteColor]];
    [orderAgain setTitle:@"再来一单" forState:UIControlStateNormal];
    orderAgain.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_11];
    [orderAgain setBackgroundColor:txtColors(249, 54, 73, 1)];
    orderAgain.tag = 1007;
    [orderAgain addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    orderAgain.layer.masksToBounds = YES;
    orderAgain.layer.cornerRadius = 3.0;
    [fotView addSubview:orderAgain];
}

-(void)reloadData
{
    
    NSDictionary * pram = @{@"userid":user_id,@"dindan.danhao":_dingdanId};
    [Request getOrderInfoWithDic:pram success:^(NSInteger message,id data) {
        NSDictionary *dic = (NSDictionary*)data;
        
        
        model = [[orderDetailModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        
        NSString *zhuangt = [NSString stringWithFormat:@"%@",model.dindanzhuangtai];
        [orderMessageAry addObject:zhuangt];
        NSString *dingdanhao = model.dingdanhao; //订单号
        [orderMessageAry addObject:dingdanhao];
        NSString *shouhuoren = model.shouhuoren;
     
        [orderMessageAry addObject:shouhuoren];
   
        
      
        //收货人
     
        
        NSString *tel = model.tel; //电话
        [orderMessageAry addObject:tel];

    
   
      
        NSString *address = model.shouhuodizhi; //收货地址
        [orderMessageAry addObject:address];
        
     
        NSString *zhifustyle=@"";
//        if ([model.zhifufangshi isEqualToString:@"1"]) {
//            zhifustyle = @"货到付款";
//        }
//        else if ([model.zhifufangshi isEqualToString:@"2"]){
//            zhifustyle = @"在线支付";
//        }
//        else if ([model.zhifufangshi isEqualToString:@"8"]) {
//            
//        }
//        else
//            zhifustyle = @"余额支付";
        
        switch ([model.zhifufangshi integerValue]) {
            case 1:
                zhifustyle = @"货到付款" ;
                break;
            case 2:
                zhifustyle = @"在线支付";
                break;
            case 3:
                zhifustyle = @"余额支付";
                break;
            case 8://4改成8
                zhifustyle = @"礼包支付";
                break;
            case 7:
                zhifustyle = @"现金支付";
                break;
        }
        
        
        
        [orderMessageAry addObject:zhifustyle];
        NSString *xiadanTime = model.yuyuesongda; //下单时间
        if([xiadanTime isEqualToString:@"0"]){
            [orderMessageAry addObject:@"立即配送"];
        }
        else
            [orderMessageAry addObject:xiadanTime];
        NSString *fptt = model.fapiaotaitou;
        [orderMessageAry addObject:fptt]; //发票抬头
        NSString *dianpuName = model.dinapuname;
        [orderMessageAry addObject:dianpuName]; //店铺名
        NSString *dianpuID = model.dianpuid;
        [orderMessageAry addObject:dianpuID]; //dianouid
        
        if ([fptt isEqualToString:@"0"]) {
            headView.frame = CGRectMake(0, 0, kDeviceWidth, 280*MCscale);
        }
        else
        {
            headView.frame = CGRectMake(0, 0, kDeviceWidth, 310*MCscale);
        }
        headView.dindanzhuangtaidate = model.dindanzhuangtaidate;
        headView.dingdanleixing      = model.dingdanleixing;
        [headView createUIWithArray:orderMessageAry];
        
        //尾视图
        NSString *fujiafeiName = model.fujiafeiname;
        [moneyArray addObject:fujiafeiName]; //附加费name
       
        NSString *fujiafei = [NSString stringWithFormat:@"%@",model.fujiafei];
        [moneyArray addObject:fujiafei]; //附加费
        
  
        NSString *peisongfei = [NSString stringWithFormat:@"%@",model.peisongshishou];
        [moneyArray addObject:peisongfei]; //配送费
        
        
        NSString *yingfujine = [NSString stringWithFormat:@"%@",model.yingfujines];
        [moneyArray addObject:yingfujine]; //应付金额
        
  
        NSString *dingdanbeizhu = model.dindanbeizhu;
        [moneyArray addObject:dingdanbeizhu]; //订单备注
        

        
//        [moneyArray addObject:@""];// 福利
        
        CGSize size = [dingdanbeizhu boundingRectWithSize:CGSizeMake(kDeviceWidth-50*MCscale, 140*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        CGFloat footViewHeight = 120*MCscale;
        if (![dingdanbeizhu isEqualToString:@""] && ![dingdanbeizhu isEqualToString:@"0"]) {
            footViewHeight = footViewHeight +size.height;
        }
        
        footView.frame = CGRectMake(0,detailTableView.height - footViewHeight, kDeviceWidth,footViewHeight);
        [footView createUIWithArray:moneyArray];
        
        [detailTableView reloadData];
        
        BOOL isTh = 0;
        NSArray *ary = model.shoplist;
        for (NSDictionary *dic in ary) {
            NSString *shuxing = [NSString stringWithFormat:@"%@",[dic valueForKey:@"shopshuxing"]];
            if ([shuxing isEqualToString:@"5"]) {
                isTh =1;
            }
        }
        if (_isOrderAgn && !isTh) {
            [self.view addSubview:fotView];
        }
        else
        {
            detailTableView.frame = CGRectMake(0, 64*MCscale, kDeviceWidth, kDeviceHeight-64*MCscale);
        }
        
        NSString *sbid = [NSString stringWithFormat:@"%@",userSheBei_id];
        NSString *usid = [NSString stringWithFormat:@"%@",user_id];
        if ([[dic valueForKey:@"youhuiquanstatus"]integerValue]==0 && ![sbid isEqualToString:usid]) {
            [self redPackets];
        }
        if ([[NSString stringWithFormat:@"%@",model.dindanzhuangtai] isEqualToString:@"1"]) {
            [self reloadDataWithFuli];
        }

    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)reloadDataWithFuli
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dindan.danhao":[NSString stringWithFormat:@"%@",_dingdanId]}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"showFuli.action" params:pram success:^(id json) {
        [Hud hide:YES];
        if ([json integerForKey:@"message"] == 1) {
            NSArray *fuliArr = [json valueForKey:@"fulishop"];
            for (NSDictionary *dic in  fuliArr) {
                FuliModel *fuliModel = [[FuliModel alloc]init];
                [fuliModel setValuesForKeysWithDictionary:dic];
                [fuliAry addObject:fuliModel];
            }
            [receiveBenefits reloadDataFromArray:fuliAry AndDanhao:_dingdanId];
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 1;
                [self .view addSubview:maskView];
                receiveBenefits.alpha = 0.95;
                [self.view addSubview:receiveBenefits];
            }];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误2";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

//弹框遮罩
-(void)maskViewView
{
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
    [self.view addSubview:maskView];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        receiveBenefits.alpha = 0;
        [receiveBenefits removeFromSuperview];
    }];
}
//领取福利
-(void)initFulilingqu
{
    receiveBenefits = [[ReceiveBenefitsView alloc]initWithFrame:CGRectMake(30*MCscale, 150*MCscale, kDeviceWidth- 60*MCscale,300*MCscale)];
    receiveBenefits.alpha = 0;
    receiveBenefits.receiveBenefitsdelegate = self;
}
#pragma mark ReceiveBenefitsdelegate
-(void)reloadDataWithIndex:(NSInteger)index
{
    if (index == 0) {
        [self promptMessageWithString:@"无可领取福利商品"];
    }
    else if(index == 1)
    {
        [self promptMessageWithString:@"领取成功"];
//        [self reloadData];
//        self
//        FuliModel * fulimodel =  fuliAry[index];
        
        
        
    }
    else
    {
        [self promptMessageWithString:@"放弃领取成功"];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        receiveBenefits.alpha = 0;
        [receiveBenefits removeFromSuperview];
    }];
    [self reloadData];
    //    [detailTableView reloadData];
}

-(void)redPackets
{
    redPack = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth*4/7.0, kDeviceHeight/2.0, 76*MCscale, 80*MCscale)];
    redPack.backgroundColor = [UIColor clearColor];
    redPack.image = [UIImage imageNamed:@"红包"];
    redPack.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRedPack)];
    [redPack addGestureRecognizer:tap];
    [self.view addSubview:redPack];
}
-(void)initPopView
{
    shareRedPack = [[ShareRedPackView alloc]initWithFrame:CGRectMake(kDeviceWidth/10.0, 150*MCscale, kDeviceWidth*4/5.0, 250*MCscale)];
    shareRedPack.shareRedPackDelegate = self;
}

#pragma mark ShareRedPackViewDelegate
-(void)reloadDataFromShareRedPackWithTag:(NSInteger)tag
{
    [UIView animateWithDuration:0.3 animations:^{
        shareRedPack.alpha = 0;
        [shareRedPack removeFromSuperview];
    }];
}

-(void)reloadDataFromShareRedPackWithIndex:(NSInteger)index
{
    if (index < 0) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"分享失败";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"分享成功";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}

#pragma mark 按钮Action
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 1007) {
        orderMoreArginController *orderVc = [[orderMoreArginController alloc]init];
        orderVc.danhao = _dingdanId;
        orderVc.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:orderVc animated:YES];
    }
    else if(btn.tag == 1002)
    {
        [[NSUserDefaults standardUserDefaults]setValue:model.dianpuid forKey:@"dianpuqiehuan"];
        [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"isFirst"];
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
    
        
        [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"isFirst"];
        CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
        [main setSelectedIndex:1];
        main.buttonIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
        if (!_isFromList) {
            main.buttonIndex = 0;
            
        }
    }
}
-(void)tapRedPack
{
    NSString *dianpId = [NSString stringWithFormat:@"%@",model.dianpuid];
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"dianpuid":dianpId,@"shequid":@"0",@"hongbaotype":@"1"}];
    
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"fahongbao.action" params:pram success:^(id json) {
        //            if(([json integerForKey:@"message"]==1)){
        NSArray *ary = [json valueForKey:@"fahongbao"];
        NSDictionary *dic = ary[0];
        NSString *urlls= [NSString stringWithFormat:@"%@",[dic valueForKey:@"hongbaourl"]];
        NSString *imagePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"imgurl"]];
        NSString *hongMessage = [dic valueForKey:@"shuoming"];
        
        NSString *totlhongbao = [dic valueForKey:@"totalcount"];
        UILabel *lb = [shareRedPack viewWithTag:10110];
        lb.text = [NSString stringWithFormat:@"恭喜获得%@个红包",totlhongbao];
        [UIView animateWithDuration:0.3 animations:^{
            redPack.alpha = 0;
            [redPack removeFromSuperview];
            shareRedPack.alpha = 0.95;
            [shareRedPack loadDataWithDanhao:_dingdanId AndTitle:hongMessage AndImage:imagePath AndUrl:urlls AndDianpuId:dianpId];
            [self.view addSubview:shareRedPack];
        }];
        //    }
        //     else{
        //         MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //         bud.mode = MBProgressHUDModeCustomView;
        //         bud.labelText = @"红包分享失败";
        //         [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        //     }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误3";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return model.shoplist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    detailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[detailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
        
    }
    [cell reloadDataWithIndexpath:indexPath AndArray:model.shoplist];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}
#pragma mark DetailTableHeadViewDelegate
-(void)gotoDianpuFirst
{
    if (![model.dianpustate isEqualToString:@"0"]) {
        [[NSUserDefaults standardUserDefaults]setValue:model.dianpuid forKey:@"dianpuqiehuan"];
        [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"isFirst"];
        CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
        [main setSelectedIndex:0];
        main.buttonIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*MCscale;
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    sleep(1.5);
}
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
