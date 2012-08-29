//
//  HomePageViewController.m
//  TagIt
//
//  Created by Shijia Qian on 28/12/11.
//  Copyright 2011 UTAS. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

#import "HomePageViewController.h"
#import "SettingsViewController.h"
#import "OptionsViewController.h"
#import "GPSPingServiceController.h"
#import "DataAdapters.h"
#import "CustomWebViewController.h"
#import "SuperQuestionListViewController.h"
#import "LoginViewController.h"


@implementation HomePageViewController

//@synthesize tagContent;
@synthesize processingAlert;
@synthesize navControllerWithoutLogin;
@synthesize tagString;
@synthesize barCodeBtn;
@synthesize qrTagBtn;
@synthesize logInBtn;

//GPS Ping interval
static int pingInterval = 15;
static BOOL stopPing;

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

    [barCodeBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [barCodeBtn setBackgroundImage:[UIImage imageNamed:@"btnpressed_bg.png"] forState:UIControlStateHighlighted];
    [qrTagBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [qrTagBtn setBackgroundImage:[UIImage imageNamed:@"btnpressed_bg.png"] forState:UIControlStateHighlighted];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        if(!isPad)
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner.png"]  forBarMetrics:UIBarMetricsDefault];
        }
        else 
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner_ipad.png"]  forBarMetrics:UIBarMetricsDefault];
        }
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
    if([DataAdapters getLogin] != nil)
    {
        if(isPad)
        {
            logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logInBtn.frame = CGRectMake(10, 20, 40.0, 40.0);
            [logInBtn setImage:[UIImage imageNamed:@"goback.png"] forState:UIControlStateNormal];
            [logInBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        
            [self.navigationController.navigationBar addSubview:logInBtn];
        }
        else
        {
            logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logInBtn.bounds = CGRectMake(0, 0, 30.0, 30.0);
            [logInBtn setImage:[UIImage imageNamed:@"goback.png"] forState:UIControlStateNormal];
            [logInBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:logInBtn];
            self.navigationItem.leftBarButtonItem = backBtnItem;
            [backBtnItem release];
        }
    }
    else 
    {
        if(isPad)
        {
            logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logInBtn.frame = CGRectMake(10, 20, 40.0, 40.0);
            [logInBtn setImage:[UIImage imageNamed:@"login_icon.png"] forState:UIControlStateNormal];
            [logInBtn addTarget:self action:@selector(goToLogIn) forControlEvents:UIControlEventTouchUpInside];
            
            [self.navigationController.navigationBar addSubview:logInBtn];
        }
        else
        {
            logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logInBtn.bounds = CGRectMake(0, 0, 30.0, 30.0);
            [logInBtn setImage:[UIImage imageNamed:@"login_icon.png"] forState:UIControlStateNormal];
            [logInBtn addTarget:self action:@selector(goToLogIn) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:logInBtn];
            self.navigationItem.leftBarButtonItem = backBtnItem;
            [backBtnItem release];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(isPad)
    {
        [logInBtn removeFromSuperview];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"gps"] isEqualToString:@"0"])
    {
        if([DataAdapters getLogin] != nil)
        {
            //start gps ping service
            stopPing = NO;
            CLLocationManager *m = [[CLLocationManager alloc] init];
            GPSPingServiceController *gpsController = [GPSPingServiceController getSingletonInstance];
            gpsController.locManager = m;
            gpsController.locManager.delegate = gpsController.self;
            gpsController.locManager.desiredAccuracy = kCLLocationAccuracyBest;
            [NSThread detachNewThreadSelector:@selector(startGPSPing) toTarget:self withObject:nil];
            [m release];
        }
    }
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    tagString = @"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"gps"] isEqualToString:@"0"])
    {
        stopPing = YES;
    }
    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)logout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Are you sure to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 102;
    [alert show];
    [alert release];
}


//*****Start GPS Ping***********
- (void)startGPSPing
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int timer = 0;
    while(!stopPing && timer < pingInterval)
    {
        [NSThread sleepForTimeInterval:1];
        timer++;
        NSLog(@"%d", timer);
    }
    if(timer == pingInterval)
    {
        NSLog(@"%@", @"start service!");
        
        //Do some cleans before start a new GPS ping
        [DataAdapters clearQuestionDetail];
        [DataAdapters clearQuestionList];
        
        [[GPSPingServiceController getSingletonInstance] runGPSPingService];
    }
    while(![GPSPingServiceController getSingletonInstance].done && !stopPing)
    {
        [NSThread sleepForTimeInterval:0.5];
    }
    
    [self performSelectorOnMainThread:@selector(GPSPingFinish) withObject:nil waitUntilDone:NO];
    [pool release];
}

- (void)GPSPingFinish
{
    if(!stopPing)
    {
    if([DataAdapters getQuestionDetail] != nil)
    {
        if([[DataAdapters getQuestionDetail].questionId isEqualToString:@"-1"])
        {
            [DataAdapters clearQuestionDetail];
            [NSThread detachNewThreadSelector:@selector(startGPSPing) toTarget:self withObject:nil];
            return;
        }
        else
        {
            //start question
            [TagitUtil startQuestion:self];
            return;
        }
    }
    if([[DataAdapters getQuestionList] count] != 0)
    {
        //start question list
        [TagitUtil startQuestion:self];
        return;
    }
    }
    
}
//*******************************

//start scan by ZBar
- (IBAction)startScan:(id)sender
{
    tagString = @"";
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner *scanner = reader.scanner;  
    [scanner setSymbology: ZBAR_I25
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    reader.readerView.zoom = 1.0; 
    [self presentModalViewController: reader  
                            animated: YES];   
}

//After scanning, get the content of the tag
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(!isPad)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    [picker dismissModalViewControllerAnimated:YES];
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    
    for(ZBarSymbol *symbol in results)
    {
        //tagContent.text = [symbol data];
        tagString = [symbol data];
        break;
    }
    
    //[NSThread sleepForTimeInterval:0.5];
    if([tagString isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Scan failed, please scan again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        [self startAction:tagString];
    }
}

- (void)startAction:(NSString *)tagCont
{
    if([DataAdapters getLogin] == nil)
    {
        [self actionWithoutEnhancement:tagCont];
    }
    else 
    {
        //enhancement is OFF
        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"enhancement"] isEqualToString:@"1"])
        {
            [self actionWithoutEnhancement:tagCont];
        }
        //enhancement is ON
        else
        {
            //Do some cleans before start a new action
            [DataAdapters clearQuestionDetail];
            [DataAdapters clearQuestionList];
            
            [self actionWithEnhancement:tagCont];
        }
    }
}

- (void)actionWithoutEnhancement:(NSString *)tagCont
{
    if([[tagCont lowercaseString] rangeOfString:@"http"].location != NSNotFound)
    {
        CustomWebViewController *webViewController = [[CustomWebViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setValue:tagCont forKey:@"loadUrl"];
        [self.navigationController pushViewController:webViewController animated:YES];
        [webViewController release];
    }
    else if([[tagCont lowercaseString] rangeOfString:@"tel"].location != NSNotFound)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tagCont]];
    }
    else if([[tagCont lowercaseString] rangeOfString:@"sms"].location != NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" 
                                                        message:@"This tag contains a SMS, are you sure to send this SMS?" 
                                                       delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
        [alert release];
    }
    else
    {
        if([DataAdapters getLogin] == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you want to login to get more functionalities?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.tag = 101;
            [alert show];
            [alert release];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(buttonIndex == 1)
        {
            LoginViewController *lViewController = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:lViewController animated:YES];
            [lViewController release];
        }
    }
    else if(alertView.tag = 102)
    {
        if(buttonIndex == 1)
        {
            [DataAdapters clearAll];
            [DataAdapters clearLogin];
            
            stopPing = YES;
            if(isPad)
            {
                loginView = [[LoginViewController alloc] initWithNibName:@"iPadLoginViewController" bundle:nil];
            }
            else 
            {
                loginView = [[LoginViewController alloc] init];
            }
            
            navControllerWithoutLogin = [[UINavigationController alloc] init];
            [navControllerWithoutLogin pushViewController:loginView animated:NO];
            
            CGContextRef context = UIGraphicsGetCurrentContext();  
            [UIView beginAnimations:nil context:context];  
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:YES];
            [UIView setAnimationDelegate:self];   
            [UIView commitAnimations];
            
            UIWindow *window = self.view.window;
            [self.navigationController.view.superview.superview.superview removeFromSuperview];
            [window addSubview:navControllerWithoutLogin.view];
        }
        
    }
    else 
    {
        if(buttonIndex == 1)
        {
            [self sendSMS:tagString];
        }
    }
}

- (void)actionWithEnhancement:(NSString *)tagCont
{
    processingAlert = [[[UIAlertView alloc] initWithTitle:@"Processing..."   
                                                  message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];  
    [processingAlert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
    indicator.center = CGPointMake(processingAlert.bounds.size.width / 2, processingAlert.bounds.size.height - 50);  
    [indicator startAnimating];  
    [processingAlert addSubview:indicator];  
    [indicator release];
    [NSThread sleepForTimeInterval:0.5];
    [NSThread detachNewThreadSelector:@selector(processingThreadStart:) toTarget:self withObject:tagCont];
}

//**Thread function to process the tag**
- (void)processingThreadStart:(NSString *)tag
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TagProcessingController *processor = [[TagProcessingController alloc] init];
    processor.delegate = self;
    NSString *result = [processor processTag:tag];
    [NSThread sleepForTimeInterval:1];
    
    if(processor.done)
    {
        [[NSUserDefaults standardUserDefaults] setObject:tag forKey:@"repeattag"];
        [self performSelectorOnMainThread:@selector(processingThreadStop:) withObject:result waitUntilDone:NO];
    }
    [processor release];
    [pool release];
}

- (void)processingThreadStop:(NSString *)result
{
    [processingAlert dismissWithClickedButtonIndex:0 animated:YES];
    if([[DataAdapters getQuestionDetail].questionId isEqualToString:@"-1"] || [[DataAdapters getQuestionDetail].questionId isEqualToString:@"-2"])
    {
        [self actionWithoutEnhancement:tagString];
    }
    else
    {
        if([result isEqualToString:@"question"])
        {
            [TagitUtil startQuestion:self];
        }
        else if([result isEqualToString:@"questionairelist"])
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
        else if([result isEqualToString:@"messages"])
        {
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"There is no processes attached with this tag!" 
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        tagString = @"";
    }
}
//***************************************

//*****Send SMS in App***********
- (void)sendSMS:(NSString *)sms
{
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];	
	if (canSendSMS) 
    {
        NSArray *arr = [sms componentsSeparatedByString:@":"];
		MFMessageComposeViewController *picker = [[[MFMessageComposeViewController alloc] init] autorelease];
		picker.messageComposeDelegate = self;
		picker.navigationBar.tintColor = [UIColor blackColor];
		picker.body = [arr objectAtIndex:2];
		picker.recipients = [NSArray arrayWithObject:[arr objectAtIndex:1]];
		[self presentModalViewController:picker animated:YES];
	}
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Only iOS 4.0 or later support inner App SMS sending function!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString *errMsg = nil;
    switch (result) {
		case MessageComposeResultCancelled:
			errMsg = @"Message Canceled!";
			break;
		case MessageComposeResultSent:
			errMsg = @"Message has been sent!";
			break;
		case MessageComposeResultFailed:
			errMsg = @"Sending message fail!";
			break;
		default:
			break;
	}
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:errMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
    [alert release];
	[controller dismissModalViewControllerAnimated:YES];
}
//*******************************

- (void)finishProcessWithError
{
    [processingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry we can't process this TAG. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)processFail
{
    [processingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Timeout. Please check your network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)dealloc
{
    [loginView release];
    [navControllerWithoutLogin release];
    [processingAlert release];
    //[tagContent release];
    [super dealloc];
}

@end