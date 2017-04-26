//
//  userAddressModel.h
//  LifeForMM
//
//  Created by HUI on 15/9/4.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface userAddressModel : NSObject
@property (nonatomic,copy)NSString *name; // 姓名
@property (nonatomic,copy)NSString *haoma; //电话
@property (nonatomic,copy)NSString *address; //地址
@property (nonatomic,copy)NSString *shouhuodizhi;
@property (nonatomic,copy)NSString *dizhiId; //id
@property (nonatomic,strong)NSString *qiehuan;//切换

@end
