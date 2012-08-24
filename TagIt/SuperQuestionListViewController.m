//
//  SuperQuestionListViewController.m
//  TagIt
//
//  Created by Shijia Qian on 15/04/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "SuperQuestionListViewController.h"
#import "Question.h"
#import "StartProcessController.h"
#import "TagitUtil.h"
#import "DataAdapters.h"


@interface SuperQuestionListViewController ()

@end

@implementation SuperQuestionListViewController

@synthesize backBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationItem setHidesBackButton:YES];
    questions = [DataAdapters getQuestionList];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(isPad)
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(10, 20, 40.0, 40.0);
        [backBtn setImage:[UIImage imageNamed:@"logout_icon.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addSubview:backBtn];
    }
    else 
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.bounds = CGRectMake(0, 0, 30.0, 30.0);
        [backBtn setImage:[UIImage imageNamed:@"logout_icon.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backBtnItem;
        [backBtnItem release];
    }
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if(isPad)
    {
        [backBtn removeFromSuperview];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [questions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = ((Question *)[questions objectAtIndex:[indexPath section]]).qTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    alert = [[UIAlertView alloc] initWithTitle:@"Start Process..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);  
    [indicator startAnimating];
    [alert addSubview:indicator];
    [indicator release];
    
    [DataAdapters setProcessName:((Question *)[questions objectAtIndex:[indexPath section]]).qTitle];
    [NSThread detachNewThreadSelector:@selector(threadStart:) toTarget:self withObject:((Question *)[questions objectAtIndex:[indexPath section]]).qCode];
}

- (void)threadStart:(NSString *)code
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    StartProcessController *s = [[StartProcessController alloc] init];
    [s startProcess:code];
    while(!s.done)
    {
        [NSThread sleepForTimeInterval:0.5];
    }
    if(!s.timeout)
    {
        [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    }
    else 
    {
        [self performSelectorOnMainThread:@selector(threadFail) withObject:nil waitUntilDone:NO];
    }
    [s release];
    [pool release];
}

- (void)threadStop
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [TagitUtil startQuestion:self];     
}

- (void)threadFail
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:@"Fail to start the process. Please check the network connection." 
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [DataAdapters clearQuestionList];
        [DataAdapters clearProcessName];
        [self.navigationController popToViewController:[self.navigationController.viewControllers 
                                                        objectAtIndex:0] animated:YES];
    }
}

- (void)back
{
    alert = [[UIAlertView alloc] 
             initWithTitle:@"Attention" 
             message:@"Are you sure to quit the process" 
             delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I'm sure!", nil];
    [alert show];
}

- (void)dealloc
{
    [alert release];
    [super dealloc];
}

@end
