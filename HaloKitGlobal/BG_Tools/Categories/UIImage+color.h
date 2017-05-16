//
//  UIImage+color.h
//  FreeWifi
//
//  Created by Mac on 14-6-23.
//  Copyright (c) 2014年 redTomato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (color)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
@end
