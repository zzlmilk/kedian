//
//  AppDelegate.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/2.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//屏幕尺寸模块
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
/** 宽度比 */
#define kScaleW kDeviceWidth/320
#define kScaleH kDeviceHeight/568

@class BGSocketClass;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)NSInteger allowRotation;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong)BGSocketClass *socket;

- (void)saveContext;
+ (void)autoLayoutFillScreen:(UIView *)view;
@end

