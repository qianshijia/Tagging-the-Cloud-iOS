//
//  VideoViewController.m
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "VideoViewController.h"
#import "DataAdapters.h"
#import "TagitUtil.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation VideoViewController

@synthesize questionTitle;
@synthesize imgBtn;
@synthesize startRecordingBtn;
@synthesize nextBtn;
@synthesize moviePlayer;
@synthesize processName;
@synthesize backBtn;

+ (VideoViewController *)getSingletonInstance
{
    static VideoViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[VideoViewController alloc] init];
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
    
    
    questionTitle.text = [DataAdapters getQuestionDetail].questionLabel;
    processName.text = [DataAdapters getProcessName];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(isPad)
    {
        [backBtn removeFromSuperview];
    }
    [super viewWillDisappear:animated];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [self dismissModalViewControllerAnimated:YES];
    //[picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    sendedVideo = [url retain];
    //BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
    /*if (compatible)
     {
     UISaveVideoAtPathToSavedPhotosAlbum([url path], self, nil, NULL);
     }*/
    [self dismissModalViewControllerAnimated:YES];
    [imgBtn setImage:[UIImage imageNamed:@"playicon.png"] forState:UIControlStateNormal];
    [imgBtn setEnabled:YES];
    [imgBtn setUserInteractionEnabled:YES];
    [nextBtn setHidden:NO];
    
    //[picker release];
}

- (IBAction)startRecordVideo
{
    BOOL canRecordVideo = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if (canRecordVideo) 
    {
        UIImagePickerController *videoRecorder = [[UIImagePickerController alloc] init];
        videoRecorder.sourceType = UIImagePickerControllerSourceTypeCamera;
        videoRecorder.delegate = self;
        
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *videoMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"movie"]];
        BOOL movieOutputPossible = (videoMediaTypesOnly != nil);
        
        if (movieOutputPossible) 
        {
            videoRecorder.mediaTypes = videoMediaTypesOnly;
            videoRecorder.videoMaximumDuration = [[DataAdapters getQuestionDetail].mediaLength intValue];
            videoRecorder.videoQuality = UIImagePickerControllerQualityTypeMedium;
            
            [self presentModalViewController:videoRecorder animated:YES];           
        }
        [videoRecorder release];
    }
}

- (IBAction)startNextQuestion
{
    if(sendedVideo != nil)
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Attention" 
                              message:@"You Must Record a Short Video!" 
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)threadStart
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    QuestionProcessingController *qpController = [[QuestionProcessingController alloc] init];
    qpController.currentView = @"video";
    qpController.delegate = self;
    [qpController processNextQuestion:sendedVideo];
    
    [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    [qpController release];
    [pool release];
}

- (void)threadStop
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    [TagitUtil startQuestion:self];
}

- (IBAction)playVideo
{
    MPMoviePlayerController *newPlayer = [[MPMoviePlayerController alloc] initWithContentURL:sendedVideo];
    
    self.moviePlayer = newPlayer;
    [newPlayer release];
    
    if(self.moviePlayer != nil)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVideo) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        if(isPad)
        {
            [self.moviePlayer.view setFrame:CGRectMake(150, 130, 465, 540)];
        }
        else 
        {
            [self.moviePlayer.view setFrame:CGRectMake(60, 110, 200, 180)];
        }
        //[self.moviePlayer setFullscreen:YES animated:NO];
        [self.moviePlayer play];
        [self.view addSubview:self.moviePlayer.view];
        
    }
}

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

- (void)finishProcessWithError
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Server error. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    [imgBtn release];
    [questionTitle release];
    [nextBtn release];
    [startRecordingBtn release];
    [super dealloc];
}

@end
