//
//  MapLocationViewController.m
//  GoodShop
//
//  Created by MIAO on 2017/4/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "MapLocationViewController.h"
#import "Header.h"
@interface MapLocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic,strong)BMKMapView* mapView;
@property (nonatomic,strong)BMKLocationService* locService;
@property (nonatomic,assign)CLLocationCoordinate2D coor;
@property (nonatomic,strong)BMKPointAnnotation *annotation;
@property (nonatomic,assign)BMKCoordinateRegion region ;//表示范围的结构体
@property(nonatomic,strong)UIButton *leftButton,*saveBtn;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)NSString *latitude,*longitude,*city;

@end

@implementation MapLocationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
}
-(NSString *)longitude
{
    if (!_longitude) {
        _longitude = @"";
    }
    return _longitude;
}
-(NSString *)latitude
{
    if (!_latitude) {
        _latitude = @"";
    }
    return _latitude;
}
-(NSString *)city
{
    if (!_city) {
        _city = @"";
    }
    return _city;
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(10*MCscale, 10*MCscale, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth - 90*MCscale, 10*MCscale, 80*MCscale, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"保存定位" image:@""];
        [_saveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [BaseCostomer viewWithFrame:CGRectMake(0, kDeviceHeight -45*MCscale, kDeviceWidth, 45*MCscale) backgroundColor:txtColors(47, 192, 149,1)];
        _bottomView.alpha = 0.9;
        [_bottomView addSubview:self.leftButton];
        [_bottomView addSubview:self.saveBtn];
    }
    return _bottomView;
}
-(void)initNavigation
{
    self.navigationItem.title = @"附近店铺";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
}
#pragma mark 地图定位
-(BMKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight)];
        //_mapView.rotateEnabled = NO;//禁用旋转手势
        _region.span.latitudeDelta = 0.01;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
        _region.span.longitudeDelta = 0.005;//纬度范围
        [_mapView setRegion:_region animated:YES];
        
        //添加一个PointAnnotation
        _annotation = [[BMKPointAnnotation alloc]init];
        //        _annotation.title = @"北京欢迎你";
        [_mapView addAnnotation:_annotation];
        [_mapView addSubview:self.bottomView];

        UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapTapClick:)];
        [_mapView addGestureRecognizer:mapTap];
    }
    return _mapView;
}

-(void)mapTapClick:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    CLLocation *sloccation = [[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:sloccation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            //获取当前城市
            CLPlacemark *mark = placemarks.firstObject;
            NSDictionary *dict = [mark addressDictionary];
            NSLog(@"%@",dict);
            self.city = [dict objectForKey:@"City"];
        }
    }];
    
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    _coor.longitude = touchMapCoordinate.longitude;
    _coor.latitude = touchMapCoordinate.latitude;
    _annotation.coordinate = _coor;
   self.longitude = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
}
//
////实现相关delegate 处理位置信息更新
////处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    //普通态
    [self.mapView updateLocationData:userLocation];//更新位置 前提是MapView.showsUserLocation=YES;
    self.mapView.centerCoordinate = userLocation.location.coordinate;//移动到中心点
    //以下_mapView为BMKMapView对象
    _coor.longitude = userLocation.location.coordinate.longitude;
    _coor.latitude = userLocation.location.coordinate.latitude;
    _annotation.coordinate = _coor;
    _region.center = userLocation.location.coordinate;//中心点
    
    CLLocation *sloccation = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:sloccation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            //获取当前城市
            CLPlacemark *mark = placemarks.firstObject;
            NSDictionary *dict = [mark addressDictionary];
            NSLog(@"%@",dict);
            self.city = [dict objectForKey:@"City"];
        }
    }];
}

#pragma mark BMKAnnotationViewDelegate
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotation.pinColor = BMKPinAnnotationColorPurple;
        newAnnotation.animatesDrop = YES;//设置该标注点动画显示
        return newAnnotation;
    }
    return nil;
}
-(void)btnAction:(UIButton *)button
{
    if (button == _leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSDictionary *dict = @{@"longitude":self.longitude,@"latitude":self.latitude,@"city":self.city};
        if ([self.mapDelegate respondsToSelector:@selector(selectedLocationWithWict:)]) {
            [self.mapDelegate selectedLocationWithWict:dict];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
}
-(void)viewDidAppear:(BOOL)animated
{
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
