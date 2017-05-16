//
//  BGWalkpathModel.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGWalkpathModel : NSObject
@property(nonatomic,copy)   NSString * Id;
//@property(nonatomic,copy)   NSString * endtime;
//@property(nonatomic,copy)   NSString * duration;
//@property(nonatomic,copy)   NSString *distance;
//@property(nonatomic,copy)   NSString *avgspeed;
//@property(nonatomic,copy)   NSString *begintime;
//@property(nonatomic,copy)   NSString * calories;
@property(nonatomic,copy)   NSString * createdate;
@property(nonatomic,copy)   NSString * deviceid;
@property(nonatomic, assign)  double longitude;
@property(nonatomic, assign)  double latitude;

@end
