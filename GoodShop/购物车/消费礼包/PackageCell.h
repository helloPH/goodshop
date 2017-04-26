//
//  PackageCell.h
//  GoodShop
//
//  Created by MIAO on 2017/1/4.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PackageCellDelagate <NSObject>

-(void)getPackageWithDict:(NSDictionary *)dict;

@end

@interface PackageCell : UITableViewCell

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;

@property(nonatomic,strong)id<PackageCellDelagate>packageDelegate;

@end
