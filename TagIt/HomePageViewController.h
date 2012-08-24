//
//  HomePageViewController.h
//  TagIt
//
//  Created by Shijia Qian on 28/12/11.
//  Copyright 2011 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "TagProcessingController.h"
#import "TagitUtil.h"

@interface HomePageViewController : UIViewController <UIAlertViewDelegate, UINavigationControllerDelegate, ZBarReaderDelegate, MFMessageComposeViewControllerDelegate, TagProcessDelegate>
{
    HomePageViewController *homeView;
    UINavigationController *navControllerWithoutLogin;
    UIButton *barCodeBtn, *qrTagBtn, *logInBtn;
    UIAlertView *processingAlert;
    NSString *tagString;
    bool startProcess;
}

@property (nonatomic, retain) UINavigationController *navControllerWithoutLogin;
@property (nonatomic, retain) UIAlertView *processingAlert;
@property (copy) NSString *tagString;
@property (nonatomic, retain) IBOutlet UIButton *barCodeBtn, *qrTagBtn;
@property (nonatomic, retain) UIButton *logInBtn;

- (void)startGPSPing;
- (IBAction)startScan:(id)sender;
- (void)startAction:(NSString *)tagCont;
- (void)actionWithoutEnhancement:(NSString *)tagCont;
- (void)actionWithEnhancement:(NSString *)tagCont;
- (void)sendSMS:(NSString *)sms;

- (void)processingThreadStart:(NSString *)tag;
- (void)processingThreadStop:(NSString *)result;

@end
