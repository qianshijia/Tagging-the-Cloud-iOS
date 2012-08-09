//
//  SuperQuestionListViewController.h
//  TagIt
//
//  Created by Shijia Qian on 15/04/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperQuestionListViewController : UIViewController
{
    NSMutableArray *questions;
    UIAlertView *alert;
    UIButton *backBtn;
}

@property (nonatomic,retain) UIButton *backBtn;

@end
