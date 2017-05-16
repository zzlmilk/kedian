//
//  UIButton+setButton.m
//  邻邦合乘
//
//  Created by pp on 15/2/5.
//  Copyright (c) 2015年 poxiao. All rights reserved.
//

#import "UIButton+setButton.h"

@implementation UIButton (setButton)

+ (UIButton *)buttonWithFrame:(CGRect *)frame bgColor:(UIColor *)color1 textColor:(UIColor *)color2 title:(NSString *)title radios:(BOOL)isRadius;
{
    UIButton *bu = [[UIButton alloc] initWithFrame:*frame];
    
    if (isRadius) {
        bu.layer.cornerRadius = 4;
        bu.layer.masksToBounds = YES;
    }
    
    bu.backgroundColor = color1;
    [bu setTitle:title forState:UIControlStateNormal];
    [bu setTitleColor:color2 forState:UIControlStateNormal];
    
    return bu;
}

@end
