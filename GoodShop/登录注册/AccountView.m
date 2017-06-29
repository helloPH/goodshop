//
//  AccountView.m
//  GoodShop
//
//  Created by MIAO on 16/11/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "AccountView.h"
#import "PHWeiXin.h"
#import "SetPassWordAtLoginView.h"

@interface AccountView()
@property (nonatomic,strong)NSDictionary * dataDicGetByPhone;


@end
@implementation AccountView
{
//    UITextField *tleTextFile;//电话号码
    UITextField *pasTextFile;//密码
    UIButton *loginBtn,*deleteBtn,*forgetPasBtn;//登录
    UILabel *remainLabel;//计时label
    NSInteger seconds;//计时
    UIImageView *isAutoImage;//是否自动登录选择
    
    UIButton * weixinBtn;
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
    UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:logoImg];
    logoImg.image=[UIImage imageNamed:@""];
    logoImg.tag=100;
    
    
    
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
    
    _tleTextFile = [[UITextField alloc]initWithFrame:CGRectZero];
    _tleTextFile.tag = 11001;
    _tleTextFile.backgroundColor = [UIColor clearColor];
    _tleTextFile.textAlignment = NSTextAlignmentLeft;
    _tleTextFile.font = [UIFont systemFontOfSize:MLwordFont_2];
    _tleTextFile.placeholder = @"请输入登录手机号";
    _tleTextFile.text = user_tel;
    if (_tleTextFile.text.length==11) {
        [self getLogoWithTel:_tleTextFile.text];
    }
    
    _tleTextFile.delegate = self;
    _tleTextFile.textColor = [UIColor blackColor];
    _tleTextFile.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_tleTextFile];
    
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
    
    
    weixinBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, loginBtn.bottom +40, 100, 30)];
    [weixinBtn setTitle:@"用微信登录" forState:UIControlStateNormal];
    [weixinBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [self addSubview:weixinBtn];
    [weixinBtn addTarget:self action:@selector(pullWeiXin) forControlEvents:UIControlEventTouchUpInside];
    weixinBtn.hidden=YES;
    [self reshBanbenBlockIsAfter:^(BOOL isAfter) {
        if (isAfter){
            weixinBtn.hidden=NO;
        }else{
            weixinBtn.hidden=YES;
        }
    }];
    
    
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
    UIImageView * logoImg = [self viewWithTag:100];// 头像
    logoImg.frame=CGRectMake(0, 80, 100, 100);
    logoImg.centerX=kDeviceWidth/2;
    
    
    
    UIImageView *userNameImage = [self viewWithTag:101]; // 账户
    userNameImage.frame = CGRectMake(20*MCscale,logoImg.bottom+ 25*MCscale, 30*MCscale, 30*MCscale);
    UIImageView *passdImage = [self viewWithTag:102]; //密码
    passdImage.frame = CGRectMake(20*MCscale, userNameImage.bottom+25*MCscale, 30*MCscale, 30*MCscale);
    
    
    _tleTextFile.frame = CGRectMake(userNameImage.right+5, userNameImage.top, self.width-120*MCscale, 30*MCscale);
    pasTextFile.frame = CGRectMake(passdImage.right+5, passdImage.top, self.width-70*MCscale, 30*MCscale);
    deleteBtn.frame = CGRectMake(_tleTextFile.right+10*MCscale, _tleTextFile.top+2, 25, 25);
    UIView *line1 = [self viewWithTag:104];//灰色分割线
    line1.frame = CGRectMake(10, _tleTextFile.bottom+12*MCscale, self.width-20, 1);
    UIView *line2 = [self viewWithTag:105];// 灰色分割线
    line2.frame = CGRectMake(10, pasTextFile.bottom+12*MCscale, self.width-20, 1);
    isAutoImage.frame = CGRectMake(45*MCscale, line2.bottom+18*MCscale, 22*MCscale, 22*MCscale);
    UILabel *autoLoginLabel = (UILabel *)[self viewWithTag:107]; //自动登录 label
    autoLoginLabel.frame = CGRectMake(isAutoImage.right+5, isAutoImage.top-4, 100*MCscale, 30*MCscale);
    
    forgetPasBtn.frame = CGRectMake(self.width-120*MCscale, autoLoginLabel.top, 100*MCscale, 30*MCscale);
    loginBtn.frame = CGRectMake(20*MCscale, isAutoImage.bottom+15*MCscale, self.width-40*MCscale, 45*MCscale);
    
    weixinBtn.top=loginBtn.bottom+40;
    weixinBtn.centerX=loginBtn.centerX;
    
    remainLabel.frame = CGRectMake(loginBtn.left+30*MCscale, loginBtn.top+13*MCscale, 20*MCscale, 20*MCscale);//倒计时
}
//btn事件
-(void)lognBtnAction:(UIButton *)btn
{
    if (btn == deleteBtn) {
        [self delAccount];//账号删除
        UIImageView *logoImg = [self viewWithTag:100];
        logoImg.image=nil;
        logoImg.backgroundColor=[UIColor clearColor];
        
        
        
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
    _tleTextFile.text = @"";
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
    if ([_tleTextFile.text isEqualToString:@""] || [pasTextFile.text isEqualToString:@""]) {
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
        NSString *logName = _tleTextFile.text;
        NSString *mdPasd = [md5_password encryptionPassword:pasTextFile.text userTel:logName];
        if (pasTextFile.text.length >20) {
            
            
            
            mdPasd = [md5_password encryptionPassword:pasTextFile.text];
        }
        
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
                [def setValue:_tleTextFile.text forKey:@"userTel"];
                
                if ([pasTextFile.text length]<15) {
                   [def setValue:pasTextFile.text forKey:@"userPass"];
                }else{
                    [def setValue:@"" forKey:@"userPass"];
                }
                [def setValue:[json valueForKey:@"dianpuname"] forKey:@"dianpuName"];
                NSString *usid = [NSString stringWithFormat:@"%@",[json objectForKey:@"userid"]];
                [def setValue:usid forKey:@"userId"];
                [def setValue:[json valueForKey:@"dianpuid"] forKey:@"dianpuId"];
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                if ([self.loginDelegate respondsToSelector:@selector(loginSuccessWithDict:AndIndex:)]) {
                    [self.loginDelegate loginSuccessWithDict:json AndIndex:1];
                }
                
                [_tleTextFile resignFirstResponder];
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
-(void)pullWeiXin{
    [shareWX loginBlock:^(BOOL isSuccess) {
        if (!isSuccess) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"未检测到微信,请安装微信或使用账号密码登录" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    shareWX.block=^(id url){
        
        NSDictionary * pram=@{@"code":[NSString stringWithFormat:@"%@",[url valueForKey:@"openid"]]};
        [Request getWXLoginPhotoAndPwWithDic:pram success:^(NSInteger message, id data) {
            if (message == 1) {// 有内容
//                [MBProgressHUD promptWithString:@"获取成功"];
                _tleTextFile.text=[NSString stringWithFormat:@"%@",[data valueForKey:@"tel"]];
                pasTextFile.text=[NSString stringWithFormat:@"%@",[data valueForKey:@"password"]];
                [self login];
                
            }else{// 没内容
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"当前未授权微信登录，请使用密码登录后在“安全设置”授权微信登录。" message:@"" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
//                [MBProgressHUD promptWithString:@""];
            }
        } failure:^(NSError *error) {
            
        }];
       
        
        [PHWeiXin attempDealloc];
    };
  
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
        NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        
         UIImageView *logoImg = [self viewWithTag:100];
        if (newString.length <= 11){
            if (newString.length<11) {// 手机号输入不完整
                logoImg.image=nil;
                logoImg.backgroundColor=[UIColor clearColor];
            }else{//
                [self getLogoWithTel:newString];
            }
            
            return YES;
        }
        else
            return NO;

    }
    return YES;
}
-(void)getLogoWithTel:(NSString *)tel{

    
    _dataDicGetByPhone = nil;
    NSDictionary * pram = @{@"code":tel};
    [Request getLogoByPhoneWithDic:pram success:^(NSInteger message, id data) {

//        [MBProgressHUD promptWithString:@"根据手机号获取logo"];
        
        
        _dataDicGetByPhone = [NSDictionary dictionaryWithDictionary:data];
        UIImageView * logoImg = [self viewWithTag:100];// 头像
        
        [logoImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[data valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@""]];
        

        NSString * password = [NSString stringWithFormat:@"%@",[data valueForKey:@"password"]];
        NSString * userid = [NSString stringWithFormat:@"%@",[data valueForKey:@"userid"]];
        
       
        if ([password isEqualToString:@"0"]) {
            
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"直接登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                pasTextFile.text=@"123456";
                [self login];
            }];
            [cancelAction setValue:redTextColor forKey:@"_titleTextColor"];
            
            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"重置密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SetPassWordAtLoginView * setpass = [SetPassWordAtLoginView new];
                setpass.Id=userid;
                setpass.tel=tel;
                [setpass appear];
                setpass.block=^(NSString * newPass){
                    
                    pasTextFile.text = newPass;
                    [self login];
                };
//                _newpasView.alpha = 0.95;
//                [self addSubview:_newpasView];
            }];
            [suerAction setValue:naviBarTintColor forKey:@"_titleTextColor"];
    
            
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"您的初始密码为123456是否重置" preferredStyle:1];
            NSMutableAttributedString * mes = [[NSMutableAttributedString alloc]initWithString:@"您的初始密码为123456是否重置"];
            [mes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, [[mes string] length])];
            [mes addAttribute:NSForegroundColorAttributeName value:textBlackColor range:NSMakeRange(0, [[mes string] length])];
            [alert setValue:mes forKey:@"attributedMessage"];
            
            
            [alert addAction:suerAction];
            [alert addAction:cancelAction];
            [self.controller presentViewController:alert animated:YES completion:nil];
            
            

            
            
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_tleTextFile resignFirstResponder];
    [pasTextFile resignFirstResponder];
}

// 刷新 是不是最新版本
-(void)reshBanbenBlockIsAfter:(void(^)(BOOL isAfter))block{
    if (banben_IsAfter){
        block(YES);
        return;
    }
    [Request getBanBenInfo1Success:^(NSInteger message, id data) {
        if (message == 0 || message == 1) {
            set_Banben_IsAfter(YES);
            block(YES);
            return;
        }
        set_Banben_IsAfter(NO);
        block(NO);
    } failure:^(NSError *error) {
        set_Banben_IsAfter(NO);
        block(NO);
    }];
}

@end
