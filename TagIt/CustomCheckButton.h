//
//  CustomCheckButton.h
//  TagIt
//
//  Created by Shijia Qian on 25/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

typedef enum {
    CheckButtonStyleDefault = 0,
    CheckButtonStyleBox = 1,
    CheckButtonStyleRadio = 2
} CheckButtonStyle;

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CustomCheckButton : UIControl
{
    UILabel *label;
    UIImageView *icon;
    BOOL checked;
    id value, delegate;
    CheckButtonStyle style;
    NSString *checkImg ,*uncheckImg;
}

@property (retain, nonatomic) id value, delegate;
@property (retain, nonatomic)UILabel *label;
@property (retain, nonatomic)UIImageView *icon;
@property ( assign )CheckButtonStyle style;

-(CheckButtonStyle)style;
-(void)setStyle:(CheckButtonStyle)st;
-(BOOL)isChecked;
-(void)setChecked:(BOOL)b;

@end
