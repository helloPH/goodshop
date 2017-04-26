//
//  PackagesRecordCell.m
//  GoodShop
//
//  Created by MIAO on 2017/1/9.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PackagesRecordCell.h"
#import "PackagesRecordModel.h"
@implementation PackagesRecordCell
{
    UIImageView *logoImageView;
    UILabel *gonggaoLabel,*nameLabel,*yueLabel,*moneyLabel;
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
    logoImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    logoImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:logoImageView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.textColor = textColors;
    nameLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
    [self.contentView addSubview:nameLabel];
    
    gonggaoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    gonggaoLabel.textColor = textBlackColor;
    gonggaoLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    [self.contentView addSubview:gonggaoLabel];
    
    yueLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    yueLabel.textColor = redTextColor;
    yueLabel.backgroundColor = [UIColor clearColor];
    yueLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:yueLabel];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyLabel.textColor = redTextColor;
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:MLwordFont_3];
    [self.contentView addSubview:moneyLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
}
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    PackagesRecordModel *model = array[indexpath.row];
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.dianpulogo]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    nameLabel.text = model.dianpuname;
    gonggaoLabel.text = model.gonggao;
    yueLabel.text = @"余额";
    moneyLabel.text = [NSString stringWithFormat:@"%@",model.money];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    logoImageView.frame = CGRectMake(0, 0, 70*MCscale, 70*MCscale);
    logoImageView.center = CGPointMake(45*MCscale, self.height /2.0);
    logoImageView.layer.cornerRadius = 35*MCscale;
    logoImageView.layer.masksToBounds = YES;
    nameLabel.frame = CGRectMake(logoImageView.right +10*MCscale, 10*MCscale, self.width - 120*MCscale, 20*MCscale);
    gonggaoLabel.frame = CGRectMake(logoImageView.right+10*MCscale, nameLabel.bottom+5*MCscale, self.width - 120*MCscale, 20*MCscale);
    yueLabel.frame = CGRectMake(self.width - 100*MCscale, self.height - 30*MCscale,30*MCscale, 15*MCscale);
    moneyLabel.frame = CGRectMake(yueLabel.right, self.height - 33*MCscale, 50*MCscale, 20*MCscale);
    lineView.frame = CGRectMake(10*MCscale, self.height - 1, self.width - 20*MCscale, 1);
}

@end
