//
//  carDataModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/25.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface carDataModel : NSObject
//@property(nonatomic,copy)NSString *goodId;//商品id
@property(nonatomic,copy)NSString *jiage;//商品单价
@property(nonatomic,copy)NSString *shopimg;//商品图像
@property(nonatomic,copy)NSString *shopname;//商品名称
@property(nonatomic,copy)NSString *shuliang;//数量
@property(nonatomic,copy)NSString *xinghao;//型号
@property(nonatomic,copy)NSString *yanse;//颜色
@property(nonatomic,copy)NSString *dianpuname;//店铺名
//@property(nonatomic,copy)NSString *shequid;//社区id
@property(nonatomic,copy)NSString *dianpuid;//店铺id
@property(nonatomic,copy)NSString *shopshuxing;//商品属性
@property(nonatomic,copy)NSString *dianpuzhuangtai;//（1营业中,2可预约,3休息中）
@property(nonatomic,copy)NSString *xuangzhongzhuangtai;//选中状态（1：选中，0：未选中）
@property(nonatomic,copy)NSString *shangpiid;//商品id

@end
