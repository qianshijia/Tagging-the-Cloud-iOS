//
//  RadioGroup.h
//  TagIt
//
//  Created by Shijia Qian on 26/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomCheckButton.h"

@interface RadioGroup : NSObject
{
    NSMutableArray *children;
    NSString *text;
    id value;
}
@property (readonly)NSString *text;
@property (readonly)id value;

-(void)add:(CustomCheckButton *)cb;
-(void)checkButtonClicked:(id)sender;

@end
