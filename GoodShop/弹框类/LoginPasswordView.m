//
//  LoginPasswordView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/16.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "LoginPasswordView.h"
@interface LoginPasswordView()
@property (nonatomic,strong)UIScrollView * backView;
@end
@implementation LoginPasswordView
{
    UIButton *sureBtn;
    UITextField *filed;
}
-(instancetype)init{
    if (self=[super init]) {
        _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
        [_backView addGestureRecognizer:tap];
        [_backView addSubview:self];
        
        
        self.frame=CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
    }
    return self;
}


-(void)createUI
{
    filed = [[UITextField alloc]initWithFrame:CGRectMake(10, 55,self.width-20 , 40)];
    filed.tag = 101;
    filed.placeholder = @"请输入登录密码";
    [filed setSecureTextEntry:YES];
    filed.textAlignment = NSTextAlignmentCenter;
    filed.textColor = [UIColor blackColor];
    filed.font = [UIFont systemFontOfSize:MLwordFont_2];
    filed.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:filed];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, filed.bottom+10, self.width-20, 1)];
    line.backgroundColor = lineColor;
    [self addSubview:line];
    
    sureBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = redTextColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 3.0;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    [sureBtn setTitle:@"登录密码验证" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}
-(void)layoutSubviews
{
    sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}
-(void)sureBtnClick:(UIButton *)btn
{
    NSString *pas = [md5_password encryptionPassword:filed.text userTel:user_tel];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id,@"pwd":pas}];
    
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"checkPwd1.action" params:pram success:^(id json) {
        NSLog(@"登录密码验证%@",json);
        if ([[json valueForKey:@"message"] integerValue]== 1) {
            NSDictionary * dic = @{@"fieldText":filed.text};
            filed.text = @"";
            NSNotification *fieldText = [NSNotification notificationWithName:@"fieldText" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:fieldText];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fieldText" object:nil];
            
            if ([self.loginPasswordDelegate respondsToSelector:@selector(LoginPasswordViewSuccessWithIndex:)]){
                [self.loginPasswordDelegate LoginPasswordViewSuccessWithIndex:self.indexPath];
            }
            if (_block) {
                _block();
            }
            
        }
        else{
            [MBProgressHUD promptWithString:@"登录密码错误!请重新输入"];
//            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//            mbHud.mode = MBProgressHUDModeText;
//            mbHud.labelText = @"登录密码错误!请重新输入";
//            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
            [MBProgressHUD promptWithString:@"网络连接错误"];
//        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//        bud.mode = MBProgressHUDModeCustomView;
//        bud.labelText = @"网络连接错误";
//        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }];
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}

-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    
    //    [[self getCurrentVC].view addSubview:_backView];
    //    [[UIViewController presentingVC].view addSubview:_backView];
    
    [_backView addSubview:self];
    _backView.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    }];
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}
@end
