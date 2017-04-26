//
//  CouponsCell.m
//  GoodShop
//
//  Created by MIAO on 2016/12/30.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "CouponsCell.h"
#import "Header.h"
#import "CouponsModel.h"
@implementation CouponsCell
{
    UILabel *nameLabel;
    UILabel *moneyLabel;
    UILabel *titleLabel;
    UILabel *numLabel;
    UIView *lineView;
    UIView *line1;
    UIImageView *backImageView;
    UIButton *getBtn;
    NSString *dianpuID;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dianpuID = @"";
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.textColor = textColors;
    nameLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    line1 = [[UIView alloc]initWithFrame:CGRectZero];
    line1.backgroundColor = lineColor;
    [self.contentView addSubview:line1];
    
    backImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.image = [UIImage imageNamed:@"领劵中心2"];
    [self.contentView addSubview:backImageView];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyLabel.textColor = textBlackColor;
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:MLwordFont_1];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:moneyLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textColor = textColors;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"内部优惠券";
    [backImageView addSubview:titleLabel];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    numLabel.textColor = textColors;
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    numLabel.textAlignment = NSTextAlignmentLeft;
    [backImageView addSubview:numLabel];
    
    getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getBtn.layer.cornerRadius = 2*MCscale;
    getBtn.layer.masksToBounds = YES;
    getBtn.backgroundColor = txtColors(243, 207, 104, 1);
    [getBtn setTitle:@"马上领取" forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(getBtnClick) forControlEvents:UIControlEventTouchUpInside];
    getBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:getBtn];
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = redTextColor;
    [self.contentView addSubview:lineView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    nameLabel.frame = CGRectMake(10*MCscale, 5*MCscale, self.width - 20*MCscale, 20*MCscale);
    line1.frame = CGRectMake(5*MCscale, nameLabel.bottom+5*MCscale, self.width - 10*MCscale, 1);
    backImageView.frame = CGRectMake(10*MCscale, line1.bottom +10*MCscale, self.width-90*MCscale,60*MCscale);
    moneyLabel.frame = CGRectMake(0, 0, 80*MCscale, 30*MCscale);
    moneyLabel.center = CGPointMake(40*MCscale, backImageView.height/2.0);
    titleLabel.frame = CGRectMake(90*MCscale,13*MCscale, backImageView.width-100*MCscale, 15*MCscale);
    numLabel.frame = CGRectMake(90*MCscale, titleLabel.bottom +5*MCscale, backImageView.width - 100*MCscale, 15*MCscale);
    getBtn.frame = CGRectMake(0, 0,60*MCscale, 30*MCscale);
    getBtn.center = CGPointMake(backImageView.right +10*MCscale+30*MCscale,70*MCscale);
    lineView.frame = CGRectMake(0, self.height-10*MCscale, self.width,10*MCscale);
}

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    CouponsModel *model = array[indexpath.row];
    nameLabel.text = model.name;
    moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.money];
    numLabel.text = [NSString stringWithFormat:@"内含%@张",model.shuling];
    dianpuID = model.dianpuid;
}
-(void)getBtnClick
{
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":dianpuID,@"usertel":user_tel}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"savedianpuyouhui.action" params:pram success:^(id json) {
            NSLog(@"优惠券%@",json);
            if ([self.couponsDelegate respondsToSelector:@selector(getCouponsWithIndex:)]) {
                [self.couponsDelegate getCouponsWithIndex:[[json valueForKey:@"massages"] integerValue]];
            }
        } failure:^(NSError *error) {
            if ([self.couponsDelegate respondsToSelector:@selector(getCouponsWithIndex:)]) {
                [self.couponsDelegate getCouponsWithIndex:2];
            }
        }];
}
@end
