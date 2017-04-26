//
//  ChangeAddressView.h
//  GoodShop
//
//  Created by MIAO on 2016/12/2.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userAddressModel.h"
#import "addressCell.h"
#import "Header.h"
@protocol ChangeAddressViewDelegate <NSObject>

-(void)changeAddressSuccessWithModel:(userAddressModel*)model AndArrayCount:(NSInteger)count;

@end
@interface ChangeAddressView : UIView<MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource,addressDelegate>

@property(nonatomic,strong)id<ChangeAddressViewDelegate>changeDelegate;
-(void)relodaDataWithDianpuID:(NSString *)dianpuId AndDefaultAddress:(NSString *)defaultStr;
@end
