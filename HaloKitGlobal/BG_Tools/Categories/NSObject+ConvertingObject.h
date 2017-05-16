//
//  NSObject+ConvertingObject.h
//  Golf
//
//  Created by anzeinfo on 14-1-2.
//  Copyright (c) 2014年 anzeinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ConvertingObject)
- (id)initWithProperties:(NSDictionary*)properties;
- (id)intWithModel:(id)model;
@end
