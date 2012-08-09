//
//  OptionsViewController.m
//  TagIt
//
//  Created by Shijia Qian on 2/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "OptionsViewController.h"
#import "CustomWebViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation OptionsViewController

@synthesize sectionContents;
@synthesize sectionTitles;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSArray *arrTemp = [[NSArray alloc] initWithObjects:@"Register", @"Profile", @"History", nil];
    NSDictionary *dicTemp = [[NSDictionary alloc] initWithObjectsAndKeys:arrTemp, @"1", nil];
    self.sectionContents = dicTemp;
    [dicTemp release];
    [arrTemp release];
    self.sectionTitles = [self.sectionContents allKeys];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        if(isPad)
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner_ipad.png"]  forBarMetrics:UIBarMetricsDefault];
        }
        else 
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner.png"]  forBarMetrics:UIBarMetricsDefault];
        }
    }
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
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sectionContents objectForKey:
             [self.sectionTitles objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if([[self.sectionTitles objectAtIndex:section] isEqualToString:@"1"])
//    {
//        return @"Options";
//    }
//    else
//    {
//        return @"";
//    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *listedData = [self.sectionContents objectForKey:
                           [self.sectionTitles objectAtIndex:[indexPath section]]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [listedData objectAtIndex:[indexPath row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    CustomWebViewController *webViewController = [[CustomWebViewController alloc] init];
    switch ([indexPath row]) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setValue:@"http://my.taggingthecloud.com.au/register" forKey:@"loadUrl"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setValue:@"http://my.taggingthecloud.com.au/appLogin" forKey:@"loadUrl"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setValue:@"http://my.taggingthecloud.com.au/appLogin" forKey:@"loadUrl"];
            break;
    }
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)dealloc
{
    [sectionTitles release];
    [sectionContents release];
    [super dealloc];
}


@end
