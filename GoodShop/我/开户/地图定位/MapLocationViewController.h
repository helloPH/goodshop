//
//  MapLocationViewController.h
//  GoodShop
//
//  Created by MIAO on 2017/4/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapLocationViewControllerDelegate <NSObject>

-(void)selectedLocationWithWict:(NSDictionary *)dict;

@end
@interface MapLocationViewController : UIViewController

@property(nonatomic,strong)id<MapLocationViewControllerDelegate>mapDelegate;
@end
