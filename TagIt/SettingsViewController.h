//
//  SettingsViewController.h
//  TagIt
//
//  Created by Shijia Qian on 31/12/11.
//  Copyright 2011 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController<UIAlertViewDelegate>
{
    NSDictionary *sectionContents;
    NSArray *sectionTitles;
}

@property (nonatomic, retain) NSDictionary *sectionContents;
@property (nonatomic, retain) NSArray *sectionTitles;

-(IBAction)updateSwitchState:(id)sender;
@end
