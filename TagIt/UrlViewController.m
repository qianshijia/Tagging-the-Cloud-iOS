//
//  UrlViewController.m
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "UrlViewController.h"
#import "DataAdapters.h"
#import "QuestionProcessingController.h"
#import "TagitUtil.h"
#import "CustomWebViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation UrlViewController

@synthesize questionTitle;
@synthesize processName;
@synthesize backBtn, closeBtn;
@synthesize moviePlayer;

+ (UrlViewController *)getSingletonInstance
{
    static UrlViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[UrlViewController alloc] init];
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
    self.processName.text = [DataAdapters getProcessName];
    self.questionTitle.text = [DataAdapters getQuestionDetail].questionLabel;
    [[NSUserDefaults standardUserDefaults] setValue:[[DataAdapters getQuestionDetail].questionData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"loadUrl"];
    
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

- (void) viewWillDisappear:(BOOL)animated
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

- (IBAction)go
{
    if(isPad)
    {
        CustomWebViewController *webView = [[CustomWebViewController alloc] init];
        [self.navigationController pushViewController:webView animated:YES];
        //[self presentModalViewController:webView animated:YES];
        [webView release];
        return;
    }
    /*
    else 
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[DataAdapters getQuestionDetail].questionData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
    }*/
    if([[DataAdapters getQuestionDetail].questionData rangeOfString:@"video"].location != NSNotFound)
    {
        MPMoviePlayerController *newPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[DataAdapters getQuestionDetail].questionData]];
        
        self.moviePlayer = newPlayer;
        [newPlayer release];
        
        if(self.moviePlayer != nil)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVideo) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];

            [self.moviePlayer.view setFrame:CGRectMake(30, 90, 260, 230)];
            //[self.moviePlayer setFullscreen:YES animated:NO];
            [self.moviePlayer play];
            [self.view addSubview:self.moviePlayer.view];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:
                             CGRectMake(moviePlayer.view.frame.origin.x + moviePlayer.view.frame.size.width - 15, 
                                        moviePlayer.view.frame.origin.y - 15, 30, 30)];
            closeBtn = btn;
            [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(stopVideo) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:closeBtn];
            [btn release];
            
        }
    }
    else 
    {
        CustomWebViewController *webView = [[CustomWebViewController alloc] init];
        [self.navigationController pushViewController:webView animated:YES];
        //[self presentModalViewController:webView animated:YES];
        [webView release];
    }
}

- (IBAction)stopVideo
{
    if(self.moviePlayer != nil)
    {
        [closeBtn setHidden:YES];
        closeBtn = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        [self.moviePlayer stop];
        
        if(self.moviePlayer.view != nil && self.moviePlayer.view.superview != nil && [self.moviePlayer.view.superview isEqual:self.view] == YES)
        {
            [self.moviePlayer.view removeFromSuperview];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    questionTitle = nil;
    processName = nil;
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

- (void)threadStart
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    QuestionProcessingController *qpController = [[[QuestionProcessingController alloc] init] autorelease];
    qpController.currentView = @"url";
    [qpController processNextQuestion:@""];
    while(!qpController.done)
    {
        [NSThread sleepForTimeInterval:1];
    }
    [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    [pool release];
}

- (void)threadStop
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    [TagitUtil startQuestion:self];
}

- (void)dealloc
{
    [closeBtn release];
    [questionTitle release];
    [processName release];
    [moviePlayer release];
    [super dealloc];
}

@end
