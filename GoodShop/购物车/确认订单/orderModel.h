//
//  orderModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/31.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface orderModel : NSObject
@property(nonatomic,copy)NSString *carid; //购物车id ...
@property(nonatomic,copy)NSString *dianpuid;// 店铺id ...
@property(nonatomic,copy)NSString *dianpuname; //店铺名 ....
@property(nonatomic,copy)NSString *fapiao;//发票 ...
@property(nonatomic,copy)NSString *fujiafei;//附加费 ...
@property(nonatomic,copy)NSString *jiage;//商品价格 ....
@property(nonatomic,copy)NSString *shopimg;//商品image ...
@property(nonatomic,copy)NSString *shopname; //商品名称...
@property(nonatomic,copy)NSString *shuliang;//商品数量 ....
@property(nonatomic,copy)NSString *yuyueshuoming;//预约说明

@property(nonatomic,copy)NSString *goodId;//
@property(nonatomic,copy)NSString *shopId;//
@property(nonatomic,copy)NSString *total;//
@property(nonatomic,copy)NSString *youhui;//优惠
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *hongbaoCount;
@property(nonatomic,copy)NSString *peisongfei;
//@property(nonatomic,copy)NSString *yanse;//颜色 ...
@property(nonatomic,copy)NSString *dianpuLogo;

@end
