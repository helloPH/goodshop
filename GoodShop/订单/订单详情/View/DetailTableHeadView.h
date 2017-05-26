//
//  DetailTableHeadView.h
//  LifeForMM
//
//  Created by MIAO on 16/6/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailTableHeadViewDelegate <NSObject>

-(void)gotoDianpuFirst;
@end

@interface DetailTableHeadView : UIView

@property (nonatomic,strong)id<DetailTableHeadViewDelegate>headerDelegate;

//- (instancetype)initWithFrame:(CGRect)frame AndString:(NSString *)str;
@property (nonatomic,strong)NSString * dingdanleixing;
@property (nonatomic,strong)NSString * dindanzhuangtaidate;
-(void)createUIWithArray:(NSArray *)array;

@end
