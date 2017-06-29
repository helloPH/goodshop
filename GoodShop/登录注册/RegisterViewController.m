//
//  RegisterViewController.m
//  GoodShop
//
//  Created by MIAO on 16/11/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "RegisterViewController.h"
#import "UseDirectionViewController.h"
#import "LBXScanView.h"
#import "SubLBXScanViewController.h"
#import "Header.h"
#import "shopListModel.h"
#import "MainScrollView.h"
#import "NearbyShopsViewController.h"
@interface RegisterViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate,UITextFieldDelegate,CLLocationManagerDelegate,MainScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *fujinDianpuArray;
@property(nonatomic,strong)NSString *longitude,*latitude,*city;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIButton *leftButton;
;

@end
@implementation RegisterViewController
{
    UITextField *telNumber,*phoneNumTextfiled,*codeFiled;//服务热线,手机号,验证码
    BOOL isAgree;//同意协议标记
    UIView *mask;//遮罩
    NSInteger timeSec;//
    UIView *newpasView;//设置密码
    UIView *iconBackView;
    UILabel *dianpuNameLabel;
    UIButton *sendCode,*regisBtn,*ScanBtn;
    NSString *dianpuID;
    MainScrollView *scrol;
//    UIImageView *caozuotishiImage;
    BOOL isHave;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDianpurexianNotiClick:) name:@"getDianpurexianNoti" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    isAgree = 0;
    timeSec = 120;
    isHave = 0;
    [self initNavigation];
    [self initSubViews];
    [self initMask];
    [self initNewPasView];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检测到您未开启定位,将由系统为您匹配店铺内容" preferredStyle:1];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.latitude=@"0";
            self.longitude=@"0";
            self.city=@"";
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
    }
    else{
        [self.locationManager startUpdatingLocation];
    }
    [self judgeTheFirst];
}
-(void)judgeTheFirst
{
    [self showGuideImageWithUrl:@"images/caozuotishi/zhucehd.png"];
//    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstZhuce"] integerValue] == 1) {
//        NSString *url = @"images/caozuotishi/zhucehd.png";
//        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
//        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
//        caozuotishiImage.userInteractionEnabled = YES;
//        caozuotishiImage.alpha = 0.9;
//        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
//        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
//        [caozuotishiImage addGestureRecognizer:imageTap];
//        [self.view addSubview:caozuotishiImage];
//    }
//}
//
//-(void)imageHidden
//{
//    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstZhuce"];
//    [caozuotishiImage removeFromSuperview];
}
-(NSString *)longitude
{
    if (!_longitude) {
        _longitude = @"0";
    }
    return _longitude;
}
-(NSString *)latitude
{
    if (!_latitude) {
        _latitude = @"0";
    }
    return _latitude;
}
-(NSString *)city
{
    if (!_city) {
        _city = @"";
    }
    return _city;
}
-(NSMutableArray *)fujinDianpuArray
{
    if (!_fujinDianpuArray) {
        _fujinDianpuArray = [[NSMutableArray alloc]init];
    }
    return _fujinDianpuArray;
}
-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精度
        [_locationManager setDistanceFilter:200];
    }
    return _locationManager;
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(void)initNavigation
{
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
    [leftbtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.title = @"注册";
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
//    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
//    self.navigationItem.leftBarButtonItem =leftbarBtn;
    
}
//-(void)popActon{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)loadScrolloview:(NSArray *)imgAry
{
    scrol = [[MainScrollView alloc]initWithFrame:CGRectMake(0, 0,140*MCscale, 100*MCscale)];
    scrol.scroDelegate = self;
    scrol.ViewTag = 2;
    scrol.center = CGPointMake(iconBackView.width/2.0,50*MCscale);
    [iconBackView addSubview:scrol];
    
    NSMutableArray *ImagArray = [NSMutableArray arrayWithCapacity:0];
    for (shopListModel *model in imgAry) {
        [ImagArray addObject:model.dianpuimage];
    }
    [scrol addImageViewForScrollViewWith:ImagArray];
}
-(void)initSubViews
{
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*MCscale, kDeviceWidth, 20)];
    tipLabel.font=[UIFont systemFontOfSize:MLwordFont_6];
    tipLabel.textColor=lineColor;
    tipLabel.text=@"滑动图片切换商铺";
    tipLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    iconBackView = [BaseCostomer viewWithFrame:CGRectMake(0,tipLabel.bottom,kDeviceWidth, 120*MCscale) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:iconBackView];
    
    dianpuNameLabel = [BaseCostomer labelWithFrame:CGRectMake(0,100*MCscale, iconBackView.width, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    [iconBackView addSubview:dianpuNameLabel];
    
    UIImageView *telImage = [BaseCostomer imageViewWithFrame:CGRectMake(20,iconBackView.bottom +40*MCscale, 22*MCscale, 20*MCscale) backGroundColor:[UIColor clearColor] image:@"验证码"];
    [self.view addSubview:telImage];
    telImage.hidden=YES;
    
    telNumber = [BaseCostomer textfieldWithFrame:CGRectMake(telImage.right+2*MCscale, iconBackView.bottom +35*MCscale, kDeviceWidth-120*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textBlackColor backGroundColor:[UIColor clearColor] textAlignment:0 keyboardType:UIKeyboardTypeNumberPad borderStyle:0 placeholder:@"请输入邀请码(选填)"];
    telNumber.delegate = self;
    [self.view addSubview:telNumber];
    telNumber.hidden=YES;
    
    ScanBtn = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth - 80*MCscale,iconBackView.bottom+2,100*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_3] textColor:naviBarTintColor backGroundColor:txtColors(248, 53, 74, 0) cornerRadius:3.0 text:@"扫码切换" image:@""];
    ScanBtn.centerX=kDeviceWidth/2;
    
    [ScanBtn addTarget:self action:@selector(changeRegisterStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ScanBtn];
    
    UIView *line1 = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale,telNumber.bottom+5*MCscale,  kDeviceWidth -20*MCscale, 1) backgroundColor:lineColor];
    [self.view addSubview:line1];
    line1.hidden=YES;
    
    UIImageView *phoneImage = [BaseCostomer imageViewWithFrame:CGRectMake(20,line1.bottom +20*MCscale, 22*MCscale, 22*MCscale) backGroundColor:[UIColor clearColor]  image:@"输入手机号"];
    [self.view addSubview:phoneImage];
    
    phoneNumTextfiled = [BaseCostomer textfieldWithFrame:CGRectMake(phoneImage.right, line1.bottom +15*MCscale, 190*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor blackColor] backGroundColor:[UIColor clearColor] textAlignment:0 keyboardType:UIKeyboardTypeNumberPad borderStyle:0 placeholder:@"请输入手机号(必填)"];
    phoneNumTextfiled.delegate = self;
    [self.view addSubview:phoneNumTextfiled];
    
    sendCode= [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth - 130*MCscale,phoneNumTextfiled.top,120*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:[UIColor whiteColor] backGroundColor:txtColors(248, 53, 74, 1) cornerRadius:3.0 text:@"发送验证码" image:@""];
    [sendCode addTarget:self action:@selector(changeRegisterStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendCode];
    
    UIView *line2 = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale, phoneNumTextfiled.bottom+5*MCscale, kDeviceWidth-20*MCscale, 1) backgroundColor:lineColor];
    [self.view addSubview:line2];
    
    UIImageView *codeImage = [BaseCostomer imageViewWithFrame:CGRectMake(20*MCscale,line2.bottom +20*MCscale, 20*MCscale, 22*MCscale) backGroundColor:[UIColor clearColor] image:@"输入验证码"];
    [self.view addSubview:codeImage];
    
    codeFiled = [BaseCostomer textfieldWithFrame:CGRectMake(codeImage.right, line2.bottom +15*MCscale, kDeviceWidth-120*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textBlackColor backGroundColor:[UIColor clearColor] textAlignment:0 keyboardType:UIKeyboardTypeNumberPad borderStyle:0 placeholder:@"请输入短信验证码"];
    [self.view addSubview:codeFiled];
    
    UIView *line3 = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale, codeFiled.bottom+5*MCscale, kDeviceWidth-20*MCscale, 1) backgroundColor:lineColor];
    [self.view addSubview:line3];
    regisBtn = [BaseCostomer buttonWithFrame:CGRectMake(20, line3.bottom +40*MCscale, kDeviceWidth-40*MCscale,35*MCscale) font:[UIFont systemFontOfSize:MLwordFont_11] textColor:[UIColor whiteColor] backGroundColor:txtColors(248, 53, 74, 1) cornerRadius:5.0 text:@"注册" image:@""];
    [regisBtn addTarget:self action:@selector(changeRegisterStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regisBtn];
    
    UIView *xieyiView = [BaseCostomer viewWithFrame:CGRectMake(30*MCscale, kDeviceHeight-40, kDeviceWidth-60*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:xieyiView];
    xieyiView.centerX = kDeviceWidth/2.0;
    
    UIImageView *agreeImage = [BaseCostomer imageViewWithFrame:CGRectMake(0, 6.5*MCscale, 17*MCscale, 17*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@"选中"];
    agreeImage.tag = 1001;
    [xieyiView addSubview:agreeImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeAction)];
    [xieyiView addGestureRecognizer:tap];
    //
    UILabel *xieyi = [BaseCostomer labelWithFrame:CGRectMake(agreeImage.right+5,4*MCscale, 115*MCscale, 22*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"我已经阅读并同意"];
    [xieyiView addSubview:xieyi];
    
    UILabel *xieyiCon = [BaseCostomer labelWithFrame:CGRectMake(xieyi.right+2, xieyi.top, 100*MCscale_1, 22*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:mainColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"妙店佳用户协议"];
    xieyiView.width=xieyiCon.right;
    xieyiView.centerX=kDeviceWidth/2;
    
    xieyiCon.userInteractionEnabled = YES;
    [xieyiView addSubview:xieyiCon];
    UITapGestureRecognizer *agreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userAgreement)];
    [xieyiCon addGestureRecognizer:agreeTap];
    UIView *line4 = [BaseCostomer viewWithFrame:CGRectMake(xieyiCon.left-1, xieyiCon.bottom-2, xieyiCon.width+2, 1) backgroundColor:mainColor];
    [xieyiView addSubview:line4];
    
    
    UIView * navi = [self.view viewWithTag:150];
    [self.view bringSubviewToFront:navi];
}

#pragma mark -- 定位Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    CLLocation * currLocation = locations[0];
    
    const double x_pi = M_PI * 3000.0 / 180.0;
    double bd_lon,bd_lat;
    //将 GCJ-02 坐标转换成 BD-09 坐标
    double x = currLocation.coordinate.longitude, y = currLocation.coordinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    bd_lon = z * cos(theta) + 0.0125;
    bd_lat = z * sin(theta) + 0.00625;
    self.latitude = [NSString stringWithFormat:@"%lf",bd_lat];
    self.longitude = [NSString stringWithFormat:@"%lf",bd_lon];
    CLLocation *sloccation = [[CLLocation alloc]initWithLatitude:bd_lat longitude:bd_lon];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:sloccation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            //获取当前城市
            CLPlacemark *mark = placemarks.firstObject;
            NSDictionary *dict = [mark addressDictionary];
            self.city = [dict objectForKey:@"City"];
            [self getFujinDianpuData];
        }
    }];
}
#pragma mark 获取附近店铺
-(void)getFujinDianpuData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.x":self.longitude,@"address.y":self.latitude,@"city":self.city}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"nearDianpu.action" params:pram success:^(id json) {
        NSLog(@"店铺列表%@",json);
        
        [HUD hide:YES];
        [self.fujinDianpuArray removeAllObjects];
        NSArray *ary = [json valueForKey:@"dianpuList"];
        if([[json valueForKey:@"massages"]integerValue]){
            [self promptMessageWithString:@"附近暂时没有店铺"];
        }
        if (ary.count >0) {
            for(NSDictionary *dc in ary){
                shopListModel *model = [[shopListModel alloc]init];
                [model setValuesForKeysWithDictionary:dc];
                if (self.fujinDianpuArray.count<10) {
                    [self.fujinDianpuArray addObject:model];
                }
                [self loadScrolloview:self.fujinDianpuArray];
            }
            
            shopListModel *model = self.fujinDianpuArray[0];
            dianpuNameLabel.text = model.dianpuname;
            [[NSUserDefaults standardUserDefaults]setValue:model.dianpuid forKey:@"dianpuqiehuan"];
            [self getDianpurexianWithIndex:1];
        }
    } failure:^(NSError *error) {
        [HUD hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}

-(void)initMask
{
    mask = [[UIView alloc]initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [mask addGestureRecognizer:tap];
}
//
#pragma mark 按钮点击事件
-(void)changeRegisterStyle:(UIButton *)button
{
    if (button == sendCode) {
        [self sendCodeAction];
    }
    else if(button == regisBtn)
    {
        [self regisAction];
    }
    else if(button == ScanBtn)
    {
        if (![self cameraPemission])
        {
            [self showError:@"没有摄像机权限"];
            return ;
        }
        [self QQStyleScan];
    }
}
#pragma mark 发送验证码
-(void)sendCodeAction
{
    BOOL isMatch = [BaseCostomer panduanPhoneNumberWithString:phoneNumTextfiled.text];
    if(isMatch){
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"user.tel":phoneNumTextfiled.text}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"showCode.action" params:pram success:^(id json) {
            NSLog(@"验证码%@",json);
            if ([[json valueForKey:@"massage"]integerValue] == 0) {
                [self promptMessageWithString:@"该手机号已注册过!"];
            }
            else if ([[json valueForKey:@"massage"]integerValue] == 1){
                [self timImngAction];
            }
            else{
                [self promptMessageWithString:@"手机号错误!"];
            }
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误!"];
        }];
    }
    else{
        [self promptMessageWithString:@"手机号格式错误"];
    }
}

#pragma mark 注册
-(void)regisAction
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![telNumber.text isEqualToString:@""]) {
        dianpuID = user_qiehuandianpu;
    }
    else
    {
        dianpuID = @"0";
    }
    NSString *strSysName;
    if (_isInvite) {
        strSysName = @"0";
    }
    else
    {
        strSysName = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    NSMutableDictionary *pram = [[NSMutableDictionary alloc] initWithDictionary:@{@"user.tel":phoneNumTextfiled.text,@"code":codeFiled.text,@"user.shebeiId":strSysName,@"user.defaultShequ":dianpuID,@"X":self.longitude,@"Y":self.latitude,@"city":self.city}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"userReg3.action" params:pram success:^(id json) {
        [Hud hide:YES];
        NSLog(@"注册%@",json);
        NSDictionary * dic = (NSDictionary * )json;
        if ([[dic objectForKey:@"massage"]intValue]==3){
            if (_isInvite) {
                NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuname":user_dianpuName,@"dianpuid":user_qiehuandianpu,@"userid":user_id,@"jieshouzhe":phoneNumTextfiled.text}];
                [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"faceToFace.action" params:pram success:^(id json) {
                } failure:^(NSError *error) {
                }];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"您的初始密码为123456" preferredStyle:1];
                UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:suerAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                [def setInteger:2 forKey:@"isLogin"];
                [def setValue:phoneNumTextfiled.text forKey:@"userTel"];
                [def setValue:@"123456" forKey:@"userPass"];
                [def setValue:[dic valueForKey:@"userid"] forKey:@"userId"];
                [def setValue:[json valueForKey:@"dianpuid"] forKey:@"dianpuId"];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"您的初始密码为123456是否重置" preferredStyle:1];
                NSString *title = @"发送验证码";
                sendCode.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_11];
                [sendCode setTitle:title forState:UIControlStateNormal];
                sendCode.backgroundColor = txtColors(248, 53, 74, 1);
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                timeSec =120;
                sendCode.enabled = YES;
                telNumber.text = @"";
                phoneNumTextfiled.text = @"";
                codeFiled.text = @"";
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self lognAction];
                }];
                UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    newpasView.alpha = 0.95;
                    [self.view addSubview:newpasView];
                }];
                [alert addAction:suerAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else if([[dic objectForKey:@"massage"]intValue]==2){
            [Hud hide:YES];
            [self promptMessageWithString:@"验证码错误"];
        }
        else if([[dic objectForKey:@"massage"]intValue]==0){
            [Hud hide:YES];
            [self promptMessageWithString:@"该手机号已注册过"];
        }
        else if([[dic objectForKey:@"massage"]intValue]==4){
            [Hud hide:YES];
            [self promptMessageWithString:@"手机号格式有误"];
        }
        else if([[dic objectForKey:@"massage"]intValue]==1){
            [Hud hide:YES];
            [self promptMessageWithString:@"手机号或验证码为空"];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
//登录
-(void)lognAction
{
    [UIView animateWithDuration:0.3 animations:^{
        newpasView.alpha = 0;
        [newpasView removeFromSuperview];
    }];
    
    NSString *pasdStr = [md5_password encryptionPassword:user_pass userTel:user_tel];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject:user_tel forKey:@"user.tel"];
    [jsonDict setObject:pasdStr forKey:@"user.password"];
    [jsonDict setObject:userSheBei_id forKey:@"user.shebeiId"];
    //    [jsonDict setObject:user_qiehuandianpu forKey:@"user.defaultShequ"];
    
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"login4.action" params:jsonDict success:^(id json) {
        NSLog(@"登录%@",json);
        
        NSDictionary * dic = (NSDictionary * )json;
        if ([[dic objectForKey:@"massage"]intValue]==2) {
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSString *usid = [NSString stringWithFormat:@"%@",[json objectForKey:@"userid"]];
            [def setValue:usid forKey:@"userId"];
            [def setInteger:1 forKey:@"isLogin"];
            [def setValue:[json objectForKey:@"xinrenli"] forKey:@"xinrenli"];
            [def setValue:[json valueForKey:@"dianpuname"] forKey:@"dianpuName"];
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"登录成功";
            mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            
            
            [self getRootViewController];
            
            NSNotification *userLoginNotification = [NSNotification notificationWithName:@"userLoginNotification" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:userLoginNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLoginNotification" object:nil];
            
            if ([[json valueForKey:@"canshu"] integerValue] == 1) {
                //denglulinshi.action
                [HTTPTool getWithUrlPath:HTTPWeb AndUrl:@"Denglulinshi.action" params:nil success:^(id json) {
                } failure:^(NSError *error) {
                    
                }];
            }
            
            NSNotification *kaihuPanduanNoti = [NSNotification notificationWithName:@"kaihuPanduanNoti" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:kaihuPanduanNoti];
            [[NSNotificationCenter defaultCenter]removeObserver:self];
            
        }
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"账号或密码错误";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

-(void)getRootViewController
{
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
                //                    [viewController presentViewController:navi animated:true completion:nil];
            }];
        }else {
            //                [viewController presentViewController:navi animated:true completion:nil];
        }
        NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
    }
}
-(void)initNewPasView
{
    newpasView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 200*MCscale)];
    newpasView.backgroundColor = [UIColor whiteColor];
    newpasView.layer.cornerRadius = 15.0;
    newpasView.layer.shadowRadius = 5.0;
    newpasView.layer.shadowOpacity = 0.5;
    newpasView.layer.shadowOffset = CGSizeMake(0, 0);
    NSArray *placeHolderArray = @[@"请输入新密码",@"确认新密码"];
    for (int i = 0; i<2; i++) {
        UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(10*MCscale, (20+55*i)*MCscale, newpasView.width-20*MCscale, 40*MCscale)];
        password.placeholder = placeHolderArray[i];
        password.textAlignment = NSTextAlignmentCenter;
        password.textColor = [UIColor blackColor];
        password.font = [UIFont systemFontOfSize:MLwordFont_2];
        password.backgroundColor = [UIColor clearColor];
        password.tag = i+1;
        [password setSecureTextEntry:YES];
        password.keyboardType = UIKeyboardTypeDefault;
        [newpasView addSubview:password];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5*MCscale, password.bottom+5*MCscale, newpasView.width-10*MCscale, 1)];
        line.backgroundColor = lineColor;
        [newpasView addSubview:line];
    }
    UILabel *saveBtnLb = [[UILabel alloc]initWithFrame:CGRectMake(0, newpasView.height-60*MCscale, (newpasView.width-2)/2.0, 40)];
    saveBtnLb.backgroundColor = [UIColor clearColor];
    saveBtnLb.textColor = [UIColor blackColor];
    saveBtnLb.textAlignment = NSTextAlignmentCenter;
    saveBtnLb.text = @"稍后再说";
    saveBtnLb.font = [UIFont systemFontOfSize:MLwordFont_2];
    saveBtnLb.userInteractionEnabled = YES;
    saveBtnLb.tag = 1001;
    [newpasView addSubview:saveBtnLb];
    UITapGestureRecognizer *saveTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savePasBtnAction:)];
    [saveBtnLb addGestureRecognizer:saveTap];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(newpasView.width/2.0, newpasView.height-68*MCscale, 1, 60*MCscale)];
    lineView.backgroundColor = lineColor;
    [newpasView addSubview:lineView];
    
    UILabel *cancelBtnLb = [[UILabel alloc]initWithFrame:CGRectMake(saveBtnLb.right+2, newpasView.height-60*MCscale, (newpasView.width-2)/2.0, 40)];
    cancelBtnLb.backgroundColor = [UIColor clearColor];
    cancelBtnLb.textColor = txtColors(255, 40, 48, 1);
    cancelBtnLb.text = @"确定提交";
    cancelBtnLb.textAlignment = NSTextAlignmentCenter;
    cancelBtnLb.font = [UIFont systemFontOfSize:MLwordFont_2];
    cancelBtnLb.userInteractionEnabled = YES;
    [newpasView addSubview:cancelBtnLb];
    cancelBtnLb.tag = 1002;
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savePasBtnAction:)];
    [cancelBtnLb addGestureRecognizer:cancelTap];
}
-(void)savePasBtnAction:(UITapGestureRecognizer *)tap
{
    UITextField *paswd = (UITextField *)[newpasView viewWithTag:1];
    UITextField *paswdagn = (UITextField *)[newpasView viewWithTag:2];
    if ([paswd.text isEqualToString:@"123456"]) {
        [MBProgressHUD promptWithString:@"密码过于简单,请设置其他密码!"];
        return;
    }
    
    
    if (![paswd.text isEqualToString:@""]) {
        if ([paswd.text isEqualToString:paswdagn.text]) {
            NSString *mdPasd = [md5_password encryptionPassword:@"-1" userTel:user_tel];
            NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"tel":user_id,@"yuanmima":mdPasd,@"xinmima":paswd.text}];
            [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"loginpwd1.action" params:pram success:^(id json) {
                NSDictionary *dic = (NSDictionary *)json;
                if ([[dic valueForKey:@"message"]integerValue]==1) {
                    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    mbHud.mode = MBProgressHUDModeText;
                    mbHud.labelText = @"密码修改成功";
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setInteger:2 forKey:@"isLogin"];
                    [def setValue:paswd.text forKey:@"userPass"];
                    [self performSelector:@selector(lognAction) withObject:self afterDelay:1.5];
                }
                else if ([[dic valueForKey:@"massage"]integerValue]==2){
                    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    mbHud.mode = MBProgressHUDModeText;
                    mbHud.labelText = @"原密码有误重新填写";
                    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                }
            } failure:^(NSError *error) {
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeText;
                mbHud.labelText = @"密码修改失败!请稍后再试";
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }];
        }
        else{
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeText;
            mbHud.labelText = @"两次密码不一致";
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    }
    else{
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"不能为空";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}

//定时器
-(void)timImngAction
{
    sendCode.backgroundColor = [UIColor grayColor];
    NSString *title = [NSString stringWithFormat:@"%lds后可再次发送",(long)timeSec];
    if (timeSec>=0) {
        timeSec--;
        [self performSelector:@selector(timImngAction) withObject:self afterDelay:1];
        sendCode.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
        sendCode.enabled = NO;
        [sendCode setTitle:title forState:UIControlStateNormal];
        [sendCode.titleLabel setTextAlignment:NSTextAlignmentRight];
    }
    else{
        NSString *title = @"发送验证码";
        sendCode.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
        [sendCode setTitle:title forState:UIControlStateNormal];
        [sendCode.titleLabel setTextAlignment:NSTextAlignmentCenter];
        sendCode.backgroundColor = txtColors(248, 53, 74, 1);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        timeSec =120;
        sendCode.enabled = YES;
    }
}
//同意协议
-(void)agreeAction
{
    UIImageView *image =(UIImageView *)[self.view viewWithTag:1001];
    if (isAgree == 0) {
        image.image = [UIImage imageNamed:@"选择"];
        isAgree = 1;
        regisBtn.enabled = NO;
        regisBtn.backgroundColor = txtColors(150, 150, 150, 1);
    }
    else{
        image.image = [UIImage imageNamed:@"选中"];
        isAgree = 0;
        regisBtn.enabled = YES;
        regisBtn.backgroundColor = txtColors(248, 53, 74, 1);
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
    vc.block=^(id data){
//        NSNotification * noti = [[NSNotification alloc]initWithName:@"" object:nil userInfo:@{@"dianpuid":[NSString stringWithFormat:@"%@",data]}];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getDianpurexianNoti" object:nil userInfo:@{@"dianpuid":[NSString stringWithFormat:@"%@",data]}];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    //    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    //    [window addSubview:vc.view];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

#pragma mark 根据扫描内容获取热线电话
-(void)getDianpurexianNotiClick:(NSNotification *)noti
{
    NSString * dianpuid = noti.userInfo[@"dianpuid"];
    [[NSUserDefaults standardUserDefaults]setValue:dianpuid forKey:@"dianpuqiehuan"];
    
    
    NSInteger index = 0;
    isHave = 0;
    for (shopListModel *model in self.fujinDianpuArray) {
        if ([[NSString stringWithFormat:@"%@",model.dianpuid] isEqualToString:dianpuid]) {
            dianpuNameLabel.text = model.dianpuname;
            [[NSUserDefaults standardUserDefaults]setValue:model.dianpuid forKey:@"dianpuqiehuan"];

            [scrol.mainScroll setContentOffset:CGPointMake(index*scrol.width, 0)];
            //设置pagecontrol显示哪一页
            scrol.pageControl.currentPage = index;
            isHave = 1;
        }
        index ++;
    }
    
    if (!isHave) {
        [self getDianpurexianWithIndex:2];
    }
}
-(void)getDianpurexianWithIndex:(NSInteger)index
{
    dianpuID = user_qiehuandianpu;
    
    NSMutableDictionary *pram = [[NSMutableDictionary alloc] initWithDictionary:@{@"dianpuid":dianpuID}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"getShanghurexianById.action" params:pram success:^(id json) {
        NSLog(@"热线电话%@",json);
        if ([[json valueForKey:@"message"]integerValue] == 0) {
            [self promptMessageWithString:@"邀请码错误或者店铺不存在"];
        }
        else
        {
            telNumber.text =[NSString stringWithFormat:@"%@",[json valueForKey:@"dianpurexian"]];
            [self getDianpuMessagesDataWithIndex:index];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark MainScrollviewDelagte(切换店铺)
-(void)changeDianpuIdWithIndex:(NSInteger)index
{
    shopListModel *model = self.fujinDianpuArray[index];
    dianpuNameLabel.text = model.dianpuname;
    [[NSUserDefaults standardUserDefaults]setValue:model.dianpuid forKey:@"dianpuqiehuan"];
    [self getDianpurexianWithIndex:1];
}

#pragma mark -- UITextFilerDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == phoneNumTextfiled) {
        [self getDianpuMessagesDataWithIndex:1];
    }
}
#pragma  mark  获取店铺信息
-(void)getDianpuMessagesDataWithIndex:(NSInteger)index
{
    if (![telNumber.text isEqualToString:@""]) {
        MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        Hud.mode = MBProgressHUDModeIndeterminate;
        Hud.delegate = self;
        Hud.labelText = @"请稍等...";
        [Hud show:YES];
        
        NSMutableDictionary *pram = [[NSMutableDictionary alloc] initWithDictionary:@{@"shanghurexian":telNumber.text}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"dianpuInfoByRexian.action" params:pram success:^(id json) {
            NSLog(@"店铺信息%@",json);
            
            [Hud hide:YES];
            if ([[json valueForKey:@"message"]integerValue] == 0) {
                [self promptMessageWithString:@"无可显示信息"];
                [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"dianpuqiehuan"];
            }
            else
            {
                if (index == 2) {
                    NSArray *imageArr = @[[NSString stringWithFormat:@"%@",[json valueForKey:@"dianpulogo"]]];
                    [scrol addImageViewForScrollViewWith:imageArr];
                }
                dianpuNameLabel.text = [json valueForKey:@"dianpuname"];
                [[NSUserDefaults standardUserDefaults]setValue:[json valueForKey:@"dianpuid"] forKey:@"dianpuqiehuan"];
            }
        } failure:^(NSError *error) {
            [Hud hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 11001){
        NSInteger leng = textField.text.length;
        NSInteger selectLeng = range.length;
        NSInteger replaceLeng = string.length;
        if (leng - selectLeng + replaceLeng > 11){
            return NO;
        }
        else
            return YES;
    }
    return YES;
}
-(void)userAgreement
{
    UseDirectionViewController *agrVC = [[UseDirectionViewController alloc]init];
    agrVC.pageUrl = [NSString stringWithFormat:@"%@gonggao/yonghuxieyi.jsp",HTTPHEADER];
    agrVC.titStr = @"妙店佳用户协议";
    agrVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:agrVC animated:YES];
}
-(void)btnAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)myTask
{
    sleep(1.5);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isHave = 0;
}
#pragma mark --键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    [self.view addSubview:mask];
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    [mask removeFromSuperview];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [telNumber resignFirstResponder];
    [codeFiled resignFirstResponder];
}
@end

