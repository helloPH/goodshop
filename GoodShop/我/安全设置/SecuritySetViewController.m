//
//  SecuritySetViewController.m
//  GoodShop
//
//  Created by MIAO on 16/11/25.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "SecuritySetViewController.h"
#import "SetPaymentPasswordView.h"
#import "LoginPasswordView.h"
#import "ChangePhoneNumber.h"
#import "TrueNameView.h"
#import "BindMailboxView.h"
#import "Header.h"
#import "PopView.h"
@interface SecuritySetViewController ()<MBProgressHUDDelegate,SetPaymentPasswordViewDelegate,LoginPasswordViewDelegate,ChangePhoneNumberDelegate,TrueNameViewDelegate,BindMailboxViewDelegate,PopViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation SecuritySetViewController
{
    UIView *shebeiBackView;//设备view
    UIView *renzhengView;//认证view
    UIImageView *rzImageView;//认证Image
    UILabel *rzTitleLabel;
    UIImageView *rzrightImgaeView;
    UILabel *rzstateLabel;
    UIView *yirenzhengView;//已认证View
    UILabel *nameLabel;
    UILabel *numberLabel;
    UIButton *outLoginBtn;
    LoginPasswordView *newPayPas;//支付密码
    SetPaymentPasswordView *nextPayPas;//支付密码下一步
    BindMailboxView *newEmail;//邮箱
    TrueNameView *tureName;//实名认证
    ChangePhoneNumber *changPhoneNextPop;//改变手机号下一步
    UIView *maskView;//键盘遮罩
    NSDictionary *safeDict;
    PopView *renzhengChangePayPop; //认证后修改支付密码
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }

    [self.navigationItem setTitle:@"安全设置"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMaskView];
    [self initSubViews];
    [self initData];
}

-(void)initSubViews
{
    NSArray *nameArray = @[@"已绑定手机号",@"登录密码",@"支付密码",@"绑定邮箱"];
    for (int i= 0; i<nameArray.count; i++) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 50*MCscale*i+84*MCscale, kDeviceWidth, 50*MCscale)];
        backView.backgroundColor = [UIColor clearColor];
        backView.tag = 100+i;
        [self.view addSubview:backView];
        
        UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapClick:)];
        [backView addGestureRecognizer:backViewTap];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*MCscale, 30*MCscale)];
        titleLabel.center = CGPointMake(85*MCscale, backView.height/2.0);
        titleLabel.text = nameArray[i];
        titleLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = textColors;
        titleLabel.backgroundColor = [UIColor clearColor];
        [backView addSubview:titleLabel];
        
        UIImageView *rightImgaeView = [[UIImageView alloc]initWithFrame:CGRectMake(backView.width-25*MCscale, titleLabel.top+5*MCscale, 15*MCscale, 20*MCscale)];
        rightImgaeView.image = [UIImage imageNamed:@"下拉键"];
        [backView addSubview:rightImgaeView];
        
        UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(backView.width - 70*MCscale, titleLabel.top, 45*MCscale, 30*MCscale)];
        stateLabel.tag = 200+i;
        stateLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.textColor = textColors;
        stateLabel.backgroundColor = [UIColor clearColor];
        [backView addSubview:stateLabel];
        
        if (i == 0 || i== 3) {
            UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right +10*MCscale, titleLabel.top+5*MCscale, 140*MCscale, 20*MCscale)];
            numLabel.tag = 300+i;
            numLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
            numLabel.textAlignment = NSTextAlignmentRight;
            numLabel.textColor = txtColors(213, 213, 213, 1);
            numLabel.backgroundColor = [UIColor clearColor];
            [backView addSubview:numLabel];
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, backView.height - 1,backView.width - 20*MCscale, 1)];
        lineView.backgroundColor = lineColor;
        [backView addSubview:lineView];
    }
    
#pragma mark 绑定设备
    shebeiBackView = [[UIView alloc]initWithFrame:CGRectMake(0,284*MCscale, kDeviceWidth, 50*MCscale)];
    shebeiBackView.tag = 104;
    shebeiBackView.backgroundColor = [UIColor clearColor];
    
    
    UITapGestureRecognizer *shebeiBackViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapClick:)];
    [shebeiBackView addGestureRecognizer:shebeiBackViewTap];
    
    UILabel *shebeiTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*MCscale, 30*MCscale)];
    shebeiTitleLabel.center = CGPointMake(85*MCscale, shebeiBackView.height/2.0);
    shebeiTitleLabel.text = @"更换绑定设备";
    shebeiTitleLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    shebeiTitleLabel.textAlignment = NSTextAlignmentLeft;
    shebeiTitleLabel.textColor = textColors;
    shebeiTitleLabel.backgroundColor = [UIColor clearColor];
    [shebeiBackView addSubview:shebeiTitleLabel];
    
    UIImageView *rightImgaeView = [[UIImageView alloc]initWithFrame:CGRectMake(shebeiBackView.width-25*MCscale, shebeiTitleLabel.top+5*MCscale, 15*MCscale, 20*MCscale)];
    rightImgaeView.image = [UIImage imageNamed:@"下拉键"];
    [shebeiBackView addSubview:rightImgaeView];
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(shebeiBackView.width - 70*MCscale, shebeiTitleLabel.top, 45*MCscale, 30*MCscale)];
    stateLabel.text = @"修改";
    stateLabel.tag = 204;
    stateLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.textColor = textColors;
    stateLabel.backgroundColor = [UIColor clearColor];
    [shebeiBackView addSubview:stateLabel];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, shebeiBackView.height - 1,shebeiBackView.width - 20*MCscale, 1)];
    lineView.backgroundColor = lineColor;
    [shebeiBackView addSubview:lineView];
#pragma mark 身份认证
    renzhengView = [[UIView alloc]initWithFrame:CGRectZero];
    renzhengView.tag = 105;
    renzhengView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:renzhengView];
    UITapGestureRecognizer *rzBackViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapClick:)];
    [renzhengView addGestureRecognizer:rzBackViewTap];
    
    rzImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [renzhengView addSubview:rzImageView];
    
    rzTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    rzTitleLabel.text = @"实名认证";
    rzTitleLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    rzTitleLabel.textAlignment = NSTextAlignmentLeft;
    rzTitleLabel.textColor = textColors;
    rzTitleLabel.backgroundColor = [UIColor clearColor];
    [renzhengView addSubview:rzTitleLabel];
    
    rzrightImgaeView = [[UIImageView alloc]initWithFrame:CGRectZero];
    rzrightImgaeView.image = [UIImage imageNamed:@"下拉键"];
    [renzhengView addSubview:rzrightImgaeView];
    
    rzstateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    rzstateLabel.text = @"完善信息加密账号安全";
    rzstateLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    rzstateLabel.textAlignment = NSTextAlignmentRight;
    rzstateLabel.textColor = textColors;
    rzstateLabel.backgroundColor = [UIColor clearColor];
    [renzhengView addSubview:rzstateLabel];
    
    UIView *rzlineView = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, 49*MCscale,kDeviceWidth-20*MCscale, 1)];
    rzlineView.backgroundColor = lineColor;
    [renzhengView addSubview:rzlineView];
    
#pragma mark 已认证
    yirenzhengView = [[UIView alloc]initWithFrame:CGRectZero];
    yirenzhengView.backgroundColor = [UIColor clearColor];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = textColors;
    nameLabel.backgroundColor = [UIColor clearColor];
    [yirenzhengView addSubview:nameLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, 39*MCscale, kDeviceWidth  -20*MCscale, 1)];
    line1.backgroundColor = lineColor;
    [yirenzhengView addSubview:line1];
    
    numberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    numberLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor = textColors;
    numberLabel.backgroundColor = [UIColor clearColor];
    [yirenzhengView addSubview:numberLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, 79*MCscale, kDeviceWidth -20*MCscale, 1)];
    line2.backgroundColor = lineColor;
    [yirenzhengView addSubview:line2];
    
#pragma mark 退出登录
    outLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    outLoginBtn.frame = CGRectMake(10*MCscale, kDeviceHeight-80*MCscale, kDeviceWidth-20*MCscale, 50*MCscale);
    outLoginBtn.backgroundColor = txtColors(249, 54, 73, 1);
    outLoginBtn.layer.masksToBounds = YES;
    outLoginBtn.layer.cornerRadius = 5.0;
    [outLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    outLoginBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [outLoginBtn addTarget:self action:@selector(goOutLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outLoginBtn];
}
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
    
    //登录密码弹框
    newPayPas = [[LoginPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    newPayPas.loginPasswordDelegate = self;
    newPayPas.alpha = 0;
    
    changPhoneNextPop = [[ChangePhoneNumber alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    changPhoneNextPop.changeDelegate = self;
    changPhoneNextPop.alpha = 0;
    
    //设置支付密码
    nextPayPas  = [[SetPaymentPasswordView alloc] initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    nextPayPas.setPaymentDelegate = self;
    nextPayPas.alpha = 0;
    
    newEmail = [[BindMailboxView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
    newEmail.bingMailDelegate = self;
    
    //实名认证
    tureName =[[TrueNameView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 230)];
    tureName.trueNameDelegate = self;
    tureName.alpha = 0;
    [self initShenFenzheng];
}
-(void)initData
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"getSafe.action" params:pram success:^(id json) {
        [Hud hide:YES];
        NSLog(@"安全设置%@",json);
        safeDict = json;
        [self initSafeAryWithDict:json];
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self promptMessageWithString:@"网络连接错误1"];
    }];
}
-(void)initShenFenzheng
{
    renzhengChangePayPop = [[PopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232)];
    renzhengChangePayPop.btnTitle = @"下一步";
    renzhengChangePayPop.delegate = self;
    renzhengChangePayPop.alpha = 0;
    renzhengChangePayPop.tag = 108;
    UITextField *sfzFiled = [[UITextField alloc]initWithFrame:CGRectMake(10*MCscale, 55*MCscale,renzhengChangePayPop.width-20*MCscale , 40*MCscale)];
    sfzFiled.tag = 1101;
    sfzFiled.placeholder = @"请输入认证身份证后六位";
    sfzFiled.textAlignment = NSTextAlignmentCenter;
    sfzFiled.textColor = [UIColor blackColor];
    sfzFiled.keyboardType = UIKeyboardTypeNumberPad;
    [renzhengChangePayPop addSubview:sfzFiled];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5*MCscale, sfzFiled.bottom+10*MCscale, renzhengChangePayPop.width-10*MCscale, 1)];
    line.backgroundColor = lineColor;
    [renzhengChangePayPop addSubview:line];
}

-(void)initSafeAryWithDict:(NSDictionary *)dict
{
    UILabel *telStateLabel = (UILabel *)[self.view viewWithTag:200];
    UILabel *dengluStateLabel = (UILabel *)[self.view viewWithTag:201];
    UILabel *zhifuStateLabel = (UILabel *)[self.view viewWithTag:202];
    UILabel *emailStateLabel = (UILabel *)[self.view viewWithTag:203];
    UILabel *phoneNumLabel =  (UILabel *)[self.view viewWithTag:300];
    UILabel *emailNumLabel =  (UILabel *)[self.view viewWithTag:303];
    
    telStateLabel.text = @"更换";
    phoneNumLabel.text = [user_tel stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    //登录密码
    if ([dict[@"denglumima"] integerValue] == 2) {
        dengluStateLabel.text = @"重置";
    }
    else
    {
        dengluStateLabel.text = @"设置";
    }
    
    //支付密码
    if([dict[@"zhfumima"] integerValue] == 1){
        zhifuStateLabel.text = @"设置";
    }
    else
    {
        zhifuStateLabel.text = @"重置";
    }
    
    //绑定邮箱
    if([dict[@"email"] integerValue] == 1){
        emailStateLabel.text = @"设置";
    }
    else
    {
        NSString *emails =[NSString stringWithFormat:@"%@",dict[@"emailnum"]];
        NSRange rang = [emails rangeOfString:@"@"];
        NSInteger length = rang.location;
        emailNumLabel.text = [emails stringByReplacingCharactersInRange:NSMakeRange(3, length-3) withString:@"*****"];
        emailStateLabel.text = @"修改";
    }
    
    //绑定设备
    if (![dict[@"chushishebei"] isEqual:userSheBei_id]) {
        [self.view addSubview:shebeiBackView];
        renzhengView.frame = CGRectMake(0, shebeiBackView.bottom, kDeviceWidth, 50*MCscale);
    }
    else
    {
        renzhengView.frame = CGRectMake(0, 284*MCscale, kDeviceWidth, 50*MCscale);
    }
    rzImageView.frame = CGRectMake(0,0, 28*MCscale, 28*MCscale);
    rzImageView.center = CGPointMake(39*MCscale, renzhengView.height /2.0);
    rzTitleLabel.frame =  CGRectMake(rzImageView.right +10*MCscale, rzImageView.top, 120*MCscale, 30*MCscale);
    rzrightImgaeView.frame = CGRectMake(renzhengView.width-25*MCscale, rzTitleLabel.top+5*MCscale, 15*MCscale, 20*MCscale);
    rzstateLabel.frame = CGRectMake(renzhengView.width - 180*MCscale, rzTitleLabel.top, 150*MCscale, 30*MCscale);
    //身份证号
    if ([dict[@"shenfenzhenghao"] integerValue]==0) {
        rzImageView.image = [UIImage imageNamed:@"未认证"];
    }
    else
    {
        rzImageView.image = [UIImage imageNamed:@"认证"];
        rzstateLabel.hidden = YES;
        rzrightImgaeView.hidden = YES;
        yirenzhengView.frame = CGRectMake(0, renzhengView.bottom, kDeviceWidth, 80*MCscale);
        nameLabel.frame = CGRectMake(63*MCscale, 10*MCscale, yirenzhengView.width - 100*MCscale, 20*MCscale);
        numberLabel.frame = CGRectMake(63*MCscale, nameLabel.bottom +20*MCscale, yirenzhengView.width - 100*MCscale, 20*MCscale);
        [self.view addSubview:yirenzhengView];
        NSString *nameStr = [dict[@"realname"] stringByReplacingCharactersInRange:NSMakeRange(1, [dict[@"realname"] length]-1) withString:@"**"];
        nameLabel.text = [NSString stringWithFormat:@"姓名: %@",nameStr];
        NSString *numStr =  [dict[@"shenfenzhenghao"] stringByReplacingCharactersInRange:NSMakeRange(4, 12) withString:@"************"];
        numberLabel.text = [NSString stringWithFormat:@"身份证号: %@",numStr];
    }
}
-(void)backViewTapClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    switch (index) {
        case 100:
        {
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 1;
                [self.view addSubview:maskView];
                newPayPas.alpha = 0.95;
                newPayPas.indexPath = index;
                [self.view addSubview:newPayPas];
            }];
        }
            break;
            
        case 101:
        {
            [UIView animateWithDuration:0.6 animations:^{
                maskView.alpha = 1;
                [self.view addSubview:maskView];
                newPayPas.alpha = 0.95;
                newPayPas.indexPath = index;
                [self.view addSubview:newPayPas];
            }];
        }
            break;
            
        case 102:
        {
            if ([safeDict[@"shenfenzhenghao"]integerValue] != 0 ) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    renzhengChangePayPop.alpha = 0.95;
                    [self.view addSubview:renzhengChangePayPop];
                }];
            }
            else{
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    newPayPas.alpha =0.95;
                    newPayPas.indexPath = index;
                    [self.view addSubview:newPayPas];
                }];
            }
        }
            break;
            
        case 103:
        {
            if ([safeDict[@"email"] integerValue]==1) {
                //设置
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    newEmail.alpha = 0.95;
                    [self.view addSubview:newEmail];
                }];
            }
            else{
                //修改
                [self modifyEmail];
            }
        }
            break;
            
        case 104:
        {
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 1;
                [self.view addSubview:maskView];
                newPayPas.alpha = 0.95;
                newPayPas.indexPath = index;
                [self.view addSubview:newPayPas];
            }];
        }
            break;
        case 105:
        {
            if ([safeDict[@"shenfenzhenghao"]integerValue] == 0 ) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self.view addSubview:maskView];
                    tureName.alpha = 0.95;
                    [self.view addSubview:tureName];
                }];
            }
        }
            break;
        default:
            break;
    }
}
-(void)modifyEmail
{
    MBProgressHUD *Hmud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hmud.mode = MBProgressHUDModeIndeterminate;
    Hmud.delegate = self;
    Hmud.labelText = @"正在发送邮件,请稍等...";
    [Hmud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"updateEmail.action" params:pram success:^(id json) {
        [Hmud hide:YES];
        if ([[json valueForKey:@"message"]integerValue]==1) {
            [Hmud hide:YES];
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"发送邮件成功";
            mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                maskView.alpha = 0;
                [maskView removeFromSuperview];
                [self.view endEditing:YES];
                newEmail.alpha = 0;
                [newEmail removeFromSuperview];
            }];
        }
        else{
            [Hmud hide:YES];
            [self promptMessageWithString:@"发送邮件失败"];
        }
    } failure:^(NSError *error) {
        [Hmud hide:YES];
        [self promptMessageWithString:@"网络连接错误2"];
    }];
}

#pragma mark 退出登录
-(void)goOutLogin
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    //    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"userOut.action" params:nil success:^(id json) {
        [Hud hide:YES];
        NSLog(@"退出登录%@",json);
        if ([[json valueForKey:@"massage"] integerValue] == 0) {
            [self promptMessageWithString:@"退出成功"];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setValue:@"0" forKey:@"isLogin"];
            [def setValue:@"0" forKey:@"kaihu"];
            [def setValue:userSheBei_id forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"isFirst"];
            CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
            [main setSelectedIndex:0];
            main.buttonIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSNotification *kaihuPanduanNoti = [NSNotification notificationWithName:@"kaihuPanduanNoti" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:kaihuPanduanNoti];
            [[NSNotificationCenter defaultCenter]removeObserver:self];
        }
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self promptMessageWithString:@"网络连接错误3"];
    }];
}
#pragma mark LoginPasswordViewDelegate(登录密码验证)
-(void)LoginPasswordViewSuccessWithIndex:(NSInteger)index;
{
    if (index == 100) {
        [UIView animateWithDuration:0.3 animations:^{
            newPayPas.alpha = 0;
            [newPayPas removeFromSuperview];
            changPhoneNextPop.alpha = 0.95;
            [self.view addSubview:changPhoneNextPop];
        }];
    }
    else if (index == 101) {//登录密码修改
        [UIView animateWithDuration:0.3 animations:^{
            newPayPas.alpha = 0;
            [newPayPas removeFromSuperview];
            nextPayPas.isFrom = 1;
            NSArray *array = @[@"请输入新密码",@"确认新密码"];
            [nextPayPas getTextFieldPlaceholderWithArray:array];
            nextPayPas.alpha =0.95;
            [self.view addSubview:nextPayPas];
        }];
    }
    else if(index == 102)
    {//支付密码修改
        [UIView animateWithDuration:0.3 animations:^{
            newPayPas.alpha = 0;
            [newPayPas removeFromSuperview];
            nextPayPas.alpha = 0.95;
            nextPayPas.isFrom = 2;
            NSArray *array = @[@"设置6位数字支付密码",@"确认支付密码"];
            [nextPayPas getTextFieldPlaceholderWithArray:array];
            [self.view addSubview:nextPayPas];
        }];
    }
    else if (index == 104)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            newPayPas.alpha = 0;
            [newPayPas removeFromSuperview];
        }];
        [self changeBangdingShebei];
    }
}
-(void)changeBangdingShebei
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
    Hud.delegate = self;
    Hud.labelText = @"请稍等...";
    [Hud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"chushishebei":userSheBei_id}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"changeSheBei.action" params:pram success:^(id json) {
        NSLog(@"changeSheBei.action = %@",json);
        if ([[json valueForKey:@"message"] integerValue] == 1) {
            [shebeiBackView removeFromSuperview];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"更换绑定设备成功";
            bud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            [self initData];
        }
        else
        {
            [self promptMessageWithString:@"修改失败"];
        }
        [Hud hide:YES];
    } failure:^(NSError *error) {
        [Hud hide:YES];
        [self promptMessageWithString:@"网络连接错误4"];
    }];
}
#pragma mark ChangePhoneNumberDelegate(更换手机号)
-(void)ChangePhoneNumberWithString:(NSString *)string AndIndex:(NSInteger)index
{
    if (index == 4) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeCustomView;
        mbHud.labelText = @"更换绑定手机成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"userTel"];
        UILabel *lbe = (UILabel *)[self.view viewWithTag:300];
        lbe.text = [string stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            changPhoneNextPop.alpha = 0;
            [changPhoneNextPop removeFromSuperview];
        }];
    }
    else if (index == 3)
    {
        [self promptMessageWithString:@"验证码有误"];
    }
    else
    {
        [self promptMessageWithString:@"操作失败请稍后重试"];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            changPhoneNextPop.alpha = 0;
            [changPhoneNextPop removeFromSuperview];
        }];
    }
}

#pragma mark SetPaymentPasswordViewDelegate
-(void)SetPaymentPasswordSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"修改密码成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            nextPayPas.alpha = 0;
            [nextPayPas removeFromSuperview];
        }];
    }
    else if(index == 2)
    {
        [self promptMessageWithString:@"修改失败!请稍后再试"];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            nextPayPas.alpha = 0;
            [nextPayPas removeFromSuperview];
        }];
    }
    else
    {
        [self promptMessageWithString:@"参数不能为空"];
    }
}
#pragma mark  BindMailboxViewDelegate
-(void)BindMailboxSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            newEmail.alpha = 0;
            [newEmail removeFromSuperview];
        }];
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"向绑定邮箱发送邮件成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        
        UILabel *lab = (UILabel *)[self.view viewWithTag:303];
        lab.text = @"已发送到您的邮箱";
    }
}
#pragma mark TrueNameViewDelegate
-(void)rengzhengSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeText;
        mbHud.labelText = @"实名认证成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            tureName.alpha = 0;
            [tureName removeFromSuperview];
        }];
        [self initData];
    }
    else
    {
        [self promptMessageWithString:@"认证失败"];
    }
}
#pragma mark -- PopViewDelegate
-(void)popBtnAction:(PopView *)pop atIndex:(NSInteger)index btnTag:(NSInteger)btag
{
    [self shenzhengRzLast];
}
//认证身份证后6位
-(void)shenzhengRzLast
{
    UITextField *file = (UITextField *)[renzhengChangePayPop viewWithTag:1101];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":user_id,@"shenfen":file.text}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"checkShenfen.action" params:pram success:^(id json) {
        if ([[json valueForKey:@"message"] integerValue]== 1) {
            [UIView animateWithDuration:0.3 animations:^{
                renzhengChangePayPop.alpha = 0;
                [renzhengChangePayPop removeFromSuperview];
                nextPayPas.alpha = 0.95;
                nextPayPas.isFrom = 2;
                NSArray *array = @[@"设置6位数字支付密码",@"确认支付密码"];
                [nextPayPas getTextFieldPlaceholderWithArray:array];
                [self.view addSubview:nextPayPas];
                file.text = @"";
            }];
        }
        else{
            [self promptMessageWithString:@"验证失败"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误5"];
    }];
}

-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        newPayPas.alpha = 0;
        [newPayPas removeFromSuperview];
        nextPayPas.alpha = 0;
        [nextPayPas removeFromSuperview];
        newEmail.alpha = 0;
        [newEmail removeFromSuperview];
        tureName.alpha = 0;
        [tureName removeFromSuperview];
        changPhoneNextPop.alpha = 0;
        [changPhoneNextPop removeFromSuperview];
        renzhengChangePayPop.alpha = 0;
        [renzhengChangePayPop removeFromSuperview];
        
    }];
}

-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
