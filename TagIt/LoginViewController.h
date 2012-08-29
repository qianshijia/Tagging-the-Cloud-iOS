//
//  LoginViewController.h
//  TagIt
//
//  Created by Shijia Qian on 28/12/11.
//  Copyright 2011 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewController.h"
#import "LoginController.h"
#import "TagitUtil.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate, LoginDelegate>
{
    UINavigationController *navController, *optionsNav;
    UITabBarController *tabController;
    UITextField *userName;
    UITextField *passWord;
    UIAlertView *loadAlert;
    HomePageViewController *homeView;
    UISwitch *autoLoginSwitch;
    UIScrollView *scrollView;
    UIButton *loginBtn;
}

@property (nonatomic, retain) IBOutlet UITextField *userName;
@property (nonatomic, retain) IBOutlet UITextField *passWord;
@property (nonatomic, retain) IBOutlet UISwitch *autoLoginSwitch;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;


-(IBAction)logIn:(id)sender;
-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(IBAction)setAutoLogin:(id)sender;

@end
