//
//  shopListModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/14.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface shopListModel : NSObject
@property(nonatomic,copy)NSString *address; //联系地址
@property(nonatomic,copy)NSString *dianpuid;// 店铺id
@property(nonatomic,copy)NSString *dianpuimage;//店铺图片
@property(nonatomic,copy)NSString *dianpuname;//店铺名称
@property(nonatomic,copy)NSString *distance;//距离
@property(nonatomic,retain)NSArray *tubiaoimage;//店铺活动图标
@property(nonatomic,retain)NSArray *tubiaoname;//预约说明
@property(nonatomic,retain)NSString *zhuangtai;
@end
