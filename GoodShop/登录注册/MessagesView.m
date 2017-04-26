//
//  MessagesView.m
//  GoodShop
//
//  Created by MIAO on 16/11/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "MessagesView.h"
@implementation MessagesView
{
    UITextField *telNumber;//手机号
    UITextField *codeFiled;//验证码
    UIButton *loginBtn,*sendCode;
    NSInteger seconds;//计时
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
        seconds = 120;
    }
    return self;
}
-(void)initSubViews
{
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30*MCscale, 22*MCscale, 22*MCscale)];
    phoneImage.backgroundColor = [UIColor clearColor];
    phoneImage.image = [UIImage imageNamed:@"输入手机号"];
    [self addSubview:phoneImage];
    
    telNumber = [[UITextField alloc]initWithFrame:CGRectMake(phoneImage.right, 25*MCscale, 190*MCscale, 35*MCscale)];
    telNumber.placeholder = @"请输入登录手机号";
    telNumber.tag = 11001;
    telNumber.delegate = self;
    telNumber.textColor = [UIColor blackColor];
    telNumber.font = [UIFont systemFontOfSize:MLwordFont_11];
    telNumber.textAlignment = NSTextAlignmentLeft;
    telNumber.backgroundColor = [UIColor clearColor];
    telNumber.keyboardType  = UIKeyboardTypeNumberPad;
    [self addSubview:telNumber];
    
    sendCode = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCode.frame = CGRectMake(telNumber.right+2, 25*MCscale, kDeviceWidth-telNumber.width-65*MCscale, 40*MCscale);
    sendCode.backgroundColor = txtColors(248, 53, 74, 1);
    [sendCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendCode.titleLabel.font =[UIFont systemFontOfSize:MLwordFont_2];
    sendCode.layer.cornerRadius = 3.0;
    sendCode.layer.masksToBounds = YES;
    [sendCode addTarget:self action:@selector(changeRegisterStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendCode];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale,telNumber.bottom+10*MCscale, telNumber.width+20, 1)];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    UIImageView *codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(22,phoneImage.bottom + 30*MCscale, 20*MCscale, 22*MCscale)];
    codeImage.backgroundColor = [UIColor clearColor];
    codeImage.image = [UIImage imageNamed:@"验证码"];
    [self addSubview:codeImage];
    
    codeFiled = [[UITextField alloc]initWithFrame:CGRectMake(codeImage.right+2, telNumber.bottom +20*MCscale , 190*MCscale, 30*MCscale)];
    codeFiled.placeholder = @"请输入短信验证码";
    codeFiled.keyboardType = UIKeyboardTypeNumberPad;
    codeFiled.textColor = [UIColor blackColor];
    codeFiled.backgroundColor = [UIColor clearColor];
    codeFiled.textAlignment = NSTextAlignmentLeft;
    codeFiled.font = [UIFont systemFontOfSize:MLwordFont_11];
    [self addSubview:codeFiled];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, codeFiled.bottom+10, kDeviceWidth, 1)];
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = 5.0;
    loginBtn.frame = CGRectMake(20*MCscale, line2.bottom+30*MCscale, self.width-40*MCscale, 45*MCscale);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = txtColors(248, 53, 74, 1);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_11];
    [loginBtn addTarget:self action:@selector(changeRegisterStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
}

-(void)changeRegisterStyle:(UIButton *)button
{
    if (button == sendCode) {
        if (telNumber.text.length == 0 ) {
            [self promptMessageWithString:@"手机号码不能为空"];
        }
        else
        {
            [self sendCode];
        }
    }
    else if(button == loginBtn)
    {
        [self login];
    }
}
-(void)countdownAction
{
    seconds--;
    if (seconds>0) {
        NSString *secondsStr = [NSString stringWithFormat:@"%lds后重发",(long)seconds];
        sendCode.backgroundColor = txtColors(213, 213, 213, 1);
        sendCode.enabled = NO;
        [sendCode setTitle:secondsStr forState:UIControlStateNormal];
        [self performSelector:@selector(countdownAction) withObject:self afterDelay:1];
    }
    else{
        sendCode.backgroundColor = txtColors(248, 53, 74, 1);
        [sendCode setTitle:@"发送验证码" forState:UIControlStateNormal];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        seconds = 120;
    }
}
#pragma mark 发送验证码
-(void)sendCode
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"user.tel":telNumber.text}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"registerCheckLogin.action" params:pram success:^(id json) {
        NSLog(@"验证码%@",json);
        [Hud hide:YES];
        if ([[json objectForKey:@"message"]intValue]==1) {
            [self promptMessageWithString:@"验证码发送成功"];
            [self countdownAction];
        }
        else if([[json objectForKey:@"message"]intValue]==2){
            [self promptMessageWithString:@"手机号码格式有误"];
        }
        else if([[json objectForKey:@"message"]intValue]==3){
            [self promptMessageWithString:@"号码未注册"];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark 登录
-(void)login
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"user.tel":telNumber.text,@"code":codeFiled.text,@"user.shebeiId":userSheBei_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"loginByYanzhengma.action" params:pram success:^(id json) {
        NSDictionary * dic = (NSDictionary * )json;
        NSLog(@"登录%@",json);
        [Hud hide:YES];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        if ([[dic objectForKey:@"message"]intValue]==1) {
            [def setInteger:1 forKey:@"isLogin"];
            [def setValue:telNumber.text forKey:@"userTel"];
            [def setValue:[json valueForKey:@"dianpuname"] forKey:@"dianpuName"];
            NSString *usid = [NSString stringWithFormat:@"%@",[json objectForKey:@"userid"]];
            [def setValue:usid forKey:@"userId"];
            [def setValue:[json valueForKey:@"dianpuid"] forKey:@"dianpuId"];
            [def setValue:@"1" forKey:@"isFirst"];
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            if ([self.codeloginDelegate respondsToSelector:@selector(loginSuccessWithCodeDict:AndIndex:)]) {
                [self.codeloginDelegate loginSuccessWithCodeDict:dic AndIndex:1];
            }
            [telNumber resignFirstResponder];
            [codeFiled resignFirstResponder];
            
            NSNotification *userLoginNotification = [NSNotification notificationWithName:@"userLoginNotification" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:userLoginNotification];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLoginNotification" object:nil];
            
            if ([[json valueForKey:@"canshu"] integerValue] == 1) {
                //denglulinshi.action
                
                [HTTPTool getWithUrlPath:HTTPWeb AndUrl:@"Denglulinshi.action" params:nil success:^(id json) {
                } failure:^(NSError *error) {
                    
                }];
            }
            
            NSNotification *kaihuPanduanNoti = [NSNotification notificationWithName:@"kaihuPanduanNoti" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:kaihuPanduanNoti];
            [[NSNotificationCenter defaultCenter]removeObserver:self];

        }
        else if([[dic objectForKey:@"message"]intValue]==0){
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if([[dic objectForKey:@"message"]intValue]==2){
            [self promptMessageWithString:@"手机号码格式有误"];
        }
        else if([[dic objectForKey:@"message"]intValue]==3){
            [self promptMessageWithString:@" 验证码有误"];
        }
        else if([[dic objectForKey:@"message"]intValue]==4){
            [self promptMessageWithString:@"当前号码未注册"];
        }
        
    } failure:^(NSError *error) {
        [Hud hide:YES];
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
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [telNumber resignFirstResponder];
    [codeFiled resignFirstResponder];
}

-(void)myTask
{
    sleep(1.5);
}
@end
