//
//  AccountView.m
//  GoodShop
//
//  Created by MIAO on 16/11/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "AccountView.h"
@implementation AccountView
{
    UITextField *tleTextFile;//电话号码
    UITextField *pasTextFile;//密码
    UIButton *loginBtn,*deleteBtn,*forgetPasBtn;//登录
    UILabel *remainLabel;//计时label
    NSInteger seconds;//计时
    UIImageView *isAutoImage;//是否自动登录选择
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
        
        [self performSelector:@selector(countdownAction) withObject:self afterDelay:1];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timerStop) name:@"timerStopNoti" object:nil];
    }
    return self;
}

-(void)timerStop
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    seconds = 5;
}
-(void)initSubViews
{
    UIImageView *userNameImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    userNameImage.image = [UIImage imageNamed:@"账户"];
    userNameImage.tag = 101;
    userNameImage.backgroundColor = [UIColor clearColor];
    [self addSubview:userNameImage];
    UIImageView *passdImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    passdImage.image = [UIImage imageNamed:@"输入密码"];
    passdImage.tag = 102;
    passdImage.backgroundColor = [UIColor clearColor];
    [self addSubview:passdImage];
    
    tleTextFile = [[UITextField alloc]initWithFrame:CGRectZero];
    tleTextFile.tag = 11001;
    tleTextFile.backgroundColor = [UIColor clearColor];
    tleTextFile.textAlignment = NSTextAlignmentLeft;
    tleTextFile.font = [UIFont systemFontOfSize:MLwordFont_2];
    tleTextFile.placeholder = @"请输入登录手机号";
    tleTextFile.text = user_tel;
    tleTextFile.delegate = self;
    tleTextFile.textColor = [UIColor blackColor];
    tleTextFile.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:tleTextFile];
    
    deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"账号删除"] forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor whiteColor];
    deleteBtn.tag = 103;
    [deleteBtn addTarget:self action:@selector(lognBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectZero];
    line1.tag =104;
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    pasTextFile = [[UITextField alloc]initWithFrame:CGRectZero];
    pasTextFile.tag = 11002;
    pasTextFile.placeholder = @"请输入密码";
    pasTextFile.text = user_pass;
    [pasTextFile setSecureTextEntry:YES];
    pasTextFile.delegate = self;
    pasTextFile.textAlignment = NSTextAlignmentLeft;
    pasTextFile.textColor = [UIColor blackColor];
    pasTextFile.font = [UIFont systemFontOfSize:MLwordFont_2];
    pasTextFile.backgroundColor = [UIColor clearColor];
    [self addSubview:pasTextFile];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectZero];
    line2.tag =105;
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
    
    isAutoImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"] isEqualToString:@"1"]) {
        isAutoImage.image = [UIImage imageNamed:@"选中"];
    }
    else
        isAutoImage.image = [UIImage imageNamed:@"选择"];
    isAutoImage.backgroundColor = [UIColor clearColor];
    isAutoImage.tag = 106;
    isAutoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [isAutoImage addGestureRecognizer:tap];
    [self addSubview:isAutoImage];
    
    UILabel *autoLoginLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    autoLoginLabel.textColor = textBlackColor;
    autoLoginLabel.tag = 107;
    autoLoginLabel.text = @"自动登录";
    autoLoginLabel.textAlignment = NSTextAlignmentLeft;
    autoLoginLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    autoLoginLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:autoLoginLabel];
    autoLoginLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *lbTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [autoLoginLabel addGestureRecognizer:lbTap];
    
    
    forgetPasBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasBtn.backgroundColor = [UIColor clearColor];
    [forgetPasBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPasBtn setTitleColor:mainColor forState:UIControlStateNormal];
    forgetPasBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [forgetPasBtn addTarget:self action:@selector(lognBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetPasBtn];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.tag = 109;
    loginBtn.layer.cornerRadius = 5.0;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = txtColors(248, 53, 74, 1);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_11];
    [loginBtn addTarget:self action:@selector(lognBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    remainLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"] isEqualToString:@"1"]){
        remainLabel.text = @"5";
    }
    else
        remainLabel.text = @"";
    remainLabel.alpha = 0;
    remainLabel.textAlignment = NSTextAlignmentCenter;
    remainLabel.textColor = [UIColor whiteColor];
    remainLabel.backgroundColor = [UIColor clearColor];
    remainLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self addSubview:remainLabel];
    
    UIView *line3 =[[UIView alloc]initWithFrame:CGRectZero];
    line3.tag = 112;
    line3.backgroundColor = txtColors(25, 182, 133, 1);
    [self addSubview:line3];//
    seconds = 5;//
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIImageView *userNameImage = [self viewWithTag:101]; // 账户
    userNameImage.frame = CGRectMake(20*MCscale, 25*MCscale, 30*MCscale, 30*MCscale);
    UIImageView *passdImage = [self viewWithTag:102]; //密码
    passdImage.frame = CGRectMake(20*MCscale, userNameImage.bottom+25*MCscale, 30*MCscale, 30*MCscale);
    tleTextFile.frame = CGRectMake(userNameImage.right+5, 25*MCscale, self.width-120*MCscale, 30*MCscale);
    pasTextFile.frame = CGRectMake(passdImage.right+5, passdImage.top, self.width-70*MCscale, 30*MCscale);
    deleteBtn.frame = CGRectMake(tleTextFile.right+10*MCscale, 27, 25, 25);
    UIView *line1 = [self viewWithTag:104];//灰色分割线
    line1.frame = CGRectMake(10, tleTextFile.bottom+12*MCscale, self.width-20, 1);
    UIView *line2 = [self viewWithTag:105];// 灰色分割线
    line2.frame = CGRectMake(10, pasTextFile.bottom+12*MCscale, self.width-20, 1);
    isAutoImage.frame = CGRectMake(45*MCscale, line2.bottom+18*MCscale, 22*MCscale, 22*MCscale);
    UILabel *autoLoginLabel = (UILabel *)[self viewWithTag:107]; //自动登录 label
    autoLoginLabel.frame = CGRectMake(isAutoImage.right+5, isAutoImage.top-4, 100*MCscale, 30*MCscale);
    
    forgetPasBtn.frame = CGRectMake(self.width-120*MCscale, autoLoginLabel.top, 100*MCscale, 30*MCscale);
    loginBtn.frame = CGRectMake(20*MCscale, isAutoImage.bottom+15*MCscale, self.width-40*MCscale, 45*MCscale);
    remainLabel.frame = CGRectMake(loginBtn.left+30*MCscale, loginBtn.top+13*MCscale, 20*MCscale, 20*MCscale);//倒计时
}
//btn事件
-(void)lognBtnAction:(UIButton *)btn
{
    if (btn == deleteBtn) {
        [self delAccount];//账号删除
    }
    else if (btn == loginBtn){
        [self login]; //登录
    }
    else if (btn == forgetPasBtn)
    {
        [self timerStop];
        if ([self.loginDelegate respondsToSelector:@selector(loginSuccessWithDict:AndIndex:)]) {
            [self.loginDelegate loginSuccessWithDict:@{} AndIndex:2];
        }
    }
}
//tap事件
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    NSInteger tapTag = tap.view.tag;
    if (tapTag == 106 || tapTag == 107){
        [self autoLoginAction]; //是否自动登录
    }
}
//清除账号
-(void)delAccount
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    remainLabel.alpha = 0;
    seconds = 5;
    tleTextFile.text = @"";
    pasTextFile.text = @"";
}
//自动登录选中
-(void)autoLoginAction
{
    UIImageView *image = (UIImageView *)[self viewWithTag:106];
    NSString *isAuto_bol = @"1";
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"]) {
        isAuto_bol = [[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"];
    }
    else
    {
        isAuto_bol = @"1";
    }
    if ([isAuto_bol isEqualToString:@"1"]) {
        image.image = [UIImage imageNamed:@"选择"];
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"longCode_bol"];
    }
    else{
        image.image = [UIImage imageNamed:@"选中"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"longCode_bol"];
        remainLabel.alpha = 1;
        [self countdownAction];
    }
}

//倒计时
-(void)countdownAction
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"longCode_bol"] isEqualToString:@"1"]){
        seconds--;
        if (seconds>0) {
            remainLabel.text = [NSString stringWithFormat:@"%ld",(long)seconds];
            [self performSelector:@selector(countdownAction) withObject:self afterDelay:1];
            remainLabel.alpha = 1;
        }
        else{
            [loginBtn setTitle:@"登录中..." forState:UIControlStateNormal];
            remainLabel.text = @"";
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            seconds = 5;
            [self login];
        }
    }
    else{
        remainLabel.text = @"";
        seconds = 5;
    }
}
#pragma mark -- 登陆
-(void)login
{
    if ([tleTextFile.text isEqualToString:@""] || [pasTextFile.text isEqualToString:@""]) {
        [self requestNetworkWrong:@"账户或密码不能为空"];
    }
    else
    {
        [loginBtn setTitle:@"登录中..." forState:UIControlStateNormal];
        remainLabel.text = @"";
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        seconds = 5;
        MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        Hud.mode = MBProgressHUDModeIndeterminate;
        Hud.delegate = self;
        Hud.labelText = @"请稍等...";
        [Hud show:YES];
        NSString *logName = tleTextFile.text;
        NSString *mdPasd = [md5_password encryptionPassword:pasTextFile.text userTel:logName];
        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
        [jsonDict setObject:logName forKey:@"user.tel"];
        [jsonDict setObject:mdPasd forKey:@"user.password"];
        [jsonDict setObject:userSheBei_id forKey:@"user.shebeiId"];
        //        [jsonDict setObject:user_dianpuId forKey:@"user.defaultShequ"];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"login4.action" params:jsonDict success:^(id json) {
            NSLog(@"登录%@",json);
            [Hud hide:YES];
            if ([[json objectForKey:@"massage"]intValue]==2) {
                seconds = 5;
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setInteger:1 forKey:@"isLogin"];
                [def setValue:tleTextFile.text forKey:@"userTel"];
                [def setValue:pasTextFile.text forKey:@"userPass"];
                [def setValue:[json valueForKey:@"dianpuname"] forKey:@"dianpuName"];
                NSString *usid = [NSString stringWithFormat:@"%@",[json objectForKey:@"userid"]];
                [def setValue:usid forKey:@"userId"];
                [def setValue:[json valueForKey:@"dianpuid"] forKey:@"dianpuId"];
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                if ([self.loginDelegate respondsToSelector:@selector(loginSuccessWithDict:AndIndex:)]) {
                    [self.loginDelegate loginSuccessWithDict:json AndIndex:1];
                }
                
                [tleTextFile resignFirstResponder];
                [pasTextFile resignFirstResponder];
                
                NSNotification *userLoginNotification = [NSNotification notificationWithName:@"userLoginNotification" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:userLoginNotification];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLoginNotification" object:nil];
                if ([[json valueForKey:@"canshu"] integerValue] == 1) {
                    
                    [HTTPTool getWithUrlPath:HTTPWeb AndUrl:@"Denglulinshi.action" params:nil success:^(id json) {
                    } failure:^(NSError *error) {
                        
                    }];
                }
                
                NSNotification *kaihuPanduanNoti = [NSNotification notificationWithName:@"kaihuPanduanNoti" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:kaihuPanduanNoti];
                [[NSNotificationCenter defaultCenter]removeObserver:self];
            }
            else{
                [self requestNetworkWrong:@"账号或密码错误"];
                [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            }
        } failure:^(NSError *error) {
            [Hud hide:YES];
            [self requestNetworkWrong:@"网络连接错误"];
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        }];
    }
}
-(void)requestNetworkWrong:(NSString *)wrongStr
{
    MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    bud.mode = MBProgressHUDModeCustomView;
    bud.labelText = wrongStr;
    [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
#pragma mark -- UITextFilerDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    remainLabel.alpha = 0;
    if (textField.tag == 11002 || textField.tag == 11001) {
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 11001){
        NSInteger leng = textField.text.length;
        NSInteger selectLeng = range.length;
        NSInteger replaceLeng = string.length;
        if (leng - selectLeng + replaceLeng > 11){
            return NO;
        }
        else
            return YES;
    }
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [tleTextFile resignFirstResponder];
    [pasTextFile resignFirstResponder];
}


@end
