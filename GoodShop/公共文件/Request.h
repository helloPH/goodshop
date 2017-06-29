//
//  Request.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPTool.h"

typedef  void(^SuccBlock)(NSInteger message,id data);
typedef  void(^FailBlock)(NSError * error);

@interface Request : NSObject
#pragma mark -- 登录注册
/*
 *微信登录 获取手机号密码
 */
+(void)getWXLoginPhotoAndPwWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure;
/*
 *根据手机号 获取logo
 */
+(void)getLogoByPhoneWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure;
/*
* 获取版本号
*/
+(void)getBanBenInfoSuccess:(SuccBlock)success failure:(FailBlock)failure;
/*
 * 获取版本号1
 */
+(void)getBanBenInfo1Success:(SuccBlock)success failure:(FailBlock)failure;
#pragma mrak -- 购物车
/*
 *显示默认收货地址
 */
+(void)getDefaultAddressWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure;


#pragma  mark -- 订单
/*
*获取订单列表
*/
+(void)getOrderListWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure;

/*
 *订单详情
 */
+(void)getOrderInfoWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure;


#pragma  mark -- 个人中心
/*
 *绑定微信
 */
+(void)bangDingWXWithDic:(NSDictionary *)dic success:(SuccBlock)success failure:(FailBlock)failure;


/*
 *验证身份
 */
+(void)yanZhengShengFenWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;

@end

