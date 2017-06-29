//
//  Request.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "Request.h"
#import "MBProgressHUD.h"

@implementation Request
#pragma mark -- 登录注册
/*
 *微信登录 获取手机号密码
 */
+(void)getWXLoginPhotoAndPwWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure{
    NSString * url = @"weixinhuoqu.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        NSInteger  message  = [[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] integerValue];
       success(message,json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}
/*
 *根据手机号 获取logo
 */
+(void)getLogoByPhoneWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure{
    NSString * url = @"findtelhead.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        NSInteger  message  = [[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] integerValue];
        success(message,json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}
/*
 * 获取版本号
 */
+(void)getBanBenInfoSuccess:(SuccBlock)success failure:(FailBlock)failure{
    
    NSString * url = @"banbenNew.action";
    NSDictionary * pram = @{@"banbenhao":APPVERSION,@"xitong":@"2"};
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:url params:[NSMutableDictionary dictionaryWithDictionary:pram] success:^(id json) {
        NSInteger status = 0;
        status = [[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]] integerValue];
        
        success(status,json);
    } failure:^(NSError *error) {
        [MBProgressHUD promptWithString:@"版本网络请求失败"];
        failure(error);
    }];
}
/*
 * 获取版本号1
 */
+(void)getBanBenInfo1Success:(SuccBlock)success failure:(FailBlock)failure{
    NSString * url = @"banbeniosStatus.action";
    NSDictionary * pram = @{@"banbenhao":APPVERSION,
                            @"xitong":@"2"};
    [HTTPTool getWithUrlPath:@"http://www.shp360.com/MshcShopGuanjia/" AndUrl:url params:[NSMutableDictionary dictionaryWithDictionary:pram] success:^(id json) {
        NSInteger status = 0;
        status = [[NSString stringWithFormat:@"%@",[json valueForKey:@"status"]] integerValue];
        success(status,json);
    } failure:^(NSError *error) {
//        [MBProgressHUD promptWithString:@"版本网络请求失败"];
        failure(error);
    }];
}


#pragma mrak -- 购物车
/*
 *显示默认收货地址
 */
+(void)getDefaultAddressWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure{
    NSString * url = @"findbyAddress.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        NSInteger  message  = [[NSString stringWithFormat:@"%@",[json valueForKey:@"masssage"]] integerValue];
        id data = [json objectForKey:@"dingdanxp"];
        if (message == 1) {
            [MBProgressHUD promptWithString:@"数据加载失败"];
        }else{
            success(message,data);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}


+(void)getOrderListWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure{
    NSString * url = @"finddingdanxiangqings.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        NSInteger  message  = [[NSString stringWithFormat:@"%@",[json valueForKey:@"masssage"]] integerValue];
        id data = [json objectForKey:@"dingdanxp"];
        if (message == 1) {
            [MBProgressHUD promptWithString:@"数据加载失败"];
        }else{
            success(message,data);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}
+(void)getOrderInfoWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure{
    NSString * url = @"finddingdanxiangqings.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        NSInteger  message  = [[NSString stringWithFormat:@"%@",[json valueForKey:@"masssage"]] integerValue];
        id data = [json objectForKey:@"dingdanxp"];
        if (message == 1) {
            [MBProgressHUD promptWithString:@"数据加载失败"];
        }else{
            success(message,data);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}

#pragma  mark -- 个人中心
/*
 *绑定微信
 */
+(void)bangDingWXWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure{
    NSString * url = @"bandingweixin.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        NSInteger  message  = [[NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]] integerValue];
        success(message,nil);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}

/*
 *验证身份
 */
+(void)yanZhengShengFenWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool getWithUrlPath:HTTPPush AndUrl:@"Zonghe_xitongtuisong.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];

}


@end
