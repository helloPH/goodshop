//
//  shopCollectionViewCell.h
//  LifeForMM
//
//  Created by HUI on 15/7/25.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "shopModel.h"
@interface shopCollectionViewCell : UICollectionViewCell

@property(nonatomic,retain)UIButton *goinShopCar;

-(void)reloDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;

@end
