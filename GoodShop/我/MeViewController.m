//
//  MeViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "MeViewController.h"
#import "Header.h"
#import "helpCenterViewController.h"
#import "myCollectViewController.h"
#import "couponViewController.h"
#import "SecuritySetViewController.h"
#import "balanceViewController.h"
#import "SetPaymentPasswordView.h"
#import "redMoneyModel.h"
#import "userMessModel.h"
#import "OnLinePayView.h"
#import "DataSigner.h"
#import "MoreViewController.h"
#import "PackagesRecordViewController.h"
#import "OpenAccountViewController.h"
#import "PersonalCenterCell.h"
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,UITextFieldDelegate,SetPaymentPasswordViewDelegate,OnLinePayViewDelegate>
{
    UITableView *personTabelView; //表
    NSInteger stateNum,rzcode; //状态标记值、认证标记值
    UIImageView *favicon,*rzImage;//用户头像 、认证图标
    NSString *account;//电话号码（账户）
    CGFloat balance,coupon;//余额 、优惠
    UIImagePickerController *imagePick;
    UIView *pView;
    NSMutableArray *tolMoneyData;//推荐奖励
    NSInteger totcount; //红包个数
    NSInteger totMoney,maxtiqumoney; //选中红包总金额
    NSString *stats;
    UIView *headView;
    NSMutableArray *hongbIdAry;
    OnLinePayView *rechargePopView;//充值弹框
    NSInteger popTag;
    NSString *payMonyeNumStr;//充值金额
    SetPaymentPasswordView *nextPayPas;//支付密码
    UIView *maskView;//遮罩层
    NSString *isPasdStr;
    NSMutableDictionary *wxPaymessage;
    CGFloat maxReceive;//最高领取
    
    UILabel *accountLabel;
    
    NSDictionary *personalDict;
}
@end
@implementation MeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"orderYouhActess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAgin) name:@"userLoginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"tixianAccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumber) name:@"changeNumberNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"chongzhiSueecss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"newGoodNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData) name:@"orderCreatSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentSuccessClick:) name:@"PaymentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
    [personTabelView removeFromSuperview];
    [self initTableView];
    [self reloadUserData];
    [self reloadXiaofeiData];
    self.navigationController.navigationBar.hidden=YES;
    
    [self.navigationController.navigationBar setBarTintColor:naviBarTintColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController.navigationBar setBarTintColor:naviBarTintColor];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.hidden=NO;
    
    [self.navigationController.navigationBar setBarTintColor:naviBarTintColor];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    tolMoneyData = [[NSMutableArray alloc]init];
    hongbIdAry = [[NSMutableArray alloc]init];
    wxPaymessage = [[NSMutableDictionary alloc]init];
    stateNum = 1;
    rzcode = 1;
    balance = 0.00;
    totcount = 0;
    totMoney = 0;
    popTag = -1;
    maxReceive = 10.0;
    isPasdStr = @"1";
    payMonyeNumStr =@"50.0";
    personalDict = @{};
    [self loadNavigation];
    [self initTableView];
    [self popViewshare];
    [self reloadPopViewData];
    [self relodpayPaswd];
    [self initMaskView];
    [self initPayPopView];
    [self payPasword];
}
//导航栏
-(void)loadNavigation
{
//    self.navigationItem.title = @"个人中心";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIView * navi=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    navi.backgroundColor=mainColor;
    [self.view addSubview:navi];
    
}
-(void)loginAgin
{
    totMoney = 0;
    [self reloadUserData];
    [self reloadPopViewData];
}
//改变绑定手机号码
-(void)changeNumber
{
    accountLabel.text = [user_tel stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
}
//用户信息
-(void)reloadUserData
{
    if (user_tel) {
        MBProgressHUD *ddHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        ddHud.mode = MBProgressHUDModeIndeterminate;
        ddHud.delegate = self;
        ddHud.labelText = @"请稍等...";
        [ddHud show:YES];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"tel":user_tel}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"gerenzhongxin.action" params:pram success:^(id json) {
            NSLog(@"个人中心%@",json);
            
            [ddHud hide:YES];
            NSArray *ary = [json valueForKey:@"userinfo"];
            if (ary.count > 0) {
                personalDict = ary[0];
                [personTabelView reloadData];
            }
            
            [self relodheadView];
        } failure:^(NSError *error) {
            [ddHud hide:YES];
            [self promptMessageWithString:@"网络连接错误1"];
        }];
    }
}

#pragma mark
//用户信息
-(void)reloadXiaofeiData
{
    if ([isLogin integerValue ] == 1) {
        MBProgressHUD *ddHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        ddHud.mode = MBProgressHUDModeIndeterminate;
        ddHud.delegate = self;
        ddHud.labelText = @"请稍等...";
        [ddHud show:YES];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"usertel":user_id}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyuseridalllibao.action" params:pram success:^(id json) {
            NSLog(@"消费礼包%@",json);
            [ddHud hide:YES];
            if ([[json valueForKey:@"massages"]integerValue] == 1) {
                UILabel *coupLabe2 = (UILabel *)[headView viewWithTag:2001];
                coupLabe2.text = [NSString stringWithFormat:@"%@",[json valueForKey:@"moneys"]];
            }
        } failure:^(NSError *error) {
            [ddHud hide:YES];
            [self promptMessageWithString:@"网络连接错误2"];
        }];
    }
}

///推荐红包金额
-(void)reloadPopViewData
{
    if ([isLogin integerValue] == 1) {
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"tel":user_tel}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"jiangli.action" params:pram success:^(id json) {
            NSArray *ary = [json valueForKey:@"jiangli"];
            NSString *stri = [json valueForKey:@"totalmoney"];
            stats = [NSString stringWithFormat:@"%@",[json valueForKey:@"status"]];
            maxReceive = [[json valueForKey:@"maxjine"] floatValue];
            [tolMoneyData removeAllObjects];
            maxtiqumoney = [stri integerValue];
            UITableViewCell *cell;
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"kaihu"]integerValue] == 1)
            {
                NSIndexPath *indpath = [NSIndexPath indexPathForRow:3 inSection:0];
                cell = [personTabelView cellForRowAtIndexPath:indpath];
            }
            else
            {
                NSIndexPath *indpath = [NSIndexPath indexPathForRow:2 inSection:0];
                cell = [personTabelView cellForRowAtIndexPath:indpath];
            }
            
            UILabel *lab = (UILabel *)[cell viewWithTag:203];
            UIImageView *img = (UIImageView *)[cell viewWithTag:204];
            lab.text = @"";
            if (ary.count>0) {
                [tolMoneyData removeAllObjects];
                for(NSDictionary *dic in ary){
                    redMoneyModel *mod = [[redMoneyModel alloc]init];
                    [mod setValuesForKeysWithDictionary:dic];
                    [tolMoneyData addObject:mod];
                }
                [self popViewshare];
                lab.text = [NSString stringWithFormat:@"好友%ld奖励%ld元",(long)tolMoneyData.count,(long)maxtiqumoney];
                img.alpha = 0;
                cell.userInteractionEnabled = YES;
            }
            else{
                lab.text = @"暂无好友奖励";
                img.alpha =1;
                cell.userInteractionEnabled = NO;
            }
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误3"];
        }];
    }
}
-(void)relodpayPaswd
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"zhiFuPwd.action" params:pram success:^(id json) {
        isPasdStr = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
    } failure:^(NSError *error) {
    }];
}
//表视图
-(void)initTableView
{
    personTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-49) style:UITableViewStyleGrouped];
    personTabelView.delegate = self;
    personTabelView.dataSource = self;
    personTabelView.backgroundColor = [UIColor whiteColor];
    personTabelView.scrollEnabled = NO;
    personTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initHeadView];
    [self.view addSubview:personTabelView];
}
//充值弹框
-(void)initPayPopView
{
    rechargePopView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale)];
    rechargePopView.isFrom = 2;
    rechargePopView.onLinePayDelegate = self;
}
#pragma mark -- OnLinePayViewDelegate
-(void)PaymentPasswordViewWithDanhao:(NSString *)danhao AndLeimu:(NSString *)leimu AndMoney:(NSString *)money
{
    [self promptMessageWithString:@"暂无更多充值方式"];
}

//接受来自onLinePayDelegate的通知实现方法
-(void)PaymentSuccessClick:(NSNotification *)noti
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        rechargePopView.alpha = 0;
        [maskView removeFromSuperview];
        [rechargePopView removeFromSuperview];
    }];
    [self promptSuccessWithString:@"充值成功"];
}
-(void)PaymentFailure
{
    [self promptMessageWithString:@"充值失败"];
}
//遮罩
-(void)initMaskView
{
    maskView = [BaseCostomer viewWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) backgroundColor:[UIColor clearColor]];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
}

-(void)initHeadView
{
    //表头
    headView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth, 185*MCscale) backgroundColor:[UIColor whiteColor]];
    UIImageView *backImage = [BaseCostomer imageViewWithFrame:CGRectMake(0, 0, kDeviceWidth, 116*MCscale) backGroundColor:naviBarTintColor image:@""];
    [headView addSubview:backImage];
    //用户头像
    favicon = [BaseCostomer imageViewWithFrame:CGRectMake(0, 5, 73*MCscale, 73*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:36.5*MCscale userInteractionEnabled:YES image:@"yonghutouxiang"];
    favicon.center = CGPointMake(kDeviceWidth/2.0, 42*MCscale);
    
    UITapGestureRecognizer *chooseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseUserHeadimage)];
    [favicon addGestureRecognizer :chooseTap];
    [headView addSubview:favicon];
    //认证图标
    NSArray *rzArray = @[@"认证",@"未认证"];
    rzImage = [BaseCostomer imageViewWithFrame:CGRectMake(favicon.right-20*MCscale, favicon.bottom-22*MCscale, 25*MCscale, 25*MCscale) backGroundColor:[UIColor clearColor] image:rzArray[rzcode]];
    [headView addSubview:rzImage];
    //账户
    accountLabel = [BaseCostomer labelWithFrame:CGRectMake(0, 0, favicon.width+20*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_8] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    [headView addSubview:accountLabel];
    accountLabel.center = CGPointMake(kDeviceWidth/2.0, favicon.bottom+15*MCscale);
    
    NSArray *titleArray = @[@"余额",@"消费礼包",@"优惠"];
    //分割线
    for (int i = 0;i<3;i++ ) {
        UIView *backView = [BaseCostomer viewWithFrame:CGRectMake(kDeviceWidth/3.0*i, backImage.bottom+5*MCscale, kDeviceWidth /3.0, 60*MCscale) backgroundColor:[UIColor clearColor]]
        ;
        backView.tag = 1000+i;
        [headView addSubview:backView];
        UITapGestureRecognizer *lanceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lanceTapClick:)];
        [backView addGestureRecognizer:lanceTap];
        
        UILabel *coupLabe1 = [BaseCostomer labelWithFrame:CGRectMake(0, 12*MCscale, backView.width, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        coupLabe1.tag = 2000+i;
        [backView addSubview:coupLabe1];
        
        if (i == 0) {
            coupLabe1.textColor = mainColor;
            coupLabe1.text = [NSString stringWithFormat:@"%.2f",balance];
        }
        else if (i == 1)
        {
            coupLabe1.textColor = txtColors(236, 132,34, 1);
            coupLabe1.text = @"0";
        }
        else
        {
            coupLabe1.textColor = mainColor;
            coupLabe1.text = @"3";
        }
        
        UILabel *coup = [BaseCostomer labelWithFrame:CGRectMake(0, coupLabe1.bottom, coupLabe1.width, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:txtColors(72, 73, 74, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:titleArray[i]];
        coup.tag = 3000+i;
        [backView addSubview:coup];
        
        if (i<2) {
            UIView *lineViewV = [BaseCostomer viewWithFrame:CGRectMake(backView.width-0.5,0,0.5, 60*MCscale) backgroundColor:lineColor];
            [backView addSubview:lineViewV];
        }
    }
    
    UIView *line = [BaseCostomer viewWithFrame:CGRectMake(0, headView.height - 1*MCscale, kDeviceWidth, 1) backgroundColor:lineColor];
    [headView addSubview:line];
    personTabelView.tableHeaderView = headView;
}

-(void)lanceTapClick:(UITapGestureRecognizer *)tap
{
    if ([isLogin integerValue] == 1) {
        if (tap.view.tag == 1000) {
            CGFloat uye = [personalDict[@"yue"] floatValue];
            if (uye<=0) {
                [UIView animateWithDuration:0.3 animations:^{
                    rechargePopView.alpha = 0.95;
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    rechargePopView.moneyTextFiled.text = @"50";
                    rechargePopView.yueZhifu.text = @"更多充值方式";
                    [self.view addSubview:rechargePopView];
                }];
            }
            else{
                balanceViewController *balvc = [[balanceViewController alloc]init];
                balvc.ketixMoney = personalDict[@"yue"];
                balvc.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                bar.title=@"";
                self.navigationItem.backBarButtonItem=bar;
                [self.navigationController pushViewController:balvc animated:YES];
            }
        }
        else if (tap.view.tag == 1001)
        {
            PackagesRecordViewController *packageRecoordVC = [[PackagesRecordViewController alloc]init];
            packageRecoordVC.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
            bar.title=@"";
            self.navigationItem.backBarButtonItem=bar;
            [self.navigationController pushViewController:packageRecoordVC animated:YES];
        }
        else
        {
            couponViewController *couponVC = [[couponViewController alloc]init];
            couponVC.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
            bar.title=@"";
            self.navigationItem.backBarButtonItem=bar;
            [self.navigationController pushViewController:couponVC animated:YES];
        }
    }
    else
    {
        [self loginVC];
    }
}
-(void)payPasword
{
    nextPayPas  = [[SetPaymentPasswordView alloc] initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    nextPayPas.setPaymentDelegate = self;
    nextPayPas.alpha = 0;
    nextPayPas.tag = 101;
}

#pragma mark SetPaymentPasswordViewDelegate
-(void)SetPaymentPasswordSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        [self promptSuccessWithString:@"修改密码成功"];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            nextPayPas.alpha = 0;
            [nextPayPas removeFromSuperview];
        }];
    }
    else
    {
        [self promptMessageWithString:@"修改失败!请稍后再试"];
    }
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        nextPayPas.alpha = 0;
        [nextPayPas removeFromSuperview];
        rechargePopView.alpha = 0;
        pView.alpha = 0;
        [rechargePopView removeFromSuperview];
        [pView removeFromSuperview];
    }];
}
//给表头赋值
-(void)relodheadView
{
    UILabel *coupLabe1 = (UILabel *)[headView viewWithTag:2000];
    UILabel *coupLabe2 = (UILabel *)[headView viewWithTag:2001];
    UILabel *coupLabe3 = (UILabel *)[headView viewWithTag:2002];
    UILabel *coup1 = (UILabel *)[headView viewWithTag:3000];
    
    if ([isLogin integerValue] == 1) {
        //余额
        CGFloat uye = [personalDict[@"yue"] floatValue];
        if (uye <=0) {
            coupLabe1.text = @"去充值";
            coupLabe1.textColor = txtColors(5, 170, 131, 1);
            coup1.text = @"开启余额支付功能";
            coup1.font = [UIFont systemFontOfSize:MLwordFont_7];
            coup1.textColor = txtColors(254, 42, 68, 0.9);
        }
        else{
            coupLabe1.text = [NSString stringWithFormat:@"%.2f",uye];
            coupLabe1.textColor = txtColors(254, 42, 68, 0.9);
            coup1.text = @"余额";
            coup1.textColor = txtColors(72, 73, 74, 1);
        }
        //优惠
        coupLabe3.text = [NSString stringWithFormat:@"%@",personalDict[@"youhuiquancount"]];
        [[NSUserDefaults standardUserDefaults] setValue:personalDict[@"youhuiquancount"] forKey:@"youhuiquancount"];        
        //个人头像
        [favicon sd_setImageWithURL:[NSURL URLWithString:personalDict[@"headImg"]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
        //userName
        accountLabel.text = [user_tel stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        if([personalDict[@"renzheng"] integerValue]){
            rzImage.image = [UIImage imageNamed:@"认证"];
        }
        else{
            rzImage.image = [UIImage imageNamed:@"未认证"];
        }
    }
    else
    {
        coupLabe1.text = [NSString stringWithFormat:@"%.2f",balance];
        coupLabe3.text = @"0";
        coupLabe2.text = @"0";
        favicon.image = [UIImage imageNamed:@"yonghutouxiang"];
        coup1.text = @"余额";
        accountLabel.text = @"";
    }
}
#pragma mark --UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"kaihu"]integerValue] == 1) return 7;
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identificer = @"cell";
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identificer];
    if (cell == nil) {
        cell = [[PersonalCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificer];
    }
    [cell reloadDataWithIndexPath:indexPath AndViewTag:1 AndDict:personalDict];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"kaihu"]integerValue] == 1)
    {
        if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2) {
            if ([isLogin integerValue ] != 1) {
                [self loginVC];
            }
            else
            {
                if (indexPath.row == 0) {
                    OpenAccountViewController *collectionVC = [[OpenAccountViewController alloc]init];
                    collectionVC.hidesBottomBarWhenPushed = YES;
                    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                    bar.title=@"";
                    self.navigationItem.backBarButtonItem=bar;
                    [self.navigationController pushViewController:collectionVC animated:YES];
                }
                else if (indexPath.row == 1) {
                    myCollectViewController *collectionVC = [[myCollectViewController alloc]init];
                    collectionVC.hidesBottomBarWhenPushed = YES;
                    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                    bar.title=@"";
                    self.navigationItem.backBarButtonItem=bar;
                    [self.navigationController pushViewController:collectionVC animated:YES];
                }
                else if (indexPath.row == 2) {
                    
                    SecuritySetViewController *securityVC = [[SecuritySetViewController alloc]init];
                    securityVC.hidesBottomBarWhenPushed = YES;
                    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                    bar.title=@"";
                    self.navigationItem.backBarButtonItem=bar;
                    [self.navigationController pushViewController:securityVC animated:YES];
                }
                
            }
        }
        else if (indexPath.row == 3){
            if (tolMoneyData.count>0){
                popTag = 10101;
                maskView.alpha =1;
                pView.alpha = 0.95;
                [self.view addSubview:maskView];
                [self.view addSubview:pView];
            }
        }
        else if (indexPath.row==4) {
            helpCenterViewController *helpVC = [[helpCenterViewController alloc]init];
            helpVC.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
            bar.title=@"";
            self.navigationItem.backBarButtonItem=bar;
            helpVC.pageUrl = [NSString stringWithFormat:@"http://www.shp360.com/MshcShop/gonggao/guanyuwenti.jsp"];
            helpVC.titStr = @"我的客服";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
        else if (indexPath.row==5) {
            [self shareMessage];
        }
        else{
            MoreViewController *moreVC = [[MoreViewController alloc]init];
            moreVC.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
            bar.title=@"";
            self.navigationItem.backBarButtonItem=bar;
            [self.navigationController pushViewController:moreVC animated:YES];
        }
    }
    else
    {
        if (indexPath.row == 0||indexPath.row == 1) {
            if ([isLogin integerValue ] != 1) {
                [self loginVC];
            }
            else
            {
                if (indexPath.row == 0) {
                    myCollectViewController *collectionVC = [[myCollectViewController alloc]init];
                    collectionVC.hidesBottomBarWhenPushed = YES;
                    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                    bar.title=@"";
                    self.navigationItem.backBarButtonItem=bar;
                    [self.navigationController pushViewController:collectionVC animated:YES];
                }
                else if (indexPath.row == 1) {
                    SecuritySetViewController *securityVC = [[SecuritySetViewController alloc]init];
                    securityVC.hidesBottomBarWhenPushed = YES;
                    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                    bar.title=@"";
                    self.navigationItem.backBarButtonItem=bar;
                    [self.navigationController pushViewController:securityVC animated:YES];
                }
                
            }
        }
        else if (indexPath.row == 2){
            if (tolMoneyData.count>0){
                popTag = 10101;
                maskView.alpha =1;
                pView.alpha = 0.95;
                [self.view addSubview:maskView];
                [self.view addSubview:pView];
            }
        }
        else if (indexPath.row==3) {
            helpCenterViewController *helpVC = [[helpCenterViewController alloc]init];
            helpVC.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
            bar.title=@"";
            self.navigationItem.backBarButtonItem=bar;
            helpVC.pageUrl = [NSString stringWithFormat:@"http://www.shp360.com/MshcShop/gonggao/guanyuwenti.jsp"];
            helpVC.titStr = @"我的客服";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
        else if (indexPath.row==4) {
            [self shareMessage];
        }
        else{
            MoreViewController *moreVC = [[MoreViewController alloc]init];
            moreVC.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
            bar.title=@"";
            self.navigationItem.backBarButtonItem=bar;
            [self.navigationController pushViewController:moreVC animated:YES];
        }
    }
}

#pragma mark -- 分享
-(void)shareMessage
{
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":user_qiehuandianpu}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"fenxiangFriends.action" params:pram success:^(id json) {
        NSLog(@"分享 %@",json);
        NSDictionary *mesDic = (NSDictionary *)json;
//        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        
        
        if (mesDic.count>0) {
            [self share:mesDic];
        }
        else{
            
            [self promptMessageWithString:@"获取分享信息失败"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(void)share:(NSDictionary *)shareDic
{
    NSString *shareImg = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"tubiao"]];
    NSLog(@"-- %@",shareImg);
    NSString *shareUrl = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"url"]];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImg]]];
    NSString *shareCont = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"wenzi"]];
    //    构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"妙店佳"
                                       defaultContent:@"妙店佳"
                                                image:[ShareSDK pngImageWithImage:img]
                                                title:shareCont
                                                  url:shareUrl
                                          description:shareCont
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:publishContent type:ShareTypeWeixiTimeline authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        switch (state) {
            case SSResponseStateSuccess:
                [self promptMessageWithString:@"分享成功"];
                break;
            case SSResponseStateFail:
                [self promptMessageWithString:@"分享失败"];

                break;
            case SSResponseStateCancel:
                [self promptMessageWithString:@"分享被取消"];

                break;
            default:
                break;
        }
    }];
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:personTabelView arrowDirect:UIPopoverArrowDirectionUp];
//
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess){
//                                    [self promptSuccessWithString:@"分享成功"];
//                                }
//                                else if (state == SSResponseStateFail){
//                                    [self promptMessageWithString:@"分享失败"];
//                                }
//                            }];
}
-(void)loginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UINavigationBar *bar = navi.navigationBar;
    bar.translucent = YES;
    [bar setBarTintColor:txtColors(25, 182, 132, 1)];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self presentViewController:navi animated:YES completion:^{
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*MCscale;
}
//推荐领现金
-(void)popViewshare
{
    pView = [BaseCostomer viewWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 300*MCscale) backgroundColor:[UIColor whiteColor]];
    pView.layer.cornerRadius = 15.0;
    pView.layer.shadowRadius = 5.0;
    pView.layer.shadowOpacity = 0.5;
    pView.layer.shadowOffset = CGSizeMake(0, 0);
    pView.tag = 10101;
    UIScrollView *scrllo = [[UIScrollView alloc]initWithFrame:CGRectMake(5*MCscale, 15*MCscale, pView.width-10*MCscale, 220*MCscale)];
    for (int i =0; i<tolMoneyData.count; i++) {
        redMoneyModel *mod = tolMoneyData[i];
        UIView *vie = [BaseCostomer viewWithFrame:CGRectMake(0, 82*i*MCscale, pView.width-10*MCscale, 80*MCscale) backgroundColor:[UIColor clearColor]];
        vie.tag = i+1;
        [scrllo addSubview:vie];
        UIImageView *imgv = [BaseCostomer imageViewWithFrame:CGRectMake(10*MCscale, 30*MCscale, 22*MCscale, 22*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@"选择"];
        imgv.tag = 1001;
        UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseAction:)];
        [vie addGestureRecognizer:tp];
        [vie addSubview:imgv];
        
        UIImageView *logoImage = [BaseCostomer imageViewWithFrame:CGRectMake(imgv.right+15*MCscale, 2, 74*MCscale, 74*MCscale) backGroundColor:[UIColor clearColor] image:@"现金"];
        
        UILabel *mlb = [BaseCostomer labelWithFrame:CGRectMake(32*MCscale, 15*MCscale, 20*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:redTextColor backgroundColor:[UIColor blackColor] textAlignment:1 numOfLines:1 text:[NSString stringWithFormat:@"%@",mod.money]];
        [logoImage addSubview:mlb];
        [vie addSubview:logoImage];
        
        UILabel *lb1 = [BaseCostomer labelWithFrame:CGRectMake(logoImage.right+5*MCscale, 30*MCscale, 65*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"好友账号:"];
        [vie addSubview:lb1];
        
        UILabel *lb11 = [BaseCostomer labelWithFrame:CGRectMake(lb1.right, 30*MCscale, 90*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
        if (![mod.jieshouzhe isEqual:[NSNull null]]) lb11.text = [mod.jieshouzhe stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        else lb11.text = @"妙店佳";
        [vie addSubview:lb11];
        
        UILabel *lb2 = [BaseCostomer labelWithFrame:CGRectMake(logoImage.right+5*MCscale, lb1.bottom, 40*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text: @"状态:"];
        [vie addSubview:lb2];
        
        UILabel *lb22 = [[UILabel alloc]initWithFrame:CGRectMake(lb2.right, lb1.bottom, 40*MCscale, 20*MCscale)];
        if ([mod.status integerValue]==2) {
            lb22.text = @"注册";
        }
        else if ([mod.status integerValue]==3){
            lb22.text = @"使用";
        }
        lb22.textAlignment = NSTextAlignmentLeft;
        lb22.backgroundColor = [UIColor clearColor];
        lb22.font = [UIFont systemFontOfSize:MLwordFont_7];
        [vie addSubview:lb22];
        UIView *line = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale, logoImage.bottom+2, pView.width-20*MCscale, 1) backgroundColor:lineColor];
        [vie addSubview:line];
    }
    scrllo.contentSize = CGSizeMake(pView.width-10*MCscale, 82*tolMoneyData.count*MCscale);
    [pView addSubview:scrllo];
    
    UIView *btnView = [BaseCostomer viewWithFrame:CGRectMake(20*MCscale, 245*MCscale, pView.width-40, 40*MCscale) backgroundColor:[UIColor clearColor]];
    btnView.layer.cornerRadius = 7.0*MCscale;
    btnView.layer.masksToBounds = YES;
    btnView.tag = 1002;
    [pView addSubview:btnView];
    
    UILabel *moyLab = [BaseCostomer labelWithFrame:CGRectMake(10*MCscale, 10*MCscale, 40*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor yellowColor] backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"¥0"];
    moyLab.tag = 1003;
    [btnView addSubview:moyLab];
    
    UILabel *chaoblb = [BaseCostomer labelWithFrame:CGRectMake(moyLab.right+5*MCscale, 15*MCscale, 120*MCscale, 15*MCscale) font:[UIFont systemFontOfSize:MLwordFont_9] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:[NSString stringWithFormat:@"本次最高提取金额¥%ld",(long)maxtiqumoney]];
    chaoblb.alpha = 0;
    chaoblb.tag = 1004;
    [btnView addSubview:chaoblb];
    
    UILabel *lingqLab = [[UILabel alloc]initWithFrame:CGRectMake(btnView.right-100*MCscale, 10*MCscale, 60*MCscale, 20*MCscale)];
    lingqLab.textColor = [UIColor whiteColor];
    lingqLab.textAlignment = NSTextAlignmentLeft;
    lingqLab.font = [UIFont systemFontOfSize:MLwordFont_5];
    lingqLab.text = @"领现金";
    
    UILabel *mesLab = [BaseCostomer labelWithFrame:CGRectMake(10*MCscale, 0, btnView.width-20*MCscale, 40*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"今天已经领过!请明天再来"];
    mesLab.alpha = 0;
    [btnView addSubview:mesLab];
    [btnView addSubview:lingqLab];
    
    if ([stats isEqualToString:@"0"]) {
        btnView.backgroundColor = redTextColor;
        btnView.userInteractionEnabled = YES;
    }
    else{
        btnView.backgroundColor = lineColor;
        btnView.userInteractionEnabled = NO;
        moyLab.alpha = 0;
        lingqLab.alpha = 0;
        mesLab.alpha = 1;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popViewAction:)];
    [btnView addGestureRecognizer:tap];
}
//领取现金 Action
-(void)popViewAction:(UITapGestureRecognizer *)tap
{
    if (totMoney>maxReceive) {
        NSString *maxMoney = [NSString stringWithFormat:@"最高领取金额为%.f元",maxReceive];
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = maxMoney;
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        NSString *hbidStr = [hongbIdAry componentsJoinedByString:@","];
        NSString *mony = [NSString stringWithFormat:@"%ld",(long)totMoney];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"jine":mony,@"youhuiquanid":hbidStr}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"lingquJiangli.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue]==1) {
                [self maskViewDisMiss];
                [self promptSuccessWithString:@"领取现金成功"];
                [self loginAgin];
            }
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误4"];
        }];
    }
}
-(void)choseAction:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    redMoneyModel *mod = tolMoneyData[view.tag-1];
    NSInteger num = [mod.money integerValue];
    NSString *hbid =[NSString stringWithFormat:@"%@",mod.hongbaoid];
    UIImageView *img = (UIImageView *)[view viewWithTag:1001];
    if ([img.image isEqual:[UIImage imageNamed:@"选中"]]) {
        img.image = [UIImage imageNamed:@"选择"];
        totMoney = totMoney-num;
        for (int i = 0; i<hongbIdAry.count; i++) {
            NSString *str = hongbIdAry[i];
            if ([str isEqualToString:hbid]) {
                [hongbIdAry removeObjectAtIndex:i];
                break;
            }
        }
    }
    else{
        img.image = [UIImage imageNamed:@"选中"];
        totMoney = totMoney+num;
        [hongbIdAry addObject:hbid];
    }
    UIView *btView = [pView viewWithTag:1002];
    UILabel *mlb = [btView viewWithTag:1003];
    UILabel *tlb = [btView viewWithTag:1004];
    if ([stats isEqualToString:@"0"]) {
        if (totMoney>maxtiqumoney) {
            tlb.alpha = 1;
            btView.userInteractionEnabled = NO;
            btView.backgroundColor = lineColor;
        }
        else{
            tlb.alpha = 0;
            btView.userInteractionEnabled = YES;
            btView.backgroundColor = redTextColor;
        }
    }
    mlb.text = [NSString stringWithFormat:@"¥%ld",(long)totMoney];
}
-(void)popSetPasdView
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha =1;
        nextPayPas.alpha = 0.95;
        nextPayPas.isFrom = 2;
        NSArray *array = @[@"设置6位数字支付密码",@"确认支付密码"];
        [nextPayPas getTextFieldPlaceholderWithArray:array];
        [self.view addSubview:maskView];
        [self.view addSubview:nextPayPas];
    }];
}
//选择头像
-(void)chooseUserHeadimage
{
    if ([isLogin integerValue] == 1) {
        if (imagePick == nil) {
            imagePick = [[UIImagePickerController alloc]init];
        }
        imagePick.delegate = self;
        imagePick.allowsEditing = YES;
        imagePick.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        UIAlertController  *alte = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:0];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePick animated:YES completion:nil];
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePick animated:YES completion:nil];
        }];
        UIAlertAction *cleAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alte addAction:cancleAction];
        [alte addAction:otherAction];
        [alte addAction:cleAction];
        [self presentViewController:alte animated:YES completion:nil];
    }
    else
    {
        [self loginVC];
    }
}
//相册
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        favicon.image = image;
    }];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:@"fileUp.action" params:pram image:image success:^(id json) {
        if ([[json valueForKey:@"massage"]integerValue]==1) {
            [self promptSuccessWithString:@"头像更换成功"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误5"];
    }];
    
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
-(void)mTsak
{
    sleep(2.5);
}

@end
