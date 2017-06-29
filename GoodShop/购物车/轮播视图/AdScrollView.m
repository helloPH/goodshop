//
//  AdScrollView.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import "AdScrollView.h"
#import "Header.h"
#define UISCREENWIDTH  self.bounds.size.width//广告的宽度
#define UISCREENHEIGHT  self.bounds.size.height//广告的高度

#define HIGHT self.bounds.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标

static NSInteger currentImage = 1;//记录中间图片的下标,开始总是为1

@interface AdScrollView ()

{
    //广告的label
    UILabel * _adLabel;
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    //循环滚动的周期时间
//    NSTimer * _moveTime;
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    
    NSInteger aryStyle;
    //为每一个图片添加一个广告语(可选)
//    UILabel * _leftAdLabel;
//    UILabel * _centerAdLabel;
//    UILabel * _rightAdLabel;
}
@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;

@property (nonatomic,assign)NSInteger timeInteger;

@property (nonatomic,strong)NSTimer * moveTime;

@property (nonatomic,assign)NSInteger timeCount;
@end
@implementation AdScrollView
#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _timeCount=2;
        _timeInteger = 3;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
        self.delegate = self;
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_leftImageView];
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_centerImageView];
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_rightImageView];

    }
    return self;
}
#pragma mark - 设置广告所使用的图片(名字)
- (void)setImageNameArray:(NSArray *)imageNameArray
{
    if (imageNameArray.count > 0 ) {
        aryStyle = 0;
        _imageNameArray = @[];
        _imageNameArray = imageNameArray;
        
    }
    else{
        aryStyle = 1;
        NSLog(@"-- ---%ld",(long)aryStyle);
        NSArray *arry =@[@"shoucilunbo",@"shoucilunbo",@"shoucilunbo",@"shoucilunbo"];
        _imageNameArray = @[];
        _imageNameArray = arry;

    }

    [self reshView];
  
    _moveTime = [NSTimer scheduledTimerWithTimeInterval:_timeInteger target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self animalMoveImage];
//    }];
    


}
//#pragma mark - 设置每个对应广告对应的广告语
//- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
//{
//    _adTitleArray = adTitleArray;
//    
//    if(adTitleStyle == AdTitleShowStyleNone)
//    {
//        return;
//    }
////    _leftAdLabel = [[UILabel alloc]init];
////    _centerAdLabel = [[UILabel alloc]init];
////    _rightAdLabel = [[UILabel alloc]init];
//    
//    
////    _leftAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
////    [_leftImageView addSubview:_leftAdLabel];
////    _centerAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
////    [_centerImageView addSubview:_centerAdLabel];
////    _rightAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
////    [_rightImageView addSubview:_rightAdLabel];
//    
//    if (adTitleStyle == AdTitleShowStyleLeft) {
//        _leftAdLabel.textAlignment = NSTextAlignmentLeft;
//        _centerAdLabel.textAlignment = NSTextAlignmentLeft;
//        _rightAdLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    else if (adTitleStyle == AdTitleShowStyleCenter)
//    {
//        _leftAdLabel.textAlignment = NSTextAlignmentCenter;
//        _centerAdLabel.textAlignment = NSTextAlignmentCenter;
//        _rightAdLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    else
//    {
//        _leftAdLabel.textAlignment = NSTextAlignmentRight;
//        _centerAdLabel.textAlignment = NSTextAlignmentRight;
//        _rightAdLabel.textAlignment = NSTextAlignmentRight;
//    }
//    
//    
//    _leftAdLabel.text = _adTitleArray[0];
//    _centerAdLabel.text = _adTitleArray[1];
//    _rightAdLabel.text = _adTitleArray[2];
//    
//}
#pragma mark - 创建pageControl,指定其显示样式
//- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
//{
//    if (PageControlShowStyle == UIPageControlShowStyleNone) {
//        return;
//    }
////    _pageControl = [[UIPageControl alloc]init];
////    _pageControl.numberOfPages = _imageNameArray.count;
//    
//    if (PageControlShowStyle == UIPageControlShowStyleLeft){
////        _pageControl.frame = CGRectMake(10, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
//    }
//    else if (PageControlShowStyle == UIPageControlShowStyleCenter){
////        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
////        _pageControl.center = CGPointMake(UISCREENWIDTH/2.0, HIGHT+UISCREENHEIGHT - 10);
//    }
//    else{
////        _pageControl.frame = CGRectMake( UISCREENWIDTH - 20*_pageControl.numberOfPages, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
//    }
//    _pageControl.currentPage = 0;
//    _pageControl.enabled = NO;
//    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
//}
//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
//- (void)addPageControl
//{
//    [[self superview] addSubview:_pageControl];
//}
#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    if (self.contentOffset.x==UISCREENWIDTH * 2) {
        return;
    }
    [UIView animateWithDuration:1 animations:^{
        self.contentOffset=CGPointMake(UISCREENWIDTH * 2, 0);
    }completion:^(BOOL finished) {
        if (finished) {
            currentImage++;
            [self reshView];
        }
    }];
    
    
}


#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_moveTime invalidate];
    _moveTime = nil;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.contentOffset.x == 0){
        currentImage = currentImage-1;
    }
    else if(self.contentOffset.x == UISCREENWIDTH * 2){
        currentImage = currentImage+1;
    }
    else{
    }
    [self reshView];
    if (!_moveTime) {
        _moveTime = [NSTimer scheduledTimerWithTimeInterval:_timeInteger target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    }

}
-(void)reshView{
    currentImage = currentImage%_imageNameArray.count;
    currentImage = currentImage<0?_imageNameArray.count-1:currentImage;
   
    NSInteger before = currentImage-1;
    before = before<0?_imageNameArray.count-1:before;
    
    NSInteger after  = currentImage + 1;
    after= after>_imageNameArray.count-1?0:after;
    
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
    
    
    
    if (aryStyle == 0) {
        [_leftImageView sd_setImageWithURL:_imageNameArray[before] placeholderImage:[UIImage imageNamed:@"shoucilunbo"] options:SDWebImageRefreshCached];
        [_centerImageView sd_setImageWithURL:_imageNameArray[currentImage]  placeholderImage:[UIImage imageNamed:@"shoucilunbo"] options:SDWebImageRefreshCached];
        [_rightImageView sd_setImageWithURL:_imageNameArray[after] placeholderImage:[UIImage imageNamed:@"shoucilunbo"] options:SDWebImageRefreshCached];
    }
    else{
        _leftImageView.image =[UIImage imageNamed: _imageNameArray[before]];
        _centerImageView.image = [UIImage imageNamed: _imageNameArray[currentImage] ];
        _rightImageView.image = [UIImage imageNamed: _imageNameArray[after]];
    }
}
@end
