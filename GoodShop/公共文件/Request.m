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



@end
