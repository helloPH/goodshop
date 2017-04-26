//
//  searchGoodModel.m
//  LifeForMM
//
//  Created by HUI on 15/11/12.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "searchGoodModel.h"

@implementation searchGoodModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.god_id = value;
    }
}
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
