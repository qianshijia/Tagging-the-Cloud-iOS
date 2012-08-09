//
//  OptionsViewController.h
//  TagIt
//
//  Created by Shijia Qian on 2/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController
{
    NSDictionary *sectionContents;
    NSArray *sectionTitles;
}

@property (nonatomic, retain) NSDictionary *sectionContents;
@property (nonatomic, retain) NSArray *sectionTitles;

@end
