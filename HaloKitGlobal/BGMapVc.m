//
//  BGMapVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/4/25.
//  Copyright © 2017年 范博. All rights reserved.
//


#import "BGMapVc.h"
#import "Masonry.h"
#import <CoreLocation/CoreLocation.h>
#import "BGLanageTool.h"
#import "UIViewController+PopMessage.h"
#import "NSObject+YYModel.h"
#import "GeTuiModel.h"
#import "JSONKit.h"
#import "BGLanageTool.h"
#import "LinkDeviceVc.h"

@import GoogleMaps;
#define DESDEVICEID @"deviceId"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
@interface BGMapVc ()<NSStreamDelegate,UIAlertViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate,Scan_VCDelegate>
{
    GMSMapView *mapView;
    GMSMarker *dogMarker;//宠物的标记值
    UIImageView *commonView;
    UIImageView *dogView;
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
    GMSCircle *circ;
    UIButton *refreshButton;
    UIButton *fenceButton;
    BOOL flag;
}
@end


@implementation BGMapVc

- (void)viewDidLoad {
    [super viewDidLoad];
    deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];

    NSString * longin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    if (deviceId) {//[longin isEqualToString:@"YES"]
        NSLog(@"--------------------ddd:%@",longin);
        [self skipAcion];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *deviceVc = [storyboard instantiateViewControllerWithIdentifier:@"nav"];
        [self presentViewController:deviceVc animated:YES completion:nil];
        NSLog(@"********************ddd");
    }

    flag = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(data:) name:@"Hposttude" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = BGGetStringWithKeyFromTable(@"Home", @"BGLanguageSetting");
    [self init_mapView];
    [self initRefreshBtn];
    [self initFenceBtn];
    [self findDog];

    [BGLanageTool getPreferredLanguage];
}


- (void)skipAcion {
    [self initNetworkCommunication];
    NSLog(@"deviceIddeviceId2:%@", deviceId);
    if (deviceId) {
        NSString *clientid = [[NSUserDefaults standardUserDefaults]objectForKey:@"clientId"];
        NSDictionary * dict = @{@"deviceid":deviceId ,@"func":@"00",@"clientid":clientid};
        NSString * response = [dict JSONString];
        NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];

    }
    
}



-(void)initRefreshBtn{
    refreshButton = [[UIButton alloc]init];
    [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [self.view addSubview:refreshButton];
    [refreshButton addTarget:self action:@selector(mapRefurbishAct) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(40, 40));
         make.bottom.equalTo(self.view).with.offset(-160);
         make.left.equalTo(self.view).with.offset(10);
    }];
}

-(void)mapRefurbishAct{
    [refreshButton setImage:[UIImage imageNamed:@"refeshLocation"] forState:UIControlStateNormal];
    [self initNetworkCommunication];
    [self requestLocation];
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue =   [NSNumber numberWithFloat: 0.f];;
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 1.5;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [refreshButton.imageView.layer addAnimation:animation forKey:nil];
 
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
        [self popFailureShow:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")  ];//The device is not connected
    }
}


-(void)initFenceBtn{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *desStr = [NSString stringWithFormat:@"%@",[userD objectForKey:DESDEVICEID]];
    
    if (desStr != nil) {
        fenceButton = [[UIButton alloc]init];
        fenceButton.hidden = YES;
        [fenceButton setImage:[UIImage imageNamed:@"电子围栏-取消-拷贝"] forState:UIControlStateNormal];
        [self.view addSubview:fenceButton];
        [fenceButton addTarget:self action:@selector(initFenceBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        [fenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.equalTo(self.view).with.offset(-210);
            make.left.equalTo(self.view).with.offset(10);
        }];
    }else{
        [self popFailureShow:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")];
    }
}

- (void)anamtion:(UIView *)view{
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.5];
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


-(void)initFenceBtnAct:(id)sender{
    if (isCreateFence) {
        circ.map = nil;
        isCreateFence = NO;

    }else{
        isCreateFence = YES;

        NSString *latitudeStr   = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitudeOfFenceCenter"];
        NSString *longtitudeStr   = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitudeOfFenceCenter"];
        CGFloat latitude = latitudeStr.floatValue;
        CGFloat longtitude = longtitudeStr.floatValue;
        double radius = [[NSUserDefaults standardUserDefaults] integerForKey:@"radiusOfFence"];
        NSLog(@"iiiiii%f", latitude);

        if (radius != 0) {
            if (circ != NULL) {
                circ.map = nil;
            }
            //将手势在地图上的位置转换为经纬度
            CLLocationCoordinate2D coor;
            coor.latitude = latitude;
            coor.longitude = longtitude;
            circ = [GMSCircle circleWithPosition:coor
                                          radius:radius];
            circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0.4 alpha:0.3];
            circ.strokeColor = [UIColor blueColor];
            circ.strokeWidth = 1;
            circ.map = mapView;
        }
    }

}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self anamtion:commonView];
    NSString *latitudeStr   = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitudeOfFenceCenter"];
    NSString *longtitudeStr   = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitudeOfFenceCenter"];
    CGFloat latitude = latitudeStr.floatValue;
    CGFloat longtitude = longtitudeStr.floatValue;
    double radius = [[NSUserDefaults standardUserDefaults] integerForKey:@"radiusOfFence"];
    if (radius != 0) {
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
        isCreateFence = YES;
        fenceButton.hidden = NO;
    }else{
        if (circ != NULL) {
            circ.map = nil;
        }
        fenceButton.hidden = YES;
        isCreateFence = NO;

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
    commonView = [[UIImageView alloc] initWithImage:house];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(31.170785, 121.397421);
    dogMarker = [GMSMarker markerWithPosition:position];
    dogMarker.iconView = commonView;
    dogMarker.map = mapView;
    
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







- (void)onClickedLeftbtn{


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

//获取个推返回的数据
-(void)data:(NSNotification *)center
{
    
    NSUserDefaults *usersd = [NSUserDefaults standardUserDefaults];
    dataArray = center.object;
    lonNum = [dataArray[0] doubleValue];
    latNum = [dataArray[1] doubleValue];
    NSString *loLongStr = [NSString stringWithFormat:@"%f",lonNum];
    [usersd setObject:loLongStr forKey:@"lolatitude"];
    NSString *loLatiStr = [NSString stringWithFormat:@"%f",latNum];
    [usersd setObject:loLatiStr forKey:@"lolongtude"];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latNum, lonNum);
    dogMarker.position = position;
    [usersd synchronize];
    
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
                            GeTuiModel * getModel = [GeTuiModel yy_modelWithJSON:output];
                            NSString * stateString = [NSString stringWithFormat:@"%@",getModel.state];
                            NSLog(@"stateStringstateStringstateString:%@", stateString);
                            int fun = [getModel.servercode intValue];
                            NSString *msgStr = [NSString stringWithFormat:@"%@",getModel.msg];
                            if ([stateString intValue] == 200 && fun == 00) {
                                NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
                                [userD setObject:@"TRUE" forKey:@"contect"];
                                [userD setObject:deviceId forKey:@"deviceId"];
                                [self findDog];
                                [UIView animateWithDuration:0.5 animations:^{
                                    refreshButton.imageView.transform = CGAffineTransformMakeRotation(0);
                                    [refreshButton.imageView.layer removeAllAnimations];
                                } completion:^(BOOL finished) {
                                    [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                    
                                }];
                                

                                
                            }
                            if ([stateString intValue] == 404) {
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")message:nil delegate:self cancelButtonTitle:BGGetStringWithKeyFromTable(@"OK", @"BGLanguageSetting") otherButtonTitles:nil, nil];
                                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                                [userD setObject:@"FALSE" forKey:@"contect"];

                                [alert show];
                                
                                [UIView animateWithDuration:0.5 animations:^{
                                    refreshButton.imageView.transform = CGAffineTransformMakeRotation(0);
                                    [refreshButton.imageView.layer removeAllAnimations];
                                } completion:^(BOOL finished) {
                                    [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                    
                                }];
                                
                            }
                            //直接在这边做出判断
                            if ([stateString intValue]==402) {
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting") message:nil delegate:self cancelButtonTitle:BGGetStringWithKeyFromTable(@"OK", @"BGLanguageSetting") otherButtonTitles:nil, nil];
                                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];

                                [userD setObject:@"FALSE" forKey:@"contect"];

                                [alert show];
                                
                                [UIView animateWithDuration:0.5 animations:^{
                                    refreshButton.imageView.transform = CGAffineTransformMakeRotation(0);
                                    [refreshButton.imageView.layer removeAllAnimations];
                                } completion:^(BOOL finished) {
                                    [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                    
                                }];
                            }
                            //直接在这边做出判断
                            if ([stateString intValue]==400) {
                                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                                [userD setObject:@"FALSE" forKey:@"contect"];
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:msgStr message:nil delegate:self cancelButtonTitle:BGGetStringWithKeyFromTable(@"OK", @"BGLanguageSetting") otherButtonTitles:nil, nil];
                                [alert show];
                            }
                            if ([stateString intValue] == 405) {
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:BGGetStringWithKeyFromTable(@"The device is not connected", @"BGLanguageSetting")  message:nil delegate:self cancelButtonTitle:BGGetStringWithKeyFromTable(@"OK", @"BGLanguageSetting") otherButtonTitles:nil, nil];
                                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                                [userD setObject:@"FALSE" forKey:@"contect"];

                                [alert show];
                                [UIView animateWithDuration:0.5 animations:^{
                                    refreshButton.imageView.transform = CGAffineTransformMakeRotation(0);
                                    [refreshButton.imageView.layer removeAllAnimations];
                                } completion:^(BOOL finished) {
                                    [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                    
                                }];
                                
                            }if ([stateString intValue] == 411) {
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:BGGetStringWithKeyFromTable(@"When the registration times out, restart the device", @"BGLanguageSetting") message:nil delegate:self cancelButtonTitle:BGGetStringWithKeyFromTable(@"OK", @"BGLanguageSetting") otherButtonTitles:nil, nil];
                                [alert show];
                                
                            }if ([stateString intValue] == 413) {
                                [UIView animateWithDuration:0.5 animations:^{
                                    refreshButton.imageView.transform = CGAffineTransformMakeRotation(0);
                                    [refreshButton.imageView.layer removeAllAnimations];
                                } completion:^(BOOL finished) {
                                    [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                                    
                                }];
                            }
                            
                            
                            [theStream close];
                            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                            [theStream setDelegate:nil];
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }

            
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
        {
            [UIView animateWithDuration:0.5 animations:^{
                refreshButton.imageView.transform = CGAffineTransformMakeRotation(0);
                [refreshButton.imageView.layer removeAllAnimations];
            } completion:^(BOOL finished) {
                [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                
            }];
        }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
        {
            [UIView animateWithDuration:0.5 animations:^{
                refreshButton.imageView.transform = CGAffineTransformMakeRotation(0);
                [refreshButton.imageView.layer removeAllAnimations];
            } completion:^(BOOL finished) {
                [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                
            }];
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:BGGetStringWithKeyFromTable(@"The connection failed, please reconnect", @"BGLanguageSetting") message:nil delegate:self cancelButtonTitle:BGGetStringWithKeyFromTable(@"OK", @"BGLanguageSetting") otherButtonTitles:nil, nil];
            [alert show];

        }
            break;
        case NSStreamEventEndEncountered:
        {
            [UIView animateWithDuration:0.5 animations:^{
                refreshButton.imageView.transform = CGAffineTransformMakeRotation(0);
                [refreshButton.imageView.layer removeAllAnimations];
            } completion:^(BOOL finished) {
                [refreshButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                
            }];
        }
            break;
        default:
            NSLog(@"Unknown event %lu", (unsigned long)streamEvent);
    }
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Hposttude" object:nil];
}





- (void)refurbishAct:(id)sender {
    [self initNetworkCommunication];
    [self requestLocation];
}

//向服务器请求位置
-(void)requestLocation
{
    NSDictionary * dict = @{@"deviceid":deviceId,@"func":@"03",@"language":@"cn"};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:(Byte *)[data bytes] maxLength:[data length]];
}




@end
