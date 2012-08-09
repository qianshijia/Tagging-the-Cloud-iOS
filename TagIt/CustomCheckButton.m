//
//  CustomCheckButton.m
//  TagIt
//
//  Created by Shijia Qian on 25/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "CustomCheckButton.h"

@implementation CustomCheckButton

@synthesize label,icon,value,delegate;

- (id)initWithFrame:(CGRect)frame
{
    icon = [[ UIImageView alloc ] initWithFrame:
           CGRectMake(10, 0, frame.size.height, frame.size.height)];
    [self setStyle:CheckButtonStyleDefault]; 
    [self addSubview:icon];
    label =[[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width + 32, 0,
                                                          frame.size.width - icon.frame.size.width - 32,
                                                          frame.size.height)];
    label.backgroundColor =[UIColor clearColor];
    label.font =[ UIFont fontWithName : @"Arial" size:20 ];
    label.textColor =[UIColor blackColor];
    label.textAlignment = UITextAlignmentLeft;
    
    [self addSubview:label];
    [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    return self ;
}

- (CheckButtonStyle)style
{
    return style;
}

- (void)setStyle:(CheckButtonStyle)st
{
    style = st;
    
    switch (style) {
        case CheckButtonStyleDefault:
            break;
        case CheckButtonStyleBox:
            checkImg = @"checked.png";
            uncheckImg = @"unchecked.png";
            break;
        case CheckButtonStyleRadio:
            checkImg = @"radio.png";
            uncheckImg = @"unradio.png";
            break;
        default:
            break;
    }
    [self setChecked:checked];
}

- (BOOL)isChecked
{
    return checked;
}

- (void)setChecked:(BOOL)b
{
    if (b != checked)
    {
        checked = b;
    }
    if (checked) 
    {
        [icon setImage :[UIImage imageNamed : checkImg]];
    } 
    else 
    {
        [icon setImage :[UIImage imageNamed : uncheckImg]];
    }
}

- (void)clicked
{
    [self setChecked:!checked];
    if (delegate != nil) 
    {
        SEL sel = NSSelectorFromString(@"checkButtonClicked");
        if ([delegate respondsToSelector:sel])
        {
            [delegate performSelector:sel];
        } 
    }
}

- (void)dealloc
{
    value = nil; 
    delegate = nil;
    [label release];
    [icon release];
    [super dealloc];
}

@end
