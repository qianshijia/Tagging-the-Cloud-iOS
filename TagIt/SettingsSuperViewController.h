//
//  SettingsSuperViewController.h
//  TagIt
//
//  Created by Shijia Qian on 12/04/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "HomePageViewController.h"

@interface SettingsSuperViewController : UIViewController
{
    UITableView *settingsView;
    SettingsViewController *sView;
    NSDictionary *sectionContents;
    NSArray *sectionTitles;
}

@property (nonatomic, retain) NSDictionary *sectionContents;
@property (nonatomic, retain) NSArray *sectionTitles;
@property (nonatomic, retain) IBOutlet UITableView *settingsView;
@property (nonatomic, retain) SettingsViewController *sView;

@end
