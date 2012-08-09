//
//  TagItAppDelegate.h
//  TagIt
//
//  Created by Shijia Qian on 28/12/11.
//  Copyright 2011 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "HomePageViewController.h"

@interface TagItAppDelegate : NSObject <UIApplicationDelegate>
{
    UINavigationController *navControllerWithoutLogin;
    UITabBarController *tabController;
    HomePageViewController *homeView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
