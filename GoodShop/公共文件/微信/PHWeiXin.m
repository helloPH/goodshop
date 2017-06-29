//
//  PHWeiXin.m
//  GoodShop
//
//  Created by MIAO on 2017/6/15.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PHWeiXin.h"
#import "Header.h"




@interface PHWeiXin()<WXApiDelegate>
@end
@implementation PHWeiXin


static dispatch_once_t once;
static PHWeiXin * weixin;
+(instancetype)share{

    dispatch_once(&once, ^{
        weixin = [PHWeiXin new];
    });
    return weixin;
}
+(void)attempDealloc{
    once = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
    weixin = nil;
}
-(void)loginBlock:(void(^)(BOOL isSuccess))block{
    SendAuthReq * req = [[SendAuthReq alloc]init];
    
    req.scope = @"snsapi_userinfo";
    req.state = @"wxlogin";

    if (![WXApi sendReq:req]) {
        block(NO);
        [MBProgressHUD promptWithString:@"调用失败"];
    }else{
        block(YES);
//       [MBProgressHUD promptWithString:@"调用成功"];
    }
}
-(void)goBackWithUrl:(NSURL *) url{

    NSURL * url1 = (NSURL *)url;
    NSString * query = url1.query;
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
    NSArray * arry = [query componentsSeparatedByString:@"&"];
    for (int i = 0; i < arry.count; i ++) {
        NSString* str1 = arry[i];
        NSArray * arry1 = [str1 componentsSeparatedByString:@"="];
        [resultDic setObject:arry1.lastObject forKey:[NSString stringWithFormat:@"%@",arry1.firstObject]];
    }
    
    NSString * urlstring = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPID,WXSRC,resultDic[@"code"]];
    
    [MBProgressHUD start];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:urlstring];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD stop];
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (self.block) {
                    self.block(dic);
                }
            }else{
                [MBProgressHUD promptWithString:@"授权失败"];
            }
        });
    });
}
-(void)getUserInfoWithToken:(NSString *)token openid:(NSString *)openid block:(void (^)(NSDictionary *))block{
    NSString * urlstring = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openid];
    [MBProgressHUD start];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:urlstring];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD stop];
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (block) {
                    block(dic);
                }
            }else{
                [MBProgressHUD promptWithString:@"信息获取失败"];
            }
        });
    });

}



@end
