//
//  GetPackageView.m
//  GoodShop
//
//  Created by MIAO on 2017/1/5.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "GetPackageView.h"
#import "Order.h"
#import "DataSigner.h"
@implementation GetPackageView
{
    UILabel *accountLabel,*chongzhiLabel,*moneyLabel,*xiaofeiLabel,*shijiMoneyLabel,*numLabel;
    UITextField *accountTextField;
    UIImageView *WechatImageView,*alipayImageview;
    UIButton *addBtn,*reduceBtn;
    UIView *line1,*line2,*line3,*line4,*line5;
    int num;
    NSString *chongzhiMoney,*xiaofeiMoney,*libaoid;
    NSString *danhao,*body,*payMoney;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        num = 1;
        chongzhiMoney = @"";
        xiaofeiMoney = @"";
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale,15*MCscale,80*MCscale, 20*MCscale)];
    [self customLabel:accountLabel AndString:@"充入账户:"];
    [self addSubview:accountLabel];
    
    accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(accountLabel.right+5*MCscale, 15*MCscale, self.width - 100*MCscale, 20*MCscale)];
    accountTextField.textColor = textColors;
    accountTextField.backgroundColor = [UIColor clearColor];
    accountTextField.text = user_tel;
    accountTextField.textAlignment = NSTextAlignmentCenter;
    accountTextField.font = [UIFont systemFontOfSize:MLwordFont_4];
    accountTextField.clearButtonMode = UITextFieldViewModeAlways;
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:accountTextField];
    
    chongzhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale,55*MCscale,45*MCscale, 20*MCscale)];
    [self customLabel:chongzhiLabel AndString:@"充值:"];
    [self addSubview:chongzhiLabel];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(chongzhiLabel.right+5*MCscale,55*MCscale,self.width/2.0 - 75*MCscale, 20*MCscale)];
    [self customLabel:moneyLabel AndString:@""];
    [self addSubview:moneyLabel];
    
    xiaofeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2.0+10*MCscale,55*MCscale,45*MCscale, 20*MCscale)];
    [self customLabel:xiaofeiLabel AndString:@"消费:"];
    [self addSubview:xiaofeiLabel];
    
    shijiMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(xiaofeiLabel.right+5*MCscale,55*MCscale,self.width/2.0 - 75*MCscale, 20*MCscale)];
    [self customLabel:shijiMoneyLabel AndString:@""];
    [self addSubview:shijiMoneyLabel];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2.0-20*MCscale,95*MCscale,40*MCscale, 20*MCscale)];
    [self customLabel:numLabel AndString:@"1"];
    [self addSubview:numLabel];
    
    for (int i = 0; i<2;i++ ) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(40*i*MCscale+numLabel.left, numLabel.top, 1, numLabel.height)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
    }
    
    NSArray *titleArray = @[@"-",@"+"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(85*i*MCscale +numLabel.left-35*MCscale, numLabel.top-5*MCscale, 30*MCscale,30*MCscale)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
        [button setTitleColor:textColors forState:UIControlStateNormal];
        button.tag = 200+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    for (int i = 0; i<5; i++) {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = lineColor;
        [self addSubview:line];
        if (i<3) {
            line.frame =CGRectMake(0,40*i*MCscale+45*MCscale, self.width, 1);
        }
        else
        {
            line.frame =CGRectMake(0,50*(i-2)*MCscale+125*MCscale, self.width, 1);
        }
        
        if (i == 4) {
            line.hidden = YES;
        }
    }
    
    NSArray *zhifuArray = @[@"支付宝",@"微支付"];
    for (int i = 0;i<2;i++) {
        UIImageView *zhifuImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 179*MCscale, 40*MCscale)];
        zhifuImageView.center = CGPointMake(self.width/2.0,50*MCscale*i+150*MCscale);
        zhifuImageView.image = [UIImage imageNamed:zhifuArray[i]];
        zhifuImageView.tag = 300+i;
        zhifuImageView.userInteractionEnabled = YES;
        [self addSubview:zhifuImageView];
        UITapGestureRecognizer *zhifuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhifuImageClick:)];
        [zhifuImageView addGestureRecognizer:zhifuTap];
        if (i == 1) {
            zhifuImageView.hidden = YES;
        }
    }
}
-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 200) {
        //减
        if (num >1) {
            num --;
        }
    }
    else
    {
        //加
        num ++;
    }
    numLabel.text = [NSString stringWithFormat:@"%d",num];
    moneyLabel.text = [NSString stringWithFormat:@"%.0lf",[chongzhiMoney doubleValue]*num];
    double xiaofei = [chongzhiMoney doubleValue]+[xiaofeiMoney doubleValue];
    shijiMoneyLabel.text = [NSString stringWithFormat:@"%.0lf",xiaofei*num];
}
-(void)zhifuImageClick:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 300) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyMMddHHmmss"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        danhao = [NSString stringWithFormat:@"%@",dateTime];
        payMoney = moneyLabel.text;
        body = [NSString stringWithFormat:@"妙店佳+%@充值",accountTextField.text];
        //支付宝
        [self AlipayPay];
    }
    else
    {
        //微信
    }
}
-(void)AlipayPay
{
    NSMutableDictionary *pricateDic = [[NSMutableDictionary alloc]init];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"zhifu.action" params:nil success:^(id json) {
        if (json) {
            [pricateDic setValue:[json valueForKey:@"out_trade_no"] forKey:@"out_trade_no"];//单号
            [pricateDic setValue:[json valueForKey:@"partner"] forKey:@"partner"];//appid
            [pricateDic setValue:[json valueForKey:@"private_key"] forKey:@"private_key"];//私钥
            [pricateDic setValue:[json valueForKey:@"seller_id"] forKey:@"seller_id"];//支付宝单号
            [self payMoney:pricateDic];
        }
        else
        {
            [self promptMessageWithString:@"获取支付信息失败!请稍后尝试"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(void)payMoney:(NSMutableDictionary *)dict
{
    NSString *partner = [dict valueForKey:@"partner"];
    NSString *seller = [dict valueForKey:@"seller_id"];
    NSString *privateKey = [dict valueForKey:@"private_key"];
    NSString *description = [NSString stringWithFormat:@"%@",user_id];
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = danhao;//订单ID(由商家□自□行制定)
    order.productName = body;//商品标题
    order.productDescription = description;//商品描述
    order.amount = [NSString stringWithFormat:@"%@",payMoney];//商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@notify_url.jsp",HTTPHEADER];//回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    NSString *orderSpec = [order description];
    NSString *appScheme = @"alisdkdemo1";
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec,signedString,@"RSA"];
        [[AlipaySDK defaultService]payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *payState = [resultDic valueForKey:@"resultStatus"];
            if ([payState isEqualToString:@"9000"]) {
                NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":user_qiehuandianpu,@"usertel":accountTextField.text,@"libaoid":libaoid,@"shuliang":[NSString stringWithFormat:@"%d",num]}];
                
                [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"savelibaochongzhi.action" params:pram success:^(id json) {
                    if ([[json valueForKey:@"massages"]integerValue]==1) {
                        if ([self.getDelegate respondsToSelector:@selector(goumailibaoSuccessWithIndex:)]) {
                            [self.getDelegate goumailibaoSuccessWithIndex:1];
                        }
                    }
                } failure:^(NSError *error) {
                }];
            }
            else{
                if ([self.getDelegate respondsToSelector:@selector(goumailibaoSuccessWithIndex:)]) {
                    [self.getDelegate goumailibaoSuccessWithIndex:2];
                }
            }
        }];
    }
}
-(void)reloadDataWithDict:(NSDictionary *)dict
{
    num=1;
    numLabel.text = [NSString stringWithFormat:@"%d",num];
    moneyLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"chongzhi"]];
    double xiaofei = [[dict valueForKey:@"chongzhi"] doubleValue]+[[dict valueForKey:@"song"] doubleValue];
    shijiMoneyLabel.text = [NSString stringWithFormat:@"%.0lf",xiaofei];
    chongzhiMoney = [dict valueForKey:@"chongzhi"];
    xiaofeiMoney = [dict valueForKey:@"song"];
    libaoid = [NSString stringWithFormat:@"%@",[dict valueForKey:@"libaoid"]];
}
-(void)customLabel:(UILabel *)label AndString:(NSString *)string
{
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColors;
    label.font = [UIFont systemFontOfSize:MLwordFont_4];
    label.backgroundColor = [UIColor clearColor];
    label.text = string;
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
