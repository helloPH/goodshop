//
//  SeckillCell.m
//  GoodShop
//
//  Created by MIAO on 2017/1/4.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "SeckillCell.h"
#import "SeckillModel.h"
#import "searchOldPrcLb.h"
@implementation SeckillCell
{
    UIImageView *headImageViews,*qiangImage;
    UILabel *nameLabel;
    UIView *timeView;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *yuanjiaLabel;
    UILabel *xianjiaLabel;
    UILabel *numLabel;
    UIView *lineView;
    NSString *timeStr;
    searchOldPrcLb *goodOldPrice;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        timeStr = @"";
        [self initSubViews];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getShijiancha) userInfo:self repeats:YES];
    }
    return self;
}
-(void)initSubViews
{
    headImageViews = [[UIImageView alloc]initWithFrame:CGRectZero];
    headImageViews.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:headImageViews];
    
    qiangImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    qiangImage.backgroundColor = [UIColor clearColor];
    qiangImage.image = [UIImage imageNamed:@"抢"];
    [self.contentView addSubview:qiangImage];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:MLwordFont_6];
    nameLabel.textColor = textColors;
    [self.contentView addSubview:nameLabel];
    
    timeView = [[UIView alloc]initWithFrame:CGRectZero];
    timeView.backgroundColor = txtColors(243, 213, 50, 1);
    [self.contentView addSubview:timeView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_9];
    titleLabel.textColor = txtColors(172, 37, 51, 1);
    titleLabel.text = @"距离结束";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [timeView addSubview:titleLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_9];
    timeLabel.textColor = txtColors(172, 37, 51, 1);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = @"00:00:00";
    [timeView addSubview:timeLabel];
    
    xianjiaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    xianjiaLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    xianjiaLabel.textColor = txtColors(219,42,0, 1);
    xianjiaLabel.backgroundColor = [UIColor clearColor];
    xianjiaLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:xianjiaLabel];
    
    goodOldPrice = [[searchOldPrcLb alloc]initWithFrame:CGRectZero];
    goodOldPrice.backgroundColor = [UIColor clearColor];
    goodOldPrice.textAlignment = NSTextAlignmentCenter;
    goodOldPrice.textColor = textColors;
    goodOldPrice.alpha = 0;
    goodOldPrice.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self.contentView addSubview:goodOldPrice];

    numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    numLabel.textColor = textColors;
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:numLabel];
    
    _SeckillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SeckillBtn.backgroundColor = txtColors(199, 51, 71, 1);
    _SeckillBtn.layer.cornerRadius = 3*MCscale;
    _SeckillBtn.layer.masksToBounds = YES;
    _SeckillBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [_SeckillBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [_SeckillBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_SeckillBtn];
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    headImageViews.frame = CGRectMake(0,0, 80*MCscale, 80*MCscale);
    headImageViews.center = CGPointMake(50*MCscale, self.height/2.0);
    qiangImage.frame = CGRectMake(headImageViews.right + 10*MCscale,15*MCscale, 20*MCscale, 20*MCscale);
    timeView.frame = CGRectMake(self.width - 80*MCscale,10*MCscale,70*MCscale, 40*MCscale);
    titleLabel.frame = CGRectMake(0,5*MCscale, timeView.width, 15*MCscale);
    timeLabel.frame = CGRectMake(0, titleLabel.bottom, timeView.width, 20*MCscale);
   
    _SeckillBtn.frame = CGRectMake(self.width - 80*MCscale, self.height - 40*MCscale,70*MCscale, 30*MCscale);
    lineView.frame = CGRectMake(0,self.height - 5*MCscale, self.width, 5*MCscale);
}
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    SeckillModel *model = array[indexpath.row];
    [headImageViews sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.canpinpic]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
    
    NSString *godName = model.shangpinname;
    CGSize size = [godName boundingRectWithSize:CGSizeMake(kDeviceWidth-200*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
    nameLabel.frame = CGRectMake(125*MCscale,15*MCscale, size.width, 20);
    nameLabel.text = model.shangpinname;
    
    NSString *xianjiaStr = [NSString stringWithFormat:@"￥%@",model.xianjia];
    CGSize xianjiasize = [xianjiaStr boundingRectWithSize:CGSizeMake(kDeviceWidth-200*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_2],NSFontAttributeName, nil] context:nil].size;
    xianjiaLabel.frame = CGRectMake(100*MCscale,70*MCscale, xianjiasize.width,20*MCscale);
    xianjiaLabel.text = xianjiaStr;
    
    timeStr = model.zhuangtai;
    if ([model.yuanjia integerValue] !=0) {
        goodOldPrice.alpha = 1;
        
        NSString *yuanjiaStr = [NSString stringWithFormat:@"￥%@",model.yuanjia];
        CGSize yuanjiasize = [yuanjiaStr boundingRectWithSize:CGSizeMake(200*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        goodOldPrice.frame = CGRectMake(xianjiaLabel.right+5*MCscale,70*MCscale, yuanjiasize.width+2*MCscale,20*MCscale);
        goodOldPrice.text = yuanjiaStr;
    }
    else
    {
        goodOldPrice.frame = CGRectMake(xianjiaLabel.right+5*MCscale,70*MCscale, 50*MCscale,20*MCscale);
    }
    
    if ([model.kucun integerValue] !=0 ) {
        
        NSString *numStr = [NSString stringWithFormat:@"剩%@份",model.kucun];
        CGSize numsize = [numStr boundingRectWithSize:CGSizeMake(200*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_7],NSFontAttributeName, nil] context:nil].size;
        numLabel.frame = CGRectMake(goodOldPrice.right+10*MCscale,73*MCscale, numsize.width,15*MCscale);
        numLabel.text = numStr;
    }
}

-(void)getShijiancha
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyyMMddHHmmss";
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:[NSString stringWithFormat:@"%@00",timeStr]];
    // 当前时间data格式
    
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)dateCom.day*24+(long)dateCom.hour,(long)dateCom.minute,(long)dateCom.second];
}

@end
