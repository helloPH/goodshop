//
//  Header.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/14.
//  Copyright (c) 2015年 时元尚品. All rights .
//

#ifndef LifeForMM_Header_h
#define LifeForMM_Header_h
#endif

#import "UIViewController+Helper.h"
#import "NSString+Helper.h"
#import "UIViewExt.h"
#import "Request.h"
#import "HTTPTool.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <CoreLocation/CoreLocation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <RennSDK/RennSDK.h>
#import <YiXinConnection/YiXinConnection.h>
#import "YXApi.h"
#import "WeiboSDK.h"
#import "JSONKit.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "MBPrompt.h"
#import "md5_password.h"
#import "Masonry.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "BaseCostomer.h"

#import <CommonCrypto/CommonDigest.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <CoreLocation/CoreLocation.h>
#ifdef DEBUG
//调试
#define MyLog(...) NSLog(__VA_ARGS__)
#else
//发布
#define MyLog(...)
#endif
//屏幕大小
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define IPHONE_5 ((kDeviceHeight < 667.0)? (YES):(NO))
#define IPHONE_6 ((kDeviceHeight == 667.0)? (YES):(NO))
#define IPHONE_Plus ((kDeviceHeight > 667.0)? (YES):(NO))


#define APPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define user_dianpuName [[NSUserDefaults standardUserDefaults]objectForKey:@"dianpuName"]
#define user_dianpuId [[NSUserDefaults standardUserDefaults]valueForKey:@"dianpuId"]
#define user_qiehuandianpu [[NSUserDefaults standardUserDefaults]valueForKey:@"dianpuqiehuan"]

// before and after
#define banben_IsAfter [[NSUserDefaults standardUserDefaults]boolForKey:@"banBen_isAfter"]
#define set_Banben_IsAfter(isAfter) [[NSUserDefaults standardUserDefaults] setBool:isAfter forKey:@"banBen_isAfter"]

#define user_Xinrenli [[NSUserDefaults standardUserDefaults]valueForKey:@"xinrenli"]
#define user_tel [[NSUserDefaults standardUserDefaults]valueForKey:@"userTel"]
#define user_pass [[NSUserDefaults standardUserDefaults]valueForKey:@"userPass"]
#define user_id [[NSUserDefaults standardUserDefaults]valueForKey:@"userId"]
#define isLogin [[NSUserDefaults standardUserDefaults]valueForKey:@"isLogin"]
#define userSheBei_id [[UIDevice currentDevice].identifierForVendor UUIDString]

#define userLastAddress [[NSUserDefaults standardUserDefaults]valueForKey:@"addressName"]


// 用户定位的当前城市
#define user_city [[NSUserDefaults standardUserDefaults]valueForKey:@"userCity"]
#define set_user_city(user_city) [[NSUserDefaults standardUserDefaults]setValue:user_city forKey:@"userCity"]

// 用户定位的当前经纬度
#define userLongitude [[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]
#define set_user_Longitude(user_Longitude) [[NSUserDefaults standardUserDefaults]setValue:user_Longitude forKey:@"longitude"]

#define userLatitude [[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"]
#define set_user_Latitude(user_Latitude) [[NSUserDefaults standardUserDefaults]setValue:user_Latitude forKey:@"latitude"]

// 是否配送  主要针对扫码进行购买 扫码不进行配送 修改值为0  默认为1
#define isPeiSong [[NSUserDefaults standardUserDefaults]valueForKey:@"isPeiSong"]
#define set_isPeiSong(isPeiSong) [[NSUserDefaults standardUserDefaults]setValue:isPeiSong forKey:@"isPeiSong"]

//#define location_city [[NSUserDefaults standardUserDefaults]valueForKey:@"locationShequCity"]
#define stor_url @"https://itunes.apple.com/cn/app/miao-dian-jia/id1174739493?mt=8"

//更改内外网请将此处三个网址全部更改,更改内外网的时候请将APP卸载之后重装(测试机或者模拟器)

 //外网
#define HTTPHEADER @"http://www.shp360.com/MshcShop/"
#define HTTPGugan @"http://www.mshhch.com/Backbone/"
#define HTTPWeb @"http://www.shp360.com/Store/"
#define HTTPPush @"http://www.shp360.com/MshcShopGuanjia/"

//内网
//#define HTTPHEADER @"http://192.168.1.99:8080/MshcShop/"
//#define HTTPGugan @"http://192.168.1.250:8080/Backbone/"
//#define HTTPWeb @"http://192.168.1.99:8080/Store/"
//#define HTTPPush @"http://192.168.1.99:8080/Mshc_Guanjia/"

//字体大小
#define MLwordFont_14 (IPHONE_5 ? 26 : 30)
#define MLwordFont_1 (IPHONE_5 ? 22 : 25)
#define MLwordFont_11 (IPHONE_5 ? 19 : 22)
#define MLwordFont_15 (IPHONE_5 ? 19 : 21)
#define MLwordFont_2 (IPHONE_5 ? 18 : 20)
#define MLwordFont_3 (IPHONE_5 ? 17 : 19)
#define MLwordFont_4 (IPHONE_5 ? 16 : 18)
#define MLwordFont_12 (IPHONE_5 ? 15 : 17)
#define MLwordFont_5 (IPHONE_5 ? 14 : 16)
#define MLwordFont_6 (IPHONE_5 ? 13 : 15)
#define MLwordFont_7 (IPHONE_5 ? 12 : 14)
#define MLwordFont_8 (IPHONE_5 ? 12 : 13)
#define MLwordFont_9 (IPHONE_5 ? 11 : 12)
#define MLwordFont_10 (IPHONE_5 ? 10 : 11)
#define MLwordFont_13 (IPHONE_5 ? 9 : 10)

//店铺
#define SCLHeight (IPHONE_5 ? 143.0 : 168.0) //单元格高度
#define SCLimageHeigh (IPHONE_5 ? 80 : 105) //商品高度
#define SCLgoinCarHeight (IPHONE_5 ? 30 : 40) //按钮大小
#define SCLgoinCarSpace (IPHONE_5 ? 50 : 60) //间距
#define SCTypeHeight (IPHONE_5 ? 30 : 35) //分类高度
//导航栏
#define NVbtnWight (IPHONE_5 ? 22 : 25) //导航栏按钮大小
//购物车
#define SCselectImgWidth (IPHONE_5 ? 25 : 30) //选中图片
#define SCgoodImgWidth (IPHONE_5 ? 70 : 90) //商品logo
#define SCscale (IPHONE_5 ? 0.8 : 1) //加减框缩放比例
#define SCscale1 (IPHONE_5 ? 0.65 : 1)
#define SCtitleWidth (IPHONE_5 ? 180 : 200) //商品名长度
#define SCcellHeight (IPHONE_5 ? 80 : 100)
//搜索
#define SEtxtfiledWidth (IPHONE_5 ? 200 : 240) //搜索框长度
#define SEbtnSpace (IPHONE_5 ? 90 : 84)
//个人中心
#define MCheadViewHeight (IPHONE_5 ? 162 : 190)
#define MCscale (IPHONE_5 ? 0.85 : 1)
#define MCshareImgWidth (IPHONE_5 ? 98 : 110)
#define MCbtnHeight (IPHONE_5 ? 35 : 42)//余额提现按钮高度
#define MCscale_1 (IPHONE_5 ? 0.9 : 1)
//颜色

#define naviBarTintColor [UIColor colorWithRed:72/255.0 green:204/255.0 blue:224/255.0 alpha:1]
#define mainColor        [UIColor colorWithRed:72/255.0 green:204/255.0 blue:224/255.0 alpha:1]

#define txtColors(r,g,b,alp) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alp]
#define textColors txtColors(109.0,109.0,109.0,1)
#define placeHolderColor txtColors(194, 195, 196, 1)  //占位符字体颜色
#define textBlackColor txtColors(72, 73, 74, 0.9)
#define lineColor txtColors(74, 75, 76, 0.2) //画线的颜色

#define redTextColor txtColors(237, 58, 76, 1) //红色字体颜色
