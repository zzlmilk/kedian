//
//  UILabel+setLabel.m
//  邻邦合乘
//
//  Created by pp on 15/1/28.
//  Copyright (c) 2015年 poxiao. All rights reserved.
//

#import "UILabel+setLabel.h"

@implementation UILabel (setLabel)


//初始化frame alignment font

+ (UILabel *)labelWithFrame:(CGRect *)frame alignment:(int)num font:(int)fontSize
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:*frame];
    label.backgroundColor = [UIColor clearColor];
    if (num!=0) {
        num = 1;
    }
    label.textAlignment = num;
    
    label.font = [UIFont systemFontOfSize:fontSize];
    
    return label;
    
}


@end
