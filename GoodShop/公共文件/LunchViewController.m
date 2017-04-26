//
//  LunchViewController.m
//  LifeForMM
//
//  Created by HUI on 15/8/3.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "LunchViewController.h"
#import "Header.h"
#import "AFNetworking.h"
#import "CustomTabBarViewController.h"
#import "NearbyShopsViewController.h"
@interface LunchViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CustomTabBarViewController *gesture;
    UIImageView *image;
}
@end

@implementation LunchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    
    //ping命令 原理：向大型的门户网址发送请求，来判断当前的网络状态
    //1、请求队列管理者(数据请求工具)
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.m1ao.com/"]];
    //2、发送请求监测网络
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //判断状态
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            //            [self timerClick];
            [self performSelector:@selector(btnAction) withObject:self afterDelay:2];
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            //            [self timerClick];
            [self performSelector:@selector(btnAction) withObject:self afterDelay:2];
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"'已为妙店佳'关闭蜂窝移动数据" message:@"您可以在'设置'中为此应用打开蜂窝移动数据" preferredStyle:1];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self performSelector:@selector(btnAction) withObject:self afterDelay:2];
            }];
            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }   [[UIApplication sharedApplication] openURL:url];
            }];
            [alert addAction:suerAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            //            [self requestNetworkWrong:@"不可是别的网络状态"];
        }
    }];
    //3、启动网络监测
    [manager.reachabilityManager startMonitoring];//stopMonitoring
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精度
    [locationManager setDistanceFilter:200];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        [self performSelector:@selector(btnAction) withObject:self afterDelay:2];
    }
    else{
        [locationManager startUpdatingLocation];
    }
}

#pragma mark -- 定位Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationManager stopUpdatingLocation];
    CLLocation * currLocation = locations[0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        const double x_pi = M_PI * 3000.0 / 180.0;
        double bd_lon,bd_lat;
        //将 GCJ-02 坐标转换成 BD-09 坐标
        double x = currLocation.coordinate.longitude, y = currLocation.coordinate.latitude;
        double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
        double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
        bd_lon = z * cos(theta) + 0.0125;
        bd_lat = z * sin(theta) + 0.00625;
        
        NSUserDefaults *def  = [NSUserDefaults standardUserDefaults];
        CLLocation *sloccation = [[CLLocation alloc]initWithLatitude:bd_lat longitude:bd_lon];
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:sloccation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count) {
                //获取当前城市
                CLPlacemark *mark = placemarks.firstObject;
                NSDictionary *dict = [mark addressDictionary];
                NSString *city = [dict objectForKey:@"City"];
                [def setValue:city forKey:@"userCity"];
                
                if ([city length]) {
                    // 把汉字转换成拼音
                    // NSString 转换成 CFStringRef 型
                    CFStringRef string1 = (CFStringRef)CFBridgingRetain(city);
                    //  汉字转换成拼音
                    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, string1);
                    //  拼音（带声调的）
                    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
                    NSLog(@"%@", string);
                    //  去掉声调符号
                    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
                    NSLog(@"%@", string);
                    //  CFStringRef 转换成 NSString
                    NSString *strings = (NSString *)CFBridgingRelease(string);
                    //  去掉空格
                    NSString *cityString = [strings stringByReplacingOccurrencesOfString:@" " withString:@""];

                            
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.shp360.com/Store/images/zhiyuan/%@.png",cityString]] placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.shp360.com/Store/images/yindaoye/moren.png"]]]];
                    
                    
//                    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"suoshu_shensi":cityString}];
//                    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"guideImage.action" params:pram success:^(id json) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [image sd_setImageWithURL:[NSURL URLWithString:[json valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"引导页1"] options:SDWebImageRefreshCached];
//                        });
//                    } failure:^(NSError *error) {
//                    }];
                    NSLog(@"%@", cityString);
                    [self performSelector:@selector(btnAction) withObject:self afterDelay:2];
                }
            }
        }];
    });
}
-(BOOL)panduanNullImgWithUrl:(id)imageURL{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return NO;                  // url不正确返回CGSizeZero

    NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
    UIImage* image;
//    image = [UIImage imageWithData:data];
    image = [UIImage imageWithData:data];
    if(image)
    {
        return YES;
    }else{
        return NO;
    }
    return NO;
}
-(void)initSubViews
{
    image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    image.backgroundColor = [UIColor clearColor];
    image.userInteractionEnabled = YES;
    image.image = [UIImage imageNamed:@"lauch"];
    [self.view addSubview:image];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0,kDeviceWidth, kDeviceHeight);
    //    btn.layer.cornerRadius = 10*MCscale;
    //    btn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    //    btn.layer.masksToBounds = YES;
    //    btn.layer.borderWidth = 1;
    //    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    //    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btn setTitle:@"立即进入" forState:UIControlStateNormal];
    //    btn.center = CGPointMake(kDeviceWidth/2.0, kDeviceHeight-70*MCscale);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [image addSubview:btn];
}

-(void)btnAction
{
    if (user_city) {
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"suoshu_shensi":user_city}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"zhanweituCount.action" params:pram success:^(id json) {
        } failure:^(NSError *error) {
        }];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSUserDefaults *def  = [NSUserDefaults standardUserDefaults];
    if (user_dianpuId && [user_dianpuId integerValue] !=0) {
        [def setValue:@"1" forKey:@"isFirst"];
        gesture = [[CustomTabBarViewController alloc]init];
        gesture.buttonIndex = 0;
        self.view.window.rootViewController = gesture;
    }
    else
    {
       NearbyShopsViewController *NearbyShopsVC = [[NearbyShopsViewController alloc]init];
        NearbyShopsVC.viewTag = 1;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:NearbyShopsVC];
        UINavigationBar *bar = navi.navigationBar;
        bar.translucent = YES;
        [bar setBarTintColor:naviBarTintColor];
        bar.tintColor = [UIColor whiteColor];
        [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.view.window.rootViewController = navi;
    }
}

-(void)myTask
{
    sleep(1.5);
}
@end
