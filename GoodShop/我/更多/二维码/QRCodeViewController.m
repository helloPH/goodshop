//
//  QRCodeViewController.m
//  GoodShop
//
//  Created by MIAO on 2017/4/1.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "QRCodeViewController.h"
#import "Header.h"
@interface QRCodeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>

@property(nonatomic,strong)UIImageView *QRCodeImage;
@property(nonatomic,strong)UILabel *titleLabel1,*dianpuNameLabel,*contentLabel,*titleLabel2,*titleLabel3;
@property(nonatomic,strong)UIButton *shareBtn,*saveBtn;
@property(nonatomic,strong)UIImagePickerController *imagePick;

@end

@implementation QRCodeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.viewTag == 1) {
        [self.view addSubview:self.titleLabel2];
    }
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.titleLabel3];
    [self getDianpuQRCodeData];
}

-(UIImageView *)QRCodeImage
{
    if (!_QRCodeImage) {
        _QRCodeImage = [BaseCostomer imageViewWithFrame:CGRectMake(kDeviceWidth/2.0-75*MCscale, 64+20*MCscale, 150*MCscale, 150*MCscale) backGroundColor:[UIColor clearColor] image:@"yonghutouxiang"];
        [self.view addSubview:_QRCodeImage];
        _QRCodeImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upImageTapClick:)];
        [_QRCodeImage addGestureRecognizer:backTap];
    }
    return _QRCodeImage;
}

-(UILabel *)titleLabel1
{
    if (!_titleLabel1) {
        _titleLabel1 = [BaseCostomer labelWithFrame:CGRectMake(10*MCscale, self.QRCodeImage.bottom, kDeviceWidth - 20*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(186, 186, 186, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"店铺独享二维码"];
        [self.view addSubview:_titleLabel1];
    }
    return _titleLabel1;
}
-(UILabel *)dianpuNameLabel
{
    if (!_dianpuNameLabel) {
        _dianpuNameLabel = [BaseCostomer labelWithFrame:CGRectMake(10*MCscale, self.titleLabel1.bottom+10*MCscale, kDeviceWidth - 20*MCscale, 30*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.view addSubview:_dianpuNameLabel];
    }
    return _dianpuNameLabel;
}

-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:0 text:@""];
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}
-(UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [BaseCostomer buttonWithFrame:CGRectMake(20*MCscale, kDeviceHeight - 150*MCscale, (kDeviceWidth-60*MCscale)/2.0, 40) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:5.0 text:@"分享名片" image:@""];
        [self.view addSubview:_shareBtn];
        [_shareBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
-(UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [BaseCostomer buttonWithFrame:CGRectMake(self.shareBtn.right+20*MCscale, self.shareBtn.top, (kDeviceWidth-60*MCscale)/2.0, 40) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:5.0 text:@"存到本地" image:@""];
        [_saveBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
-(UILabel *)titleLabel2
{
    if (!_titleLabel2) {
        _titleLabel2 = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:0 text:@""];
        _titleLabel2.userInteractionEnabled = YES;
        NSString *titleStr = @"上传店铺logo后,店铺独享二维码可以生成带有店铺logo的二维码";
        CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(kDeviceWidth - 60*MCscale,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
        _titleLabel2.frame = CGRectMake(30*MCscale, self.saveBtn.bottom+10*MCscale, titleSize.width, titleSize.height);
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [str addAttribute:NSForegroundColorAttributeName value:txtColors(0, 144, 148, 1) range:NSMakeRange(0,8)];
       	[str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:MLwordFont_6] range:NSMakeRange(0, 8)];
        
       	_titleLabel2.attributedText = str;
        UITapGestureRecognizer *upImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upImageTapClick:)];
        [_titleLabel2 addGestureRecognizer:upImageTap];
    }
    return _titleLabel2;
}

-(UILabel *)titleLabel3
{
    if (!_titleLabel3) {
        _titleLabel3 = [BaseCostomer labelWithFrame:CGRectMake(30*MCscale, kDeviceHeight - 50*MCscale, kDeviceWidth - 60*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(186, 186, 186, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"点击二维码返回首页"];
    }
    return _titleLabel3;
}

-(void)getDianpuQRCodeData
{
    MBProgressHUD *mbHuD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHuD.mode = MBProgressHUDModeIndeterminate;
    mbHuD.delegate = self;
    mbHuD.labelText = @"请稍后...";
    [mbHuD  show:YES];
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":user_dianpuId}];
    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyxianshi.action" params:pram success:^(id json) {
        [mbHuD hide:YES];
        NSLog(@"店铺名片%@",json);
        [self.QRCodeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[json valueForKey:@"erweima"]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
        self.dianpuNameLabel.text = [json valueForKey:@"dianpuname"];
        
        NSString *titleStr = [json valueForKey:@"neirong"];
        CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(kDeviceWidth - 60*MCscale,100) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_4],NSFontAttributeName, nil] context:nil].size;
        self.contentLabel.frame = CGRectMake(30*MCscale, self.dianpuNameLabel.bottom+10*MCscale, titleSize.width, titleSize.height);
        self.contentLabel.text = [NSString stringWithFormat:@"    %@",titleStr];
    
    } failure:^(NSError *error) {
        [mbHuD hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
//选择头像

-(UIImagePickerController *)imagePick
{
    if (_imagePick == nil) {
        _imagePick = [[UIImagePickerController alloc]init];
        _imagePick.delegate = self;
        _imagePick.allowsEditing = YES;
        _imagePick.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return _imagePick;
}
-(void)buttonClick:(UIButton *)button
{
    if (button == self.shareBtn) {
        
    }
    else
    {
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView *imaView = [[UIImageView alloc] initWithImage:image];
        imaView.frame = CGRectMake(0, 700, 500, 500);
        [self.view addSubview:imaView];
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeCustomView;
        mbHud.labelText = @"图片保存成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
-(void)upImageTapClick:(UITapGestureRecognizer *)tap
{
    if (tap.view == self.QRCodeImage) {
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isFirst"];
        CustomTabBarViewController *main = (CustomTabBarViewController *)self.tabBarController;
        [main setSelectedIndex:0];
        main.buttonIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSNotification *qiehuandianpuNoti = [NSNotification notificationWithName:@"qiehuandianpuNoti" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:qiehuandianpuNoti];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuandianpuNoti" object:nil];
    }
    else
    {
        UIAlertController  *alte = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:0];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePick animated:YES completion:nil];
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePick animated:YES completion:nil];
        }];
        UIAlertAction *cleAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alte addAction:cancleAction];
        [alte addAction:otherAction];
        [alte addAction:cleAction];
        [self presentViewController:alte animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.QRCodeImage.image = image;
    }];
    //    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":user_id}];
    //    [HTTPTool postWithUrl:@"fileUp.action" params:pram image:image success:^(id json) {
    //        if ([[json valueForKey:@"massage"]integerValue]==1) {
    //            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //            mbHud.mode = MBProgressHUDModeCustomView;
    //            mbHud.labelText = @"头像更换成功";
    //            mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    //            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    //        }
    //    } failure:^(NSError *error) {
    //    }];
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
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
