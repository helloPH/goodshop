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





@end

