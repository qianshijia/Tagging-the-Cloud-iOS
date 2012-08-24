//
//  CustomWebViewController.h
//  TagIt
//
//  Created by Shijia Qian on 6/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagitUtil.h"

@interface CustomWebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
    UIButton *backBtn;
}

@property (nonatomic, retain) UIButton *backBtn;

- (void)loadUrl:(NSString *)url;

@end
