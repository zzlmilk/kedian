//
//  BGTrailVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGTrailVc.h"
#import "HttpRequest.h"
#import "HttpRequest_url.h"
#import "BGCoordinateModel.h"
#import "BGCoordinateModel.h"
#import "UIViewController+PopMessage.h"
#import "walkPathDataModel.h"
#import "YYModel.h"
#import "BGWalkpathModel.h"
#import <GoogleMaps/GoogleMaps.h>
@import GoogleMaps;
@interface BGTrailVc ()<GMSMapViewDelegate, NSStreamDelegate>

@end

@implementation BGTrailVc
{

    GMSMapView *BGmapView;
    GMSMarker *commonMarker;//主人的标记值
    GMSMarker *dogMarker;//宠物的标记值
    UIImageView *commonView;
    NSMutableArray * dataArray;
    CLLocationCoordinate2D testcoor;//转化为百度地图的坐标
    CLLocationCoordinate2D locacoor;//把本地存储的坐标转成百度坐标
    double  lonNum;//经度
    double  latNum;//纬度
    BOOL isCreateFence;
    NSInputStream  * inputStream;
    NSOutputStream * outputStream;
    NSMutableArray *array;
    GMSMarker *infoMarker;
    GMSPanoramaView *panoView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轨迹";
    [self init_mapView];
    array = [NSMutableArray array];
}


- (void)getTrackNetWorking{
    NSLog(@"--------------------------------------------------------------");
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    NSString *deviceId = [userD objectForKey:@"deviceId"];
    [parameters setValue:@"cn" forKey:@"language"];
    NSLog(@"--walkpath_getUrl::%@", [HttpRequest_url walkpath_getUrl:deviceId]);
    [[HttpRequest sharedInstance] GET:[HttpRequest_url walkpath_getUrl:deviceId]  dict:parameters succeed:^(id data) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"---------------data:%@",json);

        walkPathDataModel *pathDataModle = [walkPathDataModel yy_modelWithJSON:json];
        NSLog(@"--------------------------------------------------------------------");

        [pathDataModle.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *listDict = obj;
            NSLog(@"--obj:%@",obj);

            //获取数组中得字典
            BGWalkpathModel *walkpathModel = [BGWalkpathModel yy_modelWithDictionary:listDict];
            BGCoordinateModel *model = [[BGCoordinateModel alloc]init];
            model.latitude = walkpathModel.latitude;
            model.longitude = walkpathModel.longitude;
            model.createdate = walkpathModel.createdate;
            [array addObject:model];
        }];
         
        [self drawTrailFromMap];
        NSLog(@"---------------:%@",array);

    } failure:^(NSError *error) {
        [self popFailureShow:@"请检查网络是否连接"];
        NSLog(@"error:%@",error);
        NSLog(@"*------------------------------------*");

    }];
}

- (void)drawTrailFromMap{
    GMSMutablePath *path = [GMSMutablePath path];

    if (array.count != 0) {
        for (int i = 0; i < array.count; i++) {
            BGCoordinateModel *coordinateModel = array[i];
            [path addCoordinate:CLLocationCoordinate2DMake(coordinateModel.latitude,coordinateModel.longitude)];
            if ( i == array.count - 1) {
                
                UIImage *house = [UIImage imageNamed:@"blue"];
                commonView = [[UIImageView alloc] initWithImage:house];
                BGCoordinateModel *lastAoordinateModel = array.lastObject;
                CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lastAoordinateModel.latitude, lastAoordinateModel.longitude);
                commonMarker = [GMSMarker markerWithPosition:position];
                commonMarker.iconView = commonView;
                commonMarker.map = BGmapView;
                [self anamtion:commonView];

                
            }else{
                GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(coordinateModel.latitude,coordinateModel.longitude)];
                marker.snippet=[NSString stringWithFormat:@"%@",coordinateModel.createdate];
                 UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 11, 18)];
                [btn setImage:[UIImage imageNamed: @"moren"]forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"xuanzhong"]forState:UIControlEventTouchDown];
                marker.iconView = btn;  //[UIImage imageNamed:@"xuanzhong"];
                marker.panoramaView = panoView;
                marker.map = BGmapView;
            }
            NSLog(@"------coordinateModel.longitude:%@", coordinateModel.createdate);
        }
        
    }
    
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
    rectangle.strokeWidth = 2.0f;
    rectangle.strokeColor = [UIColor blueColor];
    rectangle.map = BGmapView;
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




//初始化view

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getTrackNetWorking];
    

}

- (void)mapView:(GMSMapView *)mapView
didTapPOIWithPlaceID:(NSString *)placeID
           name:(NSString *)name
       location:(CLLocationCoordinate2D)location {
    infoMarker = [GMSMarker markerWithPosition:location];
    infoMarker.snippet = placeID;
    infoMarker.title = name;
    infoMarker.opacity = 0;
    CGPoint pos = infoMarker.infoWindowAnchor;
    pos.y = 1;
    infoMarker.infoWindowAnchor = pos;
    infoMarker.map = mapView;
    mapView.selectedMarker = infoMarker;
}



- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [BGmapView clear];
    [array removeAllObjects];
}

//初始化地图的一些东西
-(void)init_mapView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:31.170785 longitude:121.397421 zoom:16];
    BGmapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    BGmapView.accessibilityElementsHidden = NO;
    BGmapView.myLocationEnabled = NO;
    BGmapView.delegate = self;
    self.view = BGmapView;
    BGmapView.settings.compassButton = YES;
    BGmapView.settings.myLocationButton = YES;
    BGmapView.settings.scrollGestures = YES;
    BGmapView.settings.zoomGestures = YES;
    BGmapView.settings.tiltGestures = YES;
    panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];

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

@end
