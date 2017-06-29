//
//  SetPassWordAtLoginView.h
//  GoodShop
//
//  Created by MIAO on 2017/6/17.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPassWordAtLoginView : UIView
@property (nonatomic,strong)NSString * Id;
@property (nonatomic,strong)NSString * tel;
@property (nonatomic,strong)void (^block)(NSString * string);
-(void)appear;
-(void)disAppear;
@end
