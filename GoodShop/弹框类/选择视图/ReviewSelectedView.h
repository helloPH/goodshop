//
//  ReviewSelectedView.h
//  ManageForMM
//
//  Created by MIAO on 16/11/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@protocol ReviewSelectedViewDelegate <NSObject>

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"
//这里是会报警告的代码
//选择分类
-(void)selectedFenleiWithString:(NSString *)string;

//选择分类
-(void)selectedHangyeWithHangyeName:(NSString *)hangyeName AndID:(NSString *)ID;

//选择合作内容
-(void)selectedHezuoWithHezuoName:(NSString *)hezuoName AndID:(NSString *)ID;

#pragma clang diagnostic pop

@end
@interface ReviewSelectedView : UIView<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

@property (nonatomic,strong)id<ReviewSelectedViewDelegate>selectedDelegate;
@property(nonatomic,strong)NSString *dianpuID;
@property(nonatomic,strong)NSArray *nameArray;
-(void)reloadDataWithViewTag:(NSInteger)index;

@end
