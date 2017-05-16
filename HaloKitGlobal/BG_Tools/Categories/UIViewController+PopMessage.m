//
//  UIView+Customer.m
//  HrLibraries
//
//  Created by haytor on 10/13/14.
//  Copyright (c) 2014 haytor. All rights reserved.
//

#import "UIViewController+PopMessage.h"

@implementation UIViewController(PopMessage)

static MBProgressHUD *hudProgress;

- (void)popLoading:(NSString *)text
{
    [self InstancePopMessage];
    hudProgress.labelText = text;
    [hudProgress show:YES];
}

- (void)popSuccessShow:(NSString *)messge
{
    [self HUDSleepShow:messge afterDelay:1 state:YES];
}

- (void)popFailureShow:(NSString *)messge
{
     [self HUDSleepShow:messge afterDelay:1 state:NO];
}

- (void)popSuccessShow:(NSString *)messge afterDelay:(NSTimeInterval)time
{
     [self HUDSleepShow:messge afterDelay:time state:YES];
}

- (void)popFailureShow:(NSString *)messge afterDelay:(NSTimeInterval)time
{
     [self HUDSleepShow:messge afterDelay:time state:NO];
}

- (void)popMessageHide
{
    if ( hudProgress != nil)
    {
        [hudProgress removeFromSuperview];
        hudProgress = nil;
    }
}


-(void)HUDSleepShow:(NSString *)msg afterDelay:(NSTimeInterval)time state:(BOOL)isSuccess
{
    [self InstancePopMessage];

    NSString *imgName = isSuccess?@"success-white.png":@"error-white.png";
    hudProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    hudProgress.mode =MBProgressHUDModeCustomView;
    hudProgress.delegate = self;
    hudProgress.labelText = msg;
    [hudProgress show:YES];
    [hudProgress hide:true afterDelay:time];
}



-(void)InstancePopMessage
{
    if (hudProgress==nil)
    {
        hudProgress = [[MBProgressHUD alloc] initWithView:self.view];
    }
    [self.view.window addSubview:hudProgress];
}

@end
