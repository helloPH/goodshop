//
//  KaihuiView.m
//  GoodShop
//
//  Created by MIAO on 2017/4/1.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "KaihuiView.h"
#import "Header.h"

@interface KaihuiView ()

@property(nonatomic,strong)UILabel *kaihuContentLabel;
@property(nonatomic,strong)UIButton *cancalBtn,*kaihuBtn;
@property(nonatomic,strong)UIView *line1,*line2;

@end
@implementation KaihuiView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 10.0;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}

-(void)reloadKaifuData
{
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id}];
    
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbytiyandaoqi.action" params:pram success:^(id json) {
        NSLog(@"开户提示%@",json);
        self.kaihuContentLabel.text = [NSString stringWithFormat:@"    感谢您体验妙店佳用户端，赶快开启店铺后台管理账户吧！请在体验现金有效期（%@）前使用。",[json valueForKey:@"time"]];
    } failure:^(NSError *error) {
    }];
}
-(UILabel *)kaihuContentLabel
{
    if (!_kaihuContentLabel) {
        _kaihuContentLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:0 text:@""];
        [self addSubview:_kaihuContentLabel];
    }
    return _kaihuContentLabel;
}

-(UIButton *)cancalBtn
{
    if (!_cancalBtn) {
        _cancalBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor blackColor] backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"稍后再说" image:@""];
        [self addSubview:_cancalBtn];
        _cancalBtn.tag = 1000;
        [_cancalBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancalBtn;
}
-(UIButton *)kaihuBtn
{
    if (!_kaihuBtn) {
        _kaihuBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:txtColors(255, 79, 90, 1) backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"现在开户" image:@""];
        [self addSubview:_kaihuBtn];
        _kaihuBtn.tag = 1001;
        [_kaihuBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kaihuBtn;
}
-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_line1];
    }
    return _line1;
}
-(UIView *)line2
{
    if (!_line2) {
        _line2 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_line2];
    }
    return _line2;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.kaihuContentLabel.frame = CGRectMake(15*MCscale, 20*MCscale, self.width-30*MCscale, self.height-85*MCscale);
    self.cancalBtn.frame = CGRectMake(8, self.height-56*MCscale, self.width/2.0-8, 50*MCscale);
    self.kaihuBtn.frame = CGRectMake(self.width/2.0+1, self.height-56*MCscale, self.width/2.0-9, 50*MCscale);
    self.line1.frame  = CGRectMake(0,self.height-60*MCscale, self.width, 1);
    self.line2.frame  = CGRectMake(self.width/2.0, self.height-59*MCscale, 1, 59*MCscale);
}
-(void)btnAction:(UIButton *)btn
{
    if ([self.kaihuDelegate respondsToSelector:@selector(OpenAnAccountWithIndex:)]) {
        [self.kaihuDelegate OpenAnAccountWithIndex:btn.tag];
    }
}

@end

