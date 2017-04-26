//
//  PaymentPasswordView.h
//  LifeForMM
//
//  Created by MIAO on 16/5/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 输入支付密码

#import <UIKit/UIKit.h>

@protocol PaymentPasswordViewDelegate <NSObject>
-(void)PaymentSuccessWithIndex:(NSInteger )index;
@end

@interface PaymentPasswordView : UIView
@property (nonatomic,strong)id<PaymentPasswordViewDelegate>paymentPasswordDelegate;
-(void)reloadDataWithIndex:(NSInteger) index;
@end
