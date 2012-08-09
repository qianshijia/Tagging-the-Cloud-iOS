//
//  AudioViewController.m
//  TagIt
//
//  Created by Shijia Qian on 28/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "AudioViewController.h"
#import "TagitUtil.h"
#import "DataAdapters.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation AudioViewController

@synthesize audioPlayer;
@synthesize audioRecorder;
@synthesize questionTitle;
@synthesize imageBtn;
@synthesize startRecordingBtn;
@synthesize nextBtn;
@synthesize processName;
@synthesize backBtn;

+ (AudioViewController *)getSingletonInstance
{
    static AudioViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[AudioViewController alloc] init];
        }
    }
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.navigationItem setHidesBackButton:YES];
    
    resumeFromPause = NO;
    stopped = YES;
    questionTitle.text = [DataAdapters getQuestionDetail].questionLabel;
    processName.text = [DataAdapters getProcessName];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [DataAdapters clearAll];
        [self.navigationController popToViewController:[self.navigationController.viewControllers 
                                                        objectAtIndex:0] animated:YES];
    }
}

- (void)back
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Attention" 
                          message:@"Are you sure to quit the process" 
                          delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I'm sure!", nil];
    [alert show];
    [alert release];
}

- (void)viewDidUnload
{
    if(self.audioRecorder != nil)
    {
        if([self.audioRecorder isRecording] == YES)
        {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
    if(self.audioPlayer != nil)
    {
        if([self.audioPlayer isPlaying] == YES)
        {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(isPad)
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(10, 20, 40.0, 40.0);
        [backBtn setImage:[UIImage imageNamed:@"logout_icon.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addSubview:backBtn];
    }
    else 
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.bounds = CGRectMake(0, 0, 30.0, 30.0);
        [backBtn setImage:[UIImage imageNamed:@"logout_icon.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backBtnItem;
        [backBtnItem release];
    }
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if(isPad)
    {
        [backBtn removeFromSuperview];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)audioRecordingPath
{
    return [TagitUtil getFilePath:@"Recording.m4a"];
}

- (NSDictionary *)audioRecordingSettings
{
    NSDictionary *result = nil;
    
    NSMutableDictionary *settings = [[[NSMutableDictionary alloc] init] autorelease];
    
    [settings setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0f] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    [settings setValue:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
     
    result = [NSDictionary dictionaryWithDictionary:settings];
    return result;
}

- (void)stopRecordingOnAudioRecorder:(AVAudioRecorder *)recorder
{
    if(!stopped)
    {
        stopped = YES;
        [recorder stop];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if(flag == YES)
    {
        [imageBtn setImage:[UIImage imageNamed:@"playicon.png"] forState:UIControlStateNormal];
        [imageBtn setUserInteractionEnabled:YES];
        nextBtn.hidden = NO;
        [startRecordingBtn setEnabled:YES];
        [imageBtn setTitle:nil forState:UIControlStateNormal];
        //sendedAudio = [TagitUtil getFilePath:@"Recording.m4a"];
        sendedAudio = [NSString stringWithString:[self audioRecordingPath]];
    }
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder
{
    [recorder record];
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags
{
    if(flags == AVAudioSessionInterruptionFlags_ShouldResume && recorder != nil)
    {
        [recorder record];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    if(flag)
    {
        resumeFromPause = NO;
        [startRecordingBtn setHidden:NO];
        [nextBtn setHidden:NO];
        [imageBtn setImage:[UIImage imageNamed:@"playicon.png"] forState:UIControlStateNormal];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [player play];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    if(flags == AVAudioSessionInterruptionFlags_ShouldResume && player != nil)
    {
        [player play];
    }
}

- (IBAction)startNextQuestion
{
    if(sendedAudio == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Attention" 
                              message:@"You Must Pick An Image!" 
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        processingIndicator = [[[UIAlertView alloc] initWithTitle:@"Processing..."   
                                                                       message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];     
        [processingIndicator show];  
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
        indicator.center = CGPointMake(processingIndicator.bounds.size.width / 2, processingIndicator.bounds.size.height - 50);  
        [indicator startAnimating];  
        [processingIndicator addSubview:indicator];  
        [indicator release]; 
        
        [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
        
    }
}

- (void)threadStart
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    QuestionProcessingController *qpController = [[QuestionProcessingController alloc] init];
    qpController.currentView = @"audio";
    qpController.delegate = self;
    [qpController processNextQuestion:[self audioRecordingPath]];
    
    [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    [qpController release];
    [pool release]; 
}

- (void)threadStop
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    [TagitUtil startQuestion:self];
}

- (IBAction)startRecording
{
    if(stopped)
    {
        stopped = NO;
        NSError *error = nil;
        NSString *pathAsString = [self audioRecordingPath];
        NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
    
        AVAudioRecorder *newRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL
                                                               settings:[self audioRecordingSettings] 
                                                                  error:&error];
        self.audioRecorder = newRecorder;
        [newRecorder release];
    
        if(self.audioRecorder != nil)
        {
            self.audioRecorder.delegate = self;
            if([self.audioRecorder prepareToRecord] == YES && [self.audioRecorder record] == YES)
            {
                [self performSelector:@selector(stopRecordingOnAudioRecorder:) withObject:self.audioRecorder afterDelay:[[DataAdapters getQuestionDetail].mediaLength isEqualToString:@""] ? 10 : [DataAdapters getQuestionDetail].mediaLength.intValue];
            }
        }
        [startRecordingBtn setTitle:@"Stop Recording" forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateBtnView) userInfo:nil repeats:YES];
        counter = 0;
        [imageBtn setImage:nil forState:UIControlStateNormal];
    }
    else 
    {
        stopped = YES;
        [startRecordingBtn setTitle:@"Start Recording" forState:UIControlStateNormal];
        [timer invalidate];
        [self.audioRecorder stop];
    }
}

- (void)updateBtnView
{
    
    if(counter < ([[DataAdapters getQuestionDetail].mediaLength isEqualToString:@""] ? 10 : [DataAdapters getQuestionDetail].mediaLength.intValue))
    {
        [imageBtn setTitle:[NSString stringWithFormat:@"%d s", counter] forState:UIControlStateNormal];
        counter ++;
    }
    else
    {
        [timer invalidate];
        timer = nil;
    }
}

- (IBAction)playOrPause
{
    if(![self.audioPlayer isPlaying])
    {
        [imageBtn setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
        [startRecordingBtn setHidden:YES];
        [nextBtn setHidden:YES];
   
        if(!resumeFromPause)
        {
            NSError *playBackError = nil;
            NSError *readingError = nil;
            NSData *fileData = [NSData dataWithContentsOfFile:[self audioRecordingPath]
                                                  options:NSDataReadingMapped 
                                                    error:&readingError];
            AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&playBackError];
        
            self.audioPlayer = newPlayer;
            [newPlayer release];
        
            if(self.audioPlayer != nil)
            {
                self.audioPlayer.delegate = self;
                if([self.audioPlayer prepareToPlay] == YES && [self.audioPlayer play] == YES)
                {
                    NSLog(@"Start Playing Audio!");
                }
            }
        }
        else
        {
            [self.audioPlayer play];
        }
    }
    else
    {
        [imageBtn setImage:[UIImage imageNamed:@"playicon.png"] forState:UIControlStateNormal];
        [self.audioPlayer pause];
        resumeFromPause = YES;
    }
}

- (void)finishProcessWithError
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry we can't process this TAG. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)processFail
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Upload Timeout. Please check your network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)dealloc
{
    [audioRecorder release];
    [audioPlayer release];
    [questionTitle release];
    [imageBtn release];
    [startRecordingBtn release];
    [nextBtn release];
    [super dealloc];
}

@end
