//
//  ProcessorViewController.m
//  TagIt
//
//  Created by Shijia Qian on 5/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "ProcessorViewController.h"
#import "CheckBoxViewController.h"

@implementation ProcessorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                          target:self
                                                        selector:@selector(goToView:) 
                                                        userInfo:nil 
                                                        repeats:NO];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goToView:(id)sender
{
    CheckBoxViewController *cbViewController = [[CheckBoxViewController alloc] init];
    [self.navigationController pushViewController:cbViewController animated:YES];
    [cbViewController release];
    NSLog(@"%d", [self.navigationController.viewControllers count]); 
}

@end
