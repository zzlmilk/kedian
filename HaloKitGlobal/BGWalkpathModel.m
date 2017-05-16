//
//  BGWalkpathModel.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGWalkpathModel.h"

@implementation BGWalkpathModel
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"Id" : @"id"
             };
}

@end
