//
//  MediaViewController.h
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MediaViewController : UIViewController <AVAudioPlayerDelegate, UIAlertViewDelegate>
{
    UILabel *label;
    UIButton *imgBtn, *nextBtn;
    UIImageView *imageView;
    UIProgressView *progressBar;
    NSString *mediaType, *fileName;
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerController *moviePlayer;
    BOOL resumeFromPause;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *imgBtn;
@property (nonatomic, retain) IBOutlet UIButton *nextBtn;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (copy) NSString *mediaType;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

+ (MediaViewController *)getSingletonInstance;
- (IBAction)startNextQuestion;
- (IBAction)playOrPause;
- (void)download:(NSString *)mediaUrl;

@end
