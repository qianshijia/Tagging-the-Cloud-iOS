//
//  ImageViewController.h
//  TagIt
//
//  Created by Shijia Qian on 3/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionProcessingController.h"
#import "TagitUtil.h"

@interface ImageViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, QuestionProcessDelegate>
{
    UILabel *questionTitle, *processName;
    UIImageView *myImage;
    UIButton *pickBtn, *nextBtn, *backBtn;
    UIImage *sendedImage;
    UIAlertView *processingIndicator;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) IBOutlet UILabel *questionTitle, *processName;
@property (nonatomic, retain) IBOutlet UIImageView *myImage;
@property (nonatomic, retain) IBOutlet UIButton *pickBtn;
@property (nonatomic, retain) IBOutlet UIButton *nextBtn;
@property (nonatomic, retain) UIButton *backBtn;
@property (nonatomic, retain) UIPopoverController *popoverController;

+ (ImageViewController *)getSingletonInstance;
- (void)back;
- (IBAction)goToNextQuestion:(id)sender;
- (IBAction)pickImage;

@end
