//
//  UIButton+setButton.h
//  邻邦合乘
//
//  Created by pp on 15/2/5.
//  Copyright (c) 2015年 poxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (setButton)

+ (UIButton *)buttonWithFrame:(CGRect *)frame bgColor:(UIColor *)color1 textColor:(UIColor *)color2 title:(NSString *)title radios:(BOOL)isRadius;

@end
