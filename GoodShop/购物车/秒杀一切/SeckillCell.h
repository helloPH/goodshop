//
//  SeckillCell.h
//  GoodShop
//
//  Created by MIAO on 2017/1/4.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeckillCell : UITableViewCell
@property (nonatomic,strong)UIButton *SeckillBtn;

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
@end
