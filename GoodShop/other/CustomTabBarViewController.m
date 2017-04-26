//
//  CustomTabBarViewController.m
//  ManageForMM
//
//  Created by MIAO on 16/9/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "CustomTabBarViewController.h"

#pragma mark --  little class
@interface PHTabbarButton()
@property (nonatomic,strong)UIImageView * img;
@property (nonatomic,strong)UILabel     * label;

@end
@implementation PHTabbarButton
-(UIImageView *)img{
    if (!_img) {
        _img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 25, 25)];
        [self addSubview:_img];
    }
    return _img;
}
-(UILabel *)label{
    if (!_label) {
        _label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.img.frame.origin.y+self.img.frame.size.height+2, 20, 20)];
        _label.font=[UIFont systemFontOfSize:12];
        [self addSubview:_label];
        
    }
    return _label;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self upDateData];
    
}
-(void)upDateData{
    
    [_img setImage:self.selected?[self imageForState:UIControlStateSelected]:[self imageForState:UIControlStateNormal]];
    self.img.center=CGPointMake(self.frame.size.width/2, self.img.center.y);
    
    
    
    [self.label setText:self.selected?[self titleForState:UIControlStateSelected]:[self titleForState:UIControlStateNormal]];
    [self.label setTextColor:self.selected?[self titleColorForState:UIControlStateSelected]:[self titleColorForState:UIControlStateNormal]];
    [self.label sizeToFit];
    self.label.center=CGPointMake(self.frame.size.width/2, self.label.center.y);
    
    
    self.imageView.hidden=YES;
    self.titleLabel.hidden=YES;
}
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self upDateData];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self upDateData];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self upDateData];
}

@end





#pragma mark --- main class
#define ItemGap 10*MCscale

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController
{
    NSArray *_imageArr;
    NSArray *_changeImageArr;
    NSArray *_titleArr;
    NSArray *_titlechangeArr;
    NSArray *_classArr;
    UILabel *numLabel;//购物车物品数量
    NSInteger carNum;
    BOOL isCar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    isCar = 0;
    [self createDataSource];
    [self setTabbar];
    
    
    // 给tabbar 一个初始状态
    UIButton * btn = [self.view viewWithTag:99];
    [self buttonClick:btn];
    [btn setImage:[UIImage imageNamed:@"选中购物车"] forState:UIControlStateSelected];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}
-(void)createDataSource
{
    _imageArr = @[@"tabbar_add_icon",@"订单",@"我"];
    _changeImageArr = @[@"购物车",@"订单选中",@"选中我"];
    _titleArr = @[@"店铺",@"订单",@"我"];
    _titlechangeArr = @[@"购物车",@"订单",@"我"];
    _classArr = @[@"CarFirstViewController",@"OrderViewController",@"MeViewController"];
}
-(void)setTabbar
{
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    int i = 0;
    for (NSString *title  in _classArr) {
        i++;
        Class class = NSClassFromString(title);
        UIViewController *controller = [[class alloc]init];
        controller.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
        
        UINavigationBar *bar = navi.navigationBar;
        bar.translucent = YES;
        bar.barTintColor=naviBarTintColor;
        
        bar.tintColor = [UIColor whiteColor];
        [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [controllers addObject:navi];
    }
    //标签栏控制器管理视图
    self.viewControllers = controllers;
    
    UIImageView *tabImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 49*MCscale)];

    tabImageView.backgroundColor=txtColors(241, 244, 244, 1);
    
    tabImageView.tag = 10;
    tabImageView.userInteractionEnabled = YES;
    self.tabBar.frame = CGRectMake(0, kDeviceHeight - 49*MCscale, kDeviceWidth, 49*MCscale);
    [self.tabBar addSubview:tabImageView];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(63*MCscale, 0, 14*MCscale, 14*MCscale)];
    numLabel.tag = 1002;
    numLabel.backgroundColor = txtColors(237, 58, 76, 1);
    numLabel.layer.cornerRadius = 7.0;
    numLabel.layer.masksToBounds = YES;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.text = @"0";
    numLabel.alpha = 0;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    
    CGFloat itemWidth = (kDeviceWidth - (_classArr.count + 1)* ItemGap)/_classArr.count;
    for (int i = 0;i < _classArr.count; i++ ) {
        UIButton *button = [PHTabbarButton buttonWithType:UIButtonTypeCustom];
        
        
        
        button.frame = CGRectMake(ItemGap +(ItemGap+itemWidth)*i, 0, itemWidth, 49*MCscale);
        button.tag = i +99;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self customButton:button];
        [tabImageView addSubview:button];
    }
}

-(void)customButton:(UIButton *)sender
{
    sender.imageEdgeInsets = UIEdgeInsetsMake(3*MCscale, 40*MCscale, 20*MCscale, 25*MCscale);
    
    sender.titleEdgeInsets = UIEdgeInsetsMake(49*MCscale -18*MCscale, -20*MCscale,2*MCscale, 0);
    
    
//    sender.imageEdgeInsets = UIEdgeInsetsMake(3*MCscale, 25*MCscale, 20*MCscale, 25*MCscale);
//    
//    sender.titleEdgeInsets = UIEdgeInsetsMake(49*MCscale -18*MCscale, 25*MCscale,2*MCscale, 25*MCscale);
    
    
    
    
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    sender.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sender setTitleColor:txtColors(100, 100, 100, 1) forState:UIControlStateNormal];
    [sender setTitleColor:txtColors(34, 253, 189, 1) forState:UIControlStateSelected];
    
    [sender setTitleColor:mainColor forState:UIControlStateSelected];
    
    NSInteger index = sender.tag - 99;
    [sender setImage:[UIImage imageNamed:_imageArr[index]] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:_changeImageArr[index]] forState:UIControlStateSelected];
    [sender setTitle:_titleArr[index] forState:UIControlStateNormal];
    [sender setTitle:_titlechangeArr[index] forState:UIControlStateSelected];
    
    
    sender.titleLabel.center=CGPointMake(sender.imageView.center.x, sender.titleLabel.center.y);
    if (index == 0) {
        [sender setImage:[UIImage imageNamed:@"选中购物车"] forState:UIControlStateSelected];
        [sender addSubview:numLabel];
    }
}
-(void)setButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNumLabelNotiClick:) name:@"changeNumLabelNoti" object:nil];
    }
    UIImageView *imageView = (UIImageView *)[self.tabBar viewWithTag:10];
    NSArray *subview = imageView.subviews;
    self.selectedIndex = buttonIndex;
    for (UIButton *button in subview) {
        button.selected = NO;
    }
    UIButton *sender = subview[buttonIndex];
    sender.selected = YES;
}
-(void)buttonClick:(UIButton *)sender
{
    UIImageView *imageView = (UIImageView *)[self.tabBar viewWithTag:10];
    NSArray *subview = imageView.subviews;
    NSInteger index = sender.tag - 99;
    self.selectedIndex = index;
    for (UIButton *button in subview) {
        button.selected = NO;
    }
    sender.selected = YES;
    
    [sender setTitleColor:naviBarTintColor forState:UIControlStateSelected];
    
    

 
    if (index == 0) {
        if ([isLogin integerValue] == 1){
            
            numLabel.alpha = 0;
            [sender setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateSelected];
            [sender setTitleColor:textBlackColor forState:UIControlStateSelected];
            
            if (isCar) {
                NSNotification *carDataNoti = [NSNotification notificationWithName:@"carDataNoti" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:carDataNoti];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"carDataNoti" object:nil];
            }
            
            


            if (carNum  !=0) {
                numLabel.alpha = 1;
                numLabel.text = [NSString stringWithFormat:@"%ld",(long)carNum];
                [sender setImage:[UIImage imageNamed:@"选中购物车"] forState:UIControlStateSelected];
                [sender setTitleColor:naviBarTintColor forState:UIControlStateSelected];
            }
            else
            {
                numLabel.alpha = 0;
                [sender setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateSelected];
                [sender setTitleColor:textBlackColor forState:UIControlStateSelected];
            }

            
            
            

            
        }
        isCar = YES;
    }
    else if (index == 2)
    {
        numLabel.alpha = 0;
        isCar = 0;
    }
    else
    {
        numLabel.alpha = 0;
        if ([isLogin integerValue] != 1) {
            [self setButtonIndex:0];
            [self loginVC];
        }
        isCar = 0;
    }
    
    
    
}
-(void)loginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UINavigationBar *bar = navi.navigationBar;
    bar.translucent = YES;
    [bar setBarTintColor:naviBarTintColor];
    
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //            [self.navigationController pushViewController:loginVc animated:YES];
    [self presentViewController:navi animated:YES completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBar.frame = CGRectMake(0, kDeviceHeight - 49*MCscale, kDeviceWidth, 49*MCscale);
}

-(void)changeNumLabelNotiClick:(NSNotification *)noti
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"]integerValue] == 1) {
        carNum = [noti.userInfo[@"shuliang"] integerValue];
        
        
        UIButton * sender = (UIButton *)(numLabel.superview);
        if ([noti.userInfo[@"shuliang"] integerValue] !=0) {
            numLabel.alpha = 1;
            numLabel.text = [NSString stringWithFormat:@"%@",noti.userInfo[@"shuliang"]];
        [sender setImage:[UIImage imageNamed:@"选中购物车"] forState:UIControlStateSelected];
        [sender setTitleColor:naviBarTintColor forState:UIControlStateSelected];
        }
        else
        {
           numLabel.alpha = 0;
        [sender setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateSelected];
        [sender setTitleColor:textBlackColor forState:UIControlStateSelected];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
