//
//  detailViewCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/23.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "detailViewCell.h"
#import "Header.h"
@implementation detailViewCell
{
    UIImageView *goodImage; //商品图片
    UILabel *goodTitle,*price,*godNum;//商品名称 单价 数量
    UILabel *xianghaoLab,*yanseL;//型号 颜色
    UIView  *line;
}
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
    //商品图片
    goodImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    goodImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:goodImage];

    //商品名称
    goodTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    goodTitle.textAlignment = NSTextAlignmentLeft;
    goodTitle.textColor = txtColors(90, 91, 92, 1);
    goodTitle.font = [UIFont boldSystemFontOfSize:MLwordFont_6];
    goodTitle.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:goodTitle];

    //价格
    price = [[UILabel alloc]initWithFrame:CGRectZero];
    price.textColor = txtColors(90, 91, 92, 1);
    price.textAlignment = NSTextAlignmentLeft;
    price.font = [UIFont boldSystemFontOfSize:MLwordFont_6];
    [self.contentView addSubview:price];

    //数量
    godNum = [[UILabel alloc]initWithFrame:CGRectZero];
    godNum.textAlignment = NSTextAlignmentLeft;
    godNum.textColor = txtColors(90, 91, 92, 1);
    godNum.font = [UIFont boldSystemFontOfSize:MLwordFont_6];
    [self.contentView addSubview:godNum];

    //颜色
    yanseL = [[UILabel alloc]initWithFrame:CGRectZero];
    yanseL.textAlignment = NSTextAlignmentCenter;
    yanseL.textColor = txtColors(90, 91, 92, 1);
    yanseL.font = [UIFont systemFontOfSize:MLwordFont_6];
    [self.contentView addSubview:yanseL];

    //型号
    xianghaoLab = [[UILabel alloc]initWithFrame:CGRectZero];
    xianghaoLab.textAlignment = NSTextAlignmentCenter;
    xianghaoLab.textColor = txtColors(90, 91, 92, 1);
    xianghaoLab.font = [UIFont systemFontOfSize:MLwordFont_6];
    [self.contentView addSubview:xianghaoLab];

    //分割线
    line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:line];
}
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    NSDictionary *detailDics = array[indexpath.row];
    //商品图片
    goodImage.frame = CGRectMake(30*MCscale, 5, 55*MCscale, 55*MCscale);

    [goodImage sd_setImageWithURL:[NSURL URLWithString:[detailDics valueForKey:@"shopimg"]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    NSString *titl = [NSString stringWithFormat:@"%@",[detailDics valueForKey:@"shopname"]];
    CGSize size = [titl boundingRectWithSize:CGSizeMake(250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil].size;
    goodTitle.frame = CGRectMake(goodImage.right+12*MCscale, 10*MCscale, size.width, 20*MCscale);
    goodTitle.text = titl;
    //价格
    price.frame = CGRectMake(goodImage.right+12, goodTitle.bottom+5, 60*MCscale, 20*MCscale);
    price.text = [NSString stringWithFormat:@"¥%.2f",[[detailDics valueForKey:@"jiage"] floatValue]];
    //数量
    godNum.frame = CGRectMake(price.right+2, goodTitle.bottom+5, 30*MCscale, 20*MCscale);
    godNum.text = [NSString stringWithFormat:@"X%@",[detailDics valueForKey:@"shuliang"]];
    NSString *ysStr =[NSString stringWithFormat:@"%@",[detailDics valueForKey:@"yanse"]];
    NSString *xhStr = [NSString stringWithFormat:@"%@",[detailDics valueForKey:@"xinghao"]];
    if (![ysStr isEqualToString:@"0"]) {
        CGSize yssize = [[detailDics valueForKey:@"yanse"] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
        yanseL.frame = CGRectMake(godNum.right+2, goodTitle.bottom+5, yssize.width, 20);
        yanseL.text = [detailDics valueForKey:@"yanse"];
        if (![xhStr isEqualToString:@"0"]) {
            CGSize xhsize = [[detailDics valueForKey:@"xinghao"] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
            xianghaoLab.frame = CGRectMake(yanseL.right+5, goodTitle.bottom+5, xhsize.width, 20);
            xianghaoLab.text = [detailDics valueForKey:@"xinghao"];
        }
    }
    else{
        if (![xhStr isEqualToString:@"0"]) {
            CGSize xhsize = [[detailDics valueForKey:@"xinghao"] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
            xianghaoLab.frame = CGRectMake(godNum.right+2, goodTitle.bottom+5, xhsize.width, 20);
            xianghaoLab.text = [detailDics valueForKey:@"xinghao"];
        }
    }
    if (indexpath.row == array.count -1) {
        line.frame = CGRectMake(0, 65*MCscale, kDeviceWidth,1);
    }
    else
    {
    line.frame = CGRectMake(17*MCscale, 65*MCscale, kDeviceWidth-34*MCscale,0.5);
    }
}

@end
