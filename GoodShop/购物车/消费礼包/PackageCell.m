//
//  PackageCell.m
//  GoodShop
//
//  Created by MIAO on 2017/1/4.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PackageCell.h"
#import "PackageModel.h"
#import "Header.h"
@implementation PackageCell
{
    UIImageView *headImageView;
    UILabel *nameLabel,*addressLabel,*moneyLabel;
    UIView *lineView;
    UIButton *chongzhiBtn;
    NSString *chongzhi,*song,*libaoid;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        libaoid = @"0";
        chongzhi = @"0";
        song = @"0";
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    headImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    headImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:headImageView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.textColor = textColors;
    nameLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    addressLabel.textColor = textColors;
    addressLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:addressLabel];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyLabel.textColor = redTextColor;
    moneyLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:moneyLabel];
    
    chongzhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhiBtn.layer.cornerRadius = 3*MCscale;
    chongzhiBtn.layer.masksToBounds = YES;
    chongzhiBtn.backgroundColor = txtColors(222,21,55, 1);
    chongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [chongzhiBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [chongzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chongzhiBtn addTarget:self action:@selector(chongzhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:chongzhiBtn];

    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
}
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    if (![array[indexpath.row] isEqual:@"0"]) {
        PackageModel *model = array[indexpath.row];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.images]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
        nameLabel.text = model.dianpuname;
        addressLabel.text = model.dizhi;
        moneyLabel.text = [NSString stringWithFormat:@"*充%@送%@元",model.chongzhi,model.song];
        chongzhi = model.chongzhi;
        song = model.song;
        libaoid = model.libaoid;
    }
    else
    {
//        self.contentView.backgroundColor = lineColor;
        lineView.hidden = YES;
        chongzhiBtn.hidden = YES;
    }
}
-(void)chongzhiBtnClick
{
    NSDictionary *dict = @{@"libaoid":libaoid,@"chongzhi":chongzhi,@"song":song};
    if ([self.packageDelegate respondsToSelector:@selector(getPackageWithDict:)]) {
        [self.packageDelegate getPackageWithDict:dict];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    headImageView.frame = CGRectMake(10*MCscale, 10*MCscale,130*MCscale, 130*MCscale);
    nameLabel.frame = CGRectMake(headImageView.right +5*MCscale,15*MCscale, self.width - 150*MCscale, 20*MCscale);
    addressLabel.frame = CGRectMake(headImageView.right +5*MCscale,nameLabel.bottom+5*MCscale, self.width - 150*MCscale,15*MCscale);
    moneyLabel.frame = CGRectMake(headImageView.right +5*MCscale,addressLabel.bottom+10*MCscale, self.width - 150*MCscale, 15*MCscale);
    chongzhiBtn.frame = CGRectMake(headImageView.right +10*MCscale, moneyLabel.bottom+15*MCscale, 60*MCscale, 30*MCscale);
    lineView.frame = CGRectMake(0, self.height -5*MCscale, self.width, 5*MCscale);
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    //重置图片
    chongzhiBtn.hidden = NO;
    lineView.hidden = NO;//
}
@end
