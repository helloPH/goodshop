//
//  PHWeiXin.h
//  GoodShop
//
//  Created by MIAO on 2017/6/15.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WXAPPID @"wx86cfff8ea79fa7c8"
#define WXSRC   @"6d5f230db781d1fb19ebaca27f1792f3"


#define shareWX [PHWeiXin share]
@interface PHWeiXin : UIViewController
@property (nonatomic,strong)void(^block)(id data);
+(instancetype)share;
+(void)attempDealloc;
-(void)loginBlock:(void(^)(BOOL isSuccess))block;
-(void)goBackWithUrl:(NSURL *) url;
-(void)getUserInfoWithDic:(NSDictionary *)pram block:(void (^)(NSDictionary * info))block;
-(void)getUserInfoWithToken:(NSString *)token openid:(NSString *)openid block:(void (^)(NSDictionary * info))block;
@end
