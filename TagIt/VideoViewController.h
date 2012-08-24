//
//  VideoViewController.h
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "QuestionProcessingController.h"
#import "TagitUtil.h"

@interface VideoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, QuestionProcessDelegate>
{
    UILabel *questionTitle, *processName;
    UIButton *imgBtn, *startRecordingBtn, *nextBtn, *backBtn;
    NSURL *sendedVideo;
    MPMoviePlayerController *moviePlayer;
    UIAlertView *processingIndicator;
}

@property (nonatomic, retain) IBOutlet UILabel *questionTitle, *processName;
@property (nonatomic, retain) IBOutlet UIButton *imgBtn;
@property (nonatomic, retain) IBOutlet UIButton *startRecordingBtn;
@property (nonatomic, retain) IBOutlet UIButton *nextBtn;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) UIButton *backBtn;

+ (VideoViewController *)getSingletonInstance;
- (IBAction)startRecordVideo;
- (IBAction)startNextQuestion;
- (IBAction)playVideo;
- (IBAction)stopVideo;

@end
