//
//  AppDelegate.m
//  GoodShop
//
//  Created by MIAO on 16/11/18.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "AppDelegate.h"
#import "LunchViewController.h"
#import "Header.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AVFoundation/AVFoundation.h>
#import "PHWeiXin.h"

@interface AppDelegate ()<CLLocationManagerDelegate,BMKGeneralDelegate>

@end

@implementation AppDelegate
{
    CLLocationManager *locationManager;
    BOOL islocation;
    BMKMapManager* _mapManager;

}
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    
    
//   垃圾玩意 写那么多 不知道简化
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstShouye"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstShouye"];
//    }
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstZuiai"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstZuiai"];
//    }
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstZhuce"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstZhuce"];
//    }
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstOrder"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstOrder"];
//    }
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstFankui"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstFankui"];
//    }
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstShoucang"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstShoucang"];
//    }
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstShangpinfenlei"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstShangpinfenlei"];
//    }
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstShangpinxiangqing"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstShangpinxiangqing"];
//    }
//    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstShopCar"]){
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstShopCar"];
//    }
 
    set_isPeiSong(@"1");
    
   
    
    /*微支付*/
    [WXApi registerApp:@"wx86cfff8ea79fa7c8" withDescription:@"妙店佳"];
    
    /*******----分享----*******/
    [ShareSDK registerApp:@"1948047241dba"];//appkey
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx86cfff8ea79fa7c8" appSecret:@"6d5f230db781d1fb19ebaca27f1792f3" wechatCls:[WXApi class]];
    //qq
//    [ShareSDK connectQQWithQZoneAppKey:@"1105225280"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
    //qq空间
//    [ShareSDK connectQZoneWithAppKey:@"1105225280"
//                           appSecret:@"Kb6BIHVDTXIChuNX"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
    //新浪微博
//    [ShareSDK connectSinaWeiboWithAppKey:@"3291648112"
//                               appSecret:@"2f5c7ece45b07a68790072d2b5224596"
//                             redirectUri:@"http://www.m1ao.com/Mshc/gonggao/yonghuxieyi.jsp"
//                             weiboSDKCls:[WeiboSDK class]];
    //腾讯微博
//    [ShareSDK connectTencentWeiboWithAppKey:@"1105225280"
//                                  appSecret:@"2f5c7ece45b07a68790072d2b5224596"
//                                redirectUri:@"http://www.m1ao.com/Mshc/gonggao/yonghuxieyi.jsp"];
//    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
//                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                redirectUri:@"http://www.sharesdk.cn"];
    //人人网
//    [ShareSDK connectRenRenWithAppId:@"226427"
//                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
//                   renrenClientClass:[RennClient class]];
    //开心网
//    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
//                            appSecret:@"da32179d859c016169f66d90b6db2a23"
//                          redirectUri:@"http://www.sharesdk.cn/"];
    //易信好友
//    [ShareSDK importYiXinClass:[YXApi class]];
//    [ShareSDK connectYiXinSessionWithAppId:@"yx76ccc4c786924b0393cff76a77e90800"
//                                  yixinCls:[YiXinConnection class]];
    
//    [ShareSDK connectSMS];
//    [ShareSDK connectMail];
    
    //定位
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精度
//    [MAMapServices sharedServices].apiKey = @"baf8a95f201952ad47a3bccd5aeda7bc";
    
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"userShequCity"]){
        //        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"userShequCity"];
        
        if (![CLLocationManager locationServicesEnabled]) {
            [self defaultLocation];
        }
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            //            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"userShequCity"];
            [locationManager requestWhenInUseAuthorization];
        }
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
            [self defaultLocation];
            islocation = 1;
        }
        else{
            //            if(![[NSUserDefaults standardUserDefaults] valueForKey:@"userShequCity"]){
            [locationManager startUpdatingLocation];
            islocation = 0;
            //            }
        }
    }
    
    LunchViewController *LunchVC = [[LunchViewController alloc]init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = LunchVC;
    [self.window makeKeyAndVisible];
    
        
    //本地推送
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:@"isLogin"] integerValue ] == 0) {
        application.applicationIconBadgeNumber = 0;
    }
    //开启推送 同时询问用户是否允许推送服务
    //判断设置的iOS版本
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        //使用iOS8.0以上的方法
        //推送设置
        /*
         1、推送的类型(文字、声音、红点)
         2、推送的其他操作，传为nil即可
         */
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        
        //程序接受推送设置
        [application registerUserNotificationSettings:settings];
        
        //询问用户
        [application registerForRemoteNotifications];
        
        
    }else{
        //使用旧方法
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
        //开启推送
        [application registerForRemoteNotifications];
    }
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"aRYhOY0cd9REWoYBqzKMRCZDZQvi1C5Z" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: nil];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: nil];
    return YES;
}
-(void)defaultLocation
{
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyshequ.action" params:nil success:^(id json) {
        [[NSUserDefaults standardUserDefaults]setValue:[json valueForKey:@"shequid"]forKey:@"userShequid"];
        [[NSUserDefaults standardUserDefaults]setValue:[json valueForKey:@"shequname"] forKey:@"userShequName"];
        [[NSUserDefaults standardUserDefaults]setValue:[json valueForKey:@"suoshushengshi"] forKey:@"userShequCity"];
        [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"xinrenli"] forKey:@"isXinrenli"];
        
        NSNotification *resetTitle = [NSNotification notificationWithName:@"resetTitle" object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:resetTitle];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetTitle" object:nil];
        
    } failure:^(NSError *error) {
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        [self defaultLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationManager stopUpdatingLocation];
    CLLocation * currLocation = [locations lastObject];
    //    [locationManager stopUpdatingLocation];//室内定位不好 我就定位一次就结束了
    [[NSUserDefaults standardUserDefaults] setFloat:currLocation.coordinate.latitude forKey:@"userLatitude"];
    [[NSUserDefaults standardUserDefaults] setFloat:currLocation.coordinate.longitude forKey:@"userLongitude"];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark = placemarks.firstObject;
        NSDictionary *dict = [mark addressDictionary];
        NSString *city = [dict objectForKey:@"State"];
        
        [self getLocationData:city];
    }];
}
///定位
-(void)getLocationData:(NSString *)city
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"suoshu_shensi":city}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"dingWeiShequ.action" params:pram success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"dingweiList"];
        [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"diqu_name"] forKey:@"userDiquName"];
        [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"shequ_id"] forKey:@"userShequid"];
        [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"shequ_name"] forKey:@"userShequName"];
        [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"suoshu_shensi"] forKey:@"userShequCity"];
        [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"xinrenli"] forKey:@"isXinrenli"];
        
        NSNotification *resetTitle = [NSNotification notificationWithName:@"resetTitle" object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:resetTitle];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetTitle" object:nil];
        
    } failure:^(NSError *error) {
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"result = ");
  
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
        //        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
        //        return YES;
    }
    if ([url.host isEqualToString:@"oauth"]) {// 授权登录
        [shareWX goBackWithUrl:url];
    }
    //    if ([url.host isEqualToString:@"pay"]) {
    //        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    //    }
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"进入后台 ");
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:@"isLogin"] integerValue ] == 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

#pragma mark 本地推送的代理方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //当接收到通知会被调用的方法
    //去除小红点
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:@"isLogin"] integerValue ] == 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    NSLog(@"跳转相应界面或执行其他操作");
    
    //接收推送消息中的具体内容
//    NSDictionary * dict = notification.userInfo;
    
    //    NSString * url = dict[@"URL"];
    
    //    PlayViewController * play = [[PlayViewController alloc]init];
    //    //正向传值
    //    play.videoUrl = url;
    //    [self.window.rootViewController presentViewController:play animated:YES completion:nil];
    
}
-(void)onReq:(BaseReq *)req{
    
}
-(void)onResp:(BaseResp *)resp{
    
}
@end
