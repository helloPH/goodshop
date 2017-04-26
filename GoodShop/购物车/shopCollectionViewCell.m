//
//  shopCollectionViewCell.m
//  LifeForMM
//
//  Created by HUI on 15/7/25.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "shopCollectionViewCell.h"
#import "ShangpinModel.h"
#import "TGCenterLineLabel.h"
#import "Header.h"
@implementation shopCollectionViewCell
{
   UIImageView *goodImage;
   UIImageView *shangbiao;
   UILabel *goodTitle;
   UILabel *nowPrice;
   TGCenterLineLabel *oldPrice;
   UILabel *tishiLabel;//提示label
    UIView *line;
    UIView *line1;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
//            self.backgroundColor = redTextColor;
        }
    return self;
}
-(void)createUI
{
    goodImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@""];
//    goodImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:goodImage];
    
    //提示label
    tishiLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:MLwordFont_5] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    tishiLabel.alpha = 0.5;
    [goodImage addSubview:tishiLabel];
    
    shangbiao = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@""];
    shangbiao.contentMode = UIViewContentModeScaleAspectFit;
    [goodImage addSubview:shangbiao];
    
    goodTitle = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    [self addSubview:goodTitle];
    
    nowPrice = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_12] textColor:txtColors(248, 53, 74, 1) backgroundColor:[UIColor clearColor] textAlignment:2 numOfLines:1 text:@""];
    [self addSubview:nowPrice];
    
    oldPrice = [[TGCenterLineLabel alloc]initWithFrame:CGRectZero];
    oldPrice.textColor = textColors;
    oldPrice.alpha = 0;
    oldPrice.textAlignment = NSTextAlignmentLeft;
    oldPrice.font = [UIFont systemFontOfSize:MLwordFont_9];
    oldPrice.backgroundColor = [UIColor clearColor];
    [self addSubview:oldPrice];
    
    _goinShopCar = [BaseCostomer buttonWithFrame:CGRectZero backGroundColor:[UIColor clearColor] text:@"" image:@"加入购物车"];
    [_goinShopCar setImageEdgeInsets: UIEdgeInsetsMake(7,12,7,12)];
    [self addSubview:_goinShopCar];
    
    line = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
    [self addSubview:line];
    
    line1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
    [self addSubview:line1];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    goodImage.frame = CGRectMake(20*MCscale, 10*MCscale, self.contentView.width - 40*MCscale , SCLimageHeigh);
    tishiLabel.frame = CGRectMake(0*MCscale, goodImage.bottom - 20*MCscale, goodImage.width , 20*MCscale);
    shangbiao.frame = CGRectMake(15*MCscale, 15*MCscale, 26*MCscale, 26*MCscale);
    goodTitle.frame = CGRectMake(0, CGRectGetMaxY(goodImage.frame)+5*MCscale, CGRectGetWidth(self.frame), 20*MCscale);
    nowPrice.frame = CGRectMake(0, CGRectGetMaxY(goodTitle.frame)+10*MCscale, kDeviceWidth/5.0, 20*MCscale);
    oldPrice.frame = CGRectMake(CGRectGetMaxX(nowPrice.frame), CGRectGetMaxY(goodTitle.frame)+10, 70*MCscale, 20*MCscale);
    oldPrice.center = CGPointMake(CGRectGetMaxX(nowPrice.frame)+37*MCscale, CGRectGetMaxY(goodTitle.frame)+20*MCscale);
    _goinShopCar.frame = CGRectMake(CGRectGetMaxX(nowPrice.frame)+SCLgoinCarSpace, CGRectGetMaxY(goodTitle.frame), SCLgoinCarHeight +10, SCLgoinCarHeight);
    line.frame = CGRectMake(0, 0, self.width, 1);
    line1.frame = CGRectMake(self.width-1,5*MCscale, 1, self.height-10*MCscale);
}
-(void)reloDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    ShangpinModel *model = array[indexpath.row];
    [goodImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.canpinpic]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    
    NSString *biaoq = [NSString stringWithFormat:@"%@",model.biaoqian];
    if (![biaoq isEqualToString:@"1"] && ![biaoq isEqualToString:@""]) [shangbiao sd_setImageWithURL:[NSURL URLWithString:model.biaoqian]];
    
    NSString *zhuangtai = [NSString stringWithFormat:@"%@",model.zhuangtai];
    NSLog(@"状态%@",zhuangtai);
    //
    if (zhuangtai.length > 11) {
        tishiLabel.text = zhuangtai;
       tishiLabel.backgroundColor = [UIColor grayColor];
       _goinShopCar.hidden = YES;
    }
    else {
        if([zhuangtai isEqualToString:@"A"])
        {
            
        }
        else if ([zhuangtai integerValue] < 1) {
           tishiLabel.text = @"已售完";
            tishiLabel.backgroundColor = [UIColor grayColor];
            _goinShopCar.hidden = YES;
        }
    }
    
    goodTitle.text = model.shangpinname;
    NSString *pric = [NSString stringWithFormat:@"%.2f",[model.xianjia floatValue]];
    nowPrice.text =[NSString stringWithFormat:@"¥%@",pric] ;
    oldPrice.text = [NSString stringWithFormat:@"原价:%.1f",[model.yuanjia floatValue]];
    if ([model.yuanjia floatValue] >0) oldPrice .alpha =1;
    else oldPrice.alpha = 0;
    CGSize size = [oldPrice.text boundingRectWithSize:CGSizeMake(70, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
    oldPrice.size = CGSizeMake(size.width, 20);
    
//    [_goinShopCar addTarget:self action:@selector(goinShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
//    _goinShopCar.tag = indexpath.row;
//    [btnArray addObject:cell.goinShopCar];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    //重置图片
    shangbiao.image = nil;
    
    tishiLabel.text = nil;
    
    tishiLabel.backgroundColor = nil;
    //更新位置
//    self.shangbiao.frame = self.contentView.bounds;
    
    self.goinShopCar.hidden = NO;
}
@end
