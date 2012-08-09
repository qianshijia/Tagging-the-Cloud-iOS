//
//  QuestionListViewController.h
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionListViewController : UITableViewController<UIAlertViewDelegate>
{
    NSMutableArray *questions;
    UIAlertView *alert;
}

@end
