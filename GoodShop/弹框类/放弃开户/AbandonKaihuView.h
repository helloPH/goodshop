//
//  AbandonKaihuView.h
//  GoodShop
//
//  Created by MIAO on 2017/4/5.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AbandonKaihuViewDelegate <NSObject>

-(void)abandonKaihuSuccess;

@end
@interface AbandonKaihuView : UIView

@property(nonatomic,strong)id<AbandonKaihuViewDelegate>abandonDelegate;
@end
