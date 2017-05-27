//
//  OrderViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "OrderViewController.h"
#import "Header.h"
#import "orderViewCell.h"
#import "oldOrderViewCell.h"
#import "orderDetailViewController.h"
#import "orderEvaluateViewController.h"
#import "OnlineServiceViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import "PaymentPasswordView.h"
#import "OnLinePayView.h"
#import "OrderExceptionPrompt.h"
#import "oldOrderModel.h"
#import "recentOrderModel.h"
@interface OrderViewController()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,PaymentPasswordViewDelegate,OrderExceptionPromptDelegate>
{
    UIView *orderView,*btnView,*lineView;//商品、店铺
    UITableView *orderTableView;//商品表、店铺表
    BOOL btBool;//选择按钮表示
    NSMutableArray *recentDataAry;//近期订单
    NSMutableArray *oldDataAry;//历史订单
    BOOL isRefresh,isBotom;
    NSInteger loadType;
    int pageNum;
    int lastPage;
    PaymentPasswordView *passPopView;//密码输入
    NSMutableArray *passArray;//密码
    NSArray *numBtnTitleAry;//按钮数字
    NSMutableArray *labelAry;//密码输入框
    NSMutableArray *btnArray;//数字键
    UIView *mask;//弹框遮罩层
    NSInteger selectCellRow;
    OnLinePayView *onlinePayWayPop;// 在线支付选择支付方式
    BOOL isOnlinePay; //在线支付
    NSMutableDictionary *wxPaymessage;
    UIImageView *caozuotishiImage;
    OrderExceptionPrompt *orderPromptView;
    UIView *updateBackgroundView;
}
@end

@implementation OrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"orderCreatSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExitRefresh) name:@"orderPingjiaNotfic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExitRefresh) name:@"userExitFication" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExitRefresh) name:@"userLoginNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentSuccessClick:) name:@"PaymentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onLinePayViewHidden) name:@"onLinePayViewHidden" object:nil];
    //    [self onlyLognUser];
    [self userExitRefresh];
    [self orderStatus];
    
    
    
    UIButton *bt1 = (UIButton *)[btnView viewWithTag:1001];
    lineView.frame = CGRectMake(35*MCscale, 36, kDeviceWidth/3.0, 2);
    bt1.selected=YES;
    
    btBool = 0;
    UIButton *bt2 = (UIButton *)[btnView viewWithTag:1002];
    bt2.selected=NO;
    
    [self.navigationController.navigationBar setBarTintColor:naviBarTintColor];

}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    btBool = 0;
    isRefresh = isBotom =0;
    selectCellRow = 0;
    pageNum = 1;
    recentDataAry = [[NSMutableArray alloc]init];
    oldDataAry = [[NSMutableArray alloc]init];
    passArray = [[NSMutableArray alloc]init];
    numBtnTitleAry = [[NSArray alloc]init];
    labelAry = [[NSMutableArray alloc]init];
    btnArray = [[NSMutableArray alloc]init];
    wxPaymessage = [[NSMutableDictionary alloc]init];
    [self loadNavigation];
    [self initGoodView];
    [self reloadGesture];
    
    [self maskView];
    [self initPaymentPasswordView];
    //    [self judgeTheFirst];
    [self refresh];
}

-(void)judgeTheFirst
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstOrder"] integerValue] == 1) {
        NSString *url = @"images/caozuotishi/kefu.png";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
        caozuotishiImage.userInteractionEnabled = YES;
        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
        [caozuotishiImage addGestureRecognizer:imageTap];
        [self.view addSubview:caozuotishiImage];
    }
    
}
-(void)imageHidden
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstOrder"];
    [caozuotishiImage removeFromSuperview];
}
//判断订单状态
-(void)orderStatus
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"dingdanyichangchuli.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"massages"]integerValue] == 1){
            NSArray *arr = [json valueForKey:@"list"];
            updateBackgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
            updateBackgroundView.backgroundColor = [UIColor clearColor];
            orderPromptView = [[OrderExceptionPrompt alloc]initWithFrame:CGRectMake(40*MCscale, 170*MCscale, kDeviceWidth-80*MCscale, 270*MCscale)];
            orderPromptView.alpha = 0.95;
            orderPromptView.orderDelegate = self;
            [self.view addSubview:updateBackgroundView];
            [self.view addSubview:orderPromptView];
            NSString *string = [arr componentsJoinedByString:@","];//--分隔符
            NSString *money = [NSString stringWithFormat:@"￥%@",[json valueForKey:@"money"]];
            NSString *nameStr;
            if ([isLogin integerValue] == 1) {
                nameStr = @"账户余额";
            }
            else
            {
                nameStr = @"支付账号";
            }
            NSString *content = [NSString stringWithFormat:@"该订单(%@)由于网络异常未能形成,订单金额(%@)将在三个工作日内返回您的%@,请注意查收.由此给您带来的不便,敬请谅解!",string,money,nameStr];
            [orderPromptView getOrderPromptContentWithString:content];
        }
    } failure:^(NSError *error){
    }];
}

#pragma mark OrderExceptionPromptDelegate
-(void)titleViewHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        //        mask.alpha = 0;
        //        [mask removeFromSuperview];
        orderPromptView.alpha = 0;
        [orderPromptView removeFromSuperview];
        [updateBackgroundView removeFromSuperview];
    }];
}
//导航栏
-(void)loadNavigation
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    self.navigationItem.title = @"订单";
}
-(void)userExitRefresh
{
    loadType = 0;
    isRefresh = 1;
    lastPage = 1;
    pageNum = 1;
    [self reloadData];
}
//近期订单
-(void)reloadData
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"pageNum":[NSString stringWithFormat:@"%d",pageNum]}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findjinqidingdans.action" params:pram success:^(id json) {
        NSLog(@"订单数据%@",json);
        
        
        [Hud hide:YES];
        if (isRefresh) {
            [self endRefresh:loadType];
        }
        if (lastPage == pageNum) {
            [recentDataAry removeAllObjects];
        }
        lastPage = pageNum;
        
        
        
        NSArray *ary = [json valueForKey:@"diangdanlist"];
        if (ary.count >0) {
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            for(NSDictionary *dic in ary){
                recentOrderModel *mod = [[recentOrderModel alloc]init];
                [mod setValuesForKeysWithDictionary:dic];
                [recentDataAry addObject:mod];
            }
            isBotom = 0;
        }
        else
        {
            if (lastPage == 1) {
                orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"订单页无数据"]];
            }
            else
            {
                isBotom = 1;
                [self loadFootView];
            }
        }
        [orderTableView reloadData];
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self endRefresh:loadType];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
//历史订单
-(void)reloadLoadData
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findlishidingdan.action" params:pram success:^(id json) {
        [Hud hide:YES];
        if(isRefresh){
            [self endRefresh:loadType];
        }
        
        
        [oldDataAry removeAllObjects];
        NSArray *ary = [json valueForKey:@"lishidingdan"];
        if (ary.count >0) {
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            for(NSDictionary *dic in ary){
                oldOrderModel *mod = [[oldOrderModel alloc]init];
                [mod setValuesForKeysWithDictionary:dic];
                [oldDataAry addObject:mod];
            }
        }
        else
        {
            orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"订单页无数据"]];
        }
        [orderTableView reloadData];
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self endRefresh:loadType];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark -- 初始化视图
// 近期订单、历史订单
-(void)initGoodView
{
    orderView = [BaseCostomer viewWithFrame:CGRectMake(0, 0,kDeviceWidth , kDeviceHeight) backgroundColor:[UIColor clearColor]];
    orderTableView = [[UITableView alloc]initWithFrame:orderView.bounds style:UITableViewStyleGrouped];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.backgroundColor = [UIColor whiteColor];
    orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"订单页无数据"]];
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [orderView addSubview:orderTableView];
    [self.view addSubview:orderView];
    
    btnView = [BaseCostomer viewWithFrame:CGRectMake(0, 64, kDeviceWidth, 38) backgroundColor:[UIColor whiteColor]];
    lineView = [BaseCostomer viewWithFrame:CGRectMake(35*MCscale, 36, kDeviceWidth/3.0, 2) backgroundColor:mainColor];
    [btnView addSubview:lineView];
    
    
    // 近期订单按钮
    UIButton *goodBtn = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, kDeviceWidth/2.0, 36) font:[UIFont systemFontOfSize:MLwordFont_3] textColor:textBlackColor backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"近期订单" image:@""];
    [goodBtn setTitleColor:mainColor forState:UIControlStateSelected];
    goodBtn.tag = 1001;
    [goodBtn addTarget:self action:@selector(goodOrStoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:goodBtn];
    
    
    // 历史订单按钮
    UIButton *storeBtn = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth/2.0, 0, kDeviceWidth/2.0, 36) font:[UIFont systemFontOfSize:MLwordFont_3] textColor:textBlackColor backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"历史订单" image:@""];
    [storeBtn setTitleColor:mainColor forState:UIControlStateSelected];
    
    storeBtn.tag = 1002;
    [storeBtn addTarget:self action:@selector(goodOrStoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:storeBtn];
    UIView *line1 = [BaseCostomer viewWithFrame:CGRectMake(0, 37, kDeviceWidth, 1) backgroundColor:lineColor];
    [btnView addSubview:line1];
    [self.view addSubview:btnView];
}
//支付密码
-(void)initPaymentPasswordView
{
    //支付密码
    passPopView = [[PaymentPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 360*MCscale)];
    passPopView.paymentPasswordDelegate = self;
    passPopView.alpha = 0;
}

#pragma  mark  PaymentPasswordViewDelegate
-(void)PaymentSuccess
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        passPopView.alpha = 0;
        [passPopView removeFromSuperview];
    }];
    [self balancePay];
}
//余额支付
-(void)balancePay
{
    isOnlinePay = 0;
    recentOrderModel *model = recentDataAry[selectCellRow];
    NSString *payMoney = [NSString stringWithFormat:@"%@",model.chajia];
    NSString *danhao = [NSString stringWithFormat:@"%@",model.danhao];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":danhao,@"dindan.jine":payMoney}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"savezhangdanchajia.action" params:pram success:^(id json) {
        NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
        if ([message isEqualToString:@"1"]) {
            [self promptSuccessWithString:@"支付成功"];
        }
        else{
            [self promptMessageWithString:@"支付失败!请稍后尝试"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
//弹框遮罩
-(void)maskView
{
    mask = [BaseCostomer viewWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) backgroundColor:[UIColor clearColor]];
    mask.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
    [mask addGestureRecognizer:tap];
}

//点击遮罩层
-(void)maskDisMiss
{
    if(!isOnlinePay){
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            passPopView.alpha = 0;
            [passPopView removeFromSuperview];
            [self.view endEditing:YES];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            onlinePayWayPop.alpha = 0;
            [onlinePayWayPop removeFromSuperview];
            [self.view endEditing:YES];
        }];
    }
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (btBool == 0) {
        if (recentDataAry) {
            return recentDataAry.count;
        }
        return 0;
        
    }
    return oldDataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btBool == 0) {
        NSString *identifier1 = [NSString stringWithFormat:@"index%ld%ld",(long)indexPath.section,(long)indexPath.row];
        orderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[orderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        if (recentDataAry.count>0) {

            cell.model = recentDataAry[indexPath.row];
          

        }
        
        NSLog(@"%@",cell.model.danhao);
        
        cell.gotoeEvaluate.tag = indexPath.row + 100;
        cell.cancelOrderBtn.tag = indexPath.row + 1000;
        cell.payBtn.tag = indexPath.row + 2000;
        [cell.gotoeEvaluate addTarget:self action:@selector(gotoeEvaluateAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [cell.payBtn addTarget:self action:@selector(payAgn:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *identifier = @"cell";
        oldOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[oldOrderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.orderState.text = @"已收货";
        cell.model = oldDataAry[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btBool == 0) {
        recentOrderModel *model = recentDataAry[indexPath.row];
        orderDetailViewController *detailVc = [[orderDetailViewController alloc]init];
        detailVc.dingdanId = model.danhao;
        detailVc.isOrderAgn = 1;
        detailVc.isFromList=YES;
        detailVc.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    else{
        oldOrderModel *model = oldDataAry[indexPath.row];
        orderDetailViewController *detailVc = [[orderDetailViewController alloc]init];
        detailVc.dingdanId = model.danhao;
        detailVc.isOrderAgn = 1;
        detailVc.isFromList=YES;
        detailVc.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btBool == 1) {
        return 88*MCscale;
    }
    else{
        
        recentOrderModel *model = recentDataAry[indexPath.row];
        NSString *guaj = [NSString stringWithFormat:@"%@",model.guanjia];
        if ([guaj isEqualToString:@"0"]) {
            return 144*MCscale;
        }
        if ([model.dingdanleixing isEqualToString:@"0"]) {
            return 144*MCscale;
        }
        return 174*MCscale;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
#pragma mark -- 事件处理
//按钮事件
-(void)goodOrStoreBtnAction:(UIButton *)btn
{
    loadType = 0;
    isRefresh = 1;
    lastPage = 1;
    pageNum = 1;
    
    
 
    for (int i = 1001; i <= 1002; i ++) {
    UIButton *bt = (UIButton *)[btnView viewWithTag:i];
        bt.selected=NO;
    }
    btn.selected=YES;
    
    
    if (btn.tag == 1001) {
        lineView.frame = CGRectMake(35*MCscale, 36, kDeviceWidth/3.0, 2);
        btBool = 0;
        [self reloadData];
        
        [orderTableView removeFooter];
        [orderTableView addFooterWithTarget:self action:@selector(footRefreshing)];
        orderTableView.footerPullToRefreshText = @"上拉加载数据";
        orderTableView.footerReleaseToRefreshText = @"松开加载数据";
        orderTableView.footerRefreshingText = @"拼命加载中";
    }
    else{

        lineView.frame = CGRectMake((kDeviceWidth/2.0 - kDeviceWidth/3.0 - 35*MCscale) + kDeviceWidth/2.0, 36, kDeviceWidth/3.0, 2);
        [self reloadLoadData];
        btBool = 1;
        [orderTableView removeFooter];
    }
    [orderTableView reloadData];
}
#pragma mark -- 滑动选择近期或历史订单
-(void)reloadGesture
{
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwip];
    
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightSwip];
}
-(void)swipAction:(UISwipeGestureRecognizer *)swip
{
    if(!isOnlinePay){
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            passPopView.alpha = 0;
            [passPopView removeFromSuperview];
            [self.view endEditing:YES];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            onlinePayWayPop.alpha = 0;
            [onlinePayWayPop removeFromSuperview];
            [self.view endEditing:YES];
        }];
    }
    
    
    for (int i = 1001; i <= 1002; i ++) {
       UIButton *bt = (UIButton *)[btnView viewWithTag:1001];
        bt.selected=NO;
    }
    if (swip.direction == 1) {
   
        UIButton *btn = (UIButton *)[btnView viewWithTag:1001];
        btn.selected=YES;
        
        
        lineView.frame = CGRectMake(35, 36, kDeviceWidth/3.0, 2);
        btBool = 0;
        [self reloadData];
        [orderTableView removeFooter];
        [orderTableView addFooterWithTarget:self action:@selector(footRefreshing)];
        orderTableView.footerPullToRefreshText = @"上拉加载数据";
        orderTableView.footerReleaseToRefreshText = @"松开加载数据";
        orderTableView.footerRefreshingText = @"拼命加载中";
    }
    else{
 
        UIButton *btn = (UIButton *)[btnView viewWithTag:1002];
        btn.selected=YES;
        
        
        lineView.frame = CGRectMake((kDeviceWidth/2.0 - kDeviceWidth/3.0 - 35) + kDeviceWidth/2.0, 36, kDeviceWidth/3.0, 2);
        [self reloadLoadData];
        btBool = 1;
        [orderTableView removeFooter];
    }
    [orderTableView reloadData];
}
//导航右侧item
-(void)rightBtnAction
{
    OnlineServiceViewController *ServiceVC = [[OnlineServiceViewController alloc]init];
    ServiceVC.isOrder = YES;
    ServiceVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:ServiceVC animated:YES];
}

//订单评价
-(void)gotoeEvaluateAction:(UIButton *)btn
{
    NSInteger sender = btn.tag -100;
    orderEvaluateViewController *evaluateVC = [[orderEvaluateViewController alloc]init];
    recentOrderModel *model = recentDataAry[sender];
    evaluateVC.danhao = model.danhao;
    evaluateVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:evaluateVC animated:YES];
}
//取消订单
-(void)cancelOrder:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定取消当前订单吗?" preferredStyle:1];
    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancelOrderWithIndex:btn.tag-1000];
    }];
    
    [alert addAction:suerAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)cancelOrderWithIndex:(NSInteger)index
{
    recentOrderModel *model = recentDataAry[index];
    NSString *danhao = [NSString stringWithFormat:@"%@",model.danhao];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":danhao}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbydingdanquxiao.action" params:pram success:^(id json) {
        NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
        if ([massage isEqualToString:@"1"]) {
            NSLog(@"-- 可以取消订单");
            [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"updageyonhuquxiao.action" params:pram success:^(id json) {
                [self userExitRefresh];
                NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
                if ([massage isEqualToString:@"1"]) {
                    [self promptSuccessWithString:@"订单取消成功"];
                }
                else{
                    [self promptMessageWithString:@"订单取消失败"];
                }
            } failure:^(NSError *error) {
                [self promptMessageWithString:@"网络连接错误"];
            }];
        }
        else{
            [self promptMessageWithString:@"该订单不能取消"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
//再次支付
-(void)payAgn:(UIButton *)btn
{
    recentOrderModel *model = recentDataAry[btn.tag - 2000];
    NSString *danhao = [NSString stringWithFormat:@"%@",model.danhao];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"dindan.danhao":danhao}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbydingdanzhifu.action" params:pram success:^(id json) {
        NSLog(@"支付 %@",json);
        
        if ([[json valueForKey:@"massages"] integerValue] == 1) {
            isOnlinePay = 1;
            NSString *payStyle = [NSString stringWithFormat:@"%@",model.zhifuleixing];
            if ([payStyle isEqualToString:@"2"]) {//在支付
                selectCellRow = btn.tag-2000;
                [UIView animateWithDuration:0.3 animations:^{
                    mask.alpha = 1;
                    onlinePayWayPop = [[OnLinePayView alloc]initWithFrame:CGRectMake(kDeviceWidth*3/20.0, 330*MCscale, kDeviceWidth*7/10.0, 135*MCscale)];
                    [self.view addSubview:mask];
                    [self getPaymentInformation];
                    onlinePayWayPop.isFrom = 1;
                    onlinePayWayPop.alpha = 0.95;
                    [self.view addSubview:onlinePayWayPop];
                }];
            }
            else if ([payStyle isEqualToString:@"3"]){//余额支付
                selectCellRow = btn.tag-2000;
                [UIView animateWithDuration:0.3 animations:^{
                    mask.alpha = 1;
                    [self.view addSubview:mask];
                    passPopView.alpha = 0.95;
                    [self.view addSubview:passPopView];
                }];
            }
        }
        else
        {
            [self promptMessageWithString:@"订单不能支付"];
            [recentDataAry removeAllObjects];
            [oldDataAry removeAllObjects];
            [self reloadData];
        }
    } failure:^(NSError *error) {
    }];
}
//得到支付信息
-(void)getPaymentInformation
{
    recentOrderModel *model = recentDataAry[selectCellRow];
    NSString *danhao = [NSString stringWithFormat:@"%@",model.danhao];
    NSString *payMoney;
    NSString *yingfu = [NSString stringWithFormat:@"%@",model.yingfujine];
    NSString *chajia = [NSString stringWithFormat:@"%@",model.chajia];
    if (![chajia isEqualToString:@"0"]) {
        payMoney = chajia;
    }
    else
        payMoney = yingfu;
    NSString *suffix;//后缀
    if ([[NSString stringWithFormat:@"%@",model.zhifuleixing] isEqualToString:@"2"] && [chajia isEqualToString:@"0"])
    {
        suffix = @"消费";
    }
    else
    {
        suffix = @"补差";
    }
    NSString *body = [NSString stringWithFormat:@"妙店佳+%@%@",danhao,suffix];
    [onlinePayWayPop reloadDataFromDanhao:danhao AndMoney:payMoney AndBody:body AndLeiming:nil];
}
//接受来自onLinePayDelegate的通知实现方法
-(void)PaymentSuccessClick:(NSNotification *)noti
{
    [self promptSuccessWithString:@"支付成功"];
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        onlinePayWayPop.alpha = 0;
        [onlinePayWayPop removeFromSuperview];
    }];
    [recentDataAry removeAllObjects];
    [oldDataAry removeAllObjects];
    [self reloadData];
}
-(void)PaymentFailure
{
    [self promptMessageWithString:@"支付失败"];
}
//接收隐藏弹框的通知
-(void)onLinePayViewHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0;
        [mask removeFromSuperview];
        onlinePayWayPop.alpha = 0;
        [onlinePayWayPop removeFromSuperview];
    }];
}
-(void)refresh
{
    //下拉刷新
    [orderTableView addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [orderTableView addFooterWithTarget:self action:@selector(footRefreshing)];
    orderTableView.headerPullToRefreshText = @"下拉刷新数据";
    orderTableView.headerReleaseToRefreshText = @"松开刷新";
    orderTableView.headerRefreshingText = @"拼命加载中";
    orderTableView.footerPullToRefreshText = @"上拉加载数据";
    orderTableView.footerReleaseToRefreshText = @"松开加载数据";
    orderTableView.footerRefreshingText = @"拼命加载中";
}
-(void)headReFreshing
{
    loadType = 0;
    isRefresh = 1;
    lastPage = 1;
    pageNum = 1;
    if (!btBool) {
        [self reloadData];
    }
    else{
        [self reloadLoadData];
    }
}
-(void)footRefreshing
{
    isRefresh = 1;
    loadType = 1;
    pageNum ++;
    [self reloadData];
}
-(void)endRefresh:(BOOL)success
{
    if (success) {
        [orderTableView footerEndRefreshing];
    }
    else{
        [orderTableView headerEndRefreshing];
    }
}
-(void)loadFootView
{
    if (isBotom == 1) {
        [self promptSuccessWithString:@"已经到底了"];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    loadType = 0;
    isRefresh = 1;
    lastPage = 1;
    pageNum = 1;
  
}

-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)promptSuccessWithString:(NSString *)string
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeCustomView;
    mbHud.labelText = string;
    mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
- (void)myTasks {
    // Do something usefull in here instead of sleeping ...
    sleep(30);
}
@end
