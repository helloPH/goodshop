//
//  AccountView.h
//  GoodShop
//
//  Created by MIAO on 16/11/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol AccountViewDelegate <NSObject>
-(void)loginSuccessWithDict:(NSDictionary *)dict AndIndex:(NSInteger)index;

@end
@interface AccountView : UIView<MBProgressHUDDelegate,UITextFieldDelegate>

@property (nonatomic,weak)id<AccountViewDelegate>loginDelegate;
@end
