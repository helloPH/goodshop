//
//  SetPaymentPasswordView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/16.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 设置支付密码

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol SetPaymentPasswordViewDelegate <NSObject>
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-variable"
//这里是会报警告的代码
-(void)SetPaymentPasswordSuccessWithIndex:(NSInteger)index;
-(void)rengzhengSuccessWithIndex:(NSInteger)index;

#pragma clang diagnostic pop
@end
@interface SetPaymentPasswordView : UIView<UITextFieldDelegate,MBProgressHUDDelegate>

@property(nonatomic,assign)NSInteger isFrom;
@property(nonatomic,strong)id<SetPaymentPasswordViewDelegate>setPaymentDelegate;

-(void)getTextFieldPlaceholderWithArray:(NSArray *)array;
@end
