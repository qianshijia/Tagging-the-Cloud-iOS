//
//  UIView+UIViewExtension.m
//  TagIt
//
//  Created by Shijia Qian on 18/08/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "UIView+UIViewExtension.h"

@implementation UIView (UIViewExtension)
- (void)didAddSubview:(UIView *)subview {
    if (subview.superview.tag == 99)
    {
        NSLog(@"%@", @"Add movie view");
    }
}

- (void)willRemoveSubview:(UIView *)subview {
    if (subview.superview.tag == 99)
    {
        NSLog(@"%@", @"Quit movie view");
    }
}

@end
