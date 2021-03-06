//
//  MoNiSystemAlert.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "MoNiSystemAlert.h"
#import "Header.h"



@interface MoNiSystemAlert()
@property (nonatomic,assign)CGFloat offsetY;

//@property (nonatomic,strong)UIScrollView * backView;
@property (nonatomic,strong)UILabel * contentLabel;

@end
@implementation MoNiSystemAlert
-(instancetype)init{
    if (self=[super  init]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
//    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    
    
    self.frame=CGRectMake(5*MCscale, 20*MCscale,[UIScreen mainScreen].bounds.size.width-10*MCscale , 20);
    self.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    //    self.clipsToBounds=YES;
//    [_backView addSubview:self];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
//    [self addGestureRecognizer:tap];
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(alertSpan:)];
    
    //    UIScreenEdgePanGestureRecognizer * edge = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(alertSpan:)];
    
    [self addGestureRecognizer:pan];
    
    
    UIView * moniself = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:moniself];
    moniself.layer.cornerRadius = 15.0;
    moniself.clipsToBounds = YES;
    
    
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 30*MCscale)];
    topView.backgroundColor=[UIColor whiteColor];
    topView.alpha=1;
    [moniself addSubview:topView];
    
    
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(10*MCscale, 5*MCscale, topView.height-10*MCscale, topView.height-10*MCscale)];
    icon.image=[UIImage imageNamed:@"icon11"];
    [topView addSubview:icon];
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(icon.right + 5*MCscale, 5*MCscale, 100, icon.height)];
    name.textColor=textBlackColor;
    name.font=[UIFont systemFontOfSize:MLwordFont_6];
    [topView addSubview:name];
    name.text=@"妙店佳商铺";
    
    UILabel * time = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 5*MCscale, 100, icon.height)];
    time.right=topView.width-10*MCscale;
    time.textColor=textBlackColor;
    time.font=[UIFont systemFontOfSize:MLwordFont_6];
    [topView addSubview:time];
    time.textAlignment=NSTextAlignmentRight;
    time.text=@"刚刚";
    
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale, topView.bottom+5*MCscale, self.width-20*MCscale, 20*MCscale)];
    [moniself addSubview:title];
    title.textColor=[UIColor blackColor];
    title.font=[UIFont systemFontOfSize:MLwordFont_5];
    
    _contentLabel = title;
    
    self.height = title.bottom+10*MCscale;
    moniself.height =self.height;
//    _backView.height = self.bottom;
    
    [UIView animateWithDuration:4 animations:^{
        topView.alpha=0.9;
    }completion:^(BOOL finished) {
        [self disAppear];
    }];
    
}
-(void)setContent:(NSString *)content{
    _content = content;
    _contentLabel.text = [NSString stringWithFormat:@"你好：你的重置密码验证码是“%@“",content];
}
-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0.95;
    }];
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)alertSpan:(UIPanGestureRecognizer *)pan{
    
    
    CGFloat y =  [pan locationInView:pan.view.superview].y;
    
    
    
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            
            _offsetY = y - pan.view.top;
            
            
            break;
        case UIGestureRecognizerStateChanged:
            pan.view.top = y - _offsetY;
            break;
        case UIGestureRecognizerStateEnded:
            if (pan.view.top<0) {
                [self disAppear];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    pan.view.top = 20 *MCscale;
                }];
            }
            
            //            _offsetY = 0;
            
            break;
        default:
            break;
    }
}
@end
