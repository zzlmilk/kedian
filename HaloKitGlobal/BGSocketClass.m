//
//  BGSocketClass.m
//  socketDemo
//
//  Created by 范博 on 2017/5/5.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGSocketClass.h"
#import "JSONKit.h"

@interface BGSocketClass()<NSStreamDelegate>

@end

@implementation BGSocketClass

static BGSocketClass *SocketClass = nil;

+ (BGSocketClass *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (SocketClass == nil) {
            SocketClass = [[self alloc] init];
            [SocketClass initNetworkCommunication];
        }
    });
    return SocketClass;
}

- (void)initNetworkCommunication {
    
    uint portNo = 40738;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"16u7471l09.imwork.net", portNo, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream open];
}

-(void)close
{
    [self.outputStream close];
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                            forMode:NSDefaultRunLoopMode];
    [self.outputStream setDelegate:nil];
    [self.inputStream close];
    [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    [self.inputStream setDelegate:nil];
}

-(void)contectDevice:(NSString *)deviceId{
    NSDictionary * dict = @{@"deviceid":deviceId,@"func":@"00",@"clientid":@"7c04dbab66172d06a6138bc710805b7a"};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

-(void)findDog:(NSString *)deviceId{
    NSDictionary * dict = @{@"deviceid":deviceId,@"func":@"05",@"content":@"1"};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    uint8_t buffer[1024];
    NSInteger len;
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened now");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"has bytes");
            if (theStream == _inputStream) {
                while ([_inputStream hasBytesAvailable]) {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            
                        }
                    }
                }
            } else {
                
                NSLog(@"it is NOT theStream == inputStream");
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        default:
            NSLog(@"Unknown event %lu", (unsigned long)streamEvent);
    }
}




@end
