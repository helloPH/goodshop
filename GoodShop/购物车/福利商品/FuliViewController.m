//
//  FuliViewController.m
//  LifeForMM
//
//  Created by MIAO on 2016/12/22.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "FuliViewController.h"
#import "Header.h"
#import "FuliDisplayModel.h"
#import "FuliCollectionViewCell.h"
@interface FuliViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate>
@end

@implementation FuliViewController
{
    UICollectionView *mainCollecView;//商品列表
    NSMutableArray *allDataAry; //所有数据
    UIView *maskView;
    UIImageView *HeaderImageView,*footImageView,*backImageView;;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    __weak typeof (self) weakSelf = self;
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    //    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    allDataAry = [[NSMutableArray alloc]init];
    [self initNavigation];
    [self loadListData];
    [self initCollectionView];
}
-(void)initNavigation
{
    self.navigationItem.title = @"福利来了";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    //    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    //    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    //    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //    leftbutton.tag = 1001;
    //    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    //    self.navigationItem.leftBarButtonItem = leftItem;
}
#pragma mark -- 获取列表数据
-(void)loadListData
{
    MBProgressHUD *md = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    md.mode = MBProgressHUDModeIndeterminate;
    md.delegate = self;
    md.labelText = @"请稍等...";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":_dianpuID}];
        [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbydianpulibao.action" params:pram success:^(id json) {
            [md hide:YES];
            NSLog(@"福利 %@",json);
                [allDataAry removeAllObjects];
            NSDictionary *dc = (NSDictionary *)json;
            NSArray *shoplist = [dc valueForKey:@"list"];
            if (shoplist.count >0) {
                for (NSDictionary *dict in shoplist) {
                    FuliDisplayModel *model = [[FuliDisplayModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [allDataAry addObject:model];
                }
            }
            else
            {
                mainCollecView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"站位图"]];
            }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mainCollecView reloadData];
                });
        } failure:^(NSError *error) {
            [md hide:YES];
            MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            bud.mode = MBProgressHUDModeCustomView;
            bud.labelText = @"网络连接错误";
            [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }];
    });
}
-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout1.headerReferenceSize = CGSizeMake(kDeviceWidth, 150);
//    flowLayout1.footerReferenceSize =CGSizeMake(kDeviceWidth,100);
    mainCollecView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight-80*MCscale ) collectionViewLayout:flowLayout1];
    //左侧
    mainCollecView.delegate = self;
    mainCollecView.dataSource = self;
//    mainCollecView.alwaysBounceVertical = YES;
    mainCollecView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainCollecView];
    [mainCollecView registerClass:[FuliCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    [mainCollecView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
//    [mainCollecView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];

    
    HeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150*MCscale)];
    HeaderImageView.image = [UIImage imageNamed:@"顶部"];
    HeaderImageView.userInteractionEnabled = YES;
//
    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*MCscale,25*MCscale,25*MCscale,25*MCscale)];
    backImageView.image = [UIImage imageNamed:@"返回键"];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTapClick)];
    [backImageView addGestureRecognizer:backTap];
    
    footImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,kDeviceHeight-80*MCscale, kDeviceWidth,80*MCscale)];
    footImageView.image = [UIImage imageNamed:@"fulidibu1"];
    [self.view addSubview:footImageView];
}
#pragma mark --UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return allDataAry.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell1";
    FuliCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //    [cell sizeToFit];
        [cell reloadDataWithIndexpath:indexPath AndArray:allDataAry];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kDeviceWidth/2-6, SCLHeight);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    shopController *shop = [[shopController alloc]init];
    //    if(allDataAry.count >0){
    //        FuliDisplayModel *model = allDataAry[indexPath.row];
    //        shop.shopId = model.dianpuid;
    //        shop.shopName = model.dianpuname;
    //        //        NSString *shopState = [NSString stringWithFormat:@"%@",model.];
    //        //        if ([shopState isEqualToString:@"3"]) {
    //        //            shop.isReset = 1;
    //        //        }
    //        //        else
    //        //            shop.isReset = 0;
    //        //        shop.isHuodong = [NSString stringWithFormat:@"%@",model.isHuodong];
    //        [self.navigationController pushViewController:shop animated:YES];
    //    }
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        //        NSLog(@"mainHeight = %lf",mainHeight);
        [header addSubview:HeaderImageView];
        reusableView = header;
    }
    //    如果底部视图
//    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
//        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footView" forIndexPath:indexPath];
//        //        NSLog(@"mainHeight = %lf",mainHeight);
//        [footer addSubview:footImageView];
//        reusableView = footer;
//    }
    return reusableView;
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%f",velocity.y);
    if (velocity.y < 0.0)
    {
        //向下滑动隐藏导航栏
        backImageView.hidden = NO;
    }else
    {
        //向上滑动显示导航栏
        backImageView.hidden = YES;
    }
}
#pragma mark -- btnAction
-(void)backTapClick
{
   [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
