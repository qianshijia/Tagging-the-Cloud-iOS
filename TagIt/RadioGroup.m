//
//  RadioGroup.m
//  TagIt
//
//  Created by Shijia Qian on 26/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "RadioGroup.h"

@implementation RadioGroup

@synthesize text;
@synthesize value;

-(id)init
{
    if (self =[super init])
    {
        children = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)add:(CustomCheckButton *) cb
{
    cb.delegate = self;
    if([cb isChecked]) 
    {
        text = cb.label.text;
        value = cb.value;
    }
    
    [children addObject :cb];
}

-( void )checkButtonClicked:(id)sender
{
    CustomCheckButton * cb = (CustomCheckButton *) sender;
    if (![cb isChecked]) 
    {
        for (CustomCheckButton * each in children)
        {
            if ([each isChecked]) 
            {
                [each setChecked:NO];
            }
        }
        [cb setChecked:YES];
        text = cb.label.text;
        value = cb.value ;
    }
}
-( void )dealloc
{
    [text release];
    value = nil;
    [children release];
    [super dealloc];
}

@end
