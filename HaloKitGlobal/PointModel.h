//
//  PointModel.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/3.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointModel : NSObject
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,assign) int direction;
@property(nonatomic,assign) long loc_time;
@property(nonatomic,strong) NSArray *location;
@property(nonatomic,assign) float speed;
@property(nonatomic,copy) NSString *deviceid;


@end
