//
//  TypeSelectedCell.m
//  ManageForMM
//
//  Created by MIAO on 16/11/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "TypeSelectedCell.h"

#import "Header.h"
@implementation TypeSelectedCell
{
    UIView *lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.typeLabel.backgroundColor = [UIColor clearColor];
    self.typeLabel.textColor = textColors;
    self.typeLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.typeLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.typeLabel.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    lineView.frame = CGRectMake(10*MCscale, self.contentView.height - 1, self.contentView.width - 20*MCscale, 1);
}
-(void)reloadDataForFenleiWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    self.typeLabel.text = array[indexpath.row];
}
-(void)reloadDataForHangyeWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    self.typeLabel.text = array[indexpath.row][@"name"];
}
-(void)reloadDataForHezuoWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    self.typeLabel.text = array[indexpath.row][@"name"];
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    self.typeLabel.textColor = textColors;
    self.typeLabel.text = nil;
}

@end
