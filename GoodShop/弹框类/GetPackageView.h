//
//  GetPackageView.h
//  GoodShop
//
//  Created by MIAO on 2017/1/5.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetPackageViewDelegate <NSObject>

-(void)goumailibaoSuccessWithIndex:(NSInteger)index;

@end
@interface GetPackageView : UIView
@property(nonatomic,strong)id<GetPackageViewDelegate>getDelegate;
-(void)reloadDataWithDict:(NSDictionary *)dict;
@end
