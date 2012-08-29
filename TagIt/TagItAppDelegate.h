//
//  TagItAppDelegate.h
//  TagIt
//
//  Created by Shijia Qian on 28/12/11.
//  Copyright 2011 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@interface TagItAppDelegate : NSObject <UIApplicationDelegate>
{
    UINavigationController *navControllerWithoutLogin;
    UITabBarController *tabController;
    LoginViewController *loginView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
