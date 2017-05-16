//
//  walkPathDataModel.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/8.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "walkPathDataModel.h"
#import "BGWalkpathModel.h"

@implementation walkPathDataModel
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [BGWalkpathModel class]};
}

@end
