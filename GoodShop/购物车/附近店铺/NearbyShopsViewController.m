//
//  NearbyShopsViewController.m
//  GoodShop
//
//  Created by MIAO on 2017/3/31.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "NearbyShopsViewController.h"
#import "searchViewController.h"
#import "Header.h"
#import "searchCell.h"
#import "GoodDetailViewController.h"
#import "shopListModel.h"
#import "homePageCell.h"
@interface NearbyShopsViewController () <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIButton *leftButton,*rightButton;
@property(nonatomic,strong)UITextField *searchFiled; // 搜索框
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *fujinDianpuArray;
@property(nonatomic,strong)NSString *latitude,*longitude,*city;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIImageView *headImageView;
//@property(nonatomic,strong)UIImageView *caozuotishiImage;
@property(nonatomic,assign)BOOL isSearch;

@end

@implementation NearbyShopsViewController
-(void)viewWillAppear:(BOOL)animated
{
     
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    if (!_isManual) {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检测到您未开启定位,将无法查看附近店铺" preferredStyle:1];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
    }
    

    [self initNavigation];
    [self getHeadImageUrl];
    [self getFujinDianpuData];
}

-(void)judgeTheFirst
{
    [self showGuideImageWithUrl:@"images/caozuotishi/zuiai.png"];
    
    
    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstZuiai"] integerValue] == 1) {
//        NSString *url = @"images/caozuotishi/zuiai.png";
//        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
//        if (self.caozuotishiImage) {
//            [self.caozuotishiImage removeFromSuperview];
//            self.caozuotishiImage=nil;
//        }
//        
//       self.caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
//        self.caozuotishiImage.userInteractionEnabled = YES;
//        self.caozuotishiImage.alpha = 0.9;
//        [self.caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
//        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
//        [self.caozuotishiImage addGestureRecognizer:imageTap];
//        [self.view addSubview:self.caozuotishiImage];
//    }
}

//-(void)imageHidden
//{
//    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstZuiai"];
//    [self.caozuotishiImage removeFromSuperview];
//}
-(NSString *)longitude
{
    if (!_longitude) {
        _longitude = @"116.583822";
    }
    return _longitude;
}
-(NSString *)latitude
{
    if (!_latitude) {
        _latitude = @"39.909449";
    }
    return _latitude;
}
-(NSString *)city
{
    if (!_city) {
        _city = @"北京市";
    }
    return _city;
}
-(BOOL)isSearch
{
    if (!_isSearch) {
        _isSearch = 0;
    }
    return _isSearch;
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
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"dianpu_left_img"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"搜索"];
        [_rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(UITextField *)searchFiled
{
    if (!_searchFiled) {
        _searchFiled = [BaseCostomer textfieldWithFrame:CGRectMake(0, 0, 200*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor blackColor] backGroundColor:[UIColor whiteColor]textAlignment:NSTextAlignmentCenter keyboardType:0 borderStyle:UITextBorderStyleRoundedRect placeholder:@"请输入店铺名称"];
        _searchFiled.delegate = self;
        _searchFiled.tintColor = [UIColor blueColor];
        _searchFiled.returnKeyType = UIReturnKeyDone;
    }
    return _searchFiled;
}
-(void)initNavigation
{
    self.navigationItem.title = @"附近店铺";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem =rightItem;
}

-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView  = [BaseCostomer imageViewWithFrame:CGRectMake(0, 0, kDeviceWidth,60*MCscale) backGroundColor:[UIColor clearColor] image:@"geren_beijing_icon"];
    }
    return _headImageView;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
        [self.view addSubview:_mainTableView];
        _mainTableView.tableHeaderView = self.headImageView;
    }
    return _mainTableView;
}

-(void)getHeadImageUrl
{
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyfujinimage.action" params:nil success:^(id json) {
        NSLog(@"附近图片%@",json);
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[json valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"geren_beijing_icon"] options:SDWebImageRefreshCached];
    } failure:^(NSError *error) {
        
    }];
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
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {//
        CLPlacemark *mark = placemarks.firstObject;
        NSDictionary *dict = [mark addressDictionary];
        self.city = [dict objectForKey:@"City"];
        [self getFujinDianpuData];
    }];
}


-(void)getFujinDianpuData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.x":self.longitude,@"address.y":self.latitude,@"city":self.city}];
    [self getDianpuListDataWithUrl:@"nearDianpu.action" AndPram:pram];
}

#pragma mark --UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fujinDianpuArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    homePageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[homePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *btnView = [BaseCostomer viewWithFrame:CGRectMake(kDeviceWidth, 0, 200, 80*SCscale) backgroundColor:txtColors(206, 207, 208, 1)];
        
        UILabel *label = [BaseCostomer labelWithFrame:CGRectMake(5*MCscale, 0,60*SCscale, 80*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:2 text:@"首页最爱"];
        [btnView addSubview:label];
        [cell.contentView addSubview:btnView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reloDataWithIndexPath:indexPath AndArray:self.fujinDianpuArray];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    shopListModel *model = self.fujinDianpuArray[indexPath.row];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    
    set_isPeiSong(@"1"); /// 到正常切换店铺时 把配送方式改为1
    if (self.viewTag == 2) {
        [[NSUserDefaults standardUserDefaults]setValue:model.dianpuid forKey:@"dianpuqiehuan"];
        [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"isFirst"];
        CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [main setSelectedIndex:0];
        main.buttonIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
    }
    else
    {
        [def setValue:model.dianpuid forKey:@"dianpuqiehuan"];
        [def setValue:@"2" forKey:@"isFirst"];
        NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
        if ([isLogin integerValue] != 1 ) {
            [def setValue:userSheBei_id forKey:@"userId"];
        }
        
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
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                CustomTabBarViewController *main = [[CustomTabBarViewController  alloc]init];
                main.buttonIndex = 0;
                [UIApplication sharedApplication].keyWindow.rootViewController = main;
            }];
        }else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            CustomTabBarViewController *main = [[CustomTabBarViewController  alloc]init];
            main.buttonIndex = 0;
            [UIApplication sharedApplication].keyWindow.rootViewController = main;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*MCscale;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    shopListModel *model = self.fujinDianpuArray[indexPath.row];
    [self changeFavouriteWithDianpuId:model.dianpuid];
    [self.mainTableView reloadData];
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)searchAction
{
    if ([self.searchFiled.text isEqualToString:@""]) {
        [self promptMessageWithString:@"关键字不能为空!"];
    }
    else{
        [self.view endEditing:YES];
        [self searchDianpuDeta];
    }
}
#pragma mark 搜索店铺
-(void)searchDianpuDeta
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.x":self.longitude,@"address.y":self.latitude,@"city":self.city,@"dianpuname":self.searchFiled.text}];
    [self getDianpuListDataWithUrl:@"searchNearDianpu.action" AndPram:pram];
}

-(void)btnAction:(UIButton *)btn
{
    if (btn == self.leftButton) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
            shopListModel * model = [shopListModel new];
            model.dianpuid=@"0";
        
        
            if (self.fujinDianpuArray.count != 0) {
                model = self.fujinDianpuArray[0];
            }
            
            
            
            if ([isLogin integerValue]==1) {
                NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id}];
                [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyfujifanhui.action" params:pram success:^(id json) {
                    NSLog(@"附近返回%@",json);
                    
                    NSString *dianpuID =[NSString stringWithFormat:@"%@",[json valueForKey:@"dinapuid"]];
                    if ([dianpuID isEqualToString:@"0"]) [[NSUserDefaults standardUserDefaults]setValue:model.dianpuid forKey:@"dianpuqiehuan"];
                    else [[NSUserDefaults standardUserDefaults]setValue:[json valueForKey:@"dinapuid"] forKey:@"dianpuqiehuan"];
                    [def setValue:@"2" forKey:@"isFirst"];
                    if (self.viewTag == 2) {
                        CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                        [main setSelectedIndex:0];
                        main.buttonIndex = 0;
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
                        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
                    }
                    else
                    {
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
                                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                                CustomTabBarViewController *main = [[CustomTabBarViewController  alloc]init];
                                main.buttonIndex = 0;
                                main.selectedIndex = 0;
                                [UIApplication sharedApplication].keyWindow.rootViewController = main;
                            }];
                        }else {
                            [NSObject cancelPreviousPerformRequestsWithTarget:self];
                            CustomTabBarViewController *main = [[CustomTabBarViewController  alloc]init];
                            main.buttonIndex = 0;
                            [UIApplication sharedApplication].keyWindow.rootViewController = main;
                        }
                    }

                } failure:^(NSError *error) {
                    [self promptMessageWithString:@"网络连接错误"];
                }];
            }
            else
            {
                if (self.viewTag == 2) {
                    [def setValue:model.dianpuid forKey:@"dianpuqiehuan"];
                    [def setValue:@"2" forKey:@"isFirst"];
                    CustomTabBarViewController *main = (CustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [main setSelectedIndex:0];
                    main.buttonIndex = 0;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
                    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
                }
                else
                {
                    [def setValue:model.dianpuid forKey:@"dianpuqiehuan"];
                    [def setValue:@"2" forKey:@"isFirst"];
                    [def setValue:userSheBei_id forKey:@"userId"];
                    
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
                            [NSObject cancelPreviousPerformRequestsWithTarget:self];
                            CustomTabBarViewController *main = [[CustomTabBarViewController  alloc]init];
                            main.buttonIndex = 0;
                            [UIApplication sharedApplication].keyWindow.rootViewController = main;
                        }];
                    }else {
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                        CustomTabBarViewController *main = [[CustomTabBarViewController  alloc]init];
                        main.buttonIndex = 0;
                        [UIApplication sharedApplication].keyWindow.rootViewController = main;
                    }
                }
            }
    }
    else
    {
        if (self.isSearch == 0) {
            self.navigationItem.titleView = self.searchFiled;
            self.isSearch = 1;
        }
        else
        {
            if ([self.searchFiled.text isEmptyString]) {
                [self getFujinDianpuData];
                self.navigationItem.titleView = nil;
                self.isSearch=0;
                return;
            }

            [self searchAction];
            [self.searchFiled resignFirstResponder];
        }
    }
}
-(void)getDianpuListDataWithUrl:(NSString *)url AndPram:(NSMutableDictionary *)pram
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"请稍等...";
    [HUD show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:url params:pram success:^(id json) {
            NSLog(@"店铺列表%@",json);
            [HUD hide:YES];
            [self.fujinDianpuArray removeAllObjects];
            NSArray *ary = [json valueForKey:@"dianpuList"];
            if([[json valueForKey:@"massages"]integerValue]){
                self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索无数据.jpg"]];
                [self promptMessageWithString:@"附近暂时没有店铺"];
            }
            if (ary.count >0) {
                self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底"]];
                for(NSDictionary *dc in ary){
                    shopListModel *model = [[shopListModel alloc]init];
                    [model setValuesForKeysWithDictionary:dc];
                    [self.fujinDianpuArray addObject:model];
                }
            }
            [self judgeTheFirst];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
            });
        } failure:^(NSError *error) {
            [HUD hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    });
}

-(void)changeFavouriteWithDianpuId:(NSString *)dianpuId
{
    if ([isLogin integerValue] ==1) {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"请稍等...";
        [HUD show:YES];
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id,@"dianpuid":dianpuId}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"saveusershourezuiai.action" params:pram success:^(id json) {
            NSLog(@"首页最爱%@",json);
            [HUD hide:YES];
            if ([[json valueForKey:@"massages"]integerValue] == 1) {
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeCustomView;
                mbHud.labelText = @"首页最爱设置成功";
                mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                [[NSUserDefaults standardUserDefaults]setValue:dianpuId forKey:@"dianpuId"];
            }
            else [self promptMessageWithString:@"标记失败"];
        } failure:^(NSError *error) {
            [HUD hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
    else{
        [self loginVC];
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
    [self presentViewController:navi animated:YES completion:^{
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    [self.searchFiled resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchFiled resignFirstResponder];
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
@end
