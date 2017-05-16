//
//  BGWalkStatusModel.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "walkPathDataModel.h"

@interface BGWalkStatusModel : NSObject
@property(nonatomic,copy)   NSString * status;
@property(nonatomic,copy)   walkPathDataModel * data;
@end
