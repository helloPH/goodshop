//
//  carViewCell.h
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/21.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carDataModel.h"
@class carViewCell;
@protocol carCellViewDelegate <NSObject>

@optional
-(void)carViewCell:(carViewCell *)cellView atIndex:(NSInteger)index addoOrCut:(NSInteger)bol numCount:(NSInteger)num cellSelect:(NSInteger)sel;
-(void)carViewcell:(carViewCell *)cellView shooseGood:(NSInteger)chbol;
@end



@interface carViewCell : UITableViewCell
@property(nonatomic,retain)UIImageView *selectImageView; // 选中 商品图片 加减
@property(nonatomic,retain)UILabel*goodNum;
@property(nonatomic,assign)NSInteger selectBool;//是否选中
@property(nonatomic,assign)NSInteger numData;
@property(nonatomic,weak)id <carCellViewDelegate> delegate;

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
@end
