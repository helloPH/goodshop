//
//  findPasViewController.h
//  LifeForMM
//
//  Created by HUI on 15/11/5.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface findPasViewController : UIViewController
@property (nonatomic,strong)void (^backPhone)(NSString * tel);
@property (nonatomic,strong)NSString * beforeTel;
@end
