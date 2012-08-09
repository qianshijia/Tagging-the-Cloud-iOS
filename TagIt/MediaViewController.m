//
//  MediaViewController.m
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "MediaViewController.h"
#import "DataAdapters.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "TagitUtil.h"

@implementation MediaViewController

@synthesize imgBtn;
@synthesize nextBtn;
@synthesize label;
@synthesize imageView;
@synthesize progressBar;
@synthesize mediaType;
@synthesize audioPlayer;
@synthesize moviePlayer;

+ (MediaViewController *)getSingletonInstance
{
    static MediaViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[MediaViewController alloc] init];
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
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBtn;
    [backBtn release];
    
    [label setText:[DataAdapters getQuestionDetail].questionLabel];
    fileName = [[DataAdapters getQuestionDetail].mediaData lastPathComponent];
    
    if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"img"].location != NSNotFound)
    {
        NSString *imgUrl = nil;
        if([[DataAdapters getQuestionDetail].mediaData hasPrefix:@"http"])
        {
            imgUrl = [DataAdapters getQuestionDetail].mediaData;
        }
        else
        {
            imgUrl = [[DataAdapters getQuestionDetail].mediaData substringFromIndex:[[DataAdapters getQuestionDetail].mediaData rangeOfString:@"img:"].length + 1];
        }
        self.mediaType = @"image";
        [self download:imgUrl];
    }
    else if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"vid"].location != NSNotFound)
    {
        NSLog(@"Video");
        NSString *videoUrl = nil;
        if([[DataAdapters getQuestionDetail].mediaData hasPrefix:@"http"])
        {
            videoUrl = [DataAdapters getQuestionDetail].mediaData;
        }
        else
        {
            videoUrl = [[DataAdapters getQuestionDetail].mediaData substringFromIndex:[[DataAdapters getQuestionDetail].mediaData rangeOfString:@"vid:"].length + 1];
        }
        self.mediaType = @"video";
        [self download:videoUrl];
    }
    else if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"aud"].location != NSNotFound)
    {
        NSString *audioUrl = nil;
        if([[DataAdapters getQuestionDetail].mediaData hasPrefix:@"http"])
        {
            audioUrl = [DataAdapters getQuestionDetail].mediaData;
        }
        else
        {
            audioUrl = [[DataAdapters getQuestionDetail].mediaData substringFromIndex:[[DataAdapters getQuestionDetail].mediaData rangeOfString:@"aud:"].length + 1];
        }
        self.mediaType = @"audio";
        [self download:audioUrl];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)startNextQuestion
{
    [TagitUtil startQuestion:self];
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

- (IBAction)playOrPause
{
    if([mediaType isEqualToString:@"audio"])
    {
        if(![self.audioPlayer isPlaying])
        {
            [imgBtn setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
            [nextBtn setHidden:YES];
            
            if(!resumeFromPause)
            {
                NSError *playBackError = nil;
                NSError *readingError = nil;
                NSData *fileData = [NSData dataWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]
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
            [imgBtn setImage:[UIImage imageNamed:@"playicon.png"] forState:UIControlStateNormal];
            [self.audioPlayer pause];
            resumeFromPause = YES;
        }
    }
    else
    {
        NSURL *url = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]];
        MPMoviePlayerController *newPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        self.moviePlayer = newPlayer;
        [newPlayer release];
        
        if(self.moviePlayer != nil)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVideo) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
            
            [self.moviePlayer play];
            [self.view addSubview:self.moviePlayer.view];
            [self.moviePlayer setFullscreen:YES animated:YES];
        }
    }
}

- (void)download:(NSString *)mediaUrl
{
    ASINetworkQueue *queue = [[ASINetworkQueue alloc] init];
    [queue setDownloadProgressDelegate:progressBar];
	[queue setRequestDidFinishSelector:@selector(downloadFailed)];
	[queue setRequestDidFailSelector:@selector(downloadFinished)];
	[queue setDelegate:self];
    if([self.mediaType isEqualToString:@"image"])
    {
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:mediaUrl]];
        [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]];
        [queue addOperation:request];
    }
    if([self.mediaType isEqualToString:@"video"])
    {
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:mediaUrl]];
        [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]];
        [queue addOperation:request];
    }
    if([self.mediaType isEqualToString:@"audio"])
    {
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:mediaUrl]];
        [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]];
        [queue addOperation:request];
    }
    [queue go];
    NSLog(@"start download");
}

- (void)downloadFailed
{
    
}

- (void)downloadFinished
{
    if([self.mediaType isEqualToString:@"image"])
    {
        progressBar.hidden = YES;
        imageView.hidden = NO;
        [imageView setImage:[UIImage imageWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]]];
        [nextBtn setEnabled:YES];
    }
    if([self.mediaType isEqualToString:@"video"])
    {
        progressBar.hidden = YES;
        imgBtn.hidden = NO;
        [imgBtn setImage:[UIImage imageNamed:@"playicon.png"]
                            forState:UIControlStateNormal];
        [nextBtn setEnabled:YES];
        resumeFromPause = NO;
    }
    if([self.mediaType isEqualToString:@"audio"])
    {
        progressBar.hidden = YES;
        imgBtn.hidden = NO;
        [imgBtn setImage:[UIImage imageNamed:@"playicon.png"]
                forState:UIControlStateNormal];
        [nextBtn setEnabled:YES];
    }
}

//****Audio Player Delegeate Methods*******
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    if(flag)
    {
        resumeFromPause = NO;
        [nextBtn setHidden:NO];
        [imgBtn setImage:[UIImage imageNamed:@"playicon.png"] forState:UIControlStateNormal];
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
//*****************************************

- (IBAction)stopVideo
{
    if(self.moviePlayer != nil)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        [self.moviePlayer stop];
        
        if(self.moviePlayer.view != nil && self.moviePlayer.view.superview != nil && [self.moviePlayer.view.superview isEqual:self.view] == YES)
        {
            [self.moviePlayer.view removeFromSuperview];
        }
    }
}

- (void)dealloc
{
    [label release];
    [imgBtn release];
    [imageView release];
    [progressBar release];
    [audioPlayer release];
    [moviePlayer release];
    [super dealloc];
}

@end
