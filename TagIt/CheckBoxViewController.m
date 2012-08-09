//
//  CheckBoxViewController.m
//  TagIt
//
//  Created by Shijia Qian on 3/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "CheckBoxViewController.h"
#import "DataAdapters.h"
#import "CustomTableCellForCheckBtn.h"
#import "TagitUtil.h"
#import "QuestionProcessingController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation CheckBoxViewController

@synthesize sectionTitles;
@synthesize sectionContents;
@synthesize values;
@synthesize sendedValue;
@synthesize processName;
@synthesize backBtn;

+ (CheckBoxViewController *)getSingletonInstance
{
    static CheckBoxViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[CheckBoxViewController alloc] init];
        }
    }
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [self.navigationItem setHidesBackButton:YES];
    processName.text = [DataAdapters getProcessName];
    
    NSArray *arr = [[DataAdapters getQuestionDetail].questionData componentsSeparatedByString:@"^"];
    NSArray *next = [[NSArray alloc] initWithObjects:@"Next", nil];
    NSMutableArray *titleArr = [[NSMutableArray alloc] init];
    if(values == nil)
    {
        values = [[NSMutableArray alloc] init];
    }
    if(sendedValue == nil)
    {
        sendedValue = [[NSMutableArray alloc] init];
    }
    
    
    for(NSString *item in arr)
    {
        NSArray *temp = [item componentsSeparatedByString:@"~"];
        //option value
        [values addObject:[temp objectAtIndex:0]];
        //option title
        [titleArr addObject:[temp objectAtIndex:1]];
    }
    
    if([[DataAdapters getQuestionDetail].mediaData isEqualToString:@""])
    {
        sectionContents = [[NSDictionary alloc] initWithObjectsAndKeys:titleArr, @"1", next, @"2", nil];
        sectionTitles = [[NSArray alloc] initWithObjects:@"1", @"2", nil];
    }
    else
    {
        NSArray *temp = [[NSArray alloc] initWithObjects:@"Review", nil];
        NSArray *temp2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
        NSDictionary *dicTemp = [[NSDictionary alloc] initWithObjectsAndKeys:titleArr, @"1", temp, @"2", next, @"3", nil];
        sectionContents = dicTemp;
        sectionTitles = temp2;
        [temp release];
        [temp2 release];
        [dicTemp release];
    }
    
    [next release];
    [titleArr release];
    
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)back
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Attention" 
                          message:@"Are you sure to quit the process" 
                          delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I'm sure!", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers 
                                                        objectAtIndex:0] animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *contentsCount = [self.sectionContents objectForKey:
                              [self.sectionTitles objectAtIndex:section]];
    return [contentsCount count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [DataAdapters getQuestionDetail].questionLabel;
    }
    else
    {
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    static NSString *CellIdentifier = @"Cell";
    CustomTableCellForCheckBtn *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *listedData = [self.sectionContents objectForKey:
                           [self.sectionTitles objectAtIndex:[indexPath section]]];
    if(cell == nil)
    {
        cell = [[[CustomTableCellForCheckBtn alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if([indexPath section] == 0)
        {
            cell.checked = NO;
        }
        else
        {
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
    }
    
    if(![[DataAdapters getQuestionDetail].mediaData isEqualToString:@""])
    {
        if([indexPath section] == 1)
        {
            if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"img:"].length > 0)
            {
                cell.textLabel.text = @"Review Image";
            }
            if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"vid:"].length > 0)
            {
                cell.textLabel.text = @"Review Video";
            }
            if([[DataAdapters getQuestionDetail].mediaData rangeOfString:@"aud:"].length > 0)
            {
                cell.textLabel.text = @"Review Recording";
            }
        }
    }
    else
    {
        cell.textLabel.text = [listedData objectAtIndex:[indexPath row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    CustomTableCellForCheckBtn *cell = (CustomTableCellForCheckBtn *)[tableView cellForRowAtIndexPath:indexPath];
    if([[DataAdapters getQuestionDetail].mediaData isEqualToString:@""])
    {
        if([indexPath section] == 0)
        {
            if(!cell.checked)
            {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                cell.checked = YES;
                [sendedValue addObject:[values objectAtIndex:[indexPath row]]];
            }
            else
            {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                cell.checked = NO;
                [sendedValue removeObject:[values objectAtIndex:[indexPath row]]];
            }
        }
        else
        {
            [self goToNextQuestion:nil];
        }
    }
    else
    {
        if([indexPath section] == 0)
        {
            if(!cell.checked)
            {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                //[(UIImageView *)[cell accessoryView] setImage:[UIImage imageNamed:@"radio.png"]];
                cell.checked = YES;
                [sendedValue addObject:[values objectAtIndex:[indexPath row]]];
            }
            else
            {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                cell.checked = NO;
                [sendedValue removeObject:[values objectAtIndex:[indexPath row]]];
            }
        }
        else if([indexPath section] == 1)
        {
            [self reviewMedia];
        }
        else
        {
            [self goToNextQuestion:nil];
        }
    }
}

- (void)goToNextQuestion:(id)sender
{
    if([sendedValue count] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You Must Select At Least One Option!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        processingIndicator = [[[UIAlertView alloc] initWithTitle:@"Processing..."   
                                                                       message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];     
        [processingIndicator show];  
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];  
        indicator.center = CGPointMake(processingIndicator.bounds.size.width / 2, processingIndicator.bounds.size.height - 50);  
        [indicator startAnimating];  
        [processingIndicator addSubview:indicator];  
        [indicator release]; 
        
        [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
    }
}

-(void)threadStart
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    QuestionProcessingController *qpController = [[QuestionProcessingController alloc] init];
    qpController.currentView = @"checkbox";
    [qpController processNextQuestion:sendedValue];
    while(!qpController.done)
    {
        [NSThread sleepForTimeInterval:0.5];
    }
    [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    [qpController release];
    [pool release];
}

-(void)threadStop
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    [TagitUtil startQuestion:self];
}

- (void)reviewMedia
{
    
}

- (void)dealloc
{
    [sectionTitles release];
    [sectionContents release];
    [values release];
    [sendedValue release];
    //[processingIndicator release];
    [super dealloc];
}

@end
