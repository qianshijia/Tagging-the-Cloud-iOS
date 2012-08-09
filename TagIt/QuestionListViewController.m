//
//  QuestionListViewController.m
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "QuestionListViewController.h"
#import "DataAdapters.h"
#import "StartProcessController.h"
#import "TextFieldViewController.h"
#import "ImageViewController.h"
#import "MediaViewController.h"
#import "CheckBoxViewController.h"
#import "RadioViewController.h"
#import "VideoViewController.h"
#import "HiddenViewController.h"
#import "UrlViewController.h"
#import "ThankYouViewController.h"
#import "TagitUtil.h"

@implementation QuestionListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    questions = [DataAdapters getQuestionList];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] 
                                initWithTitle:@"Quit" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBtn;
    [backBtn release];
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = ((Question *)[questions objectAtIndex:[indexPath row]]).qTitle;
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
    
    [NSThread detachNewThreadSelector:@selector(threadStart:) toTarget:self withObject:((Question *)[questions objectAtIndex:[indexPath row]]).qCode];
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
    [s release];
    [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    [pool release];
}

- (void)threadStop
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [TagitUtil startQuestion:self];     
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [DataAdapters clearQuestionList];
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
    [super dealloc];
}

@end
