//
//  BGElectFenceVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGElectFenceVc.h"
#import "Masonry.h"
#import "BGLanageTool.h"
#import "UIViewController+PopMessage.h"
#import "NSObject+YYModel.h"
#import "GeTuiModel.h"
#import "JSONKit.h"
#import "ZTSlider.h"
#import "UIViewController+PopMessage.h"
#import "BGLanageTool.h"

/** 宽度比 */
#define kScaleW [UIScreen mainScreen].bounds.size.width/375
/** 高度比 */
#define kScaleH [UIScreen mainScreen].bounds.size.height/667
//屏幕尺寸模块
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

@import GoogleMaps;
@interface BGElectFenceVc ()<GMSMapViewDelegate, NSStreamDelegate,UIGestureRecognizerDelegate>

@end

@implementation BGElectFenceVc
{
    GMSMapView *mapView;
    GMSMarker *dogMarker;//宠物的标记值
    GMSMarker *centerMarker;
    GMSCircle *circ;
    UIButton *commonView;
    UILabel *centerLabel;
    UIImageView *dogImgView;
    UIImageView *dogView;
    UIView *dogTitleView;

    NSMutableArray * dataArray;
    CLLocationCoordinate2D testcoor;//转化为百度地图的坐标
    CLLocationCoordinate2D locacoor;//把本地存储的坐标转成百度坐标
    double  lonNum;//经度
    double  latNum;//纬度
    CLLocationManager *_loacationManager;
    BOOL isCreateFence;
    NSInputStream  * inputStream;
    NSOutputStream * outputStream;
    NSString *deviceId;
    int radiusOfFence;
    NSString *latitudeOfFenceCenter;
    NSString * longitudeOfFenceCenter;
    NSArray *titleArray;//这里直接创建一个装半径的数组，根据选择的index来取得对应的半径
    UIButton *fenceButton;
    UIButton *OKFenceBtn;
    UIButton *CancelFenceBtn;
    UIButton *initRefreshBtn ;
    BOOL flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    flag = YES;
    self.view.userInteractionEnabled = YES;
    self.title = BGGetStringWithKeyFromTable(@"Electric fence", @"BGLanguageSetting");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(data:) name:@"posttude" object:nil];
    titleArray = [NSArray arrayWithObjects:@"100",@"150",@"200",@"250",@"300",@"350",@"400",@"450",@"500",@"550",@"1000",@"2000", nil];
    radiusOfFence = [[NSString stringWithFormat:@"150"] intValue];
    deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
    NSLog(@"deviceIddeviceIddeviceIddeviceIddeviceIddeviceIddeviceId:%@",deviceId);
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:BGGetStringWithKeyFromTable(@"Close", @"BGLanguageSetting") style:UIBarButtonItemStylePlain target:self action:@selector(electicFenceAct:)];
    self.navigationItem.rightBarButtonItem = myButton;
    
    
    self.operationView = [[UIView alloc]init];
    self.operationView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, 85);

    radiusOfFence = 500;
    [self init_mapView];
    [self initRefreshBtn];
    [self creatOperationView];

    [self OKFenceBtn];
    [self CancelFenceBtn];
}


-(void)initRefreshBtn{
    initRefreshBtn = [[UIButton alloc]init];
    [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [self.view addSubview:initRefreshBtn];
    [initRefreshBtn addTarget:self action:@selector(refurbishAct:) forControlEvents:UIControlEventTouchUpInside];
    [initRefreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.view).with.offset(-200);
        make.left.equalTo(self.view).with.offset(10);
    }];
}


-(void)OKFenceBtn{
    OKFenceBtn = [[UIButton alloc]init];
    OKFenceBtn.hidden = YES;
    [OKFenceBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [self.operationView addSubview:OKFenceBtn];
    [OKFenceBtn addTarget:self action:@selector(OKFenceBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [OKFenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.view).with.offset(-85);
        make.right.equalTo(self.view).with.offset(- kScaleW/2 - 200);
    }];
}


-(void)CancelFenceBtn{
    CancelFenceBtn = [[UIButton alloc]init];
    CancelFenceBtn.hidden = YES;
    [CancelFenceBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.operationView addSubview:CancelFenceBtn];
    [CancelFenceBtn addTarget:self action:@selector(CancelFenceBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [CancelFenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.view).with.offset(-85);
        make.right.equalTo(self.view).with.offset(- kScaleW/2 - 50);
        
    }];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;

    [self initNetworkCommunication];
    [self findDog];
    NSString *latitudeStr   = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitudeOfFenceCenter"];
    NSString *longtitudeStr   = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitudeOfFenceCenter"];
    CGFloat latitude = latitudeStr.floatValue;
    CGFloat longtitude = longtitudeStr.floatValue;
    double radius = [[NSUserDefaults standardUserDefaults] integerForKey:@"radiusOfFence"];
    if ([latitudeStr isEqualToString: @"0.0"] && [longtitudeStr isEqualToString: @"0.0"]) {
        if (circ != NULL) {
            circ.map = nil;
        }
        commonView.hidden = NO;
        centerLabel.hidden = NO;
        dogTitleView.hidden = NO;
    }else{
        if (circ != NULL) {
            circ.map = nil;
        }
        
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(latitude, longtitude);
        circ = [GMSCircle circleWithPosition:coor
                                      radius:radius];
        circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0.4 alpha:0.3];
        circ.strokeColor = [UIColor blueColor];
        circ.strokeWidth = 1;
        circ.map = mapView;
        commonView.hidden = YES;
        centerLabel.hidden = YES;
        dogTitleView.hidden = YES;

        
    }

}

//初始化地图的一些东西
-(void)init_mapView
{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:31.170785 longitude:121.397421 zoom:14];
    mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    mapView.accessibilityElementsHidden = NO;
    mapView.delegate = self;
    mapView.accessibilityElementsHidden = NO;
    self.view = mapView;
    
    UIImage *house = [UIImage imageNamed:@"blue"];
    dogImgView = [[UIImageView alloc] initWithImage:house];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(31.170785, 121.397421);
    dogMarker = [GMSMarker markerWithPosition:position];
    dogMarker.iconView = dogImgView;
    dogMarker.map = mapView;
    
    UIImage *centerImg = [UIImage imageNamed:@"location@1x"];
    commonView = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/2 - 15, kDeviceHeight/2 - 15, 30, 30)];
    [commonView setImage:centerImg forState:UIControlStateNormal];
    commonView.userInteractionEnabled = NO;
   
    [self.view addSubview:commonView];
    
    dogTitleView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2 - 60, kDeviceHeight/2 - 50, 120, 30)];
    dogTitleView.layer.cornerRadius = 10;
    dogTitleView.clipsToBounds = YES;
    dogTitleView.backgroundColor = [[UIColor alloc]initWithRed:0.3 green:0.6 blue:0.3  alpha:1];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"location" ]];
    icon.frame = CGRectMake(10, 5, 20, 20);
    icon.userInteractionEnabled = YES;

    [dogTitleView addSubview:icon];
    
    centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 20)];
    centerLabel.text = BGGetStringWithKeyFromTable(@"Create an electronic fence", @"BGLanguageSetting");//
    centerLabel.userInteractionEnabled = YES;
    centerLabel.textColor = [UIColor whiteColor];
    centerLabel.font = [UIFont systemFontOfSize:12] ;
    centerLabel.textAlignment = NSTextAlignmentCenter;
    [dogTitleView addSubview:centerLabel];

    dogTitleView.userInteractionEnabled = YES;
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    [btn addTarget:self action: @selector(appearView) forControlEvents:UIControlEventTouchUpInside];
    [dogTitleView addSubview:btn];

    [self.view addSubview:dogTitleView];

}

//初始化socket
- (void)initNetworkCommunication {
    
    uint portNo = 40738;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"16u7471l09.imwork.net", portNo, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

-(void)showAlertController {
 //Make sure to close the electronic fence
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""message:BGGetStringWithKeyFromTable(@"Make sure to close the electronic fence", @"BGLanguageSetting")preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *UIAlertActionStyleCancelAction = [UIAlertAction actionWithTitle:@"Cancel"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"UIAlertActionStyleCancel");
    }];

    UIAlertAction *UIAlertActionStyleDefaultAction = [UIAlertAction actionWithTitle:@"Ok"style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self deleteFencing];
    }];
    [alertController addAction:UIAlertActionStyleCancelAction];
    [alertController addAction:UIAlertActionStyleDefaultAction];
    [self presentViewController:alertController animated:YES  completion:nil];
}




- (void)anamtion:(UIView *)view{
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 2.0f;
    opacityAnimation.autoreverses= NO;
    opacityAnimation.repeatCount = MAXFLOAT;
    CABasicAnimation * animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = [NSNumber numberWithDouble:0.5];
    animation2.toValue = [NSNumber numberWithDouble:1];
    animation2.duration= 2.0;
    animation2.autoreverses= NO;
    animation2.repeatCount= FLT_MAX;
    [view.layer addAnimation:animation2 forKey:@"scale"];
    [view.layer addAnimation:opacityAnimation forKey:nil];
    
}


-(void)creatOperationView
{
    [_operationView removeFromSuperview];
    [self.view addSubview:_operationView];
    _operationView.backgroundColor = [UIColor whiteColor];
    //创建前面的title视图
    _tilbl = [[UILabel alloc] init];
    _tilbl.textColor = [UIColor blackColor];
    [self.operationView addSubview:_tilbl];
    _tilbl.text =  BGGetStringWithKeyFromTable(@"Range size", @"BGLanguageSetting");//
    _tilbl.font = [UIFont systemFontOfSize:12*kScaleW];
    [_tilbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.operationView.mas_left).offset(10*kScaleW);
        make.top.mas_equalTo(self.operationView.mas_top).offset(20*kScaleH);
        make.width.mas_equalTo(80*kScaleW);
        make.height.mas_equalTo(30*kScaleH);
    }];
    //创建后面的进度条
    _pointSlider = [[ZTSlider alloc] initWithFrame:CGRectMake(90*kScaleW, 20*kScaleH, kDeviceWidth - 100*kScaleW, 30*kScaleH) titles:@[@"100",@"150",@"200",@"250",@"300",@"350",@"400",@"450",@"500",@"550",@"1000",@"2000"] firstAndLastTitles:@[@"100m",@"2000m"] defaultIndex:1 sliderImage:[UIImage imageNamed:@"slider"]];
    [self.operationView addSubview:_pointSlider];
    //在这里对进度条进行操作(需要使用block回调)
    __weak __typeof__ (self) wself = self;
    _pointSlider.block = ^(int index)
    {
        if (index == 12) {
            index = 11;
        }
        radiusOfFence = [titleArray[index] intValue];
        [wself addOverlayView];
    };
}

//添加圆形地理围栏
- (void)addOverlayView {
    
        if (circ != NULL) {
            circ.map = nil;
        }

    NSLog(@"radiusOfFence:%d", radiusOfFence);
    CGPoint point = CGPointMake(kDeviceWidth/2, kDeviceHeight/2);
    //将手势在地图上的位置转换为经纬度
    CLLocationCoordinate2D coor = [mapView.projection coordinateForPoint: point];
    latitudeOfFenceCenter = [NSString stringWithFormat:@"%f", coor.latitude];
    longitudeOfFenceCenter = [NSString stringWithFormat:@"%f", coor.longitude];
    circ = [GMSCircle circleWithPosition:coor
                                             radius:radiusOfFence];
    circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0.4 alpha:0.3];
    circ.strokeColor = [UIColor blueColor];
    circ.strokeWidth = 1;
    circ.map = mapView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;

    
}

//获取个推返回的数据
-(void)data:(NSNotification *)center
{
    NSUserDefaults *usersd = [NSUserDefaults standardUserDefaults];
    dataArray = center.object;
    lonNum = [dataArray[0] doubleValue];
    latNum = [dataArray[1] doubleValue];
    //经度
    NSString *loLongStr = [NSString stringWithFormat:@"%f",lonNum];
    [usersd setObject:loLongStr forKey:@"lolatitude"];
    //纬度
    NSString *loLatiStr = [NSString stringWithFormat:@"%f",latNum];
    [usersd setObject:loLatiStr forKey:@"lolongtude"];
    [usersd synchronize];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latNum, lonNum);
    dogMarker.position = position;
    
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    uint8_t buffer[1024];
    NSInteger len;
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened now");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"has bytes");
            if (theStream == inputStream) {
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                        }
                        GeTuiModel * getModel = [GeTuiModel yy_modelWithJSON:output];
                        NSString * stateString = [NSString stringWithFormat:@"%@",getModel.state];
                        if ([stateString intValue] == 200&&[getModel.servercode isEqualToString:@"0C"]) {
                            [self popSuccessShow:BGGetStringWithKeyFromTable(@"Create an electronic fence successfully", @"BGLanguageSetting")];//
                            OKFenceBtn.hidden = YES;
                            CancelFenceBtn.hidden = YES;
                            commonView.hidden = YES;
                            centerLabel.hidden = YES;
                            dogTitleView.hidden = YES;

                            [self dismissView];
                            
                            [UIView animateWithDuration:0.5 animations:^{
                                initRefreshBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                                [initRefreshBtn.imageView.layer removeAllAnimations];
                            } completion:^(BOOL finished) {
                                [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                
                            }];
                        }
                        
                        if ([stateString intValue] == 200 && [getModel.servercode isEqualToString:@"0F"]) {
                            [self popSuccessShow:BGGetStringWithKeyFromTable(@"Remove the electronic fence successfully", @"BGLanguageSetting")];
                            //隐藏勾，叉，报警按钮
                            
                            commonView.hidden = NO;
                            dogTitleView.hidden = NO;
                            OKFenceBtn.hidden = YES;
                            centerLabel.hidden = NO;
                            CancelFenceBtn.hidden = YES;
                            [self dismissView];
                            circ.map = nil;
                            
                            [UIView animateWithDuration:0.5 animations:^{
                                initRefreshBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                                [initRefreshBtn.imageView.layer removeAllAnimations];
                            } completion:^(BOOL finished) {
                                [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                
                            }];

                            
                        }
                        
                        if ([stateString intValue] == 200 && [getModel.servercode isEqualToString:@"05"]) {
                            //在这里需要判断网络请求下来的clinted与本地的是否一致
                            [UIView animateWithDuration:0.5 animations:^{
                                initRefreshBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                                [initRefreshBtn.imageView.layer removeAllAnimations];
                            } completion:^(BOOL finished) {
                                [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                
                            }];

                        }
                        
                        if ([stateString intValue] == 409 && [getModel.servercode isEqualToString:@"0C"]) {
                            //在这里需要判断网络请求下来的clinted与本地的是否一致
                            [self popSuccessShow:BGGetStringWithKeyFromTable(@"The electronic fence already exists", @"BGLanguageSetting")];
                            [UIView animateWithDuration:0.5 animations:^{
                                initRefreshBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                                [initRefreshBtn.imageView.layer removeAllAnimations];
                            } completion:^(BOOL finished) {
                                [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                
                            }];

                        }
                        
                        if ([stateString intValue] == 407 && [getModel.servercode isEqualToString:@"0F"]) {
                            //在这里需要判断网络请求下来的clinted与本地的是否一致
                            [self popSuccessShow:BGGetStringWithKeyFromTable(@"No electronic fence has been created", @"BGLanguageSetting")];
                            [[NSUserDefaults standardUserDefaults] setObject:@"0.0" forKey:@"latitudeOfFenceCenter"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"0.0" forKey:@"longitudeOfFenceCenter"];
                            [UIView animateWithDuration:0.5 animations:^{
                                initRefreshBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                                [initRefreshBtn.imageView.layer removeAllAnimations];
                            } completion:^(BOOL finished) {
                                [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                
                            }];


                        }//The device is not connected
                        
                        if ([stateString intValue] == 402) {
                            [self popFailureShow:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")];
                        }
                    }
                }
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
//            [self popFailureShow:@"请重启项圈"];
        {
            [UIView animateWithDuration:0.5 animations:^{
                initRefreshBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                [initRefreshBtn.imageView.layer removeAllAnimations];
            } completion:^(BOOL finished) {
                [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                
            }];

        }

            break;
        case NSStreamEventErrorOccurred://Load failed, please reload
            NSLog(@"Can not connect to the host!");
            [self popFailureShow:BGGetStringWithKeyFromTable(@"Load failed, please reload", @"BGLanguageSetting")];
        {
            [UIView animateWithDuration:0.5 animations:^{
                initRefreshBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                [initRefreshBtn.imageView.layer removeAllAnimations];
            } completion:^(BOOL finished) {
                [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                
            }];
            
        }

            break;
            
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        {
            [UIView animateWithDuration:0.5 animations:^{
                initRefreshBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                [initRefreshBtn.imageView.layer removeAllAnimations];
            } completion:^(BOOL finished) {
                [initRefreshBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                
            }];
            
        }

            break;
        default:
            NSLog(@"Unknown event %lu", (unsigned long)streamEvent);
    }

    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"posttude" object:nil];
}



- (void)electicFenceAct:(id)sender {
    [self showAlertController];
}

- (void)refurbishAct:(id)sender {
    [self initNetworkCommunication];
    [self requestLocation];
        [initRefreshBtn setImage:[UIImage imageNamed:@"refeshLocation"] forState:UIControlStateNormal];
        CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                                        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
                                        animation.fromValue =   [NSNumber numberWithFloat: 0.f];;
                                        animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
                                        animation.duration  = 1.5;
                                        animation.autoreverses = NO;
                                        animation.fillMode =kCAFillModeForwards;
                                        animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
                                        [initRefreshBtn.imageView.layer addAnimation:animation forKey:nil];
    

}

//发送电子围栏
-(void)OKFenceBtnAct:(id)sender{
    [self initNetworkCommunication];
    [self setFencing];
    
}

//取消电子围栏设置
-(void)CancelFenceBtnAct:(id)sender{
    [self dismissView];
    OKFenceBtn.hidden = YES;
    CancelFenceBtn.hidden = YES;

}


//向服务器请求位置
-(void)requestLocation
{
    if (deviceId.length > 8) {

        NSDictionary * dict = @{@"deviceid":deviceId,@"func":@"03",@"language":@"en"};
        NSString * response = [dict JSONString];
        NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:(Byte *)[data bytes] maxLength:[data length]];
    }else{
[self popFailureShow:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")];    }
}

//向服务器请求位置
-(void)findDog
{
    if (deviceId.length > 8) {

        NSDictionary * dict = @{@"deviceid":deviceId,@"func":@"05",@"content":@"1",@"language":@"en"};
        NSString * response = [dict JSONString];
        NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:(Byte *)[data bytes] maxLength:[data length]];
    }else{
[self popFailureShow:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")];
    }
}

-(void)setFencing
{
    //异步请求数据
    if (deviceId.length > 8) {
        int radius  = radiusOfFence;
        
        [[NSUserDefaults standardUserDefaults] setObject:latitudeOfFenceCenter forKey:@"latitudeOfFenceCenter"];
        [[NSUserDefaults standardUserDefaults] setObject:longitudeOfFenceCenter forKey:@"longitudeOfFenceCenter"];
        CGFloat latitude = latitudeOfFenceCenter.floatValue;
        CGFloat longtitude = longitudeOfFenceCenter.floatValue;
        [[NSUserDefaults standardUserDefaults] setInteger:radius forKey:@"radiusOfFence"];
        NSString * fenStr = [NSString stringWithFormat:@"%f,%f,%d",longtitude,latitude,radius];
        NSDictionary * dict = @{@"deviceid":deviceId,@"func":@"0C",@"content":fenStr,@"language":@"cn"};
        NSString * response = [dict JSONString];
        NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:(Byte *)[data bytes] maxLength:[data length]];
    }else{
[self popFailureShow:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")];
    }
}

-(void)deleteFencing
{
    //异步请求数据
    if (deviceId.length > 8) {
    [[NSUserDefaults standardUserDefaults] setObject:@"0.0" forKey:@"latitudeOfFenceCenter"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0.0" forKey:@"longitudeOfFenceCenter"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"radiusOfFence"];
    NSDictionary * dict = @{@"deviceid":deviceId,@"func":@"0F",@"language":@"cn"};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:(Byte *)[data bytes] maxLength:[data length]];
    }else{
[self popFailureShow:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")];
    }
}


-(void)appearView
{

    [UIView animateWithDuration:1.5 animations:^{
        //选择半径的视图出现
        self.operationView.frame = CGRectMake(0, kDeviceHeight - 85, kDeviceWidth, 85);
        commonView.hidden = YES;
        dogTitleView.hidden = YES;
        [self addOverlayView];
        OKFenceBtn.hidden = NO;
        CancelFenceBtn.hidden = NO;

    }];
    
}



- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture;
{
    
    [UIView animateWithDuration:1.5 animations:^{
        //选择半径的视图出现
        dogTitleView.hidden = NO;
        commonView.hidden = NO;
        OKFenceBtn.hidden = YES;
        CancelFenceBtn.hidden = YES;
        centerLabel.hidden = NO;
    }];
    
    [self dismissView];

}

-(void)dismissView
{
    [UIView animateWithDuration:1.5 animations:^{
        self.operationView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, 85);
    }];
}



@end
