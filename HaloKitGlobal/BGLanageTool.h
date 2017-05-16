//
//  BGLanageTool.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/2.
//  Copyright © 2017年 范博. All rights reserved.
//

#define BGGetStringWithKeyFromTable(key, tbl) [[BGLanageTool sharedInstance] getStringForKey:key withTable:tbl]

#import <Foundation/Foundation.h>

@interface BGLanageTool : NSObject
+(id)sharedInstance;
//返回table中指定的key的值
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;
//改变当前语言
-(void)changeNowLanguage;
//设置新的语言
-(void)setNewLanguage:(NSString*)language;

+ (NSString*)getPreferredLanguage;

@end
