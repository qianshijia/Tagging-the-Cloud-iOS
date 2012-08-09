//
//  AudioViewController.h
//  TagIt
//
//  Created by Shijia Qian on 28/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "QuestionProcessingController.h"

@interface AudioViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate, QuestionProcessDelegate>
{
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    UILabel *questionTitle, *processName;
    UIButton *imageBtn;
    UIButton *startRecordingBtn;
    UIButton *nextBtn, *backBtn;
    NSTimer *timer;
    NSString *sendedAudio;
    UIAlertView *processingIndicator;
    int counter;
    BOOL resumeFromPause, stopped;
}

@property (nonatomic, retain) AVAudioRecorder *audioRecorder;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UILabel *questionTitle, *processName;
@property (nonatomic, retain) IBOutlet UIButton *imageBtn;
@property (nonatomic, retain) IBOutlet UIButton *startRecordingBtn;
@property (nonatomic, retain) IBOutlet UIButton *nextBtn;
@property (nonatomic, retain) UIButton *backBtn;

+ (AudioViewController *)getSingletonInstance;
- (NSString*)audioRecordingPath;
- (NSDictionary *)audioRecordingSettings;
- (IBAction)startNextQuestion;
- (IBAction)playOrPause;
- (IBAction)startRecording;

@end
