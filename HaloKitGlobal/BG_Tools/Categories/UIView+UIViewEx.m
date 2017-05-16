//
//  UIView+UIViewEx.m
//  TuTu
//
//  Created by zhang xiangying on 13-9-13.
//  Copyright (c) 2013年 ChenHongbin. All rights reserved.
//

#import "UIView+UIViewEx.h"

@implementation UIView (UIViewEx)




-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x{
    CGRect r = self.frame;
    [self setFrame:CGRectMake(x, r.origin.y, r.size.width, r.size.height)];
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)y{
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, y, r.size.width, r.size.height)];
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width{
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, r.origin.y, width, r.size.height)];
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height{
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, r.origin.y, r.size.width, height)];
}

-(CGFloat)top{
    return self.frame.origin.y;
}

-(void)setTop:(CGFloat)top{
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, top, r.size.width, r.size.height)];
}

-(CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setBottom:(CGFloat)bottom{
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, bottom-r.size.height, r.size.width, r.size.height)];
}

-(CGFloat)left{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect r = self.frame;
    [self setFrame:CGRectMake(left,r.origin.y, r.size.width, r.size.height)];
}

-(CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setRight:(CGFloat)right
{
    CGRect r = self.frame;
    [self setFrame:CGRectMake(right-r.size.width,r.origin.y, r.size.width, r.size.height)];
}


-(void)removeAllSubviews{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
}



@end
