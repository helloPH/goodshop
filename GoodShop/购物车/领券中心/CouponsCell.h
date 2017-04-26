//
//  CouponsCell.h
//  GoodShop
//
//  Created by MIAO on 2016/12/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponsCellDelagate <NSObject>

-(void)getCouponsWithIndex:(NSInteger)index;

@end
@interface CouponsCell : UITableViewCell

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;

@property(nonatomic,strong)id<CouponsCellDelagate>couponsDelegate;
@end
