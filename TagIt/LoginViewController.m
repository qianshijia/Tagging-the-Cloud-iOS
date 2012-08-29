//
//  LoginViewController.m
//  TagIt
//
//  Created by Shijia Qian on 28/12/11.
//  Copyright 2011 UTAS. All rights reserved.
//

#import "LoginViewController.h"
#import "DataAdapters.h"
#import "SettingsSuperViewController.h"
#import "OptionsViewController.h"


@implementation LoginViewController

@synthesize userName;
@synthesize passWord;
@synthesize autoLoginSwitch;
@synthesize scrollView;
@synthesize loginButton;

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
    //initialize some config data
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"firsttime"] == nil)
    {
        //0 stand for YES while 1 stand for NO
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"firsttime"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"autologin"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"download"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"enhancement"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gps"];
    }
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"autologin"] isEqualToString:@"0"])
    {
        userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        passWord.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
    
    [autoLoginSwitch setOn:[[[NSUserDefaults standardUserDefaults] stringForKey:@"autologin"] isEqualToString:@"0"] animated:NO];
    if(isPad)
    {
        CGRect rect = userName.frame;
        rect.size.height = 45;
        userName.frame = rect;
        rect = passWord.frame;
        rect.size.height = 45;
        passWord.frame = rect;
    }
    userName.delegate = self;
    userName.returnKeyType = UIReturnKeyDone;
    passWord.delegate = self;
    passWord.returnKeyType = UIReturnKeyDone;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        if(isPad)
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner_ipad.png"] forBarMetrics:UIBarMetricsDefault];
        }
        else 
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner.png"] forBarMetrics:UIBarMetricsDefault];
        }
        
    }
    
    //button used to clear the textfield
    if(isPad)
    {
        UIButton *clearButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton1.frame = CGRectMake(userName.frame.size.width - 32, 7.5, 30, 30);
        clearButton1.tag = 1;
        clearButton1.alpha = 0.7;
        [clearButton1 setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [clearButton1 addTarget:self action:@selector(clearTextView:) forControlEvents:UIControlEventTouchUpInside];
        [userName addSubview:clearButton1];
        
        UIButton *clearButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton2.frame = CGRectMake(userName.frame.size.width - 32, 7.5, 30, 30);
        clearButton2.tag = 2;
        clearButton2.alpha = 0.7;
        [clearButton2 setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [clearButton2 addTarget:self action:@selector(clearTextView:) forControlEvents:UIControlEventTouchUpInside];
        [passWord addSubview:clearButton2];
    }
    else
    {
        UIButton *clearButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton1.frame = CGRectMake(userName.frame.size.width - 29, 2, 27, 27);
        clearButton1.tag = 1;
        clearButton1.alpha = 0.7;
        [clearButton1 setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [clearButton1 addTarget:self action:@selector(clearTextView:) forControlEvents:UIControlEventTouchUpInside];
        [userName addSubview:clearButton1];
        
        UIButton *clearButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton2.frame = CGRectMake(userName.frame.size.width - 29, 2, 27, 27);
        clearButton2.tag = 2;
        clearButton2.alpha = 0.7;
        [clearButton2 setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [clearButton2 addTarget:self action:@selector(clearTextView:) forControlEvents:UIControlEventTouchUpInside];
        [passWord addSubview:clearButton2];
        
    }
    
    
    //add a GestureRecognizer, when tap the backgroud dismiss the keyboard.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroudTap)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

- (void)clearTextView:(id)sender
{
    if(((UIButton *)sender).tag == 1)
    {
        userName.text = @"";
    }
    else 
    {
        passWord.text = @"";
    }
}

- (IBAction)logIn:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"autologin"] isEqualToString:@"1"]
       || [sender isKindOfClass:[UIButton class]])
    {
        if([userName.text isEqualToString:@""] || [passWord.text isEqualToString:@""])
        {
            UIAlertView *alertView = [[UIAlertView alloc] 
                                      initWithTitle:@"Error" message:@"Username/Password can not be blank!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
        }
        else
        {
            loadAlert = [[[UIAlertView alloc] initWithTitle:@"Login..."   
                                                    message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];     
            [loadAlert show];  
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
            indicator.center = CGPointMake(loadAlert.bounds.size.width / 2, loadAlert.bounds.size.height - 50);  
            [indicator startAnimating];  
            [loadAlert addSubview:indicator];  
            [indicator release]; 
            
            [[NSUserDefaults standardUserDefaults] setObject:userName.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:passWord.text forKey:@"password"];
            [NSThread detachNewThreadSelector:@selector(loginThreadStart:) toTarget:self withObject:@"btn"];
        }
    }
    else
    {
        loadAlert = [[[UIAlertView alloc] initWithTitle:@"Login..."   
                                                message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
        [loadAlert show];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
        indicator.center = CGPointMake(loadAlert.bounds.size.width / 2, loadAlert.bounds.size.height - 50);  
        [indicator startAnimating];  
        [loadAlert addSubview:indicator];  
        [indicator release]; 
        
        [NSThread detachNewThreadSelector:@selector(loginThreadStart:) toTarget:self 
                               withObject:nil];
    }
}

- (void)loginThreadStart:(NSString *)from
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //[NSThread sleepForTimeInterval:1];
    LoginController *lc = [[LoginController alloc] init];
    lc.delegate = self;
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"autologin"] isEqualToString:@"1"]
       || [from isEqualToString:@"btn"])
    {
        [lc login:userName.text password:passWord.text];
    }
    else
    {   
        [lc login:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"] password:[[NSUserDefaults standardUserDefaults] stringForKey:@"password"]];
    }
    
    [NSThread sleepForTimeInterval:0.5];
    if(lc.done)
    {
        [self performSelectorOnMainThread:@selector(loginThreadStop) withObject:nil waitUntilDone:NO];
    }
    [lc release];
    [pool release];  
}

- (void)loginThreadStop
{
    [loadAlert dismissWithClickedButtonIndex:0 animated:YES];
    if([[[DataAdapters getLogin] validLogin] isEqualToString:@"1"])
    {
        navController = [[UINavigationController alloc] init];
        SettingsSuperViewController *sViewController = nil;
        if(isPad)
        {
            sViewController = [[SettingsSuperViewController alloc] initWithNibName:@"iPadSettingsViewController" bundle:nil];
        }
        else 
        {
            sViewController = [[SettingsSuperViewController alloc] init];
        }
        sViewController.title = @"Settings";
        
        optionsNav = [[UINavigationController alloc] init];
        OptionsViewController *oViewController = nil;
        if(isPad)
        {
            oViewController = [[OptionsViewController alloc] initWithNibName:@"iPadOptionsViewController" bundle:nil];
        }
        else 
        {
            oViewController = [[OptionsViewController alloc] init];
        }
        [optionsNav pushViewController:oViewController animated:NO];
        optionsNav.tabBarItem.title = @"Options";
        
        if(isPad)
        {
            homeView = [[HomePageViewController alloc] initWithNibName:@"iPadHomePageViewController" bundle:nil];
        }
        else 
        {
            homeView = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
        }
        [navController pushViewController:homeView animated:YES];
        navController.tabBarItem.title = @"TagIt";
        
        tabController = [[UITabBarController alloc] init];
        tabController.viewControllers = [NSArray arrayWithObjects:navController, optionsNav, sViewController, nil];
        tabController.view.tag = 99;
        
        CGContextRef context = UIGraphicsGetCurrentContext();  
        [UIView beginAnimations:nil context:context];  
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.view.window cache:YES];
        [UIView setAnimationDelegate:self];   
        [UIView commitAnimations];
        
        UIWindow *window = self.view.window;
        [self.navigationController.view removeFromSuperview];
        [window addSubview:tabController.view];
        [sViewController release];
        [oViewController release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" 
                                                        message:[[DataAdapters getLogin] retMessage] == nil ? @"Please check the network connection." : [[DataAdapters getLogin] retMessage]
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [userName resignFirstResponder];
    [passWord resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

/*- (void)goBack
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"autologin"];
    [self.navigationController popViewControllerAnimated:YES];
}*/

- (IBAction)setAutoLogin:(id)sender
{
    BOOL setting = [(UISwitch *)sender isOn];
    if(!setting)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"autologin"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"autologin"];
    }
    [autoLoginSwitch setOn:setting animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 102)
    {
        [self.scrollView setContentOffset:CGPointMake(0.0f, 30.0f) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 102)
    {
        [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    }
}

- (void)finishProcessWithError
{
    [loadAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Server error. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)processFail
{
    [loadAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Timeout. Please check your network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)backgroudTap
{
    [userName resignFirstResponder];
    [passWord resignFirstResponder];
}

- (void)dealloc
{
    [homeView release];
    [navController release];
    [optionsNav release];
    [tabController release];
    [userName release];
    [passWord release];
    [super dealloc];
}

@end