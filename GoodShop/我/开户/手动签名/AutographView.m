//
//  AutographView.m
//  GoodYeWu
//
//  Created by MIAO on 2017/2/20.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "AutographView.h"
#import "Header.h"
#import "ZWview.h"
@interface AutographView ()
@property(nonatomic,strong)NSMutableArray * paths;
@property(nonatomic,strong)ZWview *autoView;
@property(nonatomic,strong)NSDictionary *imageDict;
@property(nonatomic,strong)NSString *arrayCount;
@end
@implementation AutographView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SignNotiClick:) name:@"SignNoti" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qingchuSignClick) name:@"qingchuSignClick" object:nil];
        _arrayCount = @"0";
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    NSArray *titleArray = @[@"确定",@"清除",@"取消"];
    CGFloat buttonWidth = (self.width - 12*MCscale)/titleArray.count;
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((buttonWidth +4*MCscale)*i+2*MCscale, self.height - 33*MCscale, buttonWidth, 30*MCscale);
        button.backgroundColor = txtColors(203, 203, 203, 1);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    [self addSubview:self.autoView];
    
}

-(NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

-(ZWview *)autoView
{
    if (_autoView == nil) {
        _autoView = [[ZWview alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height -35*MCscale)];
        _autoView.backgroundColor = [UIColor clearColor];
    }
    return _autoView;
}

-(void)SignNotiClick:(NSNotification *)noti
{
    _arrayCount = noti.userInfo[@"index"];
}
-(void)qingchuSignClick
{
    [_autoView qingpingView];
}
-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        if ([_arrayCount isEqual:[NSNull null]]) {
            _imageDict = @{};
        }
        else if ([_arrayCount isEqualToString:@"0"])
        {
            _imageDict = @{};
        }
        else
        {
            UIGraphicsBeginImageContext(_autoView.frame.size);
            [_autoView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            //        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            _imageDict = @{@"image":image};
        }
        
        if ([self.autoDelegate respondsToSelector:@selector(setImageWithIndex:WithDict:)]) {
            [self.autoDelegate setImageWithIndex:0 WithDict:_imageDict];
        }
    }
    else if (button.tag == 101)
    {
        [self.autoView qingpingView];
    }
    else
    {
        if ([self.autoDelegate respondsToSelector:@selector(setImageWithIndex:WithDict:)]) {
            [self.autoDelegate setImageWithIndex:2 WithDict:@{}];
        }
    }
}

@end
