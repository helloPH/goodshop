//
//  DetailTableFootView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "DetailTableFootView.h"
#import "Header.h"
@implementation DetailTableFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)createUIWithArray:(NSArray *)array
{
    NSArray *tit;
    if ([array[1] integerValue] == 0) {
        tit = @[@"配送费:",@"实付款:"];
    }
    else
    {
        if (![array[0] isEqualToString:@""] && ![array[0] isEqualToString:@"0"]) {
            NSString *str = [NSString stringWithFormat:@"%@:",array[0]];
            tit = @[str,@"配送费:",@"实付款:"];
        }
        else
        {
        tit = @[@"附加费:",@"配送费:",@"实付款:"];
        }
    }
    for (int i = 0;i<tit.count;i++ ) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale,25*MCscale*i+5*MCscale, 80*MCscale, 20*MCscale)];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = txtColors(89, 90, 91, 1);
        title.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
        title.backgroundColor = [UIColor clearColor];
        title.text = tit[i];
        title.tag = 300+i;
        [self addSubview:title];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth -130*MCscale, title.top,  100*MCscale, 20*MCscale)];
        content.textAlignment = NSTextAlignmentCenter;
        content.tag = 400+i;
        content.font = [UIFont systemFontOfSize:MLwordFont_5];
        content.backgroundColor = [UIColor clearColor];
        content.textColor = textBlackColor;
        [self addSubview:content];
        
        
        
        
        if (tit.count == 2) {
             NSString * string = [NSString stringWithFormat:@"%@",array[i+2]];
            content.text = [NSString stringWithFormat:@"￥%.2f",[string floatValue]];
            if (string.floatValue == 0) {
                content.hidden=YES;
                title.hidden=YES;
            }
        }
        else
        {
            NSString * string = [NSString stringWithFormat:@"%@",array[i+1]];
            content.text = [NSString stringWithFormat:@"￥%.2f",[string floatValue]];
            if (string.floatValue == 0) {
                content.hidden=YES;
                title.hidden=YES;
            }
        }
        
        
    }
    
    if (![array[4] isEqualToString:@""] && ![array[4] isEqualToString:@"0"]) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, tit.count*30*MCscale-1, self.width, 1)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
        
        UILabel *bj = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale,tit.count*30*MCscale +5*MCscale, 80*MCscale, 20*MCscale)];
        bj.text = @"订单备注:";
        bj.textAlignment = NSTextAlignmentLeft;
        bj.textColor = textColors;
        bj.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
        bj.backgroundColor = [UIColor clearColor];
        [self addSubview:bj];
        NSString *content =[NSString stringWithFormat:@"%@",array[4]];
        CGSize size = [content boundingRectWithSize:CGSizeMake(kDeviceWidth-50*MCscale, 140*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        UILabel *bjContent = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, bj.bottom+0*MCscale, kDeviceWidth-50*MCscale, size.height)];
        bjContent.textColor = textColors;
        bjContent.numberOfLines = 0;
        bjContent.backgroundColor = [UIColor clearColor];
        bjContent.textAlignment = NSTextAlignmentLeft;
        bjContent.text = content;
        bjContent.font = [UIFont systemFontOfSize:MLwordFont_5];
        [self addSubview:bjContent];
    }
}
@end
