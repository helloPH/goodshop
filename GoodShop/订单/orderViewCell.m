//
//  orderViewCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/20.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "orderViewCell.h"
#import "Header.h"

@implementation orderViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self SubViews];
    }
    return self;
}
-(void)SubViews
{
    //创建时间
    _timeLabel = [BaseCostomer labelWithFrame:CGRectMake(20, 6*MCscale, kDeviceWidth/4.0, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    
    //相关提示
    _showLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_8] textColor:txtColors(109, 109, 109, 0.5) backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
        //订单评价
    _gotoeEvaluate = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth-100*MCscale, 9*MCscale, 80*MCscale, 23*MCscale) backGroundColor:[UIColor clearColor] text:@"" image:@"订单评价"];
    _gotoeEvaluate.alpha =0;
    //支付
    _payBtn = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth-100*MCscale, 9*MCscale, 80*MCscale, 23*MCscale) backGroundColor:[UIColor clearColor] text:@"" image:@"支付"];
    _payBtn.alpha =0;
    
    //取消订单
    _cancelOrderBtn = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth-100*MCscale, 9*MCscale, 80*MCscale, 23*MCscale) backGroundColor:[UIColor clearColor] text:@"" image:@"取消订单"];
    _cancelOrderBtn.alpha =0;
    
    UIView *line1 = [BaseCostomer viewWithFrame:CGRectMake(15, 40*MCscale, kDeviceWidth-30*MCscale, 0.5) backgroundColor:lineColor];
    [self.contentView addSubview:line1];
    
    //店铺logo
    _userheadImage = [BaseCostomer imageViewWithFrame:CGRectMake(25*MCscale, 50*MCscale, 60*MCscale, 60*MCscale) backGroundColor:[UIColor clearColor] image:@""];
   
    UILabel *orderNumTitle = [BaseCostomer labelWithFrame:CGRectMake(_userheadImage.right+10, 45*MCscale, 30, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_8] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"单号:"];
    [self.contentView addSubview:orderNumTitle];
    //订单号
    _orderNum = [BaseCostomer labelWithFrame:CGRectMake(orderNumTitle.right+5, 45*MCscale, 125*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_8] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];

    //已确认送达
    _delivery = [BaseCostomer labelWithFrame:CGRectMake(_orderNum.right+5, 45*MCscale, 72, 18*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_8] textColor:txtColors(162, 163, 164, 1) backgroundColor:txtColors(212, 213, 214, 1) textAlignment:1 numOfLines:1 text:@""];
    _delivery.layer.cornerRadius = 9.0;
    _delivery.layer.masksToBounds = YES;
    
    UILabel *numLabel = [BaseCostomer labelWithFrame:CGRectMake(orderNumTitle.left, orderNumTitle.bottom, 30, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_8] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"数量:"];
    [self.contentView addSubview:numLabel];
    //数量
    _goodNum = [BaseCostomer labelWithFrame:CGRectMake(numLabel.right+5, numLabel.top, 30, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_8] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
    
    UILabel *moneyLabel = [BaseCostomer labelWithFrame:CGRectMake(_goodNum.right, numLabel.top, 30*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_8] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"金额"];
    [self.contentView addSubview:moneyLabel];
    //金额
    _money = [BaseCostomer labelWithFrame:CGRectMake(moneyLabel.right+5, numLabel.top, 100*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_8] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
    
    _payAgnNum = [BaseCostomer labelWithFrame:CGRectMake(kDeviceWidth-100*MCscale, numLabel.top, 80*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_10] textColor:txtColors(236, 27, 60, 0.9) backgroundColor:[UIColor clearColor] textAlignment:2 numOfLines:1 text:@""];
    
    //订单提交img
    _submitImage = [BaseCostomer imageViewWithFrame:CGRectMake(numLabel.left+5, numLabel.bottom, 26*MCscale, 26*MCscale) backGroundColor:[UIColor clearColor] image:@""];
    
    UILabel *orederSubmit = [BaseCostomer labelWithFrame:CGRectMake(numLabel.left-7, _submitImage.bottom+2, _submitImage.width+25, 15*MCscale) font:[UIFont systemFontOfSize:MLwordFont_9] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text: @"订单提交"];
    [self.contentView addSubview:orederSubmit];
    
    _submitTime = [BaseCostomer labelWithFrame:CGRectMake(_submitImage.right+3, _submitImage.top+6, 32*MCscale, 14*MCscale) font:[UIFont systemFontOfSize:MLwordFont_13] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    _submitTime.alpha = 0;
    
    UIView *line2 = [BaseCostomer viewWithFrame:CGRectMake(_submitTime.left, _submitTime.bottom, _submitTime.width, 1) backgroundColor:txtColors(193, 194, 196, 1)];
    [self.contentView addSubview:line2];
    //处理中img
    _handleingImage = [BaseCostomer imageViewWithFrame:CGRectMake(_submitTime.right+7, _submitImage.top, 26*MCscale, 26*MCscale) backGroundColor:[UIColor clearColor] image:@""];
    
    UILabel *handingLabel = [BaseCostomer labelWithFrame:CGRectMake(_handleingImage.left-10, _handleingImage.bottom+2, _handleingImage.width+20*MCscale, 15*MCscale) font: [UIFont systemFontOfSize:MLwordFont_9] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"处理中"];
    [self.contentView addSubview:handingLabel];
    
    _sendTime = [BaseCostomer labelWithFrame:CGRectMake(_handleingImage.right+3, _handleingImage.top+6, 32*MCscale, 14*MCscale) font:[UIFont systemFontOfSize:MLwordFont_13] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:0 text:@""];
    
    UIView *line3 = [BaseCostomer viewWithFrame:CGRectMake(_sendTime.left, _sendTime.bottom, _sendTime.width, 1) backgroundColor:txtColors(193, 194, 196, 1)];
    [self.contentView addSubview:line3];
    
    //配送中img
    _sendingImage  = [BaseCostomer imageViewWithFrame:CGRectMake(_sendTime.right+7, _submitImage.top, 26*MCscale, 26*MCscale) backGroundColor:[UIColor clearColor] image:@""];
    
    UILabel *sendingLabel = [BaseCostomer labelWithFrame:CGRectMake(_sendingImage.left-10, _sendingImage.bottom+2, _sendingImage.width+20*MCscale, 15*MCscale) font:[UIFont systemFontOfSize:MLwordFont_9] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"配送中"];
    [self.contentView addSubview:sendingLabel];
    _receiveTime = [BaseCostomer labelWithFrame:CGRectMake(_sendingImage.right+3, _sendingImage.top+6, 32*MCscale, 14*MCscale) font:[UIFont systemFontOfSize:MLwordFont_13] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:0 text:@""];
    
    UIView *line4 = [BaseCostomer viewWithFrame:CGRectMake(_receiveTime.left, _receiveTime.bottom+2, _receiveTime.width, 1) backgroundColor:txtColors(193, 194, 196, 1)];
    [self.contentView addSubview:line4];
    //送达img
    _receiveImage = [BaseCostomer imageViewWithFrame:CGRectMake(_receiveTime.right+7, _submitImage.top, 26*MCscale, 26*MCscale) backGroundColor:[UIColor clearColor] image:@""];
    UILabel *receiveLabel = [BaseCostomer labelWithFrame:CGRectMake(_receiveImage.left-10, _receiveImage.bottom+2, _receiveImage.width+20*MCscale, 15*MCscale) font:[UIFont systemFontOfSize:MLwordFont_9] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"已收货"];
    [self.contentView addSubview:receiveLabel];
    
    UIView *line5 = [BaseCostomer viewWithFrame:CGRectMake(15*MCscale, _userheadImage.bottom+24*MCscale, kDeviceWidth-30, 0.5) backgroundColor:lineColor];
        line5.tag = 20011;
    line5.alpha = 0;
    [self.contentView addSubview:line5];
    
    _guanjia = [BaseCostomer labelWithFrame:CGRectMake(30*MCscale, line5.bottom+5, 40*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"管家:"];
    _guanjia.alpha = 0;
    
    _housekeeper = [BaseCostomer labelWithFrame:CGRectMake(_guanjia.right+5, _guanjia.top, 80*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
    
    _tel = [BaseCostomer labelWithFrame:CGRectMake(_housekeeper.right+5, line5.bottom+5, 50*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"手机号:"];
    
    _telNumber = [BaseCostomer labelWithFrame:CGRectMake(_tel.right+5, line5.bottom+5, 100*MCscale, 30*MCscale) font:[UIFont systemFontOfSize: MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
    
    _telBtn = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth-45*MCscale, line5.bottom+5, 25*MCscale, 28*MCscale) backGroundColor:[UIColor clearColor] text:@"" image:@"手机"];
    _telBtn.alpha = 0;
     [_telBtn addTarget:self action:@selector(callGjAction) forControlEvents:UIControlEventTouchUpInside];
    
    _lineView = [BaseCostomer viewWithFrame:CGRectMake(0,142*MCscale, kDeviceWidth, 2) backgroundColor:lineColor];
    _lineView.tag = 20022;
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_showLabel];
    [self.contentView addSubview:_delivery];
    [self.contentView addSubview:_gotoeEvaluate];
    [self.contentView addSubview:_userheadImage];
    [self.contentView addSubview:_submitImage];
    [self.contentView addSubview:_handleingImage];
    [self.contentView addSubview:_sendingImage];
    [self.contentView addSubview:_receiveImage];
    [self.contentView addSubview:_showLabel];
    [self.contentView addSubview:_orderNum];
    [self.contentView addSubview:_money];
    [self.contentView addSubview:_payAgnNum];
    [self.contentView addSubview:_goodNum];
    [self.contentView addSubview:_submitTime];
    [self.contentView addSubview:_sendTime];
    [self.contentView addSubview:_receiveTime];
    [self.contentView addSubview:_cancelOrderBtn];
    [self.contentView addSubview:_payBtn];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _timeLabel.text = _model.cretdate;
    _delivery.text = @"已确认送达";
    [_userheadImage sd_setImageWithURL:[NSURL URLWithString:_model.dianpulogo] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    
    NSString *needPay = [NSString stringWithFormat:@"%@",_model.chajia];
    if ([needPay isEqualToString:@"0"] || [needPay isEqualToString:@""]) {
        _payAgnNum.text = @"";
        _payAgnNum.alpha = 0;
    }
    else{
        _payAgnNum.text = [NSString stringWithFormat:@"还需支付%@元",needPay];
        _payAgnNum.alpha = 1;
    }
    NSMutableArray *tmAry = [[NSMutableArray alloc]initWithCapacity:3];
    NSString *ddzhuangt = _model.dindanzhuangtaidate;
    if (![ddzhuangt isEqual:[NSNull null]]){
        tmAry = [NSMutableArray arrayWithArray:[ddzhuangt componentsSeparatedByString:@","]];
    }
    NSString *payStyle = [NSString stringWithFormat:@"%@",_model.zhifuleixing];
    
    if ([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"6"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中"];
        _sendingImage.image = [UIImage imageNamed:@"配送中"];
        _receiveImage.image = [UIImage imageNamed:@"已收货"];
        _showLabel.text= @"感谢捧场,订单已完成";
        _gotoeEvaluate.alpha =1;
        _cancelOrderBtn.alpha = 0;
        _payBtn.alpha = 0;
        _delivery.backgroundColor = txtColors(236, 27, 60, 0.9);
        _delivery.textColor = [UIColor whiteColor];
        _submitTime.alpha = 1;
        _sendTime.alpha = 1;
        _receiveTime.alpha = 1;
        _submitTime.text = tmAry[0];
        _sendTime.text = tmAry[1];
        _receiveTime.text = tmAry[2];
    }
    else if ([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"4"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中"];
        _sendingImage.image = [UIImage imageNamed:@"配送中"];
        _receiveImage.image = [UIImage imageNamed:@"已收货"];
        _showLabel.text= @"期待下次会面,欢迎评价";
        _gotoeEvaluate.alpha =1;
        _payBtn.alpha = 0;
        _cancelOrderBtn.alpha = 0;
        _delivery.backgroundColor = txtColors(236, 27, 60, 0.9);
        _delivery.textColor = [UIColor whiteColor];
        _submitTime.alpha = 1;
        _sendTime.alpha = 1;
        _receiveTime.alpha = 1;
        _submitTime.text = tmAry[0];
        _sendTime.text = tmAry[1];
        _receiveTime.text = tmAry[2];
        
    }
    else if ([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"3"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中"];
        _sendingImage.image = [UIImage imageNamed:@"配送中"];
        _receiveImage.image = [UIImage imageNamed:@"已收货-绿"];
        _showLabel.text= @"管家正在火速奔跑";
        _delivery.backgroundColor =txtColors(212, 213, 214, 1);
        _delivery.textColor = txtColors(162, 163, 164, 1);
        _submitTime.alpha = 1;
        _sendTime.alpha = 1;
        _receiveTime.alpha = 0;
        _submitTime.text = tmAry[0];
        _sendTime.text = tmAry[1];
        _gotoeEvaluate.alpha =0;
        _cancelOrderBtn.alpha = 0;
        if([payStyle isEqualToString:@"0"]){
            _payBtn.alpha = 0;
        }
        else{
            _payBtn.alpha =1;
            [_payBtn setImage:[UIImage imageNamed:@"支付"] forState:UIControlStateNormal];
        }
    }
    else if ([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"2"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中"];
        _sendingImage.image = [UIImage imageNamed:@"配送中-绿"];
        _receiveImage.image = [UIImage imageNamed:@"已收货-绿"];
        _showLabel.text= @"已接订单,店家准备中";
        _delivery.backgroundColor =txtColors(212, 213, 214, 1);
        _delivery.textColor = txtColors(162, 163, 164, 1);
        _submitTime.alpha = 1;
        _sendTime.alpha = 0;
        _receiveTime.alpha = 0;
        _submitTime.text = tmAry[0];
        _gotoeEvaluate.alpha =0;
        _cancelOrderBtn.alpha = 0;
        if([payStyle isEqualToString:@"0"]){
            _payBtn.alpha = 0;
        }
        else{
            _payBtn.alpha =1;
            [_payBtn setImage:[UIImage imageNamed:@"支付"] forState:UIControlStateNormal];
        }
    }
    else if([[NSString stringWithFormat:@"%@",_model.dindanzhuangtai] isEqualToString:@"1"]){
        _submitImage.image = [UIImage imageNamed:@"订单提交"];
        _handleingImage.image = [UIImage imageNamed:@"处理中-绿"];
        _sendingImage.image = [UIImage imageNamed:@"配送中-绿"];
        _receiveImage.image = [UIImage imageNamed:@"已收货-绿"];
        _showLabel.text= @"订单已提交,请耐心等待";
        _delivery.backgroundColor =txtColors(212, 213, 214, 1);
        _delivery.textColor = txtColors(162, 163, 164, 1);
        _submitTime.alpha = 0;
        _sendTime.alpha = 0;
        _receiveTime.alpha = 0;
        _gotoeEvaluate.alpha =0;
        _payBtn.alpha = 0;
        _cancelOrderBtn.alpha = 1;
        [_cancelOrderBtn setImage:[UIImage imageNamed:@"取消订单"] forState:UIControlStateNormal];
    }
    CGSize showSize =[_showLabel.text boundingRectWithSize:CGSizeMake(150, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil] context:nil].size;
    _showLabel.frame = CGRectMake(_timeLabel.right, _timeLabel.top, showSize.width, 30*MCscale);
    _orderNum.text = _model.danhao;
    _goodNum.text = _model.shuliang;
    _money.text = [NSString stringWithFormat:@"¥%.2f",[_model.yingfujine floatValue]];
    if ([_model.guanjiantel integerValue]!=0) {
        _housekeeper.text = _model.guanjia;
        _telNumber.text = [NSString stringWithFormat:@"%@",_model.guanjiantel];
        _lineView.frame = CGRectMake(0, _guanjia.bottom+3,kDeviceWidth , 2);
        UIView *line = [self viewWithTag:20011];
        line.alpha = 1;
        [self.contentView addSubview:_telBtn];
        [self.contentView addSubview:_guanjia];
        [self.contentView addSubview:_tel];
        [self.contentView addSubview:_housekeeper];
        [self.contentView addSubview:_telNumber];
        _guanjia.alpha = 1;
        _tel.alpha = 1;
        _telBtn.alpha = 1;
    }
    else{
        UIView *line = [self viewWithTag:20011];
        line.alpha = 0;
        _housekeeper.text = @"";
        _telNumber.text = @"";
        _lineView.frame = CGRectMake(0,143*MCscale, kDeviceWidth, 2);
        _guanjia.alpha = 0;
        _tel.alpha = 0;
        _telBtn.alpha = 0;
    }
//    _gotoeEvaluate.alpha =1;
}
-(void)callGjAction
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_model.guanjiantel]];
    UIWebView *phoneWeb = [[UIWebView alloc]initWithFrame:CGRectZero];
    [phoneWeb loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
    [self addSubview:phoneWeb];
}
@end
