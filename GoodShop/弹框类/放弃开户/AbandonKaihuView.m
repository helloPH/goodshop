
//
//  AbandonKaihuView.m
//  GoodShop
//
//  Created by MIAO on 2017/4/5.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "AbandonKaihuView.h"
#import "Header.h"

@interface AbandonKaihuView ()<MBProgressHUDDelegate>

@property(nonatomic,strong)UILabel *kaihuContentLabel;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIView *line1;

@end
@implementation AbandonKaihuView
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

-(UILabel *)kaihuContentLabel
{
    if (!_kaihuContentLabel) {
        _kaihuContentLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:0 text:@"    我已决定撤销商户开户信息,放弃现金奖励,只用妙店佳用户端"];
        [self addSubview:_kaihuContentLabel];
    }
    return _kaihuContentLabel;
}

-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:5.0 text:@"确定" image:@""];
        [self addSubview:_sureBtn];
        _sureBtn.tag = 1000;
        [_sureBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_line1];
    }
    return _line1;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.kaihuContentLabel.frame = CGRectMake(15*MCscale, 20*MCscale, self.width-30*MCscale, self.height-100*MCscale);
    self.line1.frame  = CGRectMake(10*MCscale,self.kaihuContentLabel.bottom +10*MCscale, self.width-20*MCscale, 1);
    self.sureBtn.frame = CGRectMake(20*MCscale, self.height-55*MCscale, self.width-40*MCscale, 40*MCscale);
}
-(void)btnAction:(UIButton *)btn
{
    
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mbHud.delegate = self;
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    [mbHud show:YES];
    
    NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:@{@"userid":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"updatechexiaoxinxi.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"开户信息%@",json);
        if ([[json valueForKey:@"massages"] integerValue] == 0) {
            [self promptMessageWithString:@"撤销失败"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:[json valueForKey:@"kaihu"] forKey:@"kaihu"];
            if ([self.abandonDelegate respondsToSelector:@selector(abandonKaihuSuccess)]) {
                [self.abandonDelegate  abandonKaihuSuccess];
            }
        }
    } failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1.5);
}
@end

