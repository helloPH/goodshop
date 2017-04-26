//
//  MainScrollView.h
//  PalmDoctor
//
//  Created by qichuang on 16/2/1.
//  Copyright © 2016年 qichuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainScrollViewDelegate <NSObject>

-(void)changeDianpuIdWithIndex:(NSInteger)index;

@end

@interface MainScrollView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,strong)id<MainScrollViewDelegate>scroDelegate;
@property(nonatomic,assign)NSInteger ViewTag;
@property(nonatomic,strong)UIScrollView *mainScroll;
@property(nonatomic,strong)UIPageControl *pageControl;

//为scrollview添加图片
-(void)addImageViewForScrollViewWith:(NSArray *)array;

@end
