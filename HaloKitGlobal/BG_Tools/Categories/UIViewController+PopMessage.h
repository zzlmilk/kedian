//
//  UIView+Customer.h
//  HrLibraries
//
//  Created by haytor on 10/13/14.
//  Copyright (c) 2014 haytor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController(PopMessage)<MBProgressHUDDelegate>

- (void)popLoading:(NSString *)text;
- (void)popSuccessShow:(NSString *)messge;
- (void)popFailureShow:(NSString *)messge;

- (void)popSuccessShow:(NSString *)messge afterDelay:(NSTimeInterval)time;
- (void)popFailureShow:(NSString *)messge afterDelay:(NSTimeInterval)time;

- (void)popMessageHide;

@end
