//
//  GeTuiModel.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/3.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeTuiModel : NSObject
@property(nonatomic,assign) NSNumber * state;//状态码
@property(nonatomic,copy)   NSString * msg;//返回的数据
@property(nonatomic,copy)   NSString * servercode;//业务码
@property(nonatomic,copy)   NSString * data;//电量
@property(nonatomic,copy)   NSString * deviceid;//设备号
@property(nonatomic,copy)   NSString * language;
@property(nonatomic,copy)   NSString * msgcode;
@end
