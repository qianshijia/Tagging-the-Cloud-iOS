//
//  UINavigationBar+CustomBackground.m
//  TagIt
//
//  Created by Shijia Qian on 7/04/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "UINavigationBar+CustomBackground.h"

@implementation UINavigationBar (CustomBackground)

- (void)drawRectCustomBackground:(CGRect)rect 
{
    if (self.barStyle == UIBarStyleDefault) {
        [[UIColor greenColor] set];
        CGRect fillRect = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
        CGContextFillRect(UIGraphicsGetCurrentContext(), fillRect);
        return;
    }
    
    // Call default implementation
    [self drawRectCustomBackground:rect];
}

- (void)drawRect:(CGRect)rect {
    UIImage *img = [UIImage imageNamed: @"banner.png"];
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
