//
//  CarFirstViewController.m
//  GoodShop
//
//  Created by MIAO on 16/11/18.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "CarFirstViewController.h"
#import "AdScrollView.h"
#import "SrcollViewImageModel.h"
#import "ShangpinModel.h"
#import "shopCollectionViewCell.h"
#import "GoodDetailViewController.h"
#import "searchViewController.h"
#import "SelectedFenleiViewController.h"
#import "ShopDetailViewController.h"
#import "ImageSelectedViewController.h"
#import "couponViewController.h"
#import "PaomaView.h"
#import "UpdateTipView.h"
#import "CarViewController.h"
#import "Header.h"
#import "AFNetworking.h"
#import "AccountLoginView.h"
#import "FuliViewController.h"
#import "MakeMoneyViewController.h"
#import "CouponsViewController.h"
#import "SeckillViewController.h"
#import "DiscountViewController.h"
#import "PackageViewController.h"
#import "locationViewController.h"
#import "NearbyShopsViewController.h"
#import "KaihuiView.h"
#import "OpenAccountViewController.h"
#import "SubLBXScanViewController.h"

@interface CarFirstViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate,CAAnimationDelegate,UIWebViewDelegate,AccountLoginViewDelegate,updateTipDelegate,MakeMoneyViewControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,KaihuiViewDelegate>

@property(nonatomic,strong)NSDictionary * gongGaoDic;
@end

@implementation CarFirstViewController
{
    UIView *headView;
    UIImageView *huImageView;
    AdScrollView *scrollView;
    NSMutableArray *scroImageAry;
    UICollectionView *mainCollectionView;
    UIView *maskView;//
    
    NSMutableArray *yingyongArray;
    NSMutableArray *rexiaoArray;
    NSMutableArray *rexiaoImageArray;
    NSMutableArray *shangpinArray;
    UICollectionViewFlowLayout *flowlayout;
    CGFloat mainHeight;
    CGFloat lineViewTop;
    UIView *backView;
    UIView *lineH;
    UIView *lineView;
    NSMutableArray *btnArray; //c存放所有加入购物车按钮
    CALayer  *anmiatorlayer; //贝塞尔曲线 加入购物车动画
    NSMutableArray *goodAry;
    
    BOOL isRefresh,isBotom;
    NSInteger loadType;
    int pageNum;
    int lastPage;
    UILabel *nameLabel;
    UIImageView *nameRight;
    PaomaView *paomaview;
    UIImageView *labaImage;
    UIImageView *gonggaoImage;
    NSString *dianpuID;
    
    UpdateTipView *updatePop;//更新提示弹框
    UIView *updateBackgroundView,*bottomBackView;//更新背景
    NSString *sysLevel,*descripton;//更新等级 更新说明
    
    UIWebView *webview;
    AccountLoginView *accounView;
    UIView *tabbarView;
    
    KaihuiView *openView;
    
    UIView *leftView;
    UILabel *leftLabel;
    UIView *rightView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_codeSearch;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
    
//    UIImageView *caozuotishiImage;
}
-(void)initData{
    _gongGaoDic = [NSDictionary new];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(carDataNotiClick) name:@"carDataNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notafitionAction) name:@"changeGoodsAnying" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(qiehuandianpuNotiClick:) name:@"qiehuandianpuNoti" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(daohanglanHiddenClick) name:@"daohanglanHidden" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kaihuPanduanNotiClick) name:@"kaihuPanduanNoti" object:nil];
    
    NSString * leftTitle=@"请点击定位";
    if (userLastAddress){
        leftTitle = userLastAddress;
    }
    leftLabel.text = [NSString stringWithFormat:@"%@",leftTitle];
    NSString *xingStr =[NSString stringWithFormat:@"%@",leftLabel.text];
    CGSize xinSzie = [xingStr boundingRectWithSize:CGSizeMake(150*MCscale, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    leftLabel.frame = CGRectMake(33*MCscale, 0, xinSzie.width+6*MCscale, 30*MCscale);
    leftView.frame = CGRectMake(15*MCscale,25*MCscale, leftLabel.width + 40*MCscale, 30*MCscale);
//    nameLabel.text = user_dianpuName;
    [self fuzhiNameAddRightImg];
    

    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    mainCollectionView.top=0;
    mainCollectionView.height=kDeviceHeight-self.tabBarController.tabBar.height;
    leftView.hidden = NO;
    rightView.hidden = NO;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    mainCollectionView.top=0;
    mainCollectionView.height=kDeviceHeight-self.tabBarController.tabBar.height;
    leftView.hidden = NO;
    rightView.hidden = NO;
 
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBarTintColor:naviBarTintColor];
    self.navigationController.navigationBar.frame=CGRectMake(0, 0, kDeviceWidth, 64);
    mainCollectionView.top=64;
    mainCollectionView.height=kDeviceHeight-self.tabBarController.tabBar.height-64;
//
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    

    mainHeight = 275*MCscale;
    lineViewTop = 240*MCscale;
    pageNum = 1;
    isRefresh =0;
    isBotom = 1;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:@"isFirst"]integerValue] == 1) {
        dianpuID = user_dianpuId;
    }
    else
    {
        dianpuID = user_qiehuandianpu;
    }
    [def setValue:dianpuID forKey:@"dianpuqiehuan"];
    
    btnArray = [[NSMutableArray alloc]init];
    goodAry = [[NSMutableArray alloc]init];
    
    yingyongArray = [NSMutableArray arrayWithCapacity:0];
    scroImageAry = [NSMutableArray arrayWithCapacity:0];
    rexiaoArray = [NSMutableArray arrayWithCapacity:0];
    rexiaoImageArray = [NSMutableArray arrayWithCapacity:0];
    shangpinArray = [NSMutableArray arrayWithCapacity:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy = 5;
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    [self performSelector:@selector(delaysss) withObject:self afterDelay:0.1];
    [self kaihuPanduanNotiClick];
    [self initMaskView];
    [self relodCarData];
    [self getDianpuYingyongData];
    [self reloadScrollViewData];
    [self getAllShangpin];
    [self createCollectionView];
    [self addContent];
    [self refresh];
    [self BackgroundDataAcquisition];
    [self setNavigationItem];
    [self getUpdateData];//
    
}

//获取后台版本(版本更新有关)
-(void)getUpdateData
{
    [Request getBanBenInfoSuccess:^(NSInteger message, id data) {

        if (message == 3) {
            sysLevel = [NSString stringWithFormat:@"%@",[data valueForKey:@"jibie"]];
            descripton = [NSString stringWithFormat:@"%@",[data valueForKey:@"shuoming"]];
            [self initUpdateTipView];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark -- tipView
-(void)initUpdateTipView
{
    CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
    main.buttonIndex = 0;
    
    updateBackgroundView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:updateBackgroundView];
    
    tabbarView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth, 50*MCscale) backgroundColor:[UIColor clearColor]];
    [main.tabBar addSubview:tabbarView];
    
    updatePop = [[UpdateTipView alloc]initWithFrame:CGRectMake(40*MCscale, 170*MCscale, kDeviceWidth-80*MCscale, 320*MCscale)];
    updatePop.delegate = self;
    NSArray *descripAry = [descripton componentsSeparatedByString:@"#"];
    updatePop.alpha = 0.95;
    NSString *decStr = @"";
    for (int i = 0; i<descripAry.count; i++) {
        if (i==0) {
            decStr = [NSString stringWithFormat:@"%@\n",descripAry[i]];
        }
        else
            decStr = [NSString stringWithFormat:@"%@%@\n",decStr,descripAry[i]];
    }
    NSString *ss = [NSString stringWithFormat:@"%@",decStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5*MCscale;// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:MLwordFont_3],NSParagraphStyleAttributeName:paragraphStyle};
    updatePop.txtView.attributedText = [[NSAttributedString alloc]initWithString:ss attributes:attributes];
    [self.view addSubview:updateBackgroundView];
    [self.view addSubview:updatePop];
}
#pragma mark --更新类代理方法
-(void)updateTip:(UpdateTipView *)updateView tapIndex:(NSInteger)index
{
    if (index == 102) {
        if ([sysLevel isEqualToString:@"1"]) {
            exit(0);
        }
        else{
            [updateBackgroundView removeFromSuperview];
            [updatePop removeFromSuperview];
            [tabbarView removeFromSuperview];
        }
    }
    else if (index == 101){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stor_url]];
    }
}

#pragma mark -- 详情页添加数据/购物车删除数据
-(void)notafitionAction
{
    [self relodCarData];
}
-(void)setNavigationItem
{
    UIView *shopDetailView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, 200*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *shopTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopDetailViewTapClick)];
    [shopDetailView addGestureRecognizer:shopTap];
    self.navigationItem.titleView = shopDetailView;
    
    
    
    nameLabel = [BaseCostomer labelWithFrame:CGRectMake(0, 5*MCscale,200*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    [shopDetailView addSubview:nameLabel];
    

    
    nameRight = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, nameLabel.height, nameLabel.height)];
//    nameRight.backgroundColor=[UIColor redColor];
    [shopDetailView addSubview:nameRight];
    nameRight.contentMode=UIViewContentModeScaleAspectFit;

    
    
    

    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"分类" style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"搜索"];
    rightButton.tag = 1002;
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    //定位视图
    leftView = [[UIView alloc]init];
    leftView.backgroundColor = lineColor;
    leftView.layer.cornerRadius = 15*MCscale;
    leftView.layer.masksToBounds = YES;
    leftView.alpha = 0.75;
    [self.view addSubview:leftView];
    [leftView bringSubviewToFront:self.view];
    
    
    
    UITapGestureRecognizer *leftViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NaviViewTapClick:)];
    [leftView addGestureRecognizer:leftViewTap];
    
    UIImageView *leftImage = [BaseCostomer imageViewWithFrame:CGRectMake(5*MCscale, 2*MCscale, 25*MCscale, 25*MCscale) backGroundColor:[UIColor clearColor] image:@"定位"];
    [leftView addSubview:leftImage];
    leftLabel = [[UILabel alloc]init];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [leftView addSubview:leftLabel];
    
    //搜索视图
    rightView = [BaseCostomer viewWithFrame:CGRectMake(kDeviceWidth-120*MCscale,25*MCscale, 100*MCscale, 30*MCscale) backgroundColor:lineColor];
    rightView.layer.cornerRadius = 15*MCscale;
    rightView.layer.masksToBounds = YES;
    rightView.alpha = 0.75;
    [self.view addSubview:rightView];
    [rightView bringSubviewToFront:self.view];
    UITapGestureRecognizer *rightViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NaviViewTapClick:)];
    [rightView addGestureRecognizer:rightViewTap];
    
    UIImageView *rightImage = [BaseCostomer imageViewWithFrame:CGRectMake(rightView.width-40*MCscale, 2*MCscale, 25*MCscale, 25*MCscale) backGroundColor:[UIColor clearColor] image:@"扫描"];
    [rightView addSubview:rightImage];
}
-(void)NaviViewTapClick:(UITapGestureRecognizer *)tap
{
    if (tap.view == leftView) {
    
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检测到您未开启定位,请前往开启" preferredStyle:1];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
            }];
            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }   [[UIApplication sharedApplication] openURL:url];
            }];
            [alert addAction:suerAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        
        
        locationViewController *locaVC = [[locationViewController alloc]init];
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        locaVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:locaVC animated:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
    else
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
        vc.btnPhotoHiden = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        //    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        //    [window addSubview:vc.view];
        
        vc.block=^(NSString * Id){
            set_isPeiSong(@"0");///  当扫码  进行 切换店铺时 把配送方式改为0
            
            [[NSUserDefaults standardUserDefaults]setValue:Id forKey:@"dianpuqiehuan"];
            [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"isFirst"];
            CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [main setSelectedIndex:0];
            main.buttonIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
        
        };

    }
}
-(void)shopDetailViewTapClick
{
    NSString * img = [NSString stringWithFormat:@"%@",_gongGaoDic[@"renzheng"]];
    if (![img hasSuffix:@"renzheng.png"]) {
        
        
        NSString * message = @"商铺还未进行认证，无法查看店铺信息。";
        
        UIAlertController * alertC =[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        

        
        UIAlertAction * action  =[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        
        NSMutableAttributedString * mes = [[NSMutableAttributedString alloc]initWithString:message];
        [mes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, [[mes string] length])];
        [mes addAttribute:NSForegroundColorAttributeName value:textBlackColor range:NSMakeRange(0, [[mes string] length])];
        [alertC setValue:mes forKey:@"attributedMessage"];
        
        
        
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:^{
        }];
        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle: message:@"" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        [alert show];
        return;
    }
    
    
    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc]init];
    shopVC.dianpuId = dianpuID;
    shopVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:shopVC animated:YES];
}
-(void)leftItemClick
{
    SelectedFenleiViewController *fenleiVC = [[SelectedFenleiViewController alloc]init];
    fenleiVC.hidesBottomBarWhenPushed = YES;
    fenleiVC.viewTag = 1;
    fenleiVC.dianpuID = dianpuID;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:fenleiVC animated:YES];
}
-(void)rightItemClick
{
 
    searchViewController *searchVC = [[searchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    searchVC.viewTag = 1;
    searchVC.dianpuID = dianpuID;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:searchVC animated:YES];
  
      }
-(void)delaysss
{
    _codeSearch =[[BMKGeoCodeSearch alloc]init];
    _codeSearch.delegate = self;
}
#pragma mark 实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude] forKey:@"longitude"];
    NSLog(@"%f  %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    //发起反向地理编码检索
    reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_codeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_locService stopUserLocationService];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        BMKPoiInfo* poi = [result.poiList objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults]setValue:poi.name forKey:@"addressName"];
        leftLabel.text = userLastAddress;
        NSString *xingStr =[NSString stringWithFormat:@"%@",userLastAddress];
        CGSize xinSzie = [xingStr boundingRectWithSize:CGSizeMake(150*MCscale, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        leftLabel.frame = CGRectMake(33*MCscale, 0, xinSzie.width+6*MCscale, 30*MCscale);
        leftView.frame=CGRectMake(15*MCscale,25*MCscale, leftLabel.width + 40*MCscale, 30*MCscale);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark 获取店铺公告
-(void)getDianpuYingyongData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":dianpuID}];
        
//        _gongGaoDic=@{};
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"dianpuYingyong.action" params:pram success:^(id json) {
            NSLog(@"应用%@",json);
            _gongGaoDic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)json];
            
            if ([json[@"gonggao"]integerValue] != 1 ) {
                [paomaview removeFromSuperview];
                paomaview = [[PaomaView alloc]initWithFrame:CGRectMake(kDeviceWidth/4.0 + 25*MCscale, 20*MCscale, 180*MCscale, 20*MCscale) AndText:json[@"gonggao"]];
                [huImageView addSubview:paomaview];
                labaImage.hidden = NO;
            }
            [[NSUserDefaults standardUserDefaults]setObject:json[@"dianpuname"] forKey:@"dianpuName"];
            NSArray *yingyong = json[@"yingyong"];
            if (![yingyong isEqual:[NSNull null]]) {
                for (NSDictionary *dict in yingyong) {
                    [yingyongArray addObject:dict[@"image"]];
                }
            }
            [self createYingyongView];
            if (yingyongArray.count == 0) {
            }
            else if (yingyongArray.count>0&&yingyongArray.count<=2) {
                mainHeight = mainHeight + 50*MCscale;
            }
            else
            {
                mainHeight = mainHeight + 100*MCscale;
            }
            lineViewTop = mainHeight-35*MCscale;
            
            NSString *imagesStr = [NSString stringWithFormat:@"%@",json[@"lianmeng"]];
            
            imagesStr = @"http://www.shp360.com/Store/images/lianmeng.png";
 //          if (![imagesStr isEqualToString:@"0"]) {
                [gonggaoImage removeFromSuperview];
                gonggaoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,lineViewTop, kDeviceWidth, 50*MCscale)];
                [gonggaoImage sd_setImageWithURL:[NSURL URLWithString:imagesStr] placeholderImage:[UIImage imageNamed:@"查看更多1"] options:SDWebImageRefreshCached];
            
            
                gonggaoImage.userInteractionEnabled = YES;
                [headView addSubview:gonggaoImage];
                
                UITapGestureRecognizer *gonggaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gonggaoTapClick)];
                [gonggaoImage addGestureRecognizer:gonggaoTap];
                mainHeight = mainHeight +50*MCscale;
                lineViewTop = mainHeight - 35*MCscale;
  //            }
            [self getRexiaoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                flowlayout.headerReferenceSize=CGSizeMake(kDeviceWidth,mainHeight); //设置collectionView头视图的大小
                [mainCollectionView reloadData];
                [self fuzhiNameAddRightImg];
            });
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误1"];
        }];
    });
}

-(void)createYingyongView
{
    CGFloat imageWidth = headView.width/2;
    if (yingyongArray.count%2 == 0){
        if (yingyongArray.count >0 &&yingyongArray.count <=2) {
            for (int j = 0; j<yingyongArray.count; j++) {
                if (![yingyongArray[j] isEqualToString:@""]) {
                    UIImageView *image = [BaseCostomer imageViewWithFrame:CGRectMake(imageWidth*j,huImageView.bottom , imageWidth, 50*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:yingyongArray[j]];
                    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",yingyongArray[j]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                    
                    NSLog(@"%@",yingyongArray[j]);
                    image.tag = 100+j;
                    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
                    [image addGestureRecognizer:imageTap];
                    [headView addSubview:image];
                }
            }
        }
        else
        {
            for (int i = 0; i<2; i++) {
                for (int j = 0; j<yingyongArray.count/2; j++) {
                    if (![yingyongArray[yingyongArray.count/2*j+i] isEqualToString:@""]) {
                        UIImageView *image = [BaseCostomer imageViewWithFrame:CGRectMake(imageWidth*i,huImageView.bottom +50*j*MCscale, imageWidth, 50*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@""];
                        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",yingyongArray[j*2+i]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        
                        image.tag = 100+j*2+i;
                        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
                        [image addGestureRecognizer:imageTap];
                        [headView addSubview:image];
                    }
                }
            }
        }
    }
    else
    {
        [yingyongArray addObject:@""];
        [self createYingyongView];
    }
}

#pragma mark 图片点击事件
-(void)imageTapClick:(UITapGestureRecognizer *)tap
{
    NSInteger index =tap.view.tag - 100;
    NSString *imageName = yingyongArray[index];
    NSRange range = [imageName rangeOfString:@"/images/"];//匹配得到的下标
    NSString *imageStr = [imageName substringFromIndex:range.location+range.length];
    NSLog(@"%@",imageStr);
    
    if ([imageStr isEqualToString:@"yingyong/1.png"])
    {
        //特价专区
        SelectedFenleiViewController *fenleiVC = [[SelectedFenleiViewController alloc]init];
        fenleiVC.hidesBottomBarWhenPushed = YES;
        fenleiVC.viewTag = 2;
        fenleiVC.dianpuID = dianpuID;
        [self.navigationController pushViewController:fenleiVC animated:YES];
    }
    else if ([imageStr isEqualToString:@"yingyong/2.png"])
    {
        //折扣专区
        DiscountViewController *DiscountVC = [[DiscountViewController alloc]init];
        DiscountVC.dianpuID = dianpuID;
        DiscountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:DiscountVC animated:YES];
    }
    else if ([imageStr isEqualToString:@"yingyong/3.png"])
    {
        //秒杀一切
        SeckillViewController *SeckillVC = [[SeckillViewController alloc]init];
        SeckillVC.dianpuID = dianpuID;
        SeckillVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SeckillVC animated:YES];
    }
    else if ([imageStr isEqualToString:@"yingyong/4.png"])
    {
        //人人赚
        MakeMoneyViewController *MoneyVC = [[MakeMoneyViewController alloc]init];
        MoneyVC.moneyDelegate = self;
        MoneyVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:MoneyVC animated:YES];
    }
    else if ([imageStr isEqualToString:@"yingyong/5.png"])
    {
        //福利来了
        if ([isLogin integerValue] == 1) {
            //            couponViewController *couponVC = [[couponViewController alloc]init];
            //            couponVC.hidesBottomBarWhenPushed = YES;
            //            UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
            //            bar.title=@"";
            //            self.navigationItem.backBarButtonItem=bar;
            //            [self.navigationController pushViewController:couponVC animated:YES];
            //            //
            FuliViewController *fuliVC = [[FuliViewController alloc]init];
            fuliVC.dianpuID = dianpuID;
            fuliVC.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
            bar.title=@"";
            self.navigationItem.backBarButtonItem=bar;
            [self.navigationController pushViewController:fuliVC animated:YES];
        }
        else
        {
            [self loginVC];
        }
    }
    else if ([imageStr isEqualToString:@"yingyong/6.png"])
    {
        //消费礼包
        PackageViewController *PackageVC = [[PackageViewController alloc]init];
        PackageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:PackageVC animated:YES];
    }
    else if ([imageStr isEqualToString:@"yingyong/7.png"])
    {
        //领券中心
        CouponsViewController *CouponsVC = [[CouponsViewController alloc]init];
        CouponsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CouponsVC animated:YES];
    }
    else if ([imageStr isEqualToString:@"yingyong/8.png"])
    {
        //生产供应
    }
}
#pragma mark MakeMoneyViewControllerDelegate
-(void)gotoLogin
{
    [self loginVC];
}
#pragma mark 公告点击
-(void)gonggaoTapClick
{
    NearbyShopsViewController *NearbyShopsVC = [[NearbyShopsViewController alloc]init];
    NearbyShopsVC.hidesBottomBarWhenPushed = YES;
    NearbyShopsVC.viewTag = 2;
    //    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    //    bar.title=@"";
    //    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:NearbyShopsVC animated:YES];
}
#pragma mark 获取热销商品
-(void)getRexiaoData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    mbHud.delegate =self;
    [mbHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dianpuID,@"userid":user_id}];
    
    backView.backgroundColor=[UIColor whiteColor];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findrexiaoshow.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"热销商品%@",json);
        

        if ([[json valueForKey:@"massages"]integerValue] !=0) {
           
            
            
            NSArray *imageArray = [json valueForKey:@"shoplist"];
            
            
            for (NSDictionary *dict in imageArray) {
                ShangpinModel *model = [[ShangpinModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [rexiaoArray addObject:model];
            }
            for (NSInteger i =0; i<rexiaoArray.count; i++) {
                ShangpinModel *model = rexiaoArray[i];
                NSString *str = [NSString stringWithFormat:@"%@",model.canpinpic];
                [rexiaoImageArray addObject:str];
            }
            [self createRexiaoShangpinView];
            if (rexiaoArray.count>0&&rexiaoArray.count<=3) {
                mainHeight = mainHeight + 130*MCscale;
            }
            else
            {
                mainHeight = mainHeight + 230*MCscale;
            }
            if (rexiaoArray.count==0 || rexiaoArray==nil) {
                backView.backgroundColor=[UIColor whiteColor];
            }else{
                backView.backgroundColor=txtColors(242, 242, 242, 1);

            }
            

        }
        flowlayout.headerReferenceSize=CGSizeMake(kDeviceWidth,mainHeight); //设置collectionView头视图的大小
        [mainCollectionView reloadData];
        
    
        
        NSLog(@"scroImageAryscroImageAryscroImageAry  %@",scroImageAry);
    } failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误2"];
    }];
}
#pragma mark 热销商品视图
-(void)createRexiaoShangpinView
{
    NSLog(@"rexiaoImageArray.count %ld",(unsigned long)rexiaoImageArray.count);
    NSLog(@"rexiaoImageArray.count %@",rexiaoImageArray);
    UIView *back = [BaseCostomer viewWithFrame:CGRectMake(0,lineViewTop +5*MCscale,kDeviceWidth,30*MCscale) backgroundColor:[UIColor clearColor]];
    [headView addSubview:back];
    
    UILabel *fenleiLabel = [BaseCostomer labelWithFrame:CGRectMake(15*MCscale,0, 70*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:txtColors(173, 173, 173, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"招牌推荐"];
//    fenleiLabel.center = CGPointMake(backView.width/2.0, 15*MCscale);
    [back addSubview:fenleiLabel];
    
    UIView *line1 = [BaseCostomer viewWithFrame:CGRectMake(70*MCscale,15*MCscale,(kDeviceWidth-230*MCscale)/2.0,0.5) backgroundColor:txtColors(173, 173, 173, 1)];
    [back addSubview:line1];
    line1.width=kDeviceWidth;
    line1.top=fenleiLabel.bottom+5;
    line1.left=0;
    

//    UIView *line2 = [BaseCostomer viewWithFrame:CGRectMake(fenleiLabel.right +10*MCscale, 15*MCscale,(kDeviceWidth-230*MCscale)/2.0,0.5) backgroundColor:txtColors(173, 173, 173, 1)];
//    [back addSubview:line2];
    
    if (rexiaoImageArray.count%3 == 0) {
        if (rexiaoImageArray.count >0 &&rexiaoImageArray.count <=3) {
            for (int j = 0; j<rexiaoImageArray.count; j++) {
                if (![rexiaoImageArray[j] isEqualToString:@""]) {
                    UIView *rexiaoView = [BaseCostomer viewWithFrame:CGRectMake(kDeviceWidth/3.0*j,lineViewTop +35*MCscale, kDeviceWidth/3.0, 100*MCscale) backgroundColor:[UIColor whiteColor]];
                    rexiaoView.tag = 1000+j;
                    [headView addSubview:rexiaoView];
                    
                    UITapGestureRecognizer *rexiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rexiaoTapClick:)];
                    [rexiaoView addGestureRecognizer:rexiaoTap];
                    
                    UIImageView *rexiaoImage = [BaseCostomer imageViewWithFrame:CGRectMake(5*MCscale,5*MCscale,rexiaoView.width - 10*MCscale ,rexiaoView.height - 10*MCscale) backGroundColor:[UIColor clearColor] image:@""];
                    [rexiaoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",rexiaoImageArray[j]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
                    [rexiaoView addSubview:rexiaoImage];
                    
                    UIView *lineV = [BaseCostomer viewWithFrame:CGRectMake(rexiaoView.width - 1,5*MCscale, 1, rexiaoView.height - 10*MCscale) backgroundColor:lineColor];
                    [rexiaoView addSubview:lineV];
                }
            }
        }
        else
        {
            NSLog(@"ddd%lf",mainHeight);
            for (int i = 0; i<2; i++) {
                for (int j = 0; j<rexiaoImageArray.count/2; j++) {
                    if (![rexiaoImageArray[rexiaoImageArray.count/2*i+j] isEqualToString:@""]) {
                        UIView *rexiaoView = [BaseCostomer viewWithFrame:CGRectMake(kDeviceWidth/3.0*j, 100*MCscale*i+lineViewTop +35*MCscale, kDeviceWidth/3.0, 100*MCscale) backgroundColor:[UIColor whiteColor]];
                        rexiaoView.tag = 1000+rexiaoImageArray.count/2*i+j;
                        [headView addSubview:rexiaoView];
                        
                        UITapGestureRecognizer *rexiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rexiaoTapClick:)];
                        [rexiaoView addGestureRecognizer:rexiaoTap];
                        
                        UIImageView *rexiaoImage = [BaseCostomer imageViewWithFrame:CGRectMake(5*MCscale,5*MCscale,rexiaoView.width - 10*MCscale ,rexiaoView.height - 10*MCscale) backGroundColor:[UIColor clearColor] image:@""];
                        [rexiaoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",rexiaoImageArray[rexiaoImageArray.count/2*i+j]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
                        [rexiaoView addSubview:rexiaoImage];
                        
                        if (i == 0) {
                            UIView *lineViewH = [BaseCostomer viewWithFrame:CGRectMake(0, rexiaoView.height - 1, rexiaoView.width, 1) backgroundColor:lineColor];
                            [rexiaoView addSubview:lineViewH];
                        }
                        
                        UIView *lineV = [BaseCostomer viewWithFrame:CGRectMake(rexiaoView.width - 1,5*MCscale, 1, rexiaoView.height - 10*MCscale) backgroundColor:lineColor];
                        [rexiaoView addSubview:lineV];
                    }
                }
            }
        }
    }
    else
    {
        [rexiaoImageArray addObject:@""];
        [self createRexiaoShangpinView];
    }
}
#pragma mark 热销商品点击事件
-(void)rexiaoTapClick:(UITapGestureRecognizer *)tap
{
    ShangpinModel *shModel = rexiaoArray[tap.view.tag -1000];
    GoodDetailViewController *goodDetail = [[GoodDetailViewController alloc]init];
    goodDetail.goodId = shModel.shanpinid;
    goodDetail.goodtag = shModel.biaoqian;
    goodDetail.zhuangtai = shModel.zhuangtai;
    goodDetail.dianpuId = dianpuID;
    goodDetail.ViewTag = 1;
    goodDetail.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:goodDetail animated:YES];
}
#pragma mark 全部商品
-(void)getAllShangpin
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    mbHud.delegate =self;
    [mbHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dianpuID,@"userid":user_id,@"pageNum":[NSString stringWithFormat:@"%d",pageNum],@"leibei":@"0"}];
    
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findshangpingshow.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"全部商品%@",json);
        if (isRefresh) {
            [self endRefresh:loadType];
        }
        if (lastPage == pageNum) {
            [shangpinArray removeAllObjects];
        }
        lastPage = pageNum;
        
        NSArray *shoplist = [json valueForKey:@"shoplist"];
        if (shoplist.count >0) {
            for (NSDictionary *dict in shoplist) {
                ShangpinModel *model = [[ShangpinModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [shangpinArray addObject:model];
            }
            [mainCollectionView reloadData];
            isBotom = 0;
            [self loadFootView];
        }
        else
        {
            if (lastPage == 1) {
                mainCollectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"特价"]];
            }
            else
            {
                isBotom = 1;
                [self loadFootView];
            }
        }
        [mainCollectionView reloadData];
        NSLog(@"scroImageAryscroImageAryscroImageAry  %@",scroImageAry);
    } failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误3"];
    }];
}
//
-(void)initMaskView
{
    maskView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) backgroundColor:[UIColor clearColor]];
    maskView.alpha = 0;
    
    bottomBackView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth, 50*MCscale) backgroundColor:[UIColor clearColor]];
    
    openView = [[KaihuiView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 200*MCscale)];
    openView.kaihuDelegate = self;
}

-(void)createCollectionView
{
    flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumInteritemSpacing = 0.0f;
    flowlayout.minimumLineSpacing = 0.0f;
    
    flowlayout.headerReferenceSize=CGSizeMake(kDeviceWidth,mainHeight); //设置collectionView头视图的大小
    mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight - 49*MCscale) collectionViewLayout:flowlayout];
    mainCollectionView.dataSource = self;
    mainCollectionView.delegate = self;
    mainCollectionView.backgroundColor = [UIColor clearColor];
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.alwaysBounceVertical = NO;
    [mainCollectionView registerClass:[shopCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:mainCollectionView];
    [mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
}
#pragma mark  UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return shangpinArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    shopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [btnArray addObject:cell.goinShopCar];
    [cell.goinShopCar addTarget:self action:@selector(AddCarClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.goinShopCar.tag = indexPath.row;
    [cell reloDataWithIndexpath:indexPath AndArray:shangpinArray];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ShangpinModel *shModel = shangpinArray[indexPath.row];
    GoodDetailViewController *goodDetail = [[GoodDetailViewController alloc]init];
    goodDetail.goodId = shModel.shanpinid;
    goodDetail.goodtag = shModel.biaoqian;
    goodDetail.zhuangtai = shModel.zhuangtai;
    goodDetail.dianpuId = dianpuID;
    goodDetail.ViewTag = 2;
    goodDetail.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:goodDetail animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kDeviceWidth/2, 180*MCscale);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,50, 0);
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        NSLog(@"mainHeight = %lf",mainHeight);
        [header addSubview:headView];
        
        
        
        //添加头视图的内容
        headView.frame = CGRectMake(0,0, kDeviceWidth, mainHeight);
        
        backView.center = CGPointMake(kDeviceWidth/2.0,mainHeight - 15*MCscale);
        
        
        //头视图添加view
        flowlayout.headerReferenceSize=CGSizeMake(kDeviceWidth,headView.bottom+10*MCscale);
        return header;
    }
    //如果底部视图
    //    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
    //
    //    }
    return nil;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%f",velocity.y);

    
        if (velocity.y < 0.0)
        {
            //向下滑动隐藏导航栏

            self.navigationController.navigationBar.frame=CGRectMake(0, 0, 0, 0) ;
            mainCollectionView.top=0;
            mainCollectionView.height=kDeviceHeight-self.tabBarController.tabBar.height;
            leftView.hidden = NO;
            rightView.hidden = NO;
            [self.navigationController setNavigationBarHidden:YES animated:NO];

        }else
        {
            //向上滑动显示导航栏
//            nameLabel.text = user_dianpuName;
            [self fuzhiNameAddRightImg];
            [self judgeTheFirst];

            self.navigationController.navigationBar.frame=CGRectMake(0, 0, kDeviceWidth, 64) ;
           
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [self.navigationController.navigationBar setBarTintColor:naviBarTintColor];
            
            leftView.hidden = YES;
            rightView.hidden = YES;

            
        }
}
-(void)judgeTheFirst
{
    [self showGuideImageWithUrl:@"images/caozuotishi/shouye.png"];
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstShouye"] integerValue] == 1) {
//        NSString *url = @"images/caozuotishi/shouye.png";
//        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
//        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
//        caozuotishiImage.userInteractionEnabled = YES;
//        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
//        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
//        [caozuotishiImage addGestureRecognizer:imageTap];
//        [self.view addSubview:caozuotishiImage];
//    }
//}
//-(void)imageHidden
//{
//    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstShouye"];
//    [caozuotishiImage removeFromSuperview];
}
#pragma mark 获取轮播图片
-(void)reloadScrollViewData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    mbHud.delegate =self;
    [mbHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dianpuID}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"imageHeads.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"轮播图片%@",json);
        NSArray *imageArray = [json valueForKey:@"listImage"];
        for (NSDictionary *dict in imageArray) {
            SrcollViewImageModel *scrollModel = [[SrcollViewImageModel alloc]init];
            [scrollModel setValuesForKeysWithDictionary:dict];
            [scroImageAry addObject:scrollModel];
        }
        [self relodaScrollImage];
        [mainCollectionView reloadData];
        NSLog(@"scroImageAryscroImageAryscroImageAry  %@",scroImageAry);
    } failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误4"];
    }];
}
-(void)relodaScrollImage
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (NSInteger i =0; i<scroImageAry.count; i++)
    {
        SrcollViewImageModel *scrollModel = scroImageAry[i];
        NSString *str = [NSString stringWithFormat:@"%@",scrollModel.imageurl];
        [ary addObject:str];
    }
    scrollView.imageNameArray = ary;
}
/*
 *  补充头部内容
 */
-(void)addContent
{
    headView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0,0,kDeviceWidth,mainHeight);
    
    [self initScrollView];
    huImageView = [BaseCostomer imageViewWithFrame:CGRectMake(0, 190*MCscale, headView.width, 50*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@"tuoyuan"];
    [headView addSubview:huImageView];
    [huImageView bringSubviewToFront:headView];
    
    labaImage = [BaseCostomer imageViewWithFrame:CGRectMake(huImageView.width /4.0, 20*MCscale, 20*MCscale, 20*MCscale) backGroundColor:[UIColor clearColor] image:@"laba"];
    labaImage.hidden = YES;
    [huImageView addSubview:labaImage];
    
    backView = [BaseCostomer viewWithFrame:CGRectMake(0, 100,kDeviceWidth,30*MCscale) backgroundColor:txtColors(242, 242, 242, 1)];
    [headView addSubview:backView];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTapClick)];
    [backView addGestureRecognizer:backTap];
    
    CGFloat setY=10*MCscale;
    CGFloat setH=30*MCscale;
    UIView * backHead = [[UIView alloc]initWithFrame:CGRectMake(0, setY, kDeviceWidth, setH)];
    backHead.backgroundColor=[UIColor whiteColor];
    [backView addSubview:backHead];
    
    UILabel *fenleiLabel = [BaseCostomer labelWithFrame:CGRectMake(15*MCscale,setY+ 5*MCscale, 70*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:txtColors(173, 173, 173, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@"全部分类"];
//    fenleiLabel.center = CGPointMake(backView.width/2.0, 15*MCscale);
    
    [backView addSubview:fenleiLabel];
    
    
    UIImageView * allImg = [BaseCostomer imageViewWithFrame:CGRectMake(0, setY+ 5*MCscale, 20*MCscale, 20*MCscale) backGroundColor:[UIColor clearColor] image:@"下拉键"];
    [backView addSubview:allImg];
    allImg.right=kDeviceWidth-15*MCscale;
    
    UILabel * allLabel = [BaseCostomer labelWithFrame:CGRectMake(15*MCscale,setY + 5*MCscale, 70*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_6] textColor:txtColors(173, 173, 173, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@"查看全部"];
    allLabel.right=allImg.left;
    [backView addSubview:allLabel];
    
//    UIView *line1 = [BaseCostomer viewWithFrame:CGRectMake(70*MCscale,15*MCscale,(kDeviceWidth-230*MCscale)/2.0,0.5) backgroundColor:txtColors(173, 173, 173, 1)];
//    [backView addSubview:line1];
//    
//    UIView *line2 = [BaseCostomer viewWithFrame:CGRectMake(fenleiLabel.right +10*MCscale, 15*MCscale,(kDeviceWidth-230*MCscale)/2.0,0.5) backgroundColor:txtColors(173, 173, 173, 1)];
//    [backView addSubview:line2];
    
    //    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    //    lineView.backgroundColor = lineColor;
    //    [headView addSubview:lineView];
}
#pragma mark 全部分类点击事件
-(void)backTapClick
{
    SelectedFenleiViewController *fenleiVC = [[SelectedFenleiViewController alloc]init];
    fenleiVC.hidesBottomBarWhenPushed = YES;
    fenleiVC.viewTag = 1;
    fenleiVC.dianpuID = dianpuID;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:fenleiVC animated:YES];
}
#pragma mark --  创建 轮播视图
-(void)initScrollView
{
    scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,240*MCscale)];
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for(NSString *str in scroImageAry)
    {
        [ary addObject:str];
    }
    scrollView.imageNameArray = ary;
    scrollView.contentSize = CGSizeMake(kDeviceWidth*3,240*MCscale);
    scrollView.PageControlShowStyle = UIPageControlShowStyleCenter;
    //    scrollView.pageControl.pageIndicatorTintColor = txtColors(211, 206, 207, 1);
    //    scrollView.pageControl.currentPageIndicatorTintColor = txtColors(29, 126, 252, 1);
    scrollView.showsHorizontalScrollIndicator = NO;
    [headView addSubview:scrollView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scroTapAction)];
    [scrollView addGestureRecognizer:tap];
}

//轮播手势点击
-(void)scroTapAction
{
    
}
#pragma mark
-(void)AddCarClick:(UIButton *)btn
{
    if ([isLogin integerValue] == 1) {
        NSLog(@"%ld",(long)btn.tag);
        ShangpinModel *shModel = shangpinArray[btn.tag];
        NSString *goodId = [NSString stringWithFormat:@"%@",shModel.shanpinid];
        NSString *label = [NSString stringWithFormat:@"%@",shModel.biaoqian];
        if ([label isEqualToString:@"1"] || [label isEqualToString:@""]) [self addcardAnimation:btn];
        else{
            NSString *cutLabelStr = [label substringFromIndex:45];
            NSLog(@"%@",cutLabelStr);
            if ([cutLabelStr isEqualToString:@"tehui.png"]) {
                NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shangpinid":goodId}];
                [HTTPTool getWithUrlPath:HTTPHEADER  AndUrl:@"findbycarshop.action" params:pram success:^(id json) {
                    NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massage"]];
                    if ([massage isEqualToString:@"3"]) [self promptMessageWithString:@"该特惠商品购物车已存在"];
                    else [self addcardAnimation:btn];
                } failure:^(NSError *error) {
                    [self promptMessageWithString:@"网络连接错误5"];
                }];
            }
            else  [self addcardAnimation:btn];
        }
    }
    else [self loginVC];
}
-(void)addcardAnimation:(UIButton *)btn
{
    for (UIButton *btns in btnArray) {
        btns.userInteractionEnabled = NO;
    }
    [self addDataInCar:btn.tag];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    [goodAry addObject:str];
    CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
    CGPoint stPoint = rc.origin;
    CGPoint startPoint = CGPointMake(stPoint.x+12, stPoint.y+12);
    CGPoint endpoint = CGPointMake(80, kDeviceHeight-40);
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"购物车圆点"];
    imageView.contentMode=UIViewContentModeScaleToFill;
    imageView.frame=CGRectMake(0, 0, 10, 10);
    imageView.hidden=YES;
    
    anmiatorlayer =[[CALayer alloc]init];
    anmiatorlayer.contents=imageView.layer.contents;
    anmiatorlayer.frame=imageView.frame;
    anmiatorlayer.opacity=1;
    [self.view.layer addSublayer:anmiatorlayer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    //贝塞尔曲线中间点
    float sx=startPoint.x;
    float sy=startPoint.y;
    float ex=endpoint.x;
    float ey=endpoint.y;
    float x=sx+(ex-sx)/3;
    float y=sy+(ey-sy)*0.5-400;
    CGPoint centerPoint=CGPointMake(x,y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration=1;
    animation.delegate=self;
    animation.autoreverses= NO;
    [animation setValue:@"yingmeiji_buy" forKey:@"MyAnimationType_yingmeiji"];
    [anmiatorlayer addAnimation:animation forKey:@"yingmiejibuy"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString* value = [anim valueForKey:@"MyAnimationType_yingmeiji"];
    if ([value isEqualToString:@"yingmeiji_buy"]){
        [anmiatorlayer removeAnimationForKey:@"yingmiejibuy"];
        [anmiatorlayer removeFromSuperlayer];
        anmiatorlayer.hidden=YES;
        for (UIButton *btns in btnArray) {
            btns.userInteractionEnabled = YES;
        }
    }
}
#pragma mark -- 加入购物车数据
-(void)addDataInCar:(NSInteger )index
{
    
     
    ShangpinModel *shModel = shangpinArray[index];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shangpinid":shModel.shanpinid,@"userid":user_id,@"car.dianpuid":dianpuID}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"saveaddcarone.action" params:pram success:^(id json) {
        NSLog(@"加入购物车%@",json);
        
        if ([[json valueForKey:@"massages"]integerValue]==0) [self promptMessageWithString:@"添加失败"];
        else if ([[json valueForKey:@"massages"]integerValue]==1) [self relodCarData];
        else if ([[json valueForKey:@"massages"]integerValue]==2) [self promptMessageWithString:@"店铺休息中"];
        else if ([[json valueForKey:@"massages"]integerValue]==3) [self promptMessageWithString:@"当前商品库存不足"];
        else [self promptMessageWithString:@"当前数量已达到活动上限"];
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误6"];
    }];
}

-(void)relodCarData
{
    NSLog(@"%@  %@ ",user_id,dianpuID);
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"car.dianpuid":dianpuID}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"dianpuprice.action" params:pram success:^(id json) {
        NSLog(@"购物车数量%@",json);
        NSDictionary *dict = @{@"shuliang":[json valueForKey:@"shuliangs"]};
        NSNotification *changeNumLabelNoti = [NSNotification notificationWithName:@"changeNumLabelNoti" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:changeNumLabelNoti];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeNumLabelNoti" object:nil];
        
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误7";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

#pragma mark 进入购物车
-(void)carDataNotiClick
{
    if ([isLogin integerValue] == 1) {
        CarViewController *carVC = [[CarViewController alloc]init];
        carVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:carVC animated:YES];
    }
    else [self loginVC];
}

-(void)BackgroundDataAcquisition
{
    //让该方法延迟五秒在执行一次
    [self performSelector:@selector(BackgroundDataAcquisition) withObject:nil afterDelay:60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"H"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"datetime %@",dateTime);
    if ([dateTime integerValue]>=8 && [dateTime integerValue]<=23) {
        
        //ping命令 原理：向大型的门户网址发送请求，来判断当前的网络状态
        //1、请求队列管理者(数据请求工具)
        AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.m1ao.com/"]];
        //2、发送请求监测网络
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            //判断状态
            if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                [self timerClick];
            }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
                [self timerClick];
            }
        }];
        //3、启动网络监测
        [manager.reachabilityManager startMonitoring];//stopMonitoring
    }
    //网页视图
    webview = [[UIWebView alloc]initWithFrame:CGRectZero];
    webview.delegate = self;
    [self.view addSubview:webview];
}

-(void)timerClick
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@UserInfo.jsp?userid=%@&shequid=%@",HTTPWeb,user_id,dianpuID];
        NSLog(@"%@",urlStr);
        
        NSURL *url =[NSURL URLWithString:urlStr];
        //转化成相应的源码
        NSString * htmlStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        //加载HTML数据的
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //baseURL通常写为公司网址
            [webview loadHTMLString:htmlStr baseURL:nil];
        });
    });
    //    NSUserDefaults *def =  [NSUserDefaults standardUserDefaults];
    [self sendUILocalNotificationWithBody:nil AndTitle:nil AndBadgeNumber:0 AndSound:nil];
}
#pragma mark WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webview stopLoading];
    //在该方法中可以手动书写javaScript代码 为图片添加点击事件可以获取图片网址
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"sdaf %@",currentURL);
    NSRange range = [currentURL rangeOfString:@"<!-- 1user登录时间  -->"];//匹配得到的下标
    NSString *str1 = [currentURL substringWithRange:NSMakeRange(0,range.location+range.length)];
    
    NSRange range2 = [currentURL rangeOfString:@"<!--2 user注册设备 -->"];//匹配得到的下标
    NSString *str2 = [currentURL substringWithRange:NSMakeRange(range.location+range.length,range2.location+range2.length-range.location-range.length)];
    
    NSRange range3 = [currentURL rangeOfString:@"<!--3 系统推送编号 -->"];//匹配得到的下标
    NSString *str3 = [currentURL substringWithRange:NSMakeRange(range2.location+range2.length,range3.location+ range3.length -range2.location-range2.length)];
    
    NSString *str4 = [currentURL substringFromIndex:range3.location+range3.length];
    
    NSRange rangeDef1 = [str1 rangeOfString:@"value="];//匹配得到的下标
    NSRange rangestop1 = [str1 rangeOfString:@"><!"];//匹配得到的下标
    
    NSRange rangeDef2 = [str2 rangeOfString:@"value="];//匹配得到的下标
    NSRange rangestop2 = [str2 rangeOfString:@"><!"];//匹配得到的下标
    
    NSRange rangeDef3 = [str3 rangeOfString:@"value="];//匹配得到的下标
    NSRange rangestop3 = [str3 rangeOfString:@"><!"];//匹配得到的下标
    
    NSRange rangeDef4 = [str4 rangeOfString:@"value="];//匹配得到的下标
    NSRange rangestop4 = [str4 rangeOfString:@"> <!"];//匹配得到的下标
    
    NSString *loginTime = [str1 substringWithRange:NSMakeRange(rangeDef1.location + rangeDef1.length +1,rangestop1.location-rangeDef1.location -rangeDef1.length-1-1)];
    
    NSString *shebeiBianhao = [str2 substringWithRange:NSMakeRange(rangeDef2.location + rangeDef2.length +1,rangestop2.location-rangeDef2.location -rangeDef2.length-1-1)];
    
    NSString *xitongbianhao = [str3 substringWithRange:NSMakeRange(rangeDef3.location + rangeDef3.length +1,rangestop3.location-rangeDef3.location -rangeDef3.length-1-1)];
    
    NSString *shequbianhao = [str4 substringWithRange:NSMakeRange(rangeDef4.location + rangeDef4.length +1,rangestop4.location-rangeDef4.location -rangeDef4.length-1-1)];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSLog(@"asdfads %@  %@ ",[def valueForKey:@"xitongPush"],xitongbianhao);
    
    if(![shebeiBianhao isEqualToString:@"0"]&&[userSheBei_id isEqualToString:shebeiBianhao])
    {
        NSLog(@"设备相等时 %@  %@ ",userSheBei_id,shebeiBianhao);
        NSString *hour = [loginTime substringWithRange:NSMakeRange(8, 2)];
        NSString *minute = [loginTime substringWithRange:NSMakeRange(10, 2)];
        NSString *second = [loginTime substringWithRange:NSMakeRange(12, 2)];
        NSString *loginTitle = [NSString stringWithFormat:@"您的账号于%@:%@:%@在其他地方登陆",hour,minute,second];
        [self sendUILocalNotificationWithBody:loginTitle AndTitle:nil AndBadgeNumber:0 AndSound:UILocalNotificationDefaultSoundName];
        [self AccountLoginViewWithLoginTime:loginTitle];
        [self.view bringSubviewToFront:accounView];
        
        [def setValue:0 forKey:@"isLogin"];
        [def setValue:userSheBei_id forKey:@"userId"];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"xrlTapNum"];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"youhuiquancount"];
        NSNotification *userExitNotification = [NSNotification notificationWithName:@"userExitFication" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:userExitNotification];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userExitFication" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
        [HTTPTool getWithUrlPath:HTTPWeb AndUrl:@"findbyuseriddenglulinshi.action" params:pram success:^(id json) {
        } failure:^(NSError *error) {
        }];
    }
#pragma mark 系统通知
    else if(![xitongbianhao isEqualToString:@"0"]&&![[def valueForKey:@"xitongPush"] isEqualToString:xitongbianhao])
    {
        NSLog(@"系统不相等时 %@   %@  ",[def valueForKey:@"xitongPush"],[def valueForKey:@"shequPush"]);
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"xitongbianhao":xitongbianhao}];
        [self xitongPushActionWithUrl:@"tuiSongXiTongIOS.action" AndPram:pram];
        [def setValue:xitongbianhao forKey:@"xitongPush"];
    }
#pragma mark 社区通知
    else if(![shequbianhao isEqualToString:@"0"]&&![[def valueForKey:@"shequPush"] isEqualToString:shequbianhao])
    {
        NSLog(@"社区不相等时 %@   %@ ",[def valueForKey:@"xitongPush"],[def valueForKey:@"shequPush"]);
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"shequbianhao":shequbianhao}];
        [self xitongPushActionWithUrl:@"tuiSongSheQu.action" AndPram:pram];
        [def setValue:shequbianhao forKey:@"shequPush"];
    }
}
-(void)xitongPushActionWithUrl:(NSString *)url AndPram:(NSMutableDictionary *)pram
{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = 20;
    
    NSString * urlPath =  [NSString stringWithFormat:@"%@/%@",HTTPPush,url];
    //    // 3.发送请求
    [manger GET:urlPath parameters:pram success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@",responseObject);
        [self sendUILocalNotificationWithBody:[responseObject valueForKey:@"content"] AndTitle:[responseObject valueForKey:@"biaoti"] AndBadgeNumber:0 AndSound:UILocalNotificationDefaultSoundName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    }];
}
-(void)sendUILocalNotificationWithBody:(NSString *)body AndTitle:(NSString *)title AndBadgeNumber:(NSInteger)num AndSound:(NSString *)sound
{
    //进行本地推送
    UILocalNotification * noti = [[UILocalNotification alloc]init];
    if (noti != nil) {
        //获取当前时间
        NSDate * now = [NSDate date];
        //让推送在10秒之后执行
        //设置推送开启时间
        noti.fireDate = now;
        //设置推送的循环次数 0表示不要重复
        noti.repeatInterval = 0;
        //设置推送的时区
        noti.timeZone = [NSTimeZone defaultTimeZone];
        //设置红点表示数目/98721
        noti.applicationIconBadgeNumber =num;
        //设置推送声音
        noti.soundName = sound;//也可以添加音频文件，但是文字类型有要求acr
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.2) {
            //使用iOS8.0以上的方法
            noti.alertTitle = title;
        }
        //推送的内容
        noti.alertBody = body;
        //设置用户点入推送之后所需操作的具体内容
        //noti.userInfo = @{@"URL":@"http://www.iqy.com/wanwan"};
        //开启推送
        [[UIApplication sharedApplication]scheduleLocalNotification:noti];
    }
}
-(void)AccountLoginViewWithLoginTime:(NSString *)loginTime
{
    CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
    main.buttonIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    updateBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    updateBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:updateBackgroundView];
    
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50*MCscale)];
    tabbarView.backgroundColor = [UIColor clearColor];
    [main.tabBar addSubview:tabbarView];
    
    accounView = [[AccountLoginView alloc]initWithFrame:CGRectMake(40*MCscale, 170*MCscale, kDeviceWidth-80*MCscale, 180*MCscale)];
    accounView.alpha = 0.95;
    accounView.accountDelegate = self;
    [accounView loadLabelTextContentWithLoginTime:loginTime];
    [self.view addSubview:accounView];
}

#pragma mark AccountLoginViewDelegate
-(void)AccountLoginViewButtonClickWithIndex:(NSInteger)index
{
    if (index == 0) {
        [updateBackgroundView removeFromSuperview];
        [accounView removeFromSuperview];
        [tabbarView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setValue:userSheBei_id forKey:@"userId"];
    }
    else
    {
        [updateBackgroundView removeFromSuperview];
        [accounView removeFromSuperview];
        [tabbarView removeFromSuperview];
        [self loginVC];
    }
}

#pragma mark 切换店铺的通知
-(void)qiehuandianpuNotiClick:(NSNotification *)noti
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:@"isFirst"]integerValue] == 1) dianpuID = user_dianpuId;
    else  dianpuID = user_qiehuandianpu;
    [def setValue:dianpuID forKey:@"dianpuqiehuan"];
    [self headReFreshing];
}
#pragma mark 导航栏显示
-(void)daohanglanHiddenClick
{
    [self.navigationController.navigationBar setHidden:NO];
    
    mainCollectionView.frame = CGRectMake(0,64, kDeviceWidth, kDeviceHeight - 49*MCscale-64);
    [self fuzhiNameAddRightImg];
    leftView.hidden = YES;
    rightView.hidden = YES;
}
-(void)fuzhiNameAddRightImg{
    nameLabel.text = user_dianpuName;
  
    if ([user_dianpuName length]>7) {
        nameLabel.text=[user_dianpuName substringWithRange:NSMakeRange(0, 7)];
       nameLabel.text= [nameLabel.text stringByAppendingString:@"."];
        nameLabel.width=MLwordFont_4*7+MLwordFont_4;
    }
    [nameLabel sizeToFit];
    nameLabel.centerX=nameLabel.superview.width/2;
    nameRight.left=nameLabel.right;
    [nameRight sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_gongGaoDic[@"renzheng"]]]];
}
#pragma mark 判断开户状态
-(void)kaihuPanduanNotiClick
{
    if ([isLogin integerValue] == 1) {
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"code":user_tel}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyuserkaifu.action" params:pram success:^(id json) {
            NSLog(@"kaihu%@",json);
            if ([[json valueForKey:@"kaihu"]integerValue] == 1) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha =1;
                    openView.alpha = 0.95;
                    [openView reloadKaifuData];
                    [self.view addSubview:maskView];
                    [self.view addSubview:openView];
                    [self.tabBarController.tabBar addSubview:bottomBackView];
                }];
            }
            [[NSUserDefaults standardUserDefaults]setValue:[json valueForKey:@"kaihu"] forKey:@"kaihu"];
        } failure:^(NSError *error) {
        }];
    }
}
#pragma mark 开户(KaihuDelegate)
-(void)OpenAnAccountWithIndex:(NSInteger)index
{
    if (index == 1000) {
        //拒绝
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            openView.alpha = 0;
            [openView removeFromSuperview];
            bottomBackView.alpha = 0;
            [bottomBackView removeFromSuperview];
        }];
    }
    else
    {
        //开户
        OpenAccountViewController *collectionVC = [[OpenAccountViewController alloc]init];
        collectionVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:collectionVC animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            openView.alpha = 0;
            [openView removeFromSuperview];
            bottomBackView.alpha = 0;
            [bottomBackView removeFromSuperview];
        }];
    }
}
-(void)xiala{
    double delayInSeconds = 0.3;
    __block CarFirstViewController* bself = self;
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
         dispatch_after(popTime, dispatch_get_main_queue(), ^{
    });
}
-(void)refresh
{
    //下拉刷新
    [mainCollectionView addHeaderWithTarget:self action:@selector(headReFreshing)];
    
    
    //上拉加载
    [mainCollectionView addFooterWithTarget:self action:@selector(footRefreshing)];
    mainCollectionView.headerPullToRefreshText = @"下拉刷新数据";
    mainCollectionView.headerReleaseToRefreshText = @"松开刷新";
    mainCollectionView.headerRefreshingText = @"拼命加载中";
    mainCollectionView.footerPullToRefreshText = @"上拉加载数据";
    mainCollectionView.footerReleaseToRefreshText = @"松开加载数据";
    mainCollectionView.footerRefreshingText = @"拼命加载中";
}
-(void)headReFreshing
{
    
    isRefresh = 1;
    loadType = 0;
    lastPage = 1;
    pageNum = 1;
    mainHeight = 275*MCscale;
    lineViewTop = 240*MCscale;
    
    [mainCollectionView removeFromSuperview];
    [headView removeFromSuperview];
    [btnArray removeAllObjects];
    [goodAry removeAllObjects];
    [scroImageAry removeAllObjects];
    [yingyongArray removeAllObjects];
    [rexiaoArray removeAllObjects];
    [rexiaoImageArray removeAllObjects];
    [leftView removeFromSuperview];
    [rightView removeFromSuperview];
    

    [self createCollectionView];
    [self addContent];
    [self relodCarData];
    [self getDianpuYingyongData];
    [self reloadScrollViewData];
    [self getAllShangpin];
    [self refresh];
    [self setNavigationItem];

    

    
    
    NSString * leftTitle=@"请点击定位";
    if (userLastAddress) {
        leftTitle = userLastAddress;
    }
    leftLabel.text = [NSString stringWithFormat:@"%@",leftTitle];
    NSString *xingStr =[NSString stringWithFormat:@"%@",leftLabel.text];
    CGSize xinSzie = [xingStr boundingRectWithSize:CGSizeMake(150*MCscale, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    leftLabel.frame = CGRectMake(33*MCscale, 0, xinSzie.width+6*MCscale, 30*MCscale);
    leftView.frame = CGRectMake(15*MCscale,25*MCscale, leftLabel.width + 40*MCscale, 30*MCscale);
}
-(void)footRefreshing
{
    isRefresh = 1;
    loadType = 1;
    pageNum ++;
    [self getAllShangpin];
}
-(void)endRefresh:(BOOL)success
{
    if (success) [mainCollectionView footerEndRefreshing];
    else [mainCollectionView headerEndRefreshing];
}
-(void)loadFootView
{
    if (isBotom == 1) {
        MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mHud.mode = MBProgressHUDModeCustomView;
        mHud.labelText = @"已经到底了";
        mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
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
    //            [self.navigationController pushViewController:loginVc animated:YES];
    [self presentViewController:navi animated:YES completion:^{
        //code;
    }];
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
