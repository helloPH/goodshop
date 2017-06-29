//
//  OpenAccountViewController.m
//  GoodYeWu
//
//  Created by MIAO on 16/11/15.
//  Copyright © 2016年 时元尚品. All rights reserved.
//
#import "OpenAccountViewController.h"
#import "ReviewSelectedView.h"
#import "AFNetworking.h"
#import "Header.h"
#import "AutographView.h"
#import "UseDirectionViewController.h"
#import "OnLinePayView.h"
#import "AbandonKaihuView.h"
#import "MapLocationViewController.h"
#import "QRCodeViewController.h"
@interface OpenAccountViewController ()<ReviewSelectedViewDelegate,MBProgressHUDDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,AutographViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate,AbandonKaihuViewDelegate,MapLocationViewControllerDelegate>
@property (nonatomic,strong)BMKLocationService* locService;
@property (nonatomic,strong)UIButton *leftButton,*rightButton;
@property (nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic,strong)UIView *industryView;//行业信息
@property (nonatomic,strong)UILabel *selectedIndustrLabel;
@property (nonatomic,strong)UIImageView *imageview1;

@end
//method not implement
@implementation OpenAccountViewController
{
//    UIImageView *caozuotishiImage;
    
    UIView *protocolView;
    UIImageView *protocolImage;
    UILabel *xieyiLabel;
    
    UIView *signView;
    UILabel *signLabel;
    UIImageView *signImageView;
    
    UIButton *submitBtn;
    UIView *maskView;
    UIView *mask;
    
    BOOL isMap,isAgree,ISImage,isFapiaoSel,isFapiao,isDianzi;//地图定位,同意协议,选择照片,发票选中,发票,电子
    
    NSString *hangyeID;
    ReviewSelectedView *selectedView;
    NSInteger imageViewTag;
    
    NSString *yingyezhizhao;
    NSString *suiwudengjizhen;
    
    NSMutableArray *selectedImageArray;
    NSString *dianpuID;
    AutographView *autoView;
    
    NSString *latitudeStr,*longitudeStr;
    NSString *city;
    NSArray *moneyArray;
    NSString  *kaihufeiStr,*chongzhiStr;
    
    OnLinePayView *rechargePopView;
    AbandonKaihuView *abandonView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RechargSuccess) name:@"RechargSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaymentFailure) name:@"PaymentFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLinePayViewHidden) name:@"onLinePayViewHidden" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    yingyezhizhao = @"";
    suiwudengjizhen = @"";
    hangyeID = @"";
    dianpuID = @"";
    latitudeStr = @"";
    longitudeStr = @"";
    city = @"";
    kaihufeiStr = chongzhiStr = @"";
    isMap = ISImage = isFapiaoSel = isFapiao = isDianzi = 0;
    isAgree = 1;
    
    selectedImageArray = [NSMutableArray arrayWithObjects:@{},@{},@{}, nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //    //初始化BMKLocationService
    [self.locService startUserLocationService];
    
    [self initSubviews];
    [self initMaskView];
    [self initMask];
    [self judgeTheFirst];
    [self setNavigationItem];
    [self getkaihuMessageData];
}

-(BMKLocationService *)locService
{
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //启动LocationService
    }
    return _locService;
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"加号按钮"];
        [_rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(void)setNavigationItem
{
    [self.navigationItem setTitle:@"创建开户"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem =rightItem;
}
-(void)judgeTheFirst
{
    [self showGuideImageWithUrl:@"images/caozuotishi/caogao.png"];
    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstkaihu"] integerValue] == 1) {
//        NSString *url = @"images/caozuotishi/caogao.png";
//        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPHEADER,url];
//        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
//        caozuotishiImage.alpha = 0.9;
//        caozuotishiImage.userInteractionEnabled = YES;
//        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
//        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
//        [caozuotishiImage addGestureRecognizer:imageTap];
//        [self.view addSubview:caozuotishiImage];
//    }
//}
//-(void)imageHidden
//{
//    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstkaihu"];
//    [caozuotishiImage removeFromSuperview];
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
        //滑动一页
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.contentSize = CGSizeMake(kDeviceWidth,kDeviceHeight +100*MCscale);
        //偏移量
        _mainScrollView.contentOffset = CGPointMake(0, 0);
        //竖直方向滑动
        _mainScrollView.alwaysBounceVertical = YES;
        //水平方向滑动
        _mainScrollView.alwaysBounceHorizontal = NO;
        //滑动指示器
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        //无法超过边界
        _mainScrollView.bounces = NO;
        //设置滑动时减速到0所用的时间
        _mainScrollView.decelerationRate  = 1;
        [_mainScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView)]];
    }
    return _mainScrollView;
}
-(void)initSubviews
{
    [self.view addSubview:self.mainScrollView];
    [self createUI];
}
-(void)createUI
{
    NSArray *titleArray = @[@"店铺名",@"行业",@"法人/联系人",@"联系/注册手机号",@"服务电话",@"定位签到点",@"店铺地址"];
    NSArray *placeHoldArray = @[@"请输入店铺名",@"",@"请输入法人/联系人",@"请输入联系/注册手机号",@"请输入服务电话",@"",@"请输入店铺地址"];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *label = [BaseCostomer labelWithFrame:CGRectMake(20*MCscale,40*MCscale*i+20*MCscale, 140*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:titleArray[i]];
        label.tag = 10000+i;
        label.userInteractionEnabled = YES;
        [self.mainScrollView addSubview:label];
        
        UIView *lineView = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale, label.bottom +5*MCscale, kDeviceWidth - 20*MCscale, 1) backgroundColor:lineColor];
        [self.mainScrollView addSubview:lineView];
        
        if (i == 0 ||i == 2 ||i == 4||i == 6) {
            UITextField *textField = [BaseCostomer textfieldWithFrame:CGRectMake(label.right,label.top, kDeviceWidth - 40*MCscale - 140*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors  backGroundColor:[UIColor clearColor] textAlignment:2 keyboardType:0 borderStyle:0 placeholder:placeHoldArray[i]];
            textField.delegate = self;
            [self.mainScrollView addSubview:textField];
            if (i== 4) {
                textField.keyboardType = UIKeyboardTypePhonePad;
            }
            textField.returnKeyType = UIReturnKeyDone;
            textField.tag = 11000+i;
        }
        else if (i == 3)
        {
            UILabel *telLabel = [BaseCostomer labelWithFrame:CGRectMake(label.right,label.top, kDeviceWidth - 40*MCscale - 140*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(231, 231, 231, 1) backgroundColor:[UIColor clearColor] textAlignment:2 numOfLines:1 text:user_tel];
            [self.mainScrollView addSubview:telLabel];
        }
        else if (i == 1)
        {
            [self.mainScrollView addSubview:self.industryView];
        }
        else
        {
            [self getLocationData];
        }
    }
    [self selectedImageData];
    [self setProtocolData];
    [self setSaveButtonData];
    [self setfapiaoSelView];
}

#pragma 行业信息
-(UIView *)industryView
{
    if (!_industryView) {
        UILabel *industrLabel = [self.mainScrollView viewWithTag:10001];
        _industryView = [BaseCostomer viewWithFrame:CGRectMake(industrLabel.right ,industrLabel.top, kDeviceWidth - 180*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
        
        UITapGestureRecognizer *industryTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
        [_industryView addGestureRecognizer:industryTap];
        [_industryView addSubview:self.selectedIndustrLabel];
        [_industryView addSubview:self.imageview1];
    }
    return _industryView;
}

-(UILabel *)selectedIndustrLabel
{
    if (!_selectedIndustrLabel) {
        _selectedIndustrLabel = [BaseCostomer labelWithFrame:CGRectMake(0, 0,self.industryView.width - 15*MCscale,30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:2 numOfLines:1 text:@"请选择行业类别"];
    }
    return _selectedIndustrLabel;
}
-(UIImageView *)imageview1
{
    if (!_imageview1) {
        _imageview1 = [BaseCostomer imageViewWithFrame:CGRectMake(self.industryView.width - 15*MCscale, 5*MCscale, 15*MCscale,20*MCscale) backGroundColor:[UIColor clearColor] image:@"下拉键"];
    }
    return _imageview1;
}

#pragma mark 定位坐标
-(void)getLocationData
{
    NSArray *locaArray = @[@"当前位置",@"地图定位"];
    UITextField *telTextField = [self.mainScrollView viewWithTag:11004];
    for (int i = 0; i<2; i++) {
        UIView *locationView = [BaseCostomer viewWithFrame:CGRectMake(100*MCscale*i +170*MCscale,telTextField.bottom +10*MCscale, 80*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
        locationView.tag = 12000+i;
        UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
        [locationView addGestureRecognizer:locationTap];
        [self.mainScrollView addSubview:locationView];
        
        UIImageView *locationImage = [BaseCostomer imageViewWithFrame:CGRectMake(0, 8*MCscale, 15*MCscale, 15*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@""];
        locationImage.tag = 13000+i;
        [locationView addSubview:locationImage];
        if (i == 0) {
            locationImage.image = [UIImage imageNamed:@"选中"];
        }
        else
        {
            locationImage.image = [UIImage imageNamed:@"选择"];
        }
        
        UILabel *locationLabel = [BaseCostomer labelWithFrame:CGRectMake(locationImage.right + 5*MCscale,5*MCscale, locationView.width - 17*MCscale, 20*MCscale) font: [UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:locaArray[i]];
        locationLabel.userInteractionEnabled = YES;
        [locationView addSubview:locationLabel];
    }
}
#pragma mark 选择照片
-(void)selectedImageData
{
    UITextField *addressTextField = [self.mainScrollView viewWithTag:11006];
    CGFloat imageWidth = (kDeviceWidth - 150*MCscale)/2;
    NSArray *imageArray = @[@"yingyezhizhao",@"shenfenzheng"];
    for (int i = 0; i<2; i++) {
        UIImageView *imageView = [BaseCostomer imageViewWithFrame:CGRectMake((imageWidth +50*MCscale)*i+50*MCscale , addressTextField.bottom +20*MCscale, imageWidth, imageWidth) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:imageArray[i]];
        imageView.tag = 1000+i;
        [self.mainScrollView addSubview:imageView];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
        [imageView addGestureRecognizer:imageTap];
    }
}

#pragma mark 开户协议
-(void)setProtocolData
{
    UIImageView *imageView = [self.mainScrollView viewWithTag:1000];
    protocolView = [BaseCostomer viewWithFrame:CGRectMake(20*MCscale,imageView.bottom +5*MCscale, kDeviceWidth - 40*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *protocoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
    [protocolView addGestureRecognizer:protocoTap];
    [self.mainScrollView addSubview:protocolView];
    
    protocolImage = [BaseCostomer imageViewWithFrame:CGRectMake(5*MCscale, 7*MCscale, 15*MCscale, 15*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@"选中"];
    [protocolView addSubview:protocolImage];
    
    UILabel *protocolLabel = [BaseCostomer labelWithFrame:CGRectMake(protocolImage.right + 5*MCscale,5*MCscale,100, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"我已阅读并同意"];
    [protocolView addSubview:protocolLabel];
    
    xieyiLabel = [BaseCostomer labelWithFrame:CGRectMake(protocolLabel.right,5*MCscale,188*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:mainColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"《妙店佳应用系统使用协议》"];
    xieyiLabel.userInteractionEnabled = YES;
    [protocolView addSubview:xieyiLabel];
    
    UITapGestureRecognizer *xieyiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
    [xieyiLabel addGestureRecognizer:xieyiTap];
    
    UIView *xieyiView = [BaseCostomer viewWithFrame:CGRectMake(xieyiLabel.left, xieyiLabel.bottom, xieyiLabel.width, 1) backgroundColor:mainColor];
    [protocolView addSubview:xieyiView];
}
#pragma mark 乙方签名及提交按钮
-(void)setSaveButtonData
{
    signView = [BaseCostomer viewWithFrame:CGRectMake(20*MCscale, protocolView.bottom, kDeviceWidth - 40*MCscale, 40*MCscale) backgroundColor:[UIColor clearColor]];
    [self.mainScrollView addSubview:signView];
    UITapGestureRecognizer *signViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signViewTapClick:)];
    [signView addGestureRecognizer:signViewTap];
    
    signLabel = [BaseCostomer labelWithFrame:CGRectMake(5*MCscale, 5*MCscale, 100*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"乙方签名:"];
    [signView addSubview:signLabel];
    
    signImageView = [BaseCostomer imageViewWithFrame:CGRectMake(signLabel.right +5*MCscale,0,80*MCscale,40*MCscale) backGroundColor:[UIColor clearColor] image:@""];
    [signView addSubview:signImageView];
    
    moneyArray = @[@"创建账户费用合计:",@"体验奖励:",@"充值金额:"];
    for (int i = 0; i<3; i++) {
        UILabel *titleLabel = [BaseCostomer labelWithFrame:CGRectMake(20*MCscale,20*MCscale*i +signView.bottom +10*MCscale, kDeviceWidth - 40*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:moneyArray[i]];
        titleLabel.tag = 15000+i;
        [self.mainScrollView addSubview:titleLabel];
    }
    
#pragma mark 提交按钮
    submitBtn = [BaseCostomer buttonWithFrame:CGRectMake(20*MCscale,signView.bottom+90*MCscale, kDeviceWidth - 40*MCscale, 40*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:txtColors(213, 213, 213, 1) cornerRadius:5 text:@"创建开户" image:@""];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    submitBtn.enabled = NO;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:submitBtn];
}

#pragma mark 发票信息
-(void)setfapiaoSelView
{
    UIView *fapiaoSelView = [BaseCostomer viewWithFrame:CGRectMake(20*MCscale,submitBtn.bottom +10*MCscale, 80*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
    fapiaoSelView.tag = 12002;
    UITapGestureRecognizer *fapiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
    [fapiaoSelView addGestureRecognizer:fapiaoTap];
    [self.mainScrollView addSubview:fapiaoSelView];
    
    UIImageView *fapiaoImage = [BaseCostomer imageViewWithFrame:CGRectMake(0, 8*MCscale, 15*MCscale, 15*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@"选择"];
    fapiaoImage.tag = 13002;
    [fapiaoSelView addSubview:fapiaoImage];
    
    UILabel *fapiaoLabel = [BaseCostomer labelWithFrame:CGRectMake(fapiaoImage.right + 5*MCscale,5*MCscale, fapiaoSelView.width - 17*MCscale, 20*MCscale) font: [UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"发票"];
    fapiaoLabel.userInteractionEnabled = YES;
    [fapiaoSelView addSubview:fapiaoLabel];
    
    for (int i = 0; i<3; i++) {
        UIView *fapiaoLine1 = [BaseCostomer viewWithFrame:CGRectMake(20*MCscale,40*MCscale*i+ fapiaoSelView.bottom, kDeviceWidth - 40*MCscale, 0.5) backgroundColor:lineColor];
        fapiaoLine1.tag = 14000+i;
        fapiaoLine1.hidden = YES;
        [self.mainScrollView addSubview:fapiaoLine1];
    }
    
    NSArray *fapiaoArray = @[@"收据",@"发票",@"邮寄",@"电子"];
    NSInteger btnCount = 0;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            UIView *View = [BaseCostomer viewWithFrame:CGRectMake(150*MCscale*j +40*MCscale,40*MCscale*i + fapiaoSelView.bottom +5*MCscale, 80*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
            View.hidden = YES;
            View.tag = 12003+btnCount;
            UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
            [View addGestureRecognizer:locationTap];
            [self.mainScrollView addSubview:View];
            
            UIImageView *Image = [BaseCostomer imageViewWithFrame:CGRectMake(0, 8*MCscale, 15*MCscale, 15*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@""];
            Image.tag = 13003+btnCount;
            [View addSubview:Image];
            if (j == 0) {
                Image.image = [UIImage imageNamed:@"选中"];
            }
            else
            {
                Image.image = [UIImage imageNamed:@"选择"];
            }
            
            UILabel *Label = [BaseCostomer labelWithFrame:CGRectMake(Image.right + 5*MCscale,5*MCscale, View.width - 17*MCscale, 20*MCscale) font: [UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:fapiaoArray[btnCount]];
            Label.userInteractionEnabled = YES;
            [View addSubview:Label];
            btnCount ++;
        }
    }
}

#pragma mark 获取开户信息
-(void)getkaihuMessageData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.mainScrollView animated:YES];
    mbHud.delegate = self;
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    [mbHud show:YES];
    
    NSLog(@"%@",user_tel);
    
    NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:@{@"code":user_tel}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbykaihuxianshi.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"开户信息%@",json);
        if ([[json valueForKey:@"massages"] integerValue] != 0) {
            kaihufeiStr = [NSString stringWithFormat:@"%@",[json valueForKey:@"kaihufeiyong"]];
            chongzhiStr = [NSString stringWithFormat:@"%@",[json valueForKey:@"chongzhi"]];
            moneyArray = @[[NSString stringWithFormat:@"创建账户费用合计: %.2f",[[json valueForKey:@"kaihufeiyong"] floatValue]],[NSString stringWithFormat:@"体验奖励: %.2f",[[json valueForKey:@"yue"] floatValue]],[NSString stringWithFormat:@"充值金额: %.2f",[[json valueForKey:@"chongzhi"] floatValue]]];
            for (int i = 0; i<3; i++) {
                UILabel *titleLabel = [self.mainScrollView viewWithTag:15000+i];
                titleLabel.text = moneyArray[i];
            }
            UITextField *storyNameTextField = [self.mainScrollView viewWithTag:11000];
            storyNameTextField.text = json[@"dianpu"];
            self.selectedIndustrLabel.text = [NSString stringWithFormat:@"%@",json[@"name"]];
            hangyeID = json[@"nameid"];
        }
    } failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误1"];
    }];
}

-(void)initMaskView
{
    maskView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight +50*MCscale) backgroundColor:[UIColor clearColor]];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
    
    selectedView = [[ReviewSelectedView  alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale)];
    selectedView.selectedDelegate = self;
    
    //放弃开户
    abandonView = [[AbandonKaihuView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 180*MCscale)];
    abandonView.abandonDelegate = self;
    
    autoView = [[AutographView alloc]initWithFrame:CGRectMake(60*MCscale, 200*MCscale, kDeviceWidth - 120*MCscale, 200*MCscale)];
    
    rechargePopView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale)];
}
-(void)initMask
{
    mask = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight +50*MCscale) backgroundColor:txtColors(83,83,83,0.5)];
    mask.alpha = 0;
    autoView = [[AutographView alloc]initWithFrame:CGRectMake(30*MCscale, 200*MCscale, kDeviceWidth - 60*MCscale, 200*MCscale)];
    autoView.autoDelegate = self;
}

-(UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil)
    {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return _imagePicker;
}
#pragma mark 上传照片
-(void)imageTapClick:(UITapGestureRecognizer *)tap
{
    imageViewTag = tap.view.tag;
    if (imageViewTag == 1000)  yingyezhizhao = @"yingyezhizhao.png";
    else if (imageViewTag == 1001) suiwudengjizhen = @"shenfenzheng.png";
    
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancalAction];
    [alert addAction:otherAction];
    [alert addAction:cleAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImageView *imageView = [self.mainScrollView viewWithTag:imageViewTag];
        imageView.image = image;
        ISImage = 1;
        NSString *imageName;
        if (imageViewTag == 1000) imageName = @"yingyezhizhao.png";
        else if (imageViewTag == 1001) imageName = @"shenfenzheng.png";
        
        NSDictionary *dict = @{@"imageName":imageName,@"image":image};
        [selectedImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqual:@{}]) {
                if ([dict[@"imageName"] isEqualToString:@"yingyezhizhao.png"]) {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:0 withObject:dict];
                    }
                }
                else if([dict[@"imageName"] isEqualToString:@"shenfenzheng.png"])
                {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:1 withObject:dict];
                    }
                }
            }
            else
            {
                if ([dict[@"imageName"] isEqualToString:@"yingyezhizhao.png"]) {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:0 withObject:dict];
                    }
                }
                else if([dict[@"imageName"] isEqualToString:@"shenfenzheng.png"])
                {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:1 withObject:dict];
                    }
                }
            }
        }];
        NSLog(@"%@selectedImageArray",selectedImageArray);
    }];
}
-(void)submitBtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        rechargePopView.alpha = 0.95;
        maskView.alpha = 1;
        [self.view addSubview:maskView];
        rechargePopView.isFrom = 4;
        rechargePopView.isFromSure = 1;
        rechargePopView.moneyTextFiled.text =  [NSString stringWithFormat:@"%.2f",[chongzhiStr floatValue]];
        rechargePopView.shouldMoney =  [NSString stringWithFormat:@"%.2f",[chongzhiStr floatValue]];
        rechargePopView.yueZhifu.text = @"暂无更多充值方式";
        [self.view addSubview:rechargePopView];
    }];
}
#pragma mark 充值成功的通知
-(void)RechargSuccess
{
    [self promptSuccessWithString:@"充值成功"];
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        rechargePopView.alpha = 0;
        [rechargePopView removeFromSuperview];
    }];
    [self FabuKaihu];
    
}
-(void)PaymentFailure
{
    [self promptMessageWithString:@"支付失败"];
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        rechargePopView.alpha = 0;
        [rechargePopView removeFromSuperview];
    }];
}
//接收隐藏弹框的通知
-(void)onLinePayViewHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        rechargePopView.alpha = 0;
        [rechargePopView removeFromSuperview];
    }];
}
#pragma mark 发布开户
-(void)FabuKaihu
{
    UITextField *storyNameTextField = [self.mainScrollView viewWithTag:11000];
    UITextField *nameTextField = [self.mainScrollView viewWithTag:11002];
    UITextField *telTextField = [self.mainScrollView viewWithTag:11004];
    UITextField *addressTextField = [self.mainScrollView viewWithTag:11006];
    
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.mainScrollView animated:YES];
    mbHud.delegate = self;
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    [mbHud show:YES];
    
    NSString *fapiaoCode;
    NSArray *fapiaoArr = @[@"收据",@"发票"];
    NSArray *youjiArr = @[@"邮寄",@"电子"];
    if (isFapiaoSel) {
        fapiaoCode = [NSString stringWithFormat:@"%@,%@",fapiaoArr[isFapiao],youjiArr[isDianzi]];
    }
    else
    {
        fapiaoCode = @"0";
    }
    
    NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:@{@"dianpu.dianpuname":storyNameTextField.text,@"dianpu.suozaihangyi":hangyeID,@"dianpu.dianpuleixing":[NSString stringWithFormat:@"%d",isMap],@"dianpu.x":longitudeStr,@"dianpu.y":latitudeStr,@"dianpu.lianxiren":nameTextField.text,@"dianpu.yidongtel":user_tel,@"dianpu.kefurexian":telTextField.text,@"dianpu.dingweidizhi":addressTextField.text,@"dianpu.yingyezhizhao":yingyezhizhao,@"dianpu.suiwudengjizhen":suiwudengjizhen,@"dianpu.kaihufei":kaihufeiStr,@"dianpu.shifoukaitonghoutai":city,@"code":fapiaoCode}];
    
    [HTTPTool  postWithUrlPath:HTTPHEADER AndUrl:@"savekaihuyuangong.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"开户%@",json);
        if ([[json valueForKey:@"message"]integerValue] == 1) {
            dianpuID = [NSString stringWithFormat:@"%@",[json valueForKey:@"dianpuid"]];
            [self upLoadImages];
        }
        else
        {
            [self promptMessageWithString:@"请将开户信息填写完整后重试"];
        }
    } failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误3"];
    }];
}

#pragma mark 上传图片
-(void)upLoadImages
{
    NSLog(@"selectedImageArrayselectedImageArray%@",selectedImageArray);
    NSInteger dictCount=0;
    for (NSDictionary *dict in selectedImageArray) {
        dictCount++;
        UIImage *image = dict[@"image"];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":[NSString stringWithFormat:@"%@",dianpuID]}];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        //网络延时设置15秒
        manger.requestSerializer.timeoutInterval = 15;
        NSString *url = @"fileuploadDianpuInfo.action";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
        [manger POST:urlPath parameters:pram constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            if (![dict isEqual:@{}]) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                NSString *fileName = [NSString stringWithFormat:@"%@",dict[@"imageName"]];
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            }
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (dictCount == 3) {
                NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"code":dianpuID}];
                // 1.获取AFN的请求管理者
                [HTTPTool getWithUrlPath:HTTPWeb AndUrl:@"savekaihuerweima.action" params:pram success:^(id json) {
                    if ([[json valueForKey:@"massages"]integerValue] == 1) {
                        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"kaihu"];
                        [self promptSuccessWithString:@"开户成功"];
                        [[NSUserDefaults standardUserDefaults]setValue:dianpuID forKey:@"dianpuId"];
                        QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc]init];
                        QRCodeVC.hidesBottomBarWhenPushed = YES;
                        QRCodeVC.viewTag = 1;
                        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                        bar.title=@"";
                        self.navigationItem.backBarButtonItem=bar;
                        [self.navigationController pushViewController:QRCodeVC animated:YES];
                    }
                } failure:^(NSError *error) {
                }];
            }
            [self clernDataForKaihu];
            NSNotification *qingchuSign = [NSNotification notificationWithName:@"qingchuSignClick" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:qingchuSign];
            [[NSNotificationCenter defaultCenter]removeObserver:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}
#pragma mark 清空数据
-(void)clernDataForKaihu
{
    UITextField *storyNameTextField = [self.mainScrollView viewWithTag:11000];
    UITextField *nameTextField = [self.mainScrollView viewWithTag:11002];
    UITextField *telTextField = [self.mainScrollView viewWithTag:11004];
    UITextField *addressTextField = [self.mainScrollView viewWithTag:11006];
    
    nameTextField.text = @"";
    storyNameTextField.text = @"";
    telTextField.text = @"";
    addressTextField.text = @"";
    
    self.selectedIndustrLabel.text = @"请选择行业类别";
    UIView *locationView = [self.mainScrollView viewWithTag:12000];
    UIImageView *locationImage = [locationView viewWithTag:13000];
    UIView *mapView = [self.mainScrollView viewWithTag:12001];
    UIImageView *mapImage = [mapView viewWithTag:13001];
    locationImage.image = [UIImage imageNamed:@"选中"];
    mapImage.image = [UIImage imageNamed:@"选择"];
    isMap = ISImage = isFapiaoSel = 0;
    
    kaihufeiStr = @"";
    hangyeID = @"";
    latitudeStr = @"";
    longitudeStr = @"";
    city = @"";
    signImageView.image = [UIImage imageNamed:@""];
    submitBtn.enabled = NO;
    submitBtn.backgroundColor = txtColors(213, 213, 213, 1);
    
    UIView *fapiaoSelView = [self.mainScrollView viewWithTag:12002];
    UIImageView *fapiaoSelImage = [fapiaoSelView viewWithTag:13002];
    
    UIView *shoujuView = [self.mainScrollView viewWithTag:12003];
    UIView *fapiaoView = [self.mainScrollView viewWithTag:12004];
    UIView *youjiView = [self.mainScrollView viewWithTag:12005];
    UIView *dianziView = [self.mainScrollView viewWithTag:12006];
    
    fapiaoSelImage.image = [UIImage imageNamed:@"选择"];
    shoujuView.hidden = YES;
    fapiaoView.hidden = YES;
    youjiView.hidden = YES;
    dianziView.hidden = YES;
    
    for (int i = 0; i<3; i++) {
        UIView *fapiaoLine = [self.mainScrollView viewWithTag:14000+i];
        fapiaoLine.hidden = YES;
    }
    
    NSArray *imageArray = @[@"yingyezhizhao",@"shenfenzheng"];
    for (int i = 0; i<imageArray.count; i++) {
        UIImageView *image = (UIImageView *)[self.mainScrollView viewWithTag:(1000+i)];
        image.image = [UIImage imageNamed:imageArray[i]];
    }
    [selectedImageArray replaceObjectAtIndex:0 withObject:@{}];
    [selectedImageArray replaceObjectAtIndex:1 withObject:@{}];
    [selectedImageArray replaceObjectAtIndex:2 withObject:@{}];
}

#pragma mark 手动签名
-(void)signViewTapClick:(UITapGestureRecognizer *)tap
{
    UITextField *storyNameTextField = [self.mainScrollView viewWithTag:11000];
    UITextField *nameTextField = [self.mainScrollView viewWithTag:11002];
    UITextField *telTextField = [self.mainScrollView viewWithTag:11004];
    UITextField *addressTextField = [self.mainScrollView viewWithTag:11006];
    
    if ([storyNameTextField.text isEqualToString:@""]||[self.selectedIndustrLabel.text isEqualToString:@"请选择行业类别"]||[nameTextField.text isEqualToString:@""]||[telTextField.text isEqualToString:@""]||[addressTextField.text isEqualToString:@""]||[longitudeStr isEqualToString:@""]||[latitudeStr isEqualToString:@""]){
        [self promptMessageWithString:@"请完善信息后重试"];
    }
    else if(ISImage == 0)
    {
        [self promptMessageWithString:@"请上传营业执照或者身份证照片"];
    }
    else
    {
        if (tap.view  == signView) {
            if (isAgree) {
                //签名
                [UIView animateWithDuration:0.3 animations:^{
                    mask.alpha = 1;
                    [self.view addSubview:mask];
                    autoView.alpha = 1;
                    [self.view addSubview:autoView];
                }];
            }
            else
            {
                [self promptMessageWithString:@"请阅读并同意开户协议"];
            }
        }
    }
}

#pragma mark 视图点击事件
-(void)viewTapClick:(UITapGestureRecognizer *)tap
{
    UIView *locationView = [self.mainScrollView viewWithTag:12000];
    UIImageView *locationImage = [locationView viewWithTag:13000];
    
    UIView *mapView = [self.mainScrollView viewWithTag:12001];
    UIImageView *mapImage = [mapView viewWithTag:13001];
    
    UIView *fapiaoSelView = [self.mainScrollView viewWithTag:12002];
    UIImageView *fapiaoSelImage = [fapiaoSelView viewWithTag:13002];
    
    UIView *shoujuView = [self.mainScrollView viewWithTag:12003];
    UIImageView *shoujuImage = [shoujuView viewWithTag:13003];
    
    UIView *fapiaoView = [self.mainScrollView viewWithTag:12004];
    UIImageView *fapiaoImage = [fapiaoView viewWithTag:13004];
    
    UIView *youjiView = [self.mainScrollView viewWithTag:12005];
    UIImageView *youjiImage = [youjiView viewWithTag:13005];
    
    UIView *dianziView = [self.mainScrollView viewWithTag:12006];
    UIImageView *dianziImage = [dianziView viewWithTag:13006];
    
    if(tap.view == self.industryView)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self.view addSubview:maskView];
            selectedView.alpha = 0.95;
            [selectedView reloadDataWithViewTag:2];
            [self.view addSubview:selectedView];
        }];
    }
    else if (tap.view == locationView)
    {
        locationImage.image = [UIImage imageNamed:@"选中"];
        mapImage.image = [UIImage imageNamed:@"选择"];
        isMap = 0;
        [_locService startUserLocationService];
    }
    else if (tap.view == mapView)
    {
        locationImage.image = [UIImage imageNamed:@"选择"];
        mapImage.image = [UIImage imageNamed:@"选中"];
        isMap = 1;
        
        MapLocationViewController *MapVC = [[MapLocationViewController  alloc]init];
        MapVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:MapVC animated:YES];
    }
    else if (tap.view == fapiaoSelView)
    {
        isFapiaoSel = !isFapiaoSel;
        if (isFapiaoSel) {
            fapiaoSelImage.image = [UIImage imageNamed:@"选中"];
            shoujuView.hidden = NO;
            fapiaoView.hidden = NO;
            youjiView.hidden = NO;
            dianziView.hidden = NO;
            
            fapiaoImage.image = [UIImage imageNamed:@"选择"];
            shoujuImage.image = [UIImage imageNamed:@"选中"];
            youjiImage.image = [UIImage imageNamed:@"选中"];
            dianziImage.image = [UIImage imageNamed:@"选择"];
            isFapiao = isDianzi = 0;
            for (int i = 0; i<3; i++) {
                UIView *fapiaoLine = [self.mainScrollView viewWithTag:14000+i];
                fapiaoLine.hidden = NO;
            }
        }
        else
        {
            fapiaoSelImage.image = [UIImage imageNamed:@"选择"];
            shoujuView.hidden = YES;
            fapiaoView.hidden = YES;
            youjiView.hidden = YES;
            dianziView.hidden = YES;
            
            for (int i = 0; i<3; i++) {
                UIView *fapiaoLine = [self.mainScrollView viewWithTag:14000+i];
                fapiaoLine.hidden = YES;
            }
        }
    }
    else if (tap.view == fapiaoView)
    {
        isFapiao = 1;
        fapiaoImage.image = [UIImage imageNamed:@"选中"];
        shoujuImage.image = [UIImage imageNamed:@"选择"];
    }
    else if (tap.view == shoujuView)
    {
        isFapiao = 0;
        fapiaoImage.image = [UIImage imageNamed:@"选择"];
        shoujuImage.image = [UIImage imageNamed:@"选中"];
    }
    else if (tap.view == youjiView)
    {
        isDianzi = 0;
        youjiImage.image = [UIImage imageNamed:@"选中"];
        dianziImage.image = [UIImage imageNamed:@"选择"];
    }
    else if (tap.view == dianziView)
    {
        isDianzi = 1;
        dianziImage.image = [UIImage imageNamed:@"选中"];
        youjiImage.image = [UIImage imageNamed:@"选择"];
    }
    else if (tap.view ==  protocolView)
    {
        isAgree = !isAgree;
        if (isAgree) {
            protocolImage.image = [UIImage imageNamed:@"选中"];
        }
        else{
            protocolImage.image = [UIImage imageNamed:@"选择"];
        }
    }
    else if (tap.view == xieyiLabel)
    {
        UseDirectionViewController *agr = [[UseDirectionViewController alloc]init];
        //        if (isModify) {
        //            agr.pageUrl = [NSString stringWithFormat:@"%@/useXieyi.action?dianpuid=%@",HTTPWeb,dianpuID];
        //        }
        //        else
        //        {
        agr.pageUrl = [NSString stringWithFormat:@"%@useXieyi.action",HTTPWeb];
        agr.titStr = @"妙店佳应用系统使用协议";
        agr.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        //                    bar.image = [UIImage imageNamed:@"返回"];
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:agr animated:YES];
    }
}

#pragma mark btnAction
-(void)btnAction:(UIButton *)btn
{
    if (btn == self.leftButton) {
        CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
        [main setSelectedIndex:2];
        main.buttonIndex = 2;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self.view addSubview:maskView];
            abandonView.alpha = 1;
            [self.view addSubview:abandonView];
        }];
    }
}
//
////实现相关delegate 处理位置信息更新
////处理方向变更信息
#pragma mark BMKLocationDelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    latitudeStr = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    longitudeStr = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    //普通态
    CLLocation *sloccation = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:sloccation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            //获取当前城市
            CLPlacemark *mark = placemarks.firstObject;
            NSDictionary *dict = [mark addressDictionary];
            NSLog(@"%@",dict);
            city = [dict objectForKey:@"City"];
            
        }
    }];
}

#pragma mark ReviewSelectedViewDelegate(选择行业)
-(void)selectedHangyeWithHangyeName:(NSString *)hangyeName AndID:(NSString *)ID
{
    self.selectedIndustrLabel.text = hangyeName;
    hangyeID = ID;
    [self maskViewDisMiss];
}
#pragma mark AutographViewDelegate(签名)
-(void)setImageWithIndex:(NSInteger)index WithDict:(NSDictionary *)dict
{
    NSLog(@"dddddddddd%@",dict);
    if (index == 0) {
        NSData *imageData = UIImageJPEGRepresentation(dict[@"image"], 0.9);
        if (![dict isEqual:@{}]) {
            submitBtn.enabled = YES;
            submitBtn.backgroundColor = txtColors(250, 54, 71, 1);
            signImageView.image = [UIImage imageWithData:imageData];
            NSDictionary *dict111 = @{@"imageName":@"qianming.png",@"image":dict[@"image"]};
            [selectedImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqual:@{}]) {
                    if ([dict111[@"imageName"] isEqualToString:@"qianming.png"]) {
                        *stop = YES;
                        if (*stop == YES)
                        {
                            [selectedImageArray replaceObjectAtIndex:2 withObject:dict111];
                        }
                    }
                }
                else
                {
                    if ([dict111[@"imageName"] isEqualToString:@"qianming.png"]) {
                        *stop = YES;
                        if (*stop == YES)
                        {
                            [selectedImageArray replaceObjectAtIndex:2 withObject:dict111];
                        }
                    }
                }
            }];
            NSLog(@"selectedImageArray%@",selectedImageArray);
        }
        else
        {
            submitBtn.enabled = NO;
            submitBtn.backgroundColor = txtColors(213, 213, 213, 1);
        }
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            [self.view endEditing:YES];
            autoView.alpha = 0;
            [autoView removeFromSuperview];
            self.mainScrollView.alwaysBounceVertical = YES;
        }];
    }
    else if (index == 2)
    {
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            [self.view endEditing:YES];
            autoView.alpha = 0;
            [autoView removeFromSuperview];
            self.mainScrollView.alwaysBounceVertical = YES;
        }];
    }
}

#pragma mark 地图定位 (MapLocationViewContrllerDelegate)
-(void)selectedLocationWithWict:(NSDictionary *)dict
{
    longitudeStr = dict[@"longitude"];
    latitudeStr = dict[@"latitude"];
    city = dict[@"city"];
}
#pragma mark 撤销成功(AbandonDelegate)
-(void)abandonKaihuSuccess
{
    [self promptSuccessWithString:@"撤销成功"];
    [self maskViewDisMiss];
    CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
    [main setSelectedIndex:2];
    main.buttonIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma scrollView 失去焦点
- (void)tapScrollView
{
    [self.view endEditing:YES];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        selectedView.alpha = 0;
        [selectedView removeFromSuperview];
        abandonView.alpha = 0;
        [abandonView removeFromSuperview];
    }];
}
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *storyNameTextField = [self.mainScrollView viewWithTag:11000];
    UITextField *nameTextField = [self.mainScrollView viewWithTag:11002];
    UITextField *telTextField = [self.mainScrollView viewWithTag:11004];
    UITextField *addressTextField = [self.mainScrollView viewWithTag:11006];
    
    [storyNameTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [telTextField resignFirstResponder];
    [addressTextField resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITextField *storyNameTextField = [self.mainScrollView viewWithTag:11000];
    UITextField *nameTextField = [self.mainScrollView viewWithTag:11002];
    UITextField *telTextField = [self.mainScrollView viewWithTag:11004];
    UITextField *addressTextField = [self.mainScrollView viewWithTag:11006];
    
    [storyNameTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [telTextField resignFirstResponder];
    [addressTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.mainScrollView animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)promptSuccessWithString:(NSString *)string
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.mainScrollView animated:YES];
    mbHud.mode = MBProgressHUDModeCustomView;
    mbHud.labelText = string;
    mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1.5);
}

@end
