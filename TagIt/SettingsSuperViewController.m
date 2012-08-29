//
//  SettingsSuperViewController.m
//  TagIt
//
//  Created by Shijia Qian on 12/04/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "SettingsSuperViewController.h"
#import "CustomSwitch.h"
#import "TagitUtil.h"
#import "DataAdapters.h"
#import "LoginViewController.h"


@interface SettingsSuperViewController ()

@end

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface SettingsSuperViewController ()

@end

@implementation SettingsSuperViewController

@synthesize settingsView;
@synthesize sView;
@synthesize sectionTitles;
@synthesize sectionContents;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSArray *arrTemp1 = [[NSArray alloc]
                         initWithObjects:@"Remember Login Detail", nil];
    NSArray *arrTemp2 = [[NSArray alloc]
                         initWithObjects:@"Media Download", nil];
    NSArray *arrTemp3 = [[NSArray alloc]
                         initWithObjects:@"Enhancement", nil];
    NSArray *arrTemp4 = [[NSArray alloc] 
                         initWithObjects:@"GPS Ping Service", nil];
    NSArray *arrTemp5 = [[NSArray alloc] 
                         initWithObjects:@"Log Out", nil];
    self.sectionContents = [[NSDictionary alloc] 
                            initWithObjectsAndKeys:arrTemp1, @"1", arrTemp2, @"2", 
                            arrTemp3, @"3", arrTemp4, @"4", arrTemp5, @"5", nil];
    self.sectionTitles = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    [arrTemp1 release];
    [arrTemp2 release];
    [arrTemp3 release];
    [arrTemp4 release];
    [arrTemp5 release];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *contentsCount = [self.sectionContents objectForKey:
                              [self.sectionTitles objectAtIndex:section]];
    return [contentsCount count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //    if(section == 0)
    //    {
    //        return @"Settings";
    //    }
    //    else
    //    {
    //        return @"";
    //    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Remember username and password";
        case 1:
            return @"Download";
        case 2:
            return @"Enhancement";
        case 3:
            return @"GPS Ping Service";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", [indexPath section]];
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *listedData = [self.sectionContents objectForKey:
                           [self.sectionTitles objectAtIndex:[indexPath section]]];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    if([indexPath section] != 4)
    {
        CustomSwitch *switcher = [[CustomSwitch alloc] initWithFrame:CGRectZero];
        [switcher addTarget:self action:@selector(updateSwitchState:) forControlEvents:UIControlEventValueChanged];
        switch ([indexPath section]) 
        {
            case 0:
                [switcher setOn:[[[NSUserDefaults standardUserDefaults] 
                                  objectForKey:@"autologin"] isEqualToString:@"0"]];
                break;
            case 1:
                [switcher setOn:[[[NSUserDefaults standardUserDefaults] 
                                  objectForKey:@"download"] isEqualToString:@"0"]];
                break;
            case 2:
                [switcher setOn:[[[NSUserDefaults standardUserDefaults] 
                                  objectForKey:@"enhancement"] isEqualToString:@"0"]];
                break;
            case 3:
                [switcher setOn:[[[NSUserDefaults standardUserDefaults] 
                                  objectForKey:@"gps"] isEqualToString:@"0"]];
                break;
        }
        cell.accessoryView = switcher;
        switcher.index = (NSInteger *)[indexPath section];
        [switcher release];
    }
    else
    {
        cell.backgroundColor = [TagitUtil getColor:@"3399CC"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    cell.textLabel.text = [listedData objectAtIndex:[indexPath row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if([indexPath section] !=4)
    {
        CustomSwitch *switcher = (CustomSwitch *)[[tableView cellForRowAtIndexPath:indexPath] accessoryView];
        int index = (int)switcher.index;
        switch (index) 
        {
            case 0:
                if(switcher.on)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"autologin"];
                    [switcher setOn:NO animated:YES];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"autologin"];
                    [switcher setOn:YES animated:YES];
                }
                break;
            case 1:
                if(switcher.on)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"download"];
                    [switcher setOn:NO animated:YES];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"download"];
                    [switcher setOn:YES animated:YES];
                }
                break;
            case 2:
                if(switcher.on)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"enhancement"];
                    [switcher setOn:NO animated:YES];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"enhancement"];
                    [switcher setOn:YES animated:YES];
                }
                break;
            case 3:
                if(switcher.on)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"gps"];
                    [switcher setOn:NO animated:YES];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gps"];
                    [switcher setOn:YES animated:YES];
                }
                break;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Caution" message:@"Are you sure to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I'm Sure!", nil];
        alert.tag = 101;
        [alert show];
        [alert release];
    }
}

- (IBAction)updateSwitchState:(id)sender
{
    CustomSwitch *switcher = (CustomSwitch *)sender;
    int index = (int)switcher.index;
    switch (index) 
    {
        case 0:
            if([switcher isOn])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"autologin"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"autologin"];
            }
            break;
        case 1:
            if([switcher isOn])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"download"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"download"];
            }
            break;
        case 2:
            if([switcher isOn])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"enhancement"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"enhancement"];
            }
            break;
        case 3:
            if([switcher isOn])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gps"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"gps"];
            }
            break;
    }
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(buttonIndex == 1)
        {
            [DataAdapters clearLogin];
            [DataAdapters clearQuestionDetail];
            [DataAdapters clearQuestionList];
            
            loginView = nil;
            if(isPad)
            {
                loginView = [[LoginViewController alloc] initWithNibName:@"iPadLoginViewController" bundle:nil];
            }
            else 
            {
                loginView = [[LoginViewController alloc] init];
            }
            
            CGContextRef context = UIGraphicsGetCurrentContext();  
            [UIView beginAnimations:nil context:context];  
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:NO];
            [UIView setAnimationDelegate:self];   
            [UIView commitAnimations];
            
            UINavigationController *navControllerWithoutLogin = [[UINavigationController alloc] init];
            [navControllerWithoutLogin pushViewController:loginView animated:NO];
            UIWindow *window = self.view.window;
            [self.view.superview.superview.superview removeFromSuperview];
            [window addSubview:navControllerWithoutLogin.view];
            [navControllerWithoutLogin release];
        }
    }
}


@end
