//
//  CustomTabBarViewController.h
//  ManageForMM
//
//  Created by MIAO on 16/9/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFirstViewController.h"
#import "OrderViewController.h"
#import "MeViewController.h"
#import "Header.h"

@interface PHTabbarButton : UIButton
@end


@interface CustomTabBarViewController : UITabBarController

@property(nonatomic,assign) NSInteger buttonIndex;

@end
