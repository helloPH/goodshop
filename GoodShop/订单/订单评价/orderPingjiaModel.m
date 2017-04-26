//
//  orderPingjiaModel.m
//  LifeForMM
//
//  Created by HUI on 16/1/5.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "orderPingjiaModel.h"

@implementation orderPingjiaModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.pingj_id = value;
    }
}
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
