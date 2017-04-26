//
//  BusinessCooperationViewController.m
//  GoodShop
//
//  Created by MIAO on 2017/3/31.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "BusinessCooperationViewController.h"
#import "ReviewSelectedView.h"
#import "Header.h"
@interface BusinessCooperationViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,ReviewSelectedViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic,strong)BMKLocationService* locService;

@end

@implementation BusinessCooperationViewController
{
    UIView *maskView;
    UIImageView *selectImage,*headImageView;//选中图片,头视图
    UILabel *label;//提示label
    UITextView *contentTextView;//意见
    UITextField *num; //电话号码
    BOOL isChooseNum,isContent;
    UIButton *submit;
    CGRect numFrame;
    ReviewSelectedView *selectedView;
    NSArray *listArray;
    UILabel *neirongLabel;
    NSString *city;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    listArray= @[];
    city = @"";
    isContent = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    isChooseNum = 0;
    
    //启动LocationService
    [self.locService startUserLocationService];
    
    [self initNavigation];
    [self initSubViews];
    [self initMaskView];
    [self getShangwuHezuoData];
}
-(void)initNavigation
{
    self.navigationItem.title = @"业务中心";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
}
#pragma mark 获取商务合作详情
-(void)getShangwuHezuoData
{
    MBProgressHUD *ddHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ddHud.mode = MBProgressHUDModeIndeterminate;
    ddHud.delegate = self;
    ddHud.labelText = @"请稍等...";
    [ddHud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"nameRule.appid":@"4",@"nameRule.category":@"商务合作"}];
    [HTTPTool getWithUrlPath:HTTPGugan AndUrl:@"nameRoleInfo.action" params:pram success:^(id json) {
        NSLog(@"商务合作%@",json);
        [ddHud hide:YES];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[json valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
        if ([[json valueForKey:@"message"] integerValue] == 1) listArray = [json valueForKey:@"namelist"];
    } failure:^(NSError *error) {
        [ddHud hide:YES];
        [self promptMessageWithString:@"网络连接错误1"];
    }];
}
-(void)initSubViews
{
    headImageView = [BaseCostomer imageViewWithFrame:CGRectMake(0, 64, kDeviceWidth , 200*MCscale) backGroundColor:[UIColor clearColor] image:@"yonghutouxiang"];
    [self.view addSubview:headImageView];
    
    UILabel *nameLabel = [BaseCostomer labelWithFrame:CGRectMake(20*MCscale, headImageView.bottom +30*MCscale, 100*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"合作内容"];
    [self.view addSubview:nameLabel];
    
    UIView *hezuoView = [BaseCostomer viewWithFrame:CGRectMake(nameLabel.right, headImageView.bottom +25*MCscale, kDeviceWidth - 140*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
    hezuoView.tag = 10000;
    [self.view addSubview:hezuoView];
    
    UITapGestureRecognizer *selectedTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bangdingNumAction:)];
    [hezuoView addGestureRecognizer:selectedTap];
    
    UIImageView *rightImage = [BaseCostomer imageViewWithFrame:CGRectMake(hezuoView.width - 15*MCscale, 5*MCscale, 15*MCscale, 20*MCscale) backGroundColor:[UIColor clearColor] image:@"下拉键"];
    [hezuoView addSubview:rightImage];
    
    neirongLabel = [BaseCostomer labelWithFrame:CGRectMake(0, 0, hezuoView.width - 20*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:2 numOfLines:1 text:@"请选择"];
    [hezuoView addSubview:neirongLabel];
    
    UIView *line1 = [BaseCostomer viewWithFrame:CGRectMake(20*MCscale, nameLabel.bottom+10*MCscale,kDeviceWidth-40*MCscale , 1) backgroundColor:lineColor];
    [self.view addSubview:line1];
    
    contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, line1.bottom, kDeviceWidth, 120)];
    contentTextView.text= @"     请填写内容描述";
    contentTextView.textColor = txtColors(182, 183, 184, 1);
    contentTextView.delegate = self;
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.font = [UIFont systemFontOfSize:MLwordFont_5];
    contentTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentTextView];
    
    UIView *line2 = [BaseCostomer viewWithFrame:CGRectMake(0, contentTextView.bottom+5,kDeviceWidth , 5) backgroundColor:txtColors(234, 235, 236, 1)];
    line2.size=line1.size;
    line2.left=line1.left;
    [self.view addSubview:line2];
    
    selectImage = [BaseCostomer imageViewWithFrame:CGRectMake(30, line2.bottom+10, 24*MCscale, 24*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@"选中"];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bangdingNumAction:)];
    [selectImage addGestureRecognizer:imageTap];
    [self.view addSubview:selectImage];
    
    label = [BaseCostomer labelWithFrame:CGRectMake(selectImage.right+10, selectImage.top, 180, 20) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@"使用账号绑定手机号联系"];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bangdingNumAction:)];
    [label addGestureRecognizer:labTap];
    [self.view addSubview:label];
    
    num = [BaseCostomer textfieldWithFrame:CGRectMake(0, selectImage.bottom+10, kDeviceWidth, 40) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textColors backGroundColor:txtColors(236, 237, 239, 1) textAlignment:1 keyboardType:UIKeyboardTypeNumberPad borderStyle:0 placeholder:@"请输入有效手机号 以便我们联系您"];
    num.delegate = self;
    numFrame = num.frame;
    
    submit = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth/10.0, selectImage.bottom+44, kDeviceWidth*4/5.0, 48*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:txtColors(249, 54, 73, 1) cornerRadius:5.0 text:@"提交" image:@""];
    [submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    
    NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
    if ([sdf integerForKey:@"isLogin"]==0)
    {
        selectImage.hidden = YES;
        label.hidden = YES;
        
        num.frame =CGRectMake(0, selectImage.center.y, kDeviceWidth, 40);
        numFrame = num.frame;
        [self.view addSubview:num];
        
        CGRect fram = submit.frame;
        fram.origin.y +=40;
        submit.frame = fram;
    }
}
//手势遮罩
-(void)initMaskView
{
    maskView = [BaseCostomer viewWithFrame:self.view.bounds backgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDismiss)];
    [maskView addGestureRecognizer:tap];
    
    selectedView = [[ReviewSelectedView  alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale)];
    selectedView.selectedDelegate = self;
}
-(BMKLocationService *)locService
{
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    return _locService;
}

-(void)bangdingNumAction:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 10000) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self.view addSubview:maskView];
            selectedView.alpha = 0.95;
            [selectedView reloadDataWithViewTag:3];
            selectedView.nameArray = listArray;
            [self.view addSubview:selectedView];
        }];
    }
    else
    {
        if(isChooseNum == 0){
            selectImage.image = [UIImage imageNamed:@"选择"];
            isChooseNum = 1;
            [self.view addSubview:num];
            CGRect fram = submit.frame;
            fram.origin.y +=40;
            submit.frame = fram;
        }
        else{
            selectImage.image = [UIImage imageNamed:@"选中"];
            isChooseNum = 0 ;
            [num removeFromSuperview];
            CGRect fram = submit.frame;
            fram.origin.y -=40;
            submit.frame = fram;
        }
    }
}

-(void)submitAction:(UIButton *)btn
{
    NSString *textViewValue;
    NSString *numString;
    BOOL isMatch = [BaseCostomer panduanPhoneNumberWithString:num.text];
    BOOL isOk = 0;
    BOOL isMesg = 0;
    BOOL isSelected = 0;
    if (![contentTextView.text isEqualToString:@"     请填写内容描述"]) {
        textViewValue = contentTextView.text;
        isMesg = 1;
    }
    else{
        [self promptMessageWithString:@"内容描述不能为空!"];
        isMesg = 0;
    }
    
    if (![neirongLabel.text isEqualToString:@"请选择"])  isSelected = 1;
    else{
        [self promptMessageWithString:@"请选择合作内容!"];
        isSelected = 0;
    }
    
    if ([isLogin integerValue] == 1) {
        if(isChooseNum){
            if (isMatch) {
                numString = num.text;
                isOk = 1;
            }
            else  [self promptMessageWithString:@"手机格式错误!"];
        }
        else{
            numString = user_tel;
            isOk = 1;
        }
    }
    else
    {
        if (isMatch) {
            numString = num.text;
            isOk = 1;
        }
        else  [self promptMessageWithString:@"手机格式错误!"];
    }
    
    if (isOk && isMesg && isSelected) {
        btn.enabled = NO;
        [btn setBackgroundColor:[UIColor grayColor]];
        
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeIndeterminate;
        mbHud.labelText = @"努力提交中....";
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"bc.appid":@"4",@"bc.role":@"用户",@"bc.type":neirongLabel.text,@"bc.city":city,@"bc.tel":numString,@"bc.WeChat":@"0",@"bc.content":contentTextView.text}];
        [HTTPTool getWithUrlPath:HTTPGugan AndUrl:@"saveBusinessInfo.action" params:pram success:^(id json) {
            NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
            if ([message isEqualToString:@"1"]) {
                mbHud.mode = MBProgressHUDModeCustomView;
                mbHud.labelText = @"提交成功";
                mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                contentTextView.text = @"";
                neirongLabel.text = @"请选择";
                num.text = @"";
            }
            else [self promptMessageWithString:@"意见反馈失败!请稍后再试"];
            btn.enabled = YES;
            btn.backgroundColor = txtColors(249, 54, 73, 1);
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
}

#pragma mark 选择合作内容(ReviewSelectedViewDelegate)
-(void)selectedHezuoWithHezuoName:(NSString *)hezuoName AndID:(NSString *)ID
{
    neirongLabel.text = hezuoName;
    NSString *imageUrl = [NSString stringWithFormat:@"%@images/namerule/4/%@.png",HTTPGugan,ID];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    [self maskViewDismiss];
}
//
////实现相关delegate 处理位置信息更新
////处理方向变更信息
#pragma mark BMKLocationDelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.locService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    latitudeStr = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    //    longitudeStr = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    //普通态
    CLLocation *sloccation = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:sloccation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            //获取当前城市
            CLPlacemark *mark = placemarks.firstObject;
            NSDictionary *dict = [mark addressDictionary];
            NSLog(@"%@",dict);
            city = [dict objectForKey:@"City"];
        }
    }];
}
-(void)maskViewDismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];
        selectedView.alpha = 0;
        [selectedView removeFromSuperview];
    }];
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqual:@"     请填写内容描述"]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    isContent = 1;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqual:@""]) {
        textView.text = @"     请填写内容描述";
        textView.textColor = txtColors(182, 183, 184, 1);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [contentTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
#pragma mark UITextfiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == num ){
        NSInteger leng = textField.text.length;
        NSInteger selectLeng = range.length;
        NSInteger replaceLeng = string.length;
        if (leng - selectLeng + replaceLeng > 11) return NO;
        else return YES;
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    isContent = 0;
    return YES;
}
#pragma mark 键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    if (isContent == 0) {
        NSDictionary *userInfo = [notifaction userInfo];
        NSValue *userValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [userValue CGRectValue];
        NSTimeInterval animationDuration = [[[notifaction userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView setAnimationDuration:animationDuration];
        CGRect nframe = num.frame;
        if(nframe.origin.y>keyboardRect.origin.y-40){
            nframe.origin.y = keyboardRect.origin.y-40;
        }
        num.frame = nframe;
        [self.view addSubview:maskView];
    }
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    num.frame = numFrame;
    [maskView removeFromSuperview];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [num resignFirstResponder];
    [contentTextView resignFirstResponder];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end

