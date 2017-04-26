//
//  SeckillViewController.m
//  GoodShop
//
//  Created by MIAO on 2017/1/4.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "SeckillViewController.h"
#import "Header.h"
#import "SeckillCell.h"
#import "CarViewController.h"
#import "SeckillModel.h"
#import "userAddressModel.h"
#import "NewAddresPopView.h"
#import "UserOrderViewController.h"
#import "OrderPromptView.h"
@interface SeckillViewController ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate,MBProgressHUDDelegate,newAddresPopDelegate,OrderPromptViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation SeckillViewController
{
    UITableView *mainTableView;
    UIImageView *headView;
    UIView *fotView;//底部视图
    UILabel *totlMoney;//总钱数
    UILabel *numLabel;//购物车物品数量
    UILabel *youhuiLabel;//优惠价格
    UIImageView *whiteCar,*carEmptyImg,*chooseBtnView;
    NSMutableArray *SeckillArray;
    
    NSMutableArray *btnArray; //c存放所有加入购物车按钮
    CALayer  *anmiatorlayer; //贝塞尔曲线 加入购物车动画
    NSMutableArray *goodAry;
    UIView *maskView;
    NewAddresPopView *newAddressPop;
    OrderPromptView *orderPrompt;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:txtColors(255,255,255, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textBlackColor,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:textBlackColor];
    
    
    
    [self.navigationController.navigationBar setHidden:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notafitionAction) name:@"changeGoodsAnying" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:naviBarTintColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    btnArray = [[NSMutableArray alloc]init];
    goodAry = [[NSMutableArray alloc]init];
    SeckillArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubviews];
    [self getSeckillData];
    [self initMaskView];
    [self initfootView];
    [self relodCarData];
    [self initNavigation];
}
-(void)initNavigation
{
    [self.navigationItem setTitle:@"秒杀一切"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
}

-(void)initSubviews
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64-60*MCscale) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    headView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60*MCscale)];
    headView.backgroundColor = [UIColor greenColor];
    headView.image = [UIImage imageNamed:@"秒杀一切"];
    mainTableView.tableHeaderView = headView;
}
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.alpha = 0;
    
    newAddressPop = [[NewAddresPopView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 120*MCscale, kDeviceWidth*9/10.0,340*MCscale)];
    newAddressPop.alpha = 0;
    newAddressPop.dianpuID = _dianpuID;
    newAddressPop.addresPopdelegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
}
#pragma mark 获取秒杀数据
-(void)getSeckillData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    [mbHud show:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"id":_dianpuID,@"userid":user_id}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbymiaosha.action" params:pram success:^(id json) {
            [mbHud hide:YES];
            NSLog(@"秒杀%@",json);
            if ([[json valueForKey:@"massages"]integerValue] == 1) {
                NSArray *listArray = [json valueForKey:@"shoplist"];
                for (NSDictionary *dict in listArray) {
                    SeckillModel *model = [[SeckillModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [SeckillArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mainTableView reloadData];
                });
            }
            else
            {
                mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"站位图"]];
            }
        } failure:^(NSError *error) {
            [mbHud hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    });
}//初始化底部视图
-(void)initfootView
{
    fotView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    fotView.backgroundColor = txtColors(25, 182, 133, 0.8);
    [self.view addSubview:fotView];
    whiteCar = [[UIImageView alloc]initWithFrame:CGRectMake(30*MCscale, -15, 60*MCscale, 60*MCscale)];
    whiteCar.backgroundColor = [UIColor clearColor];
    whiteCar.image = [UIImage imageNamed:@"购物车-无"];
    whiteCar.tag = 1001;
    whiteCar.userInteractionEnabled = NO;
    [fotView addSubview:whiteCar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whiteCarAction)];
    [whiteCar addGestureRecognizer:tap];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(43*MCscale, 14*MCscale, 16*MCscale, 16*MCscale)];
    numLabel.tag = 1002;
    numLabel.backgroundColor = txtColors(237, 58, 76, 1);
    numLabel.layer.cornerRadius = 8.0;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.text = @"0";
    numLabel.alpha = 0;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:MLwordFont_9];
    numLabel.layer.masksToBounds = YES;
    [whiteCar addSubview:numLabel];
    //购物车无商品
    carEmptyImg = [[UIImageView alloc]initWithFrame:CGRectMake(whiteCar.right, 15, 150*MCscale, 20)];
    carEmptyImg.alpha = 0;
    carEmptyImg.backgroundColor = [UIColor clearColor];
    carEmptyImg.image = [UIImage imageNamed:@"empty"];
    [fotView addSubview:carEmptyImg];
    
    totlMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    totlMoney.backgroundColor = [UIColor clearColor];
    totlMoney.textColor = txtColors(237, 58, 76, 1);
    totlMoney.textAlignment = NSTextAlignmentLeft;
    totlMoney.alpha = 0;
    totlMoney.font = [UIFont systemFontOfSize:MLwordFont_15];
    [fotView addSubview:totlMoney];
    //优惠
    youhuiLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    youhuiLabel.text = @"";
    youhuiLabel.alpha = 0;
    youhuiLabel.textAlignment = NSTextAlignmentLeft;
    youhuiLabel.textColor = textBlackColor;
    youhuiLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [fotView addSubview:youhuiLabel];
    
    chooseBtnView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-120*MCscale, 10, 100*MCscale, 30*MCscale)];
    chooseBtnView.backgroundColor = [UIColor clearColor];
    chooseBtnView.image = [UIImage imageNamed:@"选好了灰色"];
    chooseBtnView.userInteractionEnabled = YES;
    [fotView addSubview:chooseBtnView];
    UITapGestureRecognizer *chosetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAction)];
    [chooseBtnView addGestureRecognizer:chosetap];
    [self carNumData];
}
#pragma mark -- 详情页添加数据/购物车删除数据
-(void)notafitionAction
{
    [self carNumData];
    [self relodCarData];
}
-(void)carNumData
{
    NSMutableDictionary *pramDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shequid":@"8"}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyuseridsid.action" params:pramDic success:^(id json) {
        NSLog(@"sssss%@",json);
        if ([[json valueForKey:@"massage"]integerValue]==1) {//没商品
            [self footViewState:0];
        }
        else{
            [self footViewState:1];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误7"];
    }];
}
-(void)relodCarData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"car.dianpuid":_dianpuID}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"dianpuprice.action" params:pram success:^(id json) {
        NSLog(@"购物车数量%@",json);
        
        numLabel.text =[NSString stringWithFormat:@"%@",[json valueForKey:@"shuliangs"]];
        totlMoney.text = [NSString stringWithFormat:@"¥%.2f",[[json valueForKey:@"totalPrice"] floatValue]];
        CGSize tolSize = [totlMoney.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_15], NSFontAttributeName,nil] context:nil].size;
        totlMoney.frame = CGRectMake(95*MCscale, 10, tolSize.width, 30);
        if ([[json valueForKey:@"jianmoneys"] integerValue]==0) {
            if ([[json valueForKey:@"cha"] integerValue]==0) {
                youhuiLabel.alpha = 0;
            }
            else
                if ([[json valueForKey:@"totalPrice"] floatValue]<=0) {
                    youhuiLabel.alpha = 0;
                }
                else{
                    youhuiLabel.alpha = 1;
                    youhuiLabel.text = [NSString stringWithFormat:@"还差¥%@",[json valueForKey:@"cha"]];
                }
        }
        else{
            youhuiLabel.alpha = 1;
            youhuiLabel.text = [NSString stringWithFormat:@"优惠¥%@",[json valueForKey:@"jianmoneys"]];
        }
        CGSize yhSize = [youhuiLabel.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_7], NSFontAttributeName,nil] context:nil].size;
        youhuiLabel.frame = CGRectMake(totlMoney.right+2, 17, yhSize.width, 20);
        
        NSDictionary *dict = @{@"shuliang":[json valueForKey:@"shuliangs"]};
        NSNotification *changeNumLabelNoti = [NSNotification notificationWithName:@"changeNumLabelNoti" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:changeNumLabelNoti];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeNumLabelNoti" object:nil];
        
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误8"];
    }];
}

-(void)footViewState:(NSInteger)state
{
    if (!state) {
        whiteCar.image = [UIImage imageNamed:@"购物车-无"];
        whiteCar.userInteractionEnabled = NO;
        carEmptyImg.alpha = 1;
        numLabel.alpha = 0;
        totlMoney.alpha = 0;
        youhuiLabel.alpha = 0;
        chooseBtnView.image = [UIImage imageNamed:@"选好了灰色"];
        chooseBtnView.userInteractionEnabled = NO;
    }
    else{
        whiteCar.image = [UIImage imageNamed:@"购物车-有"];
        whiteCar.userInteractionEnabled = YES;
        carEmptyImg.alpha = 0;
        numLabel.alpha = 1;
        totlMoney.alpha = 1;
        youhuiLabel.alpha = 1;
        chooseBtnView.image = [UIImage imageNamed:@"选好了红色"];
        chooseBtnView.userInteractionEnabled = YES;
    }
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SeckillArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SeckillCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SeckillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell reloadDataWithIndexpath:indexPath AndArray:SeckillArray];
    [btnArray addObject:cell.SeckillBtn];
    cell.SeckillBtn.tag = indexPath.row;
    [cell.SeckillBtn addTarget:self action:@selector(AddCarClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*MCscale;
}
-(void)AddCarClick:(UIButton *)btn
{
    if ([isLogin integerValue] == 1) {
        NSLog(@"%ld",(long)btn.tag);
        SeckillModel *model  = SeckillArray[btn.tag];
        NSString *goodId = [NSString stringWithFormat:@"%@",model.shanpinid];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id,@"shangpinid":goodId}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbycarshop.action" params:pram success:^(id json) {
            NSString *massage = [NSString stringWithFormat:@"%@",[json valueForKey:@"massage"]];
            if ([massage isEqualToString:@"3"]){//已存在该商品
                [self promptMessageWithString:@"该特惠商品购物车已存在"];
            }
            else{
                [self addcardAnimation:btn];
            }
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误5"];
        }];
    }
    else
    {
        [self loginVC];
    }
}
-(void)addcardAnimation:(UIButton *)btn
{
    for (UIButton *btns in btnArray) {
        btns.userInteractionEnabled = NO;
    }
    [self addDataInCar:btn.tag];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    [goodAry addObject:str];
    CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
    CGPoint stPoint = rc.origin;
    CGPoint startPoint = CGPointMake(stPoint.x+12, stPoint.y+12);
    CGPoint endpoint = CGPointMake(80, kDeviceHeight-40);
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"购物车圆点"];
    imageView.contentMode=UIViewContentModeScaleToFill;
    imageView.frame=CGRectMake(0, 0, 10, 10);
    imageView.hidden=YES;
    
    anmiatorlayer =[[CALayer alloc]init];
    anmiatorlayer.contents=imageView.layer.contents;
    anmiatorlayer.frame=imageView.frame;
    anmiatorlayer.opacity=1;
    [self.view.layer addSublayer:anmiatorlayer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    //贝塞尔曲线中间点
    float sx=startPoint.x;
    float sy=startPoint.y;
    float ex=endpoint.x;
    float ey=endpoint.y;
    float x=sx+(ex-sx)/3;
    float y=sy+(ey-sy)*0.5-400;
    CGPoint centerPoint=CGPointMake(x,y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration=1;
    animation.delegate=self;
    animation.autoreverses= NO;
    [animation setValue:@"yingmeiji_buy" forKey:@"MyAnimationType_yingmeiji"];
    [anmiatorlayer addAnimation:animation forKey:@"yingmiejibuy"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString* value = [anim valueForKey:@"MyAnimationType_yingmeiji"];
    if ([value isEqualToString:@"yingmeiji_buy"]){
        [anmiatorlayer removeAnimationForKey:@"yingmiejibuy"];
        [anmiatorlayer removeFromSuperlayer];
        anmiatorlayer.hidden=YES;
        for (UIButton *btns in btnArray) {
            btns.userInteractionEnabled = YES;
        }
    }
}
#pragma mark -- 加入购物车数据
-(void)addDataInCar:(NSInteger )index
{
    SeckillModel *model = SeckillArray[index];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shangpinid":model.shanpinid,@"userid":user_id,@"car.dianpuid":_dianpuID}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"saveaddcarone.action" params:pram success:^(id json) {
        NSLog(@"加入购物车%@",json);
        if ([[json valueForKey:@"massages"]integerValue]==0) {
            [self promptMessageWithString:@"添加失败"];
        }
        else if ([[json valueForKey:@"massages"]integerValue]==1) {
            [self relodCarData];
            [self footViewState:1];
        }
        else if ([[json valueForKey:@"massages"]integerValue]==2) {
            [self promptMessageWithString:@"店铺休息中"];
        }
        else if ([[json valueForKey:@"massages"]integerValue]==3) {
            [self promptMessageWithString:@"当前商品库存不足"];
        }
        else {
            [self promptMessageWithString:@"当前数量已达到活动上限"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误6"];
    }];
}

#pragma mark 选好了按钮事件
-(void)chooseAction
{
    if ([isLogin integerValue]==1) {
        MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        Hud.mode = MBProgressHUDModeIndeterminate;
        Hud.delegate = self;
        Hud.labelText = @"请稍等...";
        [Hud show:YES];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.tel":user_id,@"dianpuid":_dianpuID}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyAddress.action" params:pram success:^(id json) {
            [Hud hide:YES];
            NSLog(@"地址%@",json);
            if (![[json valueForKey:@"address"]isEqual:[NSNull null]]) {
                NSArray *ary = [json valueForKey:@"address"];
                userAddressModel * addressModel = [[userAddressModel  alloc]init];
                NSDictionary *addDic = ary[0];
                [addressModel setValuesForKeysWithDictionary:addDic];
                addressModel.qiehuan = [json valueForKey:@"qiehuan"];
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 0;
                    [maskView removeFromSuperview];
                    newAddressPop.alpha = 0;
                    [newAddressPop removeFromSuperview];
                }];
                UserOrderViewController *orderVC = [[UserOrderViewController alloc]init];
                orderVC.dianpuID = _dianpuID;
                orderVC.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                bar.title=@"";
                self.navigationItem.backBarButtonItem=bar;
                [self.navigationController pushViewController:orderVC animated:YES];
            }
            else{
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self .view addSubview:maskView];
                    newAddressPop.alpha = 0.95;
                    [self.view addSubview:newAddressPop];
                }];
            }
        } failure:^(NSError *error) {
            [Hud hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
    else
    {
        [self loginVC];
    }
}
#pragma mark -- NewAddresDelegate
-(void)newAddressView:(NewAddresPopView *)popView Andvalue:(NSInteger)index
{
    if (index == 2) {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"地址添加成功";
        hub.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [hub showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            newAddressPop.alpha = 0;
            [newAddressPop removeFromSuperview];
        }];
        
        UserOrderViewController *orderVC = [[UserOrderViewController alloc]init];
        orderVC.dianpuID = _dianpuID;
        orderVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    else if (index == 3)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self .view addSubview:maskView];
            orderPrompt.alpha = 0.95;
            orderPrompt = [[OrderPromptView alloc]initWithFrame:CGRectMake(kDeviceWidth/25.0, 170*MCscale, kDeviceWidth*9/11.0,155*MCscale)];
            orderPrompt.center =  CGPointMake(kDeviceWidth/2.0,270*MCscale);
            orderPrompt.cancalBtn.hidden = YES;
            orderPrompt.line2.hidden = YES;
            orderPrompt.orderPromptViewDelegate = self;
            [self.view addSubview:orderPrompt];
        }];
    }
    else if (index == 4)
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self .view addSubview:maskView];
            orderPrompt.alpha = 0.95;
            orderPrompt = [[OrderPromptView alloc]initWithFrame:CGRectMake(kDeviceWidth/25.0, 170*MCscale, kDeviceWidth*9/11.0,220*MCscale)];
            orderPrompt.center =  CGPointMake(kDeviceWidth/2.0,270*MCscale);
            //                    orderPrompt.alpha = 0;
            orderPrompt.orderPromptViewDelegate = self;
            [self.view addSubview:orderPrompt];
        }];
    }
}

//点击底部白色购物车 进入购物车
-(void)whiteCarAction
{
    if ([isLogin integerValue]==1) {
        CarViewController *carVC = [[CarViewController alloc]init];
        carVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:carVC animated:YES];
    }
    else
    {
        [self loginVC];
    }
}

-(void)loginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UINavigationBar *bar = navi.navigationBar;
    bar.translucent = YES;
    [bar setBarTintColor:txtColors(25, 182, 132, 1)];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
}
-(void)btnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1.5);
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        newAddressPop.alpha = 0;
        [newAddressPop removeFromSuperview];
    }];
}
#pragma mark OrderPromptViewDelegate
-(void)OrderPromptView:(OrderPromptView *)orderView AndButton:(UIButton *)button
{
    if (button == orderView.sureBtn) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            newAddressPop.alpha = 0;
            orderPrompt.alpha = 0;
            [newAddressPop removeFromSuperview];
            [orderPrompt removeFromSuperview];
        }];
    }
    else
    {
        //2.1  修改购物车中特惠商品选中状态
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"address.tel":user_id}];
        [HTTPTool postWithUrlPath:HTTPHEADER AndUrl:@"updateCarTehui.action" params:pram success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue]==1) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 0;
                    [maskView removeFromSuperview];
                    newAddressPop.alpha = 0;
                    [orderPrompt removeFromSuperview];
                    [newAddressPop removeFromSuperview];
                }];
                NSNotification *newAddressPopSave = [NSNotification notificationWithName:@"newAddressPop" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:newAddressPopSave];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"newAddressPop" object:nil];
            }
        } failure:^(NSError *error) {
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
