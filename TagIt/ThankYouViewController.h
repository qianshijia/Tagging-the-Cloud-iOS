//
//  ThankYouViewController.h
//  TagIt
//
//  Created by Shijia Qian on 4/02/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouViewController : UIViewController
{
    UIButton *backToListBtn, *repeatBtn;
    UIAlertView *processingAlert;
    UIButton *backBtn;
}

@property (nonatomic, retain) IBOutlet UIButton *backToListBtn, *repeatBtn;
@property (nonatomic, retain) UIButton *backBtn;

-(IBAction)repeatTag;
-(IBAction)backToList;
-(IBAction)finish;

@end
