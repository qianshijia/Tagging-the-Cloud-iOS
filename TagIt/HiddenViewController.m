//
//  HiddenViewController.m
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "HiddenViewController.h"
#import "DataAdapters.h"
#import "QuestionProcessingController.h"
#import "TagitUtil.h"

@implementation HiddenViewController

@synthesize questionTitle;

+ (HiddenViewController *)getSingletonInstance
{
    static HiddenViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[HiddenViewController alloc] init];
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
    
    self.questionTitle.text = [DataAdapters getQuestionDetail].questionLabel;
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
    UIAlertView *processingIndicator = [[[UIAlertView alloc] initWithTitle:@"Processing..."   
                                                                   message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];     
    [processingIndicator show];  
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
    indicator.center = CGPointMake(processingIndicator.bounds.size.width / 2, processingIndicator.bounds.size.height - 50);  
    [indicator startAnimating];  
    [processingIndicator addSubview:indicator];  
    [indicator release]; 
    
    QuestionProcessingController *qpController = [[QuestionProcessingController alloc] init];
    qpController.currentView = @"hidden";
    [qpController processNextQuestion:@""];
    while(!qpController.done)
    {
        [NSThread sleepForTimeInterval:0.5];
    }
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    [qpController release];
    [TagitUtil startQuestion:self];
}

- (void)dealloc
{
    [super dealloc];
}

@end
