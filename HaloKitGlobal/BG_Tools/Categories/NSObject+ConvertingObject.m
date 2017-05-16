//
//  NSObject+ConvertingObject.m
//  Golf
//
//  Created by anzeinfo on 14-1-2.
//  Copyright (c) 2014年 anzeinfo. All rights reserved.
//

#import "NSObject+ConvertingObject.h"
#import <objc/runtime.h>

@implementation NSObject (ConvertingObject)
/**Key-value coding**/
-(id)initWithProperties:(NSDictionary*)properties {
    if(self =[self init]){
        NSMutableDictionary *dic = [properties mutableCopy];
        //遍历排除nil
        for(NSString *keys in [[dic allKeys]mutableCopy]){
            NSObject *obj = [dic objectForKey:keys];
            if([obj isKindOfClass:[NSNull class]]){
                [dic removeObjectForKey:keys];
            }
        }
        
        NSObject *object = [properties objectForKey:@"id"];
        if(object){
            [dic removeObjectForKey:@"id"];
            [dic setObject:object forKey:@"ID"];
        }
        for(NSString *keys in [dic allKeys]){
            NSObject *obj = [dic objectForKey:keys];
            if(!obj){
                obj = [[NSObject alloc]init];
                [dic setValue:obj forKey:keys];
            }
        }
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


- (id)intWithModel:(id)model
{
    unsigned int outCount, i;

    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    
    NSMutableArray *array =[NSMutableArray array];
    for(i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
        [array addObject:[NSString stringWithFormat:@"%s",property_getName(property)]];
    }
   NSMutableDictionary *dic =  [[model dictionaryWithValuesForKeys:array] mutableCopy];
    //遍历排除nil
    for(NSString *keys in [[dic allKeys]mutableCopy]){
        NSObject *obj = [dic objectForKey:keys];
        if([obj isKindOfClass:[NSNull class]]){
            [dic removeObjectForKey:keys];
        }
    }
    return dic;
}


@end
