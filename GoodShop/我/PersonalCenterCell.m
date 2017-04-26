//
//  PersonalCenterCell.m
//  GoodShop
//
//  Created by MIAO on 2017/4/1.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PersonalCenterCell.h"
#import "Header.h"

@interface PersonalCenterCell ()
@property(nonatomic,strong)UIImageView *leftImageView,*rightImageView,*stateImage;
@property(nonatomic,strong)UILabel *titleLabel,*subTitle;
@property(nonatomic,strong)UIView *topLineView,*lineView1,*lineView2,*BackView;
@property(nonatomic,strong)NSArray *imageArray,*nameArray,*statesArray;
@property(nonatomic,assign)NSInteger viewIndex;
@end
@implementation PersonalCenterCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
-(UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_topLineView];
        _topLineView.hidden = YES;
    }
    return _topLineView;
}
-(UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@""];
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors text:@""];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@"下拉键"];
        [self.contentView addSubview:_rightImageView];
    }
    return _rightImageView;
}
-(UIView *)lineView1
{
    if (!_lineView1) {
        _lineView1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lineView1];
        _lineView1.hidden = YES;
    }
    return _lineView1;
}
-(UIView *)lineView2
{
    if (!_lineView2) {
        _lineView2 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lineView2];
        _lineView2.hidden = YES;
    }
    return _lineView2;
}
-(UILabel *)subTitle
{
    if (!_subTitle) {
        _subTitle = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:txtColors(72, 73, 74, 0.9) backgroundColor:[UIColor clearColor] textAlignment:2 numOfLines:1 text:@"账号安全状态"];
        [self.BackView addSubview:_subTitle];
    }
    return _subTitle;
}
-(UIImageView *)stateImage
{
    if (!_stateImage) {
        _stateImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@""];
        [self.BackView addSubview:_stateImage];
    }
    return _stateImage;
}
-(UIView *)BackView
{
    if (!_BackView) {
        _BackView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:[UIColor clearColor]];
    }
    return _BackView;
}

-(NSArray *)nameArray
{
    if (!_nameArray) {
        if (self.viewIndex  == 1) {
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"kaihu"]integerValue] == 1) {
                _nameArray = @[@"我要开户",@"我的收藏",@"安全设置",@"推荐免费领现金",@"我的客服",@"分享给朋友",@"更多..."];
            }
            else
            {
                _nameArray = @[@"我的收藏",@"安全设置",@"推荐免费领现金",@"我的客服",@"分享给朋友",@"更多..."];
            }
        }
        else
        {
            _nameArray = @[@"店铺二维码",@"新功能介绍",@"去评分",@"业务中心"];
        }
    }
    return _nameArray;
}
-(NSArray *)imageArray
{
    if (!_imageArray) {
        if (self.viewIndex == 1) {
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"kaihu"]integerValue] == 1) {
                _imageArray =  @[@"我的收藏",@"我的收藏",@"安全设置",@"推荐",@"客服-全黑",@"分享-橘黄色",@"意见反馈"];
            }
            else
            {
                _imageArray =  @[@"我的收藏",@"安全设置",@"推荐",@"客服-全黑",@"分享-橘黄色",@"意见反馈"];
            }
        }
        else
        {
            _imageArray =  @[@"二维码",@"新",@"评分-空心",@"合作"];
        }
    }
    return _imageArray;
}
-(NSArray *)statesArray
{
    if (!_statesArray) {
        _statesArray = @[@"安全状态-差",@"安全状态-低",@"安全状态-中",@"安全状态-高"];
    }
    return _statesArray;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.topLineView.frame = CGRectMake(0, 0, self.width, 1);
    self.leftImageView.frame = CGRectMake(0,0, 25*MCscale,25*MCscale);
    self.leftImageView.center = CGPointMake(23*MCscale, self.height/2.0);
    self.titleLabel.frame = CGRectMake(0,0, 130*MCscale, 20*MCscale);
    self.titleLabel.center = CGPointMake(self.leftImageView.right + 70*MCscale, self.height/2.0);
    self.rightImageView.frame = CGRectMake(0,0, 15*MCscale, 20*MCscale);
    self.rightImageView.center = CGPointMake(self.right - 15*MCscale,  self.height/2.0);
    self.BackView.frame = CGRectMake(self.width - 155*MCscale,0,130*MCscale,50*MCscale);
    self.subTitle.frame = CGRectMake(0, 15*MCscale,110*MCscale, 20*MCscale);
    self.stateImage.frame = CGRectMake(self.subTitle.right+2*MCscale, 16*MCscale, 17*MCscale, 17*MCscale);
    self.lineView1.frame = CGRectMake(0, self.height - 1*MCscale, self.width, 1*MCscale);
    self.lineView2.frame = CGRectMake(10*MCscale, self.height - 1*MCscale, self.width-20*MCscale, 1*MCscale);
}
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndViewTag:(NSInteger)viewTag AndDict:(NSDictionary *)dict
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"kaihu"]integerValue] == 1) {
        NSString *kaihuyouhuiStr = [NSString stringWithFormat:@"%@",dict[@"kaihuyouhui"]];
        if (indexpath.row == 0) {
            if ([kaihuyouhuiStr integerValue] !=0) {
                [self.contentView addSubview:self.BackView];
                self.subTitle.textColor = txtColors(254, 42, 68, 0.9);
                self.subTitle.frame = CGRectMake(kDeviceWidth-110*MCscale, 15/MCscale, 110*MCscale, 20*MCscale);
                self.subTitle.text = [NSString stringWithFormat:@"可用奖励%@元",kaihuyouhuiStr];            }
        }
        
        if (indexpath.row == 2){
            [self.contentView addSubview:self.BackView];
            NSInteger stateNum = [dict[@"anquanjibie"] integerValue]-1;
            if (stateNum>=0) {
                self.stateImage.image = [UIImage imageNamed:self.statesArray[stateNum]];
            }
        }
        
        if (indexpath.row == 3) {
            [self.contentView addSubview:self.BackView];
            self.stateImage.frame = CGRectMake(kDeviceWidth-(45*MCscale+110*MCscale), 16/MCscale, 18*MCscale, 18*MCscale);
            self.subTitle.textColor = txtColors(254, 42, 68, 0.9);
            self.subTitle.frame = CGRectMake(self.stateImage.right+2, 15/MCscale, 110*MCscale, 20*MCscale);
            self.subTitle.text = @"暂无好友奖励";
            self.stateImage.image = [UIImage imageNamed:@"叹号"];
        }
        if (indexpath.row == 6) {
            self.lineView1.hidden = NO;
            self.lineView2.hidden = YES;
        }
        else
        {
            self.lineView1.hidden = YES;
            self.lineView2.hidden = NO;
        }
    }
    else
    {
        if (indexpath.row == 1){
            [self.contentView addSubview:self.BackView];
            self.stateImage.image = [UIImage imageNamed:self.statesArray[3]];
        }
        
        if (indexpath.row == 2) {
            [self.contentView addSubview:self.BackView];
            self.stateImage.frame = CGRectMake(kDeviceWidth-(45*MCscale+110*MCscale), 16/MCscale, 18*MCscale, 18*MCscale);
            self.subTitle.textColor = txtColors(254, 42, 68, 0.9);
            self.subTitle.frame = CGRectMake(self.stateImage.right+2, 15/MCscale, 110*MCscale, 20*MCscale);
            self.subTitle.text = @"暂无好友奖励";
            self.stateImage.image = [UIImage imageNamed:@"叹号"];
        }
        if (indexpath.row == 5) {
            self.lineView1.hidden = NO;
            self.lineView2.hidden = YES;
        }
        else
        {
            self.lineView1.hidden = YES;
            self.lineView2.hidden = NO;
        }
    }
    
    self.viewIndex = viewTag;
    self.leftImageView.image = [UIImage imageNamed:self.imageArray[indexpath.row]];
    self.titleLabel.text = self.nameArray[indexpath.row];
}

-(void)reloadDataForMoreFromIndexPath:(NSIndexPath *)indexpath AndViewTag:(NSInteger)viewTag
{
    self.viewIndex  = viewTag;
    self.leftImageView.image = [UIImage imageNamed:self.imageArray[indexpath.row]];
    self.titleLabel.text = self.nameArray[indexpath.row];
    
    if (indexpath.row == 3) {
        self.lineView1.hidden = NO;
        self.lineView2.hidden = YES;
    }
    else
    {
        self.lineView1.hidden = YES;
        self.lineView2.hidden = NO;
    }
    
    if (indexpath.row == 0) {
        self.topLineView.hidden = NO;
    }
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    self.topLineView.hidden = YES;
    self.lineView1.hidden = YES;
    self.lineView2.hidden = YES;
}
@end

