//
//  RadioViewController.m
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "RadioViewController.h"
#import "DataAdapters.h"
#import "TagitUtil.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation RadioViewController

@synthesize questionTitle;
@synthesize picker;
@synthesize processName;
@synthesize backBtn;

+ (RadioViewController *)getSingletonInstance
{
    static RadioViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[RadioViewController alloc] init];
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
    
    //picker = [[UIPickerView alloc] init];
    NSArray *temp = [[DataAdapters getQuestionDetail].questionData componentsSeparatedByString:@"^"];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    int dRow = 0;
    
    //get the datasource of the picker view
    for(NSString *item in temp)
    {
        NSArray *arr = [item componentsSeparatedByString:@"~"];
        if([arr count] > 2)
        {
            [values addObject:@"0"];
            [keys addObject:[arr objectAtIndex:1]];
            defaultRow = dRow;
        }
        else
        {
            [values addObject:[arr objectAtIndex:0]];
            [keys addObject:[arr objectAtIndex:1]];
        }
        dRow++;
    }
    pickerViewContent = [[NSDictionary alloc] initWithObjects:values forKeys:keys]; 
    
    [picker setDelegate:self];
    [picker selectRow:defaultRow inComponent:0 animated:YES];
    if(!isPad)
    {
        picker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; 
        picker.frame = CGRectMake(47, 56, 225, 150);
    }
    
    [keys release];
    [values release];
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[pickerViewContent allKeys] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[pickerViewContent allKeys] objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    sendedValue = [pickerViewContent objectForKey:[[pickerViewContent allKeys] objectAtIndex:row]];
}

-(IBAction)startNextQuestion:(id)sender
{
    processingIndicator = [[[UIAlertView alloc] initWithTitle:@"Processing..."   
                                                                   message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];     
    [processingIndicator show];  
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
    indicator.center = CGPointMake(processingIndicator.bounds.size.width / 2, processingIndicator.bounds.size.height - 50);  
    [indicator startAnimating];  
    [processingIndicator addSubview:indicator];  
    [indicator release]; 
    
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self 
                           withObject:nil];
    
}

-(void)threadStart
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    QuestionProcessingController *qpController = [[QuestionProcessingController alloc] init];
    qpController.currentView = @"radio";
    qpController.delegate = self;
    [qpController processNextQuestion:sendedValue];
    
    if(qpController.done)
    {
        [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    }
    [qpController release];
    [pool release];
}

-(void)threadStop
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    [TagitUtil startQuestion:self];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Timeout. Please check your network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [DataAdapters clearAll];
        [self.navigationController popToViewController:[self.navigationController.viewControllers 
                                                        objectAtIndex:0] animated:YES];
    }
}

-(void)dealloc
{
    [picker release];
    [pickerViewContent release];
    [questionTitle release];
//    [sendedValue release];
   // [processingIndicator release];
    [super dealloc];
}

@end
