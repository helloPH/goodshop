//
//  DianpuRecordCell.m
//  GoodShop
//
//  Created by MIAO on 2017/1/9.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "DianpuRecordCell.h"
#import "DianpuRecordModel.h"
#import "Header.h"
@implementation DianpuRecordCell
{
    UILabel *leimuLabel,*timeLabel,*yueLabel,*xiaofeiLabel,*danhaoLabel;
    UIView *lineView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    leimuLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    leimuLabel.textColor = textBlackColor;
    leimuLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    [self.contentView addSubview:leimuLabel];

    timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.textColor = textColors;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
    [self.contentView addSubview:timeLabel];
    
    yueLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    yueLabel.textColor = txtColors(0, 188, 134, 1);
    yueLabel.backgroundColor = [UIColor clearColor];
    yueLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:yueLabel];
    
    danhaoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    danhaoLabel.textColor = textColors;
    danhaoLabel.textAlignment = NSTextAlignmentCenter;
    danhaoLabel.backgroundColor = [UIColor clearColor];
    danhaoLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self.contentView addSubview:danhaoLabel];
    
    xiaofeiLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    xiaofeiLabel.textColor = redTextColor;
    xiaofeiLabel.textAlignment = NSTextAlignmentRight;
    xiaofeiLabel.backgroundColor = [UIColor clearColor];
    xiaofeiLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:xiaofeiLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
}
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    DianpuRecordModel *model = array[indexpath.row];
    timeLabel.text = model.time;
    leimuLabel.text = model.leimu;
    yueLabel.text = [NSString stringWithFormat:@"余额:%@",model.money];
    xiaofeiLabel.text = [NSString stringWithFormat:@"%@",model.xiaofei];
    if ([model.leimu isEqualToString:@"礼包充值"]) {
        danhaoLabel.text = [user_tel stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    }
    else
    {
        danhaoLabel.text = [NSString stringWithFormat:@"%@",model.danhao];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    leimuLabel.frame = CGRectMake(10*MCscale, 10*MCscale,(self.width-20*MCscale)/2.0, 20*MCscale);
    timeLabel.frame = CGRectMake(self.width/2.0, 10*MCscale, (self.width-20*MCscale)/2.0, 20*MCscale);
    yueLabel.frame = CGRectMake(10*MCscale, leimuLabel.bottom +5*MCscale,80*MCscale, 15*MCscale);
    danhaoLabel.frame = CGRectMake(yueLabel.right +5*MCscale, yueLabel.top,self.width-190*MCscale,15*MCscale);
    xiaofeiLabel.frame = CGRectMake(danhaoLabel.right+5*MCscale, yueLabel.top,60*MCscale,15*MCscale);
    lineView.frame = CGRectMake(10*MCscale, self.height - 1, self.width - 20*MCscale, 1);
}

@end

