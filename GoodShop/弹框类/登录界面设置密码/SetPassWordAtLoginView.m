//
//  SetPassWordAtLoginView.m
//  GoodShop
//
//  Created by MIAO on 2017/6/17.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "SetPassWordAtLoginView.h"
@interface SetPassWordAtLoginView()
@property (nonatomic,strong)UIScrollView * backView;


@end
@implementation SetPassWordAtLoginView
-(instancetype)init{
    if (self=[super initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 200*MCscale)]) {
        
        [self newView];
        
        
    }
    return self;
}
-(void)newView{
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [_backView addGestureRecognizer:tap];
    [_backView addSubview:self];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    NSArray *placeHolderArray = @[@"请输入新密码",@"确认新密码"];
    for (int i = 0; i<2; i++) {
        UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(10*MCscale, (20+55*i)*MCscale, self.width-20*MCscale, 40*MCscale)];
      
        password.placeholder = placeHolderArray[i];
        password.textAlignment = NSTextAlignmentCenter;
        password.textColor = [UIColor blackColor];
        password.font = [UIFont systemFontOfSize:MLwordFont_2];
        password.backgroundColor = [UIColor clearColor];
        password.tag = i+1;
        [password setSecureTextEntry:YES];
        password.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:password];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5*MCscale, password.bottom+5*MCscale, self.width-10*MCscale, 1)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
    }
    UILabel *saveBtnLb = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-60*MCscale, (self.width-2)/2.0, 40)];
    saveBtnLb.backgroundColor = [UIColor clearColor];
    saveBtnLb.textColor = [UIColor blackColor];
    saveBtnLb.textAlignment = NSTextAlignmentCenter;
    saveBtnLb.text = @"稍后再说";
    saveBtnLb.font = [UIFont systemFontOfSize:MLwordFont_2];
    saveBtnLb.userInteractionEnabled = YES;
    saveBtnLb.tag = 1001;
    [self addSubview:saveBtnLb];
    UITapGestureRecognizer *saveTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [saveBtnLb addGestureRecognizer:saveTap];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.width/2.0, self.height-68*MCscale, 1, 60*MCscale)];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    
    UILabel *cancelBtnLb = [[UILabel alloc]initWithFrame:CGRectMake(saveBtnLb.right+2, self.height-60*MCscale, (self.width-2)/2.0, 40)];
    cancelBtnLb.backgroundColor = [UIColor clearColor];
    cancelBtnLb.textColor = txtColors(255, 40, 48, 1);
    cancelBtnLb.text = @"确定提交";
    cancelBtnLb.textAlignment = NSTextAlignmentCenter;
    cancelBtnLb.font = [UIFont systemFontOfSize:MLwordFont_2];
    cancelBtnLb.userInteractionEnabled = YES;
    [self addSubview:cancelBtnLb];
    cancelBtnLb.tag = 1002;
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savePasBtnAction:)];
    [cancelBtnLb addGestureRecognizer:cancelTap];
}
-(void)savePasBtnAction:(UITapGestureRecognizer *)tap
{

    UITextField *paswd = (UITextField *)[self viewWithTag:1];
    UITextField *paswdagn = (UITextField *)[self viewWithTag:2];
    if ([paswd.text isEqualToString:@"123456"]) {
        [MBProgressHUD promptWithString:@"密码过于简单,请设置其他密码!"];
        return;
    }
    
    if (![paswd.text isEqualToString:@""]) {
        if ([paswd.text isEqualToString:paswdagn.text]) {
            NSString *mdPasd = [md5_password encryptionPassword:@"-1" userTel:_tel];
            NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"tel":_Id,@"yuanmima":mdPasd,@"xinmima":paswd.text}];
            [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"loginpwd1.action" params:pram success:^(id json) {
                NSDictionary *dic = (NSDictionary *)json;
                if ([[dic valueForKey:@"message"]integerValue]==1) {
                    [MBProgressHUD promptWithString:@"密码修改成功"];
                    
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setInteger:2 forKey:@"isLogin"];
                    [def setValue:paswd.text forKey:@"userPass"];
                    [self disAppear];
                    if (_block) {
                        _block(paswd.text);
                    }
                    //
                    //                    [self performSelector:@selector(login) withObject:self afterDelay:1.5];
                }
                else if ([[dic valueForKey:@"massage"]integerValue]==2){

                    [MBProgressHUD promptWithString:@"原密码有误重新填写"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD promptWithString:@"密码修改失败!请稍后再试"];

            }];
        }
        else{
               [MBProgressHUD promptWithString:@"两次密码不一致"];

        }
    }
    else{
         [MBProgressHUD promptWithString:@"不能为空"];

    }
}

-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    //    [[self getCurrentVC].view addSubview:_backView];
    //    [[UIViewController presentingVC].view addSubview:_backView];
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
