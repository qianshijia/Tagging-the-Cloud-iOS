//
//  TextFieldViewController.m
//  TagIt
//
//  Created by Shijia Qian on 5/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "TextFieldViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataAdapters.h"
#import "TagitUtil.h"
#import "MediaViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation TextFieldViewController

@synthesize questionTitle;
@synthesize questionAnswer;
@synthesize reviewBtn;
@synthesize processName;
@synthesize backBtn;

+ (TextFieldViewController *)getSingletonInstance
{
    static TextFieldViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[TextFieldViewController alloc] init];
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
    self.questionAnswer.layer.borderColor = [UIColor colorWithRed:51/255 green:153/255 blue:204/255 alpha:1].CGColor;
    self.questionAnswer.layer.borderWidth =1.0;
    self.questionAnswer.layer.cornerRadius =10.0;
    self.questionAnswer.returnKeyType = UIReturnKeyDone;
    self.questionAnswer.delegate = self;
    
    self.questionTitle.text = [DataAdapters getQuestionDetail].questionLabel;
    self.questionAnswer.text = [DataAdapters getQuestionDetail].questionData;
    
    if([DataAdapters getProcessName] != nil)
    {
        self.processName.text = [DataAdapters getProcessName];
    }
    
    if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"img:"].length > 0)
    {
        self.reviewBtn.titleLabel.text = @"Review Image";
        self.reviewBtn.hidden = NO;
    }
    if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"vid:"].length > 0)
    {
        self.reviewBtn.titleLabel.text = @"Review Video";
        self.reviewBtn.hidden = NO;
    }
    if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"aud:"].length > 0)
    {
        self.reviewBtn.titleLabel.text = @"Review Recording";
        self.reviewBtn.hidden = NO;
    }
    
    [super viewDidLoad];
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

- (IBAction)startNextQuestion:(id)sender
{
    if([[[DataAdapters getQuestionDetail].validationType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"blank^int"])
    {
        if([self.questionAnswer.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Text Field Must Be Filled!" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else if(![self numberValidation:self.questionAnswer.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a Valid Number!" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            [self startProcessing];
        }
    }
    else if([[[DataAdapters getQuestionDetail].validationType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"int"])
    {
        if(![self numberValidation:self.questionAnswer.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a Valid Number!" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            [self startProcessing];
            
        }
    }
    else if([[[DataAdapters getQuestionDetail].validationType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"blank^dd/mm/yyyy"])
    {
        if([self.questionAnswer.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Text Field Must Be Filled!" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else if(![self dateValidation:self.questionAnswer.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a Valid Date!" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            [self startProcessing];
        }
    }
    else if([[[DataAdapters getQuestionDetail].validationType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"dd/mm/yyyy"])
    {
        if([self.questionAnswer.text isEqualToString:@""])
        {
            [self startProcessing];
            return;
        }
        
        if(![self dateValidation:self.questionAnswer.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a Valid Date!" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            [self startProcessing];
        }
    }
    else if([[[DataAdapters getQuestionDetail].validationType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"blank"])
    {
        if([self.questionAnswer.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Text Field Must Be Filled!" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            [self startProcessing];
        }
    }
    else 
    {
        [self startProcessing];
    }
}

- (IBAction)review:(id)sender
{
    MediaViewController *mvController = [[MediaViewController alloc] init];
    [self.navigationController pushViewController:mvController animated:YES];
    [mvController release];
}

- (BOOL)numberValidation:(NSString *)answer
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]*"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger matches = [regex numberOfMatchesInString:answer options:0 range:NSMakeRange(0, answer.length)];
    if(matches > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)dateValidation:(NSString *)date
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d{2})/(\\d{2})/(\\d{4})"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger matches = [regex numberOfMatchesInString:date options:0 range:NSMakeRange(0, date.length)];
    if(matches > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)startProcessing
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

- (void)threadStart
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    QuestionProcessingController *qpController = [[QuestionProcessingController alloc] init];
    qpController.currentView = @"textbox";
    qpController.delegate = self;
    [qpController processNextQuestion:self.questionAnswer.text];

    if(qpController.done)
    {
        [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    }
    [qpController release];
    [pool release];
}

- (void)threadStop
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

- (IBAction)backgroundTap
{
    [questionAnswer resignFirstResponder];
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text  
{  
    if ([text isEqualToString:@"\n"]) {  
        [textView resignFirstResponder];  
        return NO;  
    }  
    return YES;  
}

- (void)dealloc
{
    [questionTitle release];
    [questionAnswer release];
    [reviewBtn release];
    [super dealloc];
}

@end
