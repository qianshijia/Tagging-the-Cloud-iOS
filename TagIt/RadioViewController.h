//
//  RadioViewController.h
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioViewController : UIViewController<UIPickerViewDelegate, UIAlertViewDelegate>
{
    UILabel *questionTitle, *processName;
    UIPickerView *picker;
    NSString *sendedValue;
    NSDictionary *pickerViewContent;
    UIAlertView *processingIndicator;
    int defaultRow;
    UIButton *backBtn;
}

@property (nonatomic, retain)IBOutlet UILabel *questionTitle, *processName;
@property (nonatomic, retain)IBOutlet UIPickerView *picker;
@property (nonatomic, retain) UIButton *backBtn;

+ (RadioViewController *)getSingletonInstance;
- (IBAction)startNextQuestion:(id)sender;

@end
