//
//  HttpRequest.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/4/25.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFNetworking;
@interface HttpRequest : NSObject

+ (HttpRequest *)sharedInstance;

- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
@end
