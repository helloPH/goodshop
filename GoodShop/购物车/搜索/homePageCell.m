//
//  homePageCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/15.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "homePageCell.h"
#import "Header.h"
#define smImageHigh 57
#define smImageLength 15
@implementation homePageCell
{
    UIImageView *storeImage,*actionState,*renzhengImg;
    UILabel *storeName,*address,*distanceLabel;
    NSMutableArray *imageViewAry;
    UILabel *yuyueMessage;//预约说明
    UIView *line;//底部线
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageViewAry = [NSMutableArray arrayWithCapacity:0];
        [self SubViews];
    }
    return self;
}
-(void)SubViews
{
    storeImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    storeImage.backgroundColor = [UIColor clearColor];
    storeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:storeImage];
    
    storeName = [[UILabel alloc]initWithFrame:CGRectZero];
    storeName.backgroundColor = [UIColor clearColor];
    storeName.font = [UIFont systemFontOfSize:MLwordFont_6];
    storeName.textColor = txtColors(25, 26, 27, 1);
    storeName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:storeName];
    
    renzhengImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    renzhengImg.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:renzhengImg];
    
    address = [[UILabel alloc]initWithFrame:CGRectZero];
    address.backgroundColor = [UIColor clearColor];
    address.font = [UIFont systemFontOfSize:MLwordFont_9];
    address.textColor = txtColors(126, 127, 129, 1);
    address.textAlignment = NSTextAlignmentLeft;
    
    
    distanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    distanceLabel.textColor = txtColors(126, 127, 129, 1);
    distanceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:distanceLabel];
    
    for (int i = 0; i<8; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
        image.backgroundColor = [UIColor clearColor];
        [imageViewAry addObject:image];
    }
    actionState = [[UIImageView alloc]initWithFrame:CGRectZero];
    actionState.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:actionState];
    
    yuyueMessage = [[UILabel alloc]initWithFrame:CGRectZero];
    yuyueMessage.backgroundColor = [UIColor clearColor];
    yuyueMessage.textAlignment = NSTextAlignmentRight;
    yuyueMessage.textColor = txtColors(126, 127, 129, 1);
    yuyueMessage.font = [UIFont systemFontOfSize:MLwordFont_9];
    [self.contentView addSubview:yuyueMessage];
    
    line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = lineColor;
    [self.contentView addSubview:line];
    
}
-(void)reloDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    shopListModel *model = array[indexpath.row];
    [storeImage sd_setImageWithURL:[NSURL URLWithString:model.dianpuimage] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    storeName.text = model.dianpuname;
    CGSize storeNameSize = [model.dianpuname boundingRectWithSize:CGSizeMake(175*MCscale, 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    storeName.frame = CGRectMake(105*MCscale, 5, storeNameSize.width, 30*MCscale);
    
    storeImage.contentMode = UIViewContentModeScaleAspectFit;
//    renzhengImg.frame = CGRectMake(storeName.right+3, storeName.top+8, 14*MCscale, 14*MCscale);
    //    if ([model.renzheng isEqual:[NSNull null]]) {
    ////        [renzhengImg sd_setImageWithURL:[NSURL URLWithString:model.renzheng] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    //    }
    //    else
    //    {
    //        [renzhengImg sd_setImageWithURL:[NSURL URLWithString:model.renzheng] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    //    }
    address.text = model.address;
    CGSize addressSize = [model.address boundingRectWithSize:CGSizeMake(150*MCscale, 18*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] context:nil].size;
    
    address.frame = CGRectMake(105*MCscale, 30*MCscale, addressSize.width, 18*MCscale);
    [self.contentView addSubview:address];
    
    distanceLabel.text = [NSString stringWithFormat:@"距离:%@",model.distance];
    NSMutableArray *imagAry = [[NSMutableArray alloc]init];
    for(NSString *str in model.tubiaoimage){
        if (![str isEqual:[NSNull null]] && ![str isEqualToString:@""]) {
            [imagAry addObject:str];
        }
    }
    for(int i = 0 ;i<8 ;i++){
        UIImageView *image = imageViewAry[i];
        image.frame = CGRectMake(105*MCscale+17*i*MCscale, smImageHigh*MCscale, smImageLength*MCscale, smImageLength*MCscale);
        if (i<imagAry.count) {
            [image sd_setImageWithURL:[NSURL URLWithString:imagAry[i]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
            [self.contentView addSubview:image];
        }
        else{
            [image removeFromSuperview];
        }
    }
    NSString *stateStr = @"";
    if([[NSString stringWithFormat:@"%@",model.zhuangtai] isEqualToString:@"1"]){
        stateStr = @"营业中";
        yuyueMessage.alpha = 0;
    }
    else if ([[NSString stringWithFormat:@"%@",model.zhuangtai] isEqualToString:@"3"]){
        stateStr = @"休息中";
        yuyueMessage.alpha = 0;
    }
    else{
        stateStr = @"可预约";
        yuyueMessage.frame = CGRectMake(self.frame.size.width-115*MCscale, 30*MCscale, 100*MCscale, 20*MCscale);
//        if (![model.yuyueshuomin isEqual:[NSNull null]]) {
//            yuyueMessage.text = model.yuyueshuomin;
//        }
        yuyueMessage.alpha = 1;
    }
    actionState.image = [UIImage imageNamed:stateStr];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    line.frame = CGRectMake(10*MCscale,self.height - 0.5, self.width  -20 *MCscale, 0.5);
    actionState.frame = CGRectMake(self.contentView.width-65*MCscale, 10*MCscale, 50*MCscale, 17*MCscale);
    storeImage.frame = CGRectMake(30*MCscale, 5, 70*MCscale, 70*MCscale);
   
    distanceLabel .frame = CGRectMake(self.contentView.width-85*MCscale, 30*MCscale,80*MCscale, 17*MCscale);
}
@end
