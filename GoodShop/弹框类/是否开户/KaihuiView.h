//
//  KaihuiView.h
//  GoodShop
//
//  Created by MIAO on 2017/4/1.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KaihuiView;
@protocol KaihuiViewDelegate <NSObject>
@optional
-(void)OpenAnAccountWithIndex:(NSInteger )index;
@end
@interface KaihuiView : UIView

@property (nonatomic,weak)id<KaihuiViewDelegate>kaihuDelegate;

-(void)reloadKaifuData;
@end
