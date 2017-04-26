//
//  TypeSelectedCell.h
//  ManageForMM
//
//  Created by MIAO on 16/11/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeSelectedCell : UITableViewCell

@property(nonatomic,strong)UILabel *typeLabel;

/**
 *  分类
*/
-(void)reloadDataForFenleiWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;

/**
 *  行业信息
 */
-(void)reloadDataForHangyeWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;

/**
 *  合作内容
 */
-(void)reloadDataForHezuoWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;

@end
