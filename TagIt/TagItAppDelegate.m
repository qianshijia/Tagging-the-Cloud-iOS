//
//  TagItAppDelegate.m
//  TagIt
//
//  Created by Shijia Qian on 28/12/11.
//  Copyright 2011 UTAS. All rights reserved.
//

#import "TagItAppDelegate.h"
#import "LoginViewController.h"
#import "SettingsSuperViewController.h"
#import "OptionsViewController.h"
#import "DataAdapters.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation TagItAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if(isPad)
    {
        homeView = [[HomePageViewController alloc] initWithNibName:@"iPadHomePageViewController" bundle:nil];
    }
    else 
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        homeView = [[HomePageViewController alloc] init];
    }
    navControllerWithoutLogin = [[UINavigationController alloc] init];
    [navControllerWithoutLogin pushViewController:homeView animated:NO];
    [self.window addSubview:navControllerWithoutLogin.view];
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    /*[DataAdapters clearLogin];
     [DataAdapters clearQuestionList];
     [DataAdapters clearQuestionDetail];*/
}


- (void)dealloc
{
    [navControllerWithoutLogin release];
    [homeView release];
    [tabController release];
    [_window release];
    [super dealloc];
}

@end