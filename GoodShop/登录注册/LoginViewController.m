//
//  LoginViewController.m
//  GoodShop
//
//  Created by MIAO on 16/11/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountView.h"
#import "MessagesView.h"
#import "RegisterViewController.h"
#import "Header.h"
#import "CustomTabBarViewController.h"
#import "findPasViewController.h"
#import "LBXScanView.h"
#import "SubLBXScanViewController.h"
#import "AppDelegate.h"
#import "NearbyShopsViewController.h"
@interface LoginViewController ()<AccountViewDelegate,MessagesViewDelegate>

@end

@implementation LoginViewController
{
    UIView *btnView;
    UIView *lineView;
    UIButton *accountBtn;//常用按钮
    UIButton *MessageBtn;//全部按钮
    BOOL isAccount;
    MessagesView *messView;
    AccountView *accountView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    isAccount = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigation];
    [self initSubViews];
//    [self slidingSelectionView];
    set_isPeiSong(@"1");
}

//初始化导航栏
-(void)initNavigation
{
  
//    [self.navigationItem setTitle:@""];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
//    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
//    self.navigationController.navigationBar.hidden=YES;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(tightItemClick)];
//    self.navigationItem.rightBarButtonItem = rightItem;
////       self.navigationItem.rightBarButtonItem.=[UIColor redColor];
//    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
//    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮黑"] forState:UIControlStateNormal];
//    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
//    self.navigationItem.leftBarButtonItem =leftbarBtn;
    
    
    
    UIView * navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    [self.view addSubview:navi];
    navi.tag=150;

    
    UIButton * leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [navi addSubview:leftbtn];
    [leftbtn setImage:[UIImage imageNamed:@"返回按钮黑"] forState:UIControlStateNormal];
    leftbtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    leftbtn.left=20*MCscale;
    leftbtn.bottom=navi.height-10*MCscale;
    [leftbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [navi addSubview:rightbtn];
    [rightbtn setTitleColor:textBlackColor forState:UIControlStateNormal];
    rightbtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    rightbtn.right=kDeviceWidth-20*MCscale;
    rightbtn.bottom=navi.height-10*MCscale;
    [rightbtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(tightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)btnAction:(UIButton *)btn
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:@"2" forKey:@"isFirst"];
//    if (user_dianpuId) {
//        CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//        main.buttonIndex = 0;
//    }
    NSNotification *timerStopNoti = [NSNotification notificationWithName:@"timerStopNoti" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:timerStopNoti];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"timerStopNoti" object:nil];
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
    
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    /* viewController.presentedViewController只有present才有值，push的时候为nil
     */
    //防止重复弹
    if ([viewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (id)viewController.presentedViewController;
        if ([tabBarController.selectedViewController isKindOfClass:[tabBarController class]]) {
            return;
        }
    }
    if (viewController.presentedViewController) {
        //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
        [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
            if (user_dianpuId) {
                CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                main.buttonIndex = 0;
            }        }];
    }else {
        if (user_dianpuId) {
            CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            main.buttonIndex = 0;
        }
    }
}
-(void)tightItemClick
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.isInvite = NO;
    registerVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:registerVC animated:YES];
    
    NSNotification *timerStopNoti = [NSNotification notificationWithName:@"timerStopNoti" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:timerStopNoti];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"timerStopNoti" object:nil];
}
//初始化表格
-(void)initSubViews
{
//    btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, 40)];
//    btnView.backgroundColor = [UIColor whiteColor];
//    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 38*MCscale, kDeviceWidth/2.0, 2)];
//    lineView.backgroundColor = mainColor;
//    [btnView addSubview:lineView];
//    
//    accountBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    accountBtn.frame = CGRectMake(0, 0, kDeviceWidth/2.0, 38*MCscale);
//    accountBtn.backgroundColor = [UIColor clearColor];
//    accountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [accountBtn setTitle:@"账户登录" forState:UIControlStateNormal];
//    [accountBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
//    [accountBtn  setTitleColor:mainColor forState:UIControlStateSelected];
//    [accountBtn addTarget:self action:@selector(accountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    accountBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_3];
//    [btnView addSubview:accountBtn];
//    accountBtn.selected=YES;
//    
//    
//    
//    MessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    MessageBtn.frame = CGRectMake(kDeviceWidth/2.0, 0, kDeviceWidth/2.0, 38*MCscale);
//    MessageBtn.backgroundColor = [UIColor clearColor];
//    [MessageBtn setTitle:@"短信登录" forState:UIControlStateNormal];
//    MessageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    [MessageBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
//    [MessageBtn setTitleColor:mainColor forState:UIControlStateSelected];
//    [MessageBtn addTarget:self action:@selector(accountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    MessageBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_3];
//    [btnView addSubview:MessageBtn];
//    MessageBtn.selected=NO;
//    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39*MCscale, kDeviceWidth, 1)];
//    line.backgroundColor = lineColor;
//    [btnView addSubview:line];
//    [self.view addSubview:btnView];
    
    
    accountView= [[AccountView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight )];
    accountView.controller=self;
    accountView.loginDelegate = self;
    [self.view addSubview:accountView];
    
    UIView * navi = [self.view viewWithTag:150];
    [self.view bringSubviewToFront:navi];
    
//    messView = [[MessagesView alloc]initWithFrame:CGRectMake(0, 104, kDeviceWidth, kDeviceHeight - 64)];
//    messView.codeloginDelegate = self;
}

-(void)accountBtnClick:(UIButton *)button
{

    MessageBtn.selected=NO;
    accountBtn.selected=NO;
    button.selected=YES;
    
    
    if (button == accountBtn) {
        isAccount = 1;
        lineView.frame = CGRectMake(0, 38*MCscale, kDeviceWidth/2.0, 2);
        [messView removeFromSuperview];
        [self.view addSubview:accountView];
        
    }
    else
    {
        isAccount = 0;
        [accountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lineView.frame = CGRectMake(kDeviceWidth/2.0, 38*MCscale, kDeviceWidth/2.0, 2);
        [accountView removeFromSuperview];
        [self.view addSubview:messView];
        NSNotification *timerStopNoti = [NSNotification notificationWithName:@"timerStopNoti" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:timerStopNoti];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"timerStopNoti" object:nil];
    }
}

#pragma mark 滑动选择发布或接收页面
//-(void)slidingSelectionView
//{
//    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipClick:)];
//    [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:leftSwip];
//    
//    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipClick:)];
//    [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:rightSwip];
//}

-(void)swipClick:(UISwipeGestureRecognizer *)swip
{
    accountBtn.selected=NO;
    MessageBtn.selected=NO;
    
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        isAccount = 1;
        accountBtn.selected=YES;
        lineView.frame = CGRectMake(0, 38*MCscale, kDeviceWidth/2.0, 2);
        [messView removeFromSuperview];
        [self.view addSubview:accountView];
    }
    else
    {
        isAccount = 0;
        MessageBtn.selected=YES;
        lineView.frame = CGRectMake( kDeviceWidth/2.0, 38*MCscale, kDeviceWidth/2.0, 2);
        [accountView removeFromSuperview];
        [self.view addSubview:messView];
        NSNotification *timerStopNoti = [NSNotification notificationWithName:@"timerStopNoti" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:timerStopNoti];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"timerStopNoti" object:nil];
    }
}

#pragma mark AccountViewDelegate
-(void)loginSuccessWithDict:(NSDictionary *)dict AndIndex:(NSInteger)index
{
    if (index ==1) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([user_dianpuId integerValue] == 0) {
            NearbyShopsViewController *NearbyShopsVC = [[NearbyShopsViewController alloc]init];
            NearbyShopsVC.viewTag = 1;
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:NearbyShopsVC];
            UINavigationBar *bar = navi.navigationBar;
            bar.translucent = YES;
            [bar setBarTintColor:txtColors(25, 182, 132, 1)];
            bar.tintColor = [UIColor whiteColor];
            [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            /* viewController.presentedViewController只有present才有值，push的时候为nil
             */
            
            //防止重复弹
            if ([viewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigation = (id)viewController.presentedViewController;
                if ([navigation.topViewController isKindOfClass:[NearbyShopsViewController class]]) {
                    return;
                }
            }
            if (viewController.presentedViewController) {
                //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
                [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
                    [viewController presentViewController:navi animated:true completion:nil];
                }];
            }else {
                [viewController presentViewController:navi animated:true completion:nil];
            }
        }
        else
        {
            [def setValue:@"1" forKey:@"isFirst"];
            UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            /* viewController.presentedViewController只有present才有值，push的时候为nil
             */
            
            //防止重复弹
            if ([viewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tabBarController = (id)viewController.presentedViewController;
                if ([tabBarController.selectedViewController isKindOfClass:[tabBarController class]]) {
                    return;
                }
            }
            if (viewController.presentedViewController) {
                //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
                [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
                    CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [main setSelectedIndex:0];
                    main.buttonIndex = 0;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }else {
                CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [main setSelectedIndex:0];
                main.buttonIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
        }
    }
    else
    {
        findPasViewController *findPasVC = [[findPasViewController alloc]init];
        findPasVC.beforeTel = accountView.tleTextFile.text;
        findPasVC.backPhone=^(NSString * tel){
            accountView.tleTextFile.text=tel;
        };
        
        findPasVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:findPasVC animated:YES];
    }
}

#pragma mark MessagesViewDelegate
-(void)loginSuccessWithCodeDict:(NSDictionary *)dict AndIndex:(NSInteger)index
{
    if (index == 1) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([user_dianpuId integerValue] == 0) {
            NearbyShopsViewController *NearbyShopsVC = [[NearbyShopsViewController alloc]init];
            NearbyShopsVC.viewTag = 1;
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:NearbyShopsVC];
            UINavigationBar *bar = navi.navigationBar;
            bar.translucent = YES;
            [bar setBarTintColor:naviBarTintColor];
            bar.tintColor = [UIColor whiteColor];
            [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            /* viewController.presentedViewController只有present才有值，push的时候为nil
             */
            
            //防止重复弹
            if ([viewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigation = (id)viewController.presentedViewController;
                if ([navigation.topViewController isKindOfClass:[NearbyShopsViewController class]]) {
                    return;
                }
            }
            if (viewController.presentedViewController) {
                //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
                [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
                    [viewController presentViewController:navi animated:true completion:nil];
                }];
            }else {
                [viewController presentViewController:navi animated:true completion:nil];
            }
        }
        else
        {
            [def setValue:@"1" forKey:@"isFirst"];
            UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            /* viewController.presentedViewController只有present才有值，push的时候为nil
             */
            
            //防止重复弹
            if ([viewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tabBarController = (id)viewController.presentedViewController;
                if ([tabBarController.selectedViewController isKindOfClass:[tabBarController class]]) {
                    return;
                }
            }
            if (viewController.presentedViewController) {
                //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
                [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
                    
                    CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [main setSelectedIndex:0];
                    main.buttonIndex = 0;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }else {
                CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [main setSelectedIndex:0];
                main.buttonIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
        }
    }
    else
    {
        if (![self cameraPemission])
        {
            [self showError:@"没有摄像机权限"];
            return ;
        }
        [self QQStyleScan];
    }
}

#pragma mark - 检测是否有权限打开相机
- (BOOL)cameraPemission
{
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    return isHavePemission;
}
#pragma mark - 提示框
- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}
- (void)QQStyleScan
{
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    vc.isVideoZoom = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    
    [self.navigationController pushViewController:vc animated:YES];
    //    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    //    [window addSubview:vc.view];
}
// 刷新 是不是最新版本
-(void)reshBanbenBlockIsAfter:(void(^)(BOOL isAfter))block{
    if (banben_IsAfter) {
        block(YES);
        return;
    }
    [Request getBanBenInfo1Success:^(NSInteger message, id data) {
        if (message == 0 || message == 1) {
            set_Banben_IsAfter(YES);
            block(YES);
            return ;
        }
        set_Banben_IsAfter(NO);
        block(NO);
    } failure:^(NSError *error) {
        set_Banben_IsAfter(NO);
        block(NO);
    }];
}

@end
