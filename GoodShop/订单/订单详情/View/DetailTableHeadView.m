//
//  DetailTableHeadView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "DetailTableHeadView.h"
#import "Header.h"
@implementation DetailTableHeadView
{
    UIImageView *image;
    UILabel *receive;
    UILabel *label;
    UIView *lineView;
    UIView *shopBackView;
    UIImageView *shopImage;
    UILabel *shopTitle;
    UIImageView *locationImage;
    UIView *line;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    image = [[UIImageView alloc]initWithFrame:CGRectMake(50*MCscale, 20*MCscale, 30*MCscale, 30*MCscale)];
    image.backgroundColor = [UIColor clearColor];
    [self addSubview:image];
    
    receive = [[UILabel alloc]initWithFrame:CGRectMake(image.right,20*MCscale, 120*MCscale, 30*MCscale)];
    receive.backgroundColor = [UIColor clearColor];
    receive.textColor = [UIColor blackColor];
    receive.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    receive.textAlignment = NSTextAlignmentCenter;
    [self addSubview:receive];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(image.left, image.bottom+10*MCscale, 200*MCscale, 20*MCscale)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColors;
    label.font = [UIFont systemFontOfSize:MLwordFont_8];
    [self addSubview:label];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 89*MCscale, kDeviceWidth, 1)];
    line1.backgroundColor = txtColors(193, 194, 196, 1);
    [self addSubview:line1];
    
    NSArray *tit = @[@"订单号:",@"收货人:",@"手机号码:",@"地点:",@"支付方式:",@"送达时间:",@"发票抬头:"];
    for (int i = 0;i<tit.count;i++ ) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale,25*MCscale*i + 95*MCscale, 80*MCscale, 20*MCscale)];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = txtColors(89, 90, 91, 1);
        title.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
        title.backgroundColor = [UIColor clearColor];
        title.text = tit[i];
        title.tag = 100+i;
        [self addSubview:title];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(title.right+5, title.top, kDeviceWidth - 140*MCscale, 20*MCscale)];
        content.textAlignment = NSTextAlignmentLeft;
        content.tag =200+i;
        content.font = [UIFont systemFontOfSize:MLwordFont_5];
        content.backgroundColor = [UIColor clearColor];
        content.textColor = textBlackColor;
        //            content.text = orderMessageAry[i];
        [self addSubview:content];
    }
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    
    shopBackView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:shopBackView];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goShop)];
    [shopBackView addGestureRecognizer:backTap];
    
    shopImage = [[UIImageView alloc]initWithFrame:CGRectMake(45*MCscale, 5*MCscale, 24*MCscale, 24*MCscale)];
    shopImage.image = [UIImage imageNamed:@"店铺图标"];
    [shopBackView addSubview:shopImage];
    
    //店名
    shopTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    shopTitle.textAlignment = NSTextAlignmentCenter;
    shopTitle.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
    shopTitle.textColor = textColors;
    [shopBackView addSubview:shopTitle];
    //方向箭头 点击进入店铺
    locationImage = [[UIImageView alloc]initWithFrame: CGRectMake(kDeviceWidth-30*MCscale,10*MCscale, 15*MCscale, 15*MCscale)];
    locationImage.image = [UIImage imageNamed:@"下拉键"];
    locationImage.backgroundColor = [UIColor clearColor];
    locationImage.userInteractionEnabled = YES;
    [shopBackView addSubview:locationImage];
    //进入店铺
    
    line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = lineColor;
    [self addSubview:line];
}
-(void)createUIWithArray:(NSArray *)array
{
    if ([array[0] isEqualToString:@"6"]) {
        image.image = [UIImage imageNamed:@"选中"];
        receive.text = @"已收货";
        label.text = @"感谢捧场,订单已完成";
    }
    else if ([array[0] isEqualToString:@"1"]){
        receive.text = @"订单已提交";
        image.image = [UIImage imageNamed:@"订单提交-绿"];
        label.text = @"订单已提交,请耐心等待";
    }
    else if ([array[0] isEqualToString:@"2"]){
        image.image = [UIImage imageNamed:@"处理中-绿"];
        receive.text = @"处理中";
        label.text = @"已接订单,店家准备中";
    }
    else if ([array[0] isEqualToString:@"3"]){
        image.image = [UIImage imageNamed:@"配送中-绿"];
        receive.text = @"配送中";
        label.text = @"管家正在火速奔跑中";
    }
    else if ([array[0] isEqualToString:@"4"]){
        image.image = [UIImage imageNamed:@"选中"];
        receive.text = @"已送达";
        label.text = @"期待下次会面,欢迎评价";
    }
    else if([array[0] isEqualToString:@"7"]){
        image.image = [UIImage imageNamed:@"选中"];
        receive.text = @"未接超时";
        label.text = @"感谢使用妙店佳，带来不便敬请谅解。";
    }
    else{
        image.image = [UIImage imageNamed:@"选中"];
        receive.text = @"订单已取消";
        label.text = @"感谢使用妙店佳，带来不便敬请谅解。";
    }
    
    
    
    if (([array[0] isEqualToString:@"1"] || // 订单已提交
         [array[0] isEqualToString:@"2"] || // 处理
         [array[0] isEqualToString:@"3"] || // 配送中
         [array[0] isEqualToString:@"4"] || // 已送达
         [array[0] isEqualToString:@"6"])   // 已收货
        && [self.dingdanleixing isEqualToString:@"0"]) {   // 店铺消费 点餐
        
        NSString * dindanzhuangtaidate = [NSString stringWithFormat:@"%@",self.dindanzhuangtaidate];
        
        dindanzhuangtaidate = [dindanzhuangtaidate isEmptyString]?@"":dindanzhuangtaidate;
        NSArray * tmArr = [dindanzhuangtaidate componentsSeparatedByString:@","];
        if ([dindanzhuangtaidate isEmptyString]) {
            tmArr = @[];
        }
        if (tmArr.count == 1) { /// 消费中：感谢使用妙店佳，祝消费愉快。
            image.image = [UIImage imageNamed:@"处理中-绿"];
            receive.text = @"消费中";
            label.text = @"感谢使用妙店佳，祝消费愉快";
            
        }else if (tmArr.count == 2){ // 已结束：;感谢使用妙店佳，欢迎再次光临。
            image.image = [UIImage imageNamed:@"选中"];
            receive.text = @"已结束";
            label.text = @"感谢使用妙店佳，欢迎再次光临";
        }else{//  订单提交：感谢使用妙店佳，订单已提交。
            receive.text = @"已提交";
            image.image = [UIImage imageNamed:@"订单提交-绿"];
            label.text = @"感谢使用妙店佳，订单已提交";
        }
    }
    

    
    
    for (int i = 0; i<7; i++) {
        UILabel *title = [self viewWithTag:100+i];
        UILabel *content = [self viewWithTag:200+i];
        if (i == 6) {
            if ([array[7] isEqualToString:@"0"]) {
                title.hidden = YES;
                content.hidden = YES;
            }
            else
            {
                title.hidden = NO;
                content.hidden = NO;
            }
        }
        content.text = array[i+1];
    }
    lineView.frame = CGRectMake(0, self.height - 40*MCscale, self.width , 5*MCscale);
    shopBackView.frame = CGRectMake(0, lineView.bottom, self.width, 35*MCscale);
    NSString * stringgggg = [NSString stringWithFormat:@"%@",array[8]];
    CGSize size = [stringgggg boundingRectWithSize:CGSizeMake(250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    shopTitle.frame = CGRectMake(shopImage.right+5, 5*MCscale, size.width, 25*MCscale);
    shopTitle.text = array[8];
    line.frame = CGRectMake(0, self.height - 1, self.width,1);
}
-(void)goShop
{
    if ([self.headerDelegate respondsToSelector:@selector(gotoDianpuFirst)]) {
        [self.headerDelegate gotoDianpuFirst];
    }
}


@end
