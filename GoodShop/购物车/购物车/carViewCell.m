//
//  carViewCell.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/21.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "carViewCell.h"
#import "Header.h"
@implementation carViewCell
{
    NSString *dainpState;
    UIImageView *goodImageView,*changeNumImageView; // 选中 商品图片 加减
    UILabel *goodTitle,*moneyNum;
    UIButton *addBtn,*subtractBtn;
    UILabel *goodColor,*goodStyle;//颜色 型号
    NSInteger addOrCutBol;// '1'代表加 '0'代表减 '2'代表 没有选中
    NSInteger selOrAdd; //'1'代表
    CGFloat countMoney;
    NSInteger goodCount;
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self SubView];
    }
    return self;
}
-(void)SubView
{
    _selectImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _selectImageView.backgroundColor = [UIColor clearColor];
    _selectImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_selectImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_selectImageView];
    
    
    goodImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    goodImageView.backgroundColor = [UIColor clearColor];
    goodImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:goodImageView];
    
    
    goodTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    goodTitle.textColor = [UIColor blackColor];
    goodTitle.backgroundColor = [UIColor clearColor];
    goodTitle.textAlignment = NSTextAlignmentLeft;
    goodTitle.font = [UIFont systemFontOfSize:MLwordFont_8];
    [self.contentView addSubview:goodTitle];
    
    
    goodColor = [[UILabel alloc]initWithFrame:CGRectZero];
    goodColor.backgroundColor = [UIColor clearColor];
    goodColor.textColor = textBlackColor;
    goodColor.textAlignment = NSTextAlignmentLeft;
    goodColor.font = [UIFont systemFontOfSize:MLwordFont_9];
    
    goodStyle = [[UILabel alloc]initWithFrame:CGRectZero];
    goodStyle.backgroundColor = [UIColor clearColor];
    goodStyle.textColor = textBlackColor;
    goodStyle.textAlignment = NSTextAlignmentLeft;
    goodStyle.font = [UIFont systemFontOfSize:MLwordFont_9];
    
    moneyNum = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyNum.backgroundColor = [UIColor clearColor];
    moneyNum.textAlignment = NSTextAlignmentLeft;
    moneyNum.textColor = txtColors(252, 53, 77, 1);
    moneyNum.font = [UIFont systemFontOfSize:MLwordFont_4];
    [self.contentView addSubview:moneyNum];
    
    
    changeNumImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    changeNumImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:changeNumImageView];
    
    _goodNum = [[UILabel alloc]initWithFrame:CGRectZero];
    _goodNum.backgroundColor = [UIColor clearColor];
    _goodNum.tintColor = [UIColor blackColor];
    _goodNum.textAlignment = NSTextAlignmentCenter;
    _goodNum.font = [UIFont systemFontOfSize:MLwordFont_4];
    [self.contentView addSubview:_goodNum];
    
    subtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subtractBtn.tag = 102;
    [subtractBtn addTarget:self action:@selector(addOrSbutractAction:) forControlEvents:UIControlEventTouchUpInside];
    subtractBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:subtractBtn];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.tag = 101;
    [addBtn addTarget:self action:@selector(addOrSbutractAction:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:addBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100*SCscale, kDeviceWidth, 1)];
    line.backgroundColor = txtColors(193, 194, 196, 1);
    [self.contentView addSubview:line];
}

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    carDataModel *model = array[indexpath.row];
    
    NSLog(@"shopImg %@",model.shopimg);
    //选中图片
    _selectImageView.frame = CGRectMake(20*MCscale, 36*SCscale, SCselectImgWidth, SCselectImgWidth);
    //商品图片
    goodImageView.frame = CGRectMake(_selectImageView.right+10, 5,SCgoodImgWidth, SCgoodImgWidth);
    
    [goodImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shopimg]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    goodCount = [model.shuliang integerValue];
    NSString *selectState = [NSString stringWithFormat:@"%@",model.xuangzhongzhuangtai];
    if (_selectBool) {
        if ([selectState isEqualToString:@"0"]) {
            _selectImageView.image = [UIImage imageNamed:@"选择"];
        }
        else
            _selectImageView.image = [UIImage imageNamed:@"选中"];
    }
    else
        _selectImageView.image = [UIImage imageNamed:@"选择"];
    
    //商品名
    NSString *godName = model.shopname;
    CGSize size = [godName boundingRectWithSize:CGSizeMake(SCtitleWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_8],NSFontAttributeName, nil] context:nil].size;
    goodTitle.frame = CGRectMake(goodImageView.right+5, 10, size.width, 20);
    goodTitle.text = model.shopname;
    
    //颜色
    CGFloat conX;
    NSString *yanseStr =[NSString stringWithFormat:@"%@",model.yanse];
    CGSize yanSzie = [yanseStr boundingRectWithSize:CGSizeMake(55*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
    goodColor.frame = CGRectMake(goodImageView.right+5, goodTitle.bottom+2, yanSzie.width, 20);
    if (![model.yanse isEqualToString:@"0"] && ![model.yanse isEqualToString:@""]) {
        goodColor.text = yanseStr;
        [self.contentView addSubview:goodColor];
        conX = yanSzie.width+5;
    }
    else{
        [goodColor removeFromSuperview];
        conX = 0.0;
    }
    //型号
    NSString *xingStr =[NSString stringWithFormat:@"%@",model.xinghao];
    CGSize xinSzie = [xingStr boundingRectWithSize:CGSizeMake(55*MCscale, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
    goodStyle.frame = CGRectMake(goodImageView.right+5+conX, goodTitle.bottom+2, xinSzie.width, 20);
    if (![model.xinghao isEqualToString:@""] && ![model.xinghao isEqualToString:@"0"]) {
        goodStyle.text = xingStr;
        [self.contentView addSubview:goodStyle];
    }
    else
        [goodStyle removeFromSuperview];
    moneyNum.text =[NSString stringWithFormat:@"¥%.2f",[model.jiage floatValue]];
    NSString *goodProperty = [NSString stringWithFormat:@"%@",model.shopshuxing];
    if ([goodProperty isEqualToString:@"5"]) {
        subtractBtn.enabled = NO;
        addBtn.enabled = NO;
        changeNumImageView.image = [UIImage imageNamed:@"框"];
    }
    else{
        subtractBtn.enabled = YES;
        addBtn.enabled = YES;
        changeNumImageView.image = [UIImage imageNamed:@"加减框"];
    }
    _goodNum.text = [NSString stringWithFormat:@"%@",model.shuliang];
    
    dainpState = [NSString stringWithFormat:@"%@",model.dianpuzhuangtai];
    goodCount = model.shuliang.integerValue;
    countMoney =[model.jiage floatValue];
    
    //单价
    moneyNum.frame = CGRectMake(goodImageView.right+5, goodTitle.bottom+25*SCscale, 100*MCscale, 25*MCscale);
    //加减框图片
    changeNumImageView.frame = CGRectMake(kDeviceWidth-110*SCscale, 38*MCscale, 95*SCscale, 30*SCscale);
    //数量
    _goodNum.frame = CGRectMake(changeNumImageView.left+32*SCscale, changeNumImageView.top, 30*SCscale, 30*SCscale);
    //减
    subtractBtn.frame = CGRectMake(changeNumImageView.left, changeNumImageView.top, 30*SCscale, 30*SCscale);
    //加
    addBtn.frame =  CGRectMake(_goodNum.right+2, changeNumImageView.top, 30*SCscale, 30*SCscale) ;
}
-(void)addOrSbutractAction:(UIButton *)btn
{
    if (![dainpState isEqualToString:@"3"]){
        if (btn.tag == 101) {
            //加
            goodCount ++;
            addOrCutBol = 1;
            [self changeAction:_selectBool];
        }
        else{
            //减
            if (goodCount > 1) {
                goodCount--;
                addOrCutBol = 0;
                [self changeAction:_selectBool];
            }
        }
        selOrAdd = 0;
        NSString *gNumber = [NSString stringWithFormat:@"%ld",(long)goodCount];
        _goodNum.text = gNumber;
    }
    else{
        _selectBool = 2;
        [self changeAction:_selectBool];
    }
}
-(void)tap
{
    if (![dainpState isEqualToString:@"3"]) {
        if (_selectBool == 0) {
            _selectImageView.image = [UIImage imageNamed:@"选中"];
            _selectBool = 1;
            addOrCutBol = 2;
            selOrAdd = 1;
        }
        else{
            _selectImageView.image = [UIImage imageNamed:@"选择"];
            _selectBool = 0;
            addOrCutBol = 2;
            selOrAdd = 1;
        }
        countMoney = goodCount*countMoney;
    }
    else{
        _selectBool = 2;
    }
    [self chooseGood:_selectBool];
}
-(void)changeAction:(NSInteger)selBol
{
    if ([self.delegate respondsToSelector:@selector(carViewCell:atIndex:addoOrCut:numCount:cellSelect:)]) {
        [self.delegate carViewCell:self atIndex:self.tag addoOrCut:addOrCutBol numCount:goodCount cellSelect:selBol];
    }
}
-(void)chooseGood:(NSInteger)chbol
{
    if ([self.delegate respondsToSelector:@selector(carViewcell:shooseGood:)]) {
        [self.delegate carViewcell:self shooseGood:_selectBool];
    }
}
-(void)setNumData:(NSInteger)numData
{
    goodCount = numData;
    _goodNum.text  = [NSString stringWithFormat:@"%ld",(long)goodCount];
}
@end
