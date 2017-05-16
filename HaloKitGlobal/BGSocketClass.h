//
//  BGSocketClass.h
//  socketDemo
//
//  Created by 范博 on 2017/5/5.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSocketClass : NSObject

@property (strong, nonatomic) NSOutputStream *outputStream;
@property (strong, nonatomic) NSInputStream *inputStream;

+ (BGSocketClass *)sharedInstance;
-(void)close;
-(void)contectDevice:(NSString *)deviceId;
-(void)findDog:(NSString *)deviceId;
@end
