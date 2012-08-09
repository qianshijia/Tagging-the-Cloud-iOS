//
//  CheckBoxViewController.h
//  TagIt
//
//  Created by Shijia Qian on 3/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxViewController : UIViewController <UIAlertViewDelegate>
{
    NSDictionary *sectionContents;
    NSArray *sectionTitles;
    NSMutableArray *values;
    NSMutableArray *sendedValue;
    UIAlertView *processingIndicator;
    UILabel *processName;
    UIButton *backBtn;
}

@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSMutableArray *sendedValue;
@property (nonatomic, retain) NSDictionary *sectionContents;
@property (nonatomic, retain) NSArray *sectionTitles;
@property (nonatomic, retain) IBOutlet UILabel *processName;
@property (nonatomic, retain) UIButton *backBtn;

+ (CheckBoxViewController *)getSingletonInstance;
- (void)back;
- (void)goToNextQuestion:(id)sender;
- (void)reviewMedia;

@end
