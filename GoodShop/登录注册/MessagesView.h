//
//  MessagesView.h
//  GoodShop
//
//  Created by MIAO on 16/11/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol MessagesViewDelegate <NSObject>
-(void)loginSuccessWithCodeDict:(NSDictionary *)dict AndIndex:(NSInteger)index;

@end
@interface MessagesView : UIView<MBProgressHUDDelegate,UITextFieldDelegate>
@property (nonatomic,weak)id<MessagesViewDelegate>codeloginDelegate;

@end
