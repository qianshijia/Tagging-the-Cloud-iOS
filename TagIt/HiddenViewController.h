//
//  HiddenViewController.h
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiddenViewController : UIViewController<UIAlertViewDelegate>
{
    UILabel *questionTitle;
}

@property (nonatomic, retain) IBOutlet UILabel *questionTitle;

+ (HiddenViewController *)getSingletonInstance;
- (IBAction)startNextQuestion;

@end
