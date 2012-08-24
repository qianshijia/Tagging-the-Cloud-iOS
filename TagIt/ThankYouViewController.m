//
//  ThankYouViewController.m
//  TagIt
//
//  Created by Shijia Qian on 4/02/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "ThankYouViewController.h"
#import "DataAdapters.h"
#import "SuperQuestionListViewController.h"
#import "TagProcessingController.h"
#import "StartProcessController.h"
#import "Question.h"


@implementation ThankYouViewController

@synthesize backToListBtn;
@synthesize repeatBtn;
@synthesize backBtn;

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
    [backToListBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [backToListBtn setBackgroundImage:[UIImage imageNamed:@"btnpressed_bg.png"] forState:UIControlStateHighlighted];
    [repeatBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [repeatBtn setBackgroundImage:[UIImage imageNamed:@"btnpressed_bg.png"] forState:UIControlStateHighlighted];
    
    if([DataAdapters getQuestionList] == nil || [DataAdapters getQuestionList].count == 0)
    {
        backToListBtn.hidden = YES;
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

- (IBAction)backToList
{
    SuperQuestionListViewController *qlViewController = nil;
    if(isPad)
    {
        qlViewController = [[SuperQuestionListViewController alloc] initWithNibName:@"iPadQuestionListViewController" bundle:nil];
    }
    else 
    {
        qlViewController = [[SuperQuestionListViewController alloc] init];
    }
    
    [self.navigationController pushViewController:qlViewController animated:YES];
    [qlViewController release];
}

- (IBAction)repeatTag
{
    if([DataAdapters getQuestionList] != nil && [DataAdapters getQuestionList].count != 0)
    {
        StartProcessController *spController = [[StartProcessController alloc] init];
        [spController startProcess:[[NSUserDefaults standardUserDefaults] stringForKey:@"repeatqcode"]];
        while(!spController.done)
        {
            [NSThread sleepForTimeInterval:0.1];
        }
        [spController release];
        [TagitUtil startQuestion:self];
    }
    else 
    {
        processingAlert = [[[UIAlertView alloc] initWithTitle:@"Processing..."   
                                                      message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];  
        [processingAlert show];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
        indicator.center = CGPointMake(processingAlert.bounds.size.width / 2, processingAlert.bounds.size.height - 50);  
        [indicator startAnimating];  
        [processingAlert addSubview:indicator];  
        [indicator release]; 
        [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
    }
}

- (void)threadStart
{
    TagProcessingController *tpController = [[TagProcessingController alloc] init];
    [tpController processTag:[[NSUserDefaults standardUserDefaults] stringForKey:@"repeattag"]];
    while(!tpController.done)
    {
        [NSThread sleepForTimeInterval:0.5];
    }
    [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    [tpController release];
}

- (void)threadStop
{
    [processingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [TagitUtil startQuestion:self];
}

- (IBAction)finish
{
    [DataAdapters clearProcessName];
    [DataAdapters clearQuestionDetail];
    [DataAdapters clearQuestionList];
    [self.navigationController popToViewController:[self.navigationController.viewControllers 
                                                    objectAtIndex:0] animated:YES];
}

@end

