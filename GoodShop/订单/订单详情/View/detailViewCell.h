//
//  detailViewCell.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface detailViewCell : UITableViewCell

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
@end
