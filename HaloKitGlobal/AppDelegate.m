//
//  AppDelegate.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/2.
//  Copyright © 2017年 范博. All rights reserved.
//
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GeTuiSdk.h"
#import "BGLanageTool.h"
#import "GeTuiModel.h"
#import "NSObject+YYModel.h"

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
//个推开发者网站中申请App时,注册的AppId,AppKey,AppSecret;
#define kGtAppId     @"92dYu5rT257b7C7gdoapW7"
#define kGtAppkey    @"JDR0SKEqdY6bdoeZ5HpLj3"
#define kGtAppSecret @"bG4FdMfSge69JIgoPdASQ3"

@interface AppDelegate ()<GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate
{
    NSString     *token;//个推注册的token
    NSString     * _latiStr;//纬度
    NSString     * _lonhStr;//经度
    NSString     * _stepCount;//步数
    NSString     * _stepStr;//速度
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GMSServices provideAPIKey:@"AIzaSyCBUuYYlBFF_Ajfn4HpF5cfGLIR-OoVvUw"];
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppkey appSecret:kGtAppSecret delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(data:) name:@"postelector" object:nil];
    [self registerRemoteNotification];
    [BGLanageTool sharedInstance];
    return YES;
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];

    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

-(void)data:(NSNotification *)center
{
    NSString * postStr = [NSString stringWithFormat:@"%@",center.object];
    NSArray * arr = [postStr componentsSeparatedByString:@","];
    NSString * chargeStr = [NSString stringWithFormat:@"%@",arr[1]];
    NSString * chargeValue = [NSString stringWithFormat:@"%@", arr[0]];
    NSLog(@"电量：%d", [chargeValue intValue]);
}



- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return (UIInterfaceOrientationMaskPortrait);
    }
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用
/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    //    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    //    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

//Background Fetch 接口回调处理
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    NSString * zhuangStr = [NSString stringWithFormat:@"%@",[userD objectForKey:@"CONNECT"]];
    NSString *deviStr = [NSString stringWithFormat:@"%@",[userD objectForKey:@"DEVICEDID"]];
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"----msgmsg----:%@", msg);
    
    NSArray * array = [msg componentsSeparatedByString:@","];
    NSLog(@"arrayarrayarray:%@", array);
    NSLog(@"countcountcount:%lu", (unsigned long)array.count);
    GeTuiModel * getModel = [GeTuiModel yy_modelWithJSON:payloadMsg];
    NSLog(@"getModelgetModelgetModel%@:%@",getModel.state, getModel.data );
    NSString *strs = [NSString stringWithFormat:@"%@",getModel.state];
    if ([strs isEqualToString:@"406"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"poststate" object:strs];
    }
    if (array.count == 10) {
        NSString   * elecStr  = [NSString stringWithFormat:@"%@",getModel.data];
        NSLog(@"dianliang:%@", elecStr);
        NSString * fireStr = [NSString stringWithFormat:@"%@",array[6]];
        NSArray * staArr   = [fireStr componentsSeparatedByString:@":"];
        NSString * stateStr = [NSString stringWithFormat:@"%@",staArr[1]];
        NSLog(@"stateStr:%@", stateStr);

        if ([stateStr isEqualToString:@"200"]) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"postelector" object:elecStr];
        }
    }
    if (([getModel.state intValue] == 403)||([getModel.state intValue] == 410)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginstate" object:getModel.state];
        NSLog(@"loginstate:%@", getModel.state);
        NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
        [userD setObject:@"OK" forKey:@"exict"];
    }
    //直接在这边做出判断
    if ([getModel.state intValue]==402) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOffLine" object:nil];
        NSLog(@"AppOffLine:%@", getModel.state);

    }
    
    if (array.count == 17) {
        NSMutableArray * totalArr = [NSMutableArray array];
        _lonhStr = [NSString stringWithFormat:@"%@",array[7]];
        [totalArr addObject:_lonhStr];
        _latiStr = [NSString stringWithFormat:@"%@",array[8]];
        [totalArr addObject:_latiStr];
        NSString *eleStr = [NSString stringWithFormat:@"%@",array[13]];
        eleStr = [eleStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"posttude" object:totalArr];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Hposttude" object:totalArr];
    }
    
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}



#endif




#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    [userD setObject: clientId forKey:@"clientId"];
    [userD synchronize];
    // [4-EXT-1]: 个推SDK已注册，返回clientId
        NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
        NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];
}

+ (void)autoLayoutFillScreen:(UIView *)view{
    for (UIView *firstLevelView in view.subviews) {
        CGFloat x = firstLevelView.frame.origin.x * kScaleW;
        CGFloat y = firstLevelView.frame.origin.y* kScaleW;
        CGFloat w = firstLevelView.frame.size.width* kScaleW;
        CGFloat h = firstLevelView.frame.size.height* kScaleH;
        firstLevelView.frame =  CGRectMake(x,y,w,h);
    }
    

}



#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"HaloKitGlobal"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

