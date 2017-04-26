//
//  PersonalCenterCell.h
//  GoodShop
//
//  Created by MIAO on 2017/4/1.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterCell : UITableViewCell
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndViewTag:(NSInteger)viewTag AndDict:(NSDictionary *)dict;
-(void)reloadDataForMoreFromIndexPath:(NSIndexPath *)indexpath AndViewTag:(NSInteger)viewTag;
@end
