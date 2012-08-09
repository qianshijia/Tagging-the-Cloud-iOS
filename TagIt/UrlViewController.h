//
//  UrlViewController.h
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UrlViewController : UIViewController<UIAlertViewDelegate>
{
    UILabel *questionTitle, *processName;
    UIAlertView *processingIndicator;
    UIButton *backBtn, *closeBtn;
    MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, retain) IBOutlet UILabel *questionTitle, *processName;
@property (nonatomic, retain) UIButton *backBtn, *closeBtn;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

+ (UrlViewController *)getSingletonInstance;
- (IBAction)startNextQuestion;
- (IBAction)go;

@end
