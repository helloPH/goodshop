//
//  DiscountCell.m
//  GoodShop
//
//  Created by MIAO on 2017/1/4.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "DiscountCell.h"
#import "DiscountModel.h"
#import "searchOldPrcLb.h"
@implementation DiscountCell
{
    UIView *backView;
    UIImageView *headImageViews,*sanjiaoImageView;
    UILabel *nameLabel,*dianpuLabel,*zhekouLabel;
    UILabel *xianjiaLabel,*priceLabel;
    searchOldPrcLb *yuanjiaLabel;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = txtColors(207, 125,33, 1);
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    backView = [[UIView alloc]initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    headImageViews = [[UIImageView alloc]initWithFrame:CGRectZero];
    headImageViews.backgroundColor = [UIColor clearColor];
    [backView addSubview:headImageViews];
    
    sanjiaoImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    sanjiaoImageView.backgroundColor = [UIColor clearColor];
    sanjiaoImageView.image = [UIImage imageNamed:@"三角"];
    [backView addSubview:sanjiaoImageView];
    
    zhekouLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    zhekouLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    zhekouLabel.textColor = [UIColor whiteColor];
    zhekouLabel.textAlignment = NSTextAlignmentCenter;
    zhekouLabel.backgroundColor = [UIColor clearColor];
    zhekouLabel.transform=CGAffineTransformMakeRotation(M_PI/4);
    [sanjiaoImageView addSubview:zhekouLabel];

    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    nameLabel.textColor = textColors;
    [backView addSubview:nameLabel];
    
    dianpuLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    dianpuLabel.backgroundColor = [UIColor clearColor];
    dianpuLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    dianpuLabel.textColor = textColors;
    [backView addSubview:dianpuLabel];
    
    xianjiaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    xianjiaLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    xianjiaLabel.textColor = txtColors(219,42,0, 1);
    xianjiaLabel.text = @"活动价  ￥";
    xianjiaLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:xianjiaLabel];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    priceLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    priceLabel.textColor = txtColors(219,42,0, 1);
    priceLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:priceLabel];
    
    yuanjiaLabel = [[searchOldPrcLb alloc]initWithFrame:CGRectZero];
    yuanjiaLabel.backgroundColor = [UIColor clearColor];
    yuanjiaLabel.textAlignment = NSTextAlignmentCenter;
    yuanjiaLabel.textColor = textColors;
    yuanjiaLabel.alpha = 0;
    yuanjiaLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self.contentView addSubview:yuanjiaLabel];


    _SeckillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SeckillBtn.backgroundColor = txtColors(199, 51, 71, 1);
    _SeckillBtn.layer.cornerRadius = 3*MCscale;
    _SeckillBtn.layer.masksToBounds = YES;
    _SeckillBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [_SeckillBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [_SeckillBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:_SeckillBtn];
}

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    DiscountModel *model = array[indexpath.row];
    [headImageViews sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.canpinpic]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    nameLabel.text = model.shangpinname;
    dianpuLabel.text = user_dianpuName;
    
    NSString *xianjia = [NSString stringWithFormat:@"￥%@",model.xianjia];
    CGSize size = [xianjia boundingRectWithSize:CGSizeMake(50*MCscale, 20*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_2],NSFontAttributeName, nil] context:nil].size;
    priceLabel.frame = CGRectMake(170*MCscale,85*MCscale, size.width, 20*MCscale);
    priceLabel.text = [NSString stringWithFormat:@"%@",model.xianjia];
    
    if ([model.yuanjia integerValue] !=0) {
        yuanjiaLabel.alpha = 1;
        double zhekou = [model.xianjia doubleValue]/[model.yuanjia doubleValue]*10;
        zhekouLabel.text = [NSString stringWithFormat:@"%.1f折",zhekou];
        NSString *yuanjia = [NSString stringWithFormat:@"￥%@",model.yuanjia];
        CGSize size = [yuanjia boundingRectWithSize:CGSizeMake(60*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        yuanjiaLabel.frame = CGRectMake(priceLabel.right,88*MCscale, size.width+3*MCscale, 20);
        yuanjiaLabel.text = yuanjia;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    backView.frame = CGRectMake(5*MCscale, 2*MCscale, self.width - 10*MCscale, self.height - 10*MCscale);
    headImageViews.frame = CGRectMake(5*MCscale, 5*MCscale, 100*MCscale, 100*MCscale);
    sanjiaoImageView.frame = CGRectMake(backView.width - 50*MCscale,0,50*MCscale,50*MCscale);
    zhekouLabel.frame = CGRectMake(18*MCscale,-2*MCscale,30*MCscale,40*MCscale);
    
    nameLabel.frame = CGRectMake(headImageViews.right +10*MCscale,10*MCscale, 120*MCscale, 20*MCscale);
    dianpuLabel.frame = CGRectMake(headImageViews.right +10*MCscale,nameLabel.bottom+5*MCscale, 120*MCscale, 15*MCscale);
    xianjiaLabel.frame = CGRectMake(headImageViews.right + 10*MCscale, self.height -30*MCscale,56*MCscale, 15*MCscale);
    _SeckillBtn.frame = CGRectMake(backView.width - 80*MCscale, self.height - 40*MCscale,70*MCscale, 25*MCscale);
}

@end
