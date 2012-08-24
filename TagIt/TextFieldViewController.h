//
//  TextFieldViewController.h
//  TagIt
//
//  Created by Shijia Qian on 5/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionProcessingController.h"
#import "TagitUtil.h"

@interface TextFieldViewController : UIViewController<UITextViewDelegate, QuestionProcessDelegate>
{
    UILabel *questionTitle, *processName;
    UITextView *questionAnswer;
    UIButton *reviewBtn, *backBtn;
    UIAlertView *processingIndicator;
}

@property (nonatomic, retain) IBOutlet UILabel *questionTitle, *processName;
@property (nonatomic, retain) IBOutlet UITextView *questionAnswer;
@property (nonatomic, retain) IBOutlet UIButton *reviewBtn;
@property (nonatomic, retain) UIButton *backBtn;

+ (TextFieldViewController *)getSingletonInstance;
- (IBAction)startNextQuestion:(id)sender;
- (IBAction)review:(id)sender;
- (BOOL)numberValidation:(NSString *)answer;
- (BOOL)dateValidation:(NSString *)date;
- (void)startProcessing;
- (IBAction)backgroundTap;

@end
