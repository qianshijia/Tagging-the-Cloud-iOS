//
//  ImageViewController.m
//  TagIt
//
//  Created by Shijia Qian on 3/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "ImageViewController.h"
#import "DataAdapters.h"
#import "TagitUtil.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation ImageViewController

@synthesize questionTitle;
@synthesize myImage;
@synthesize pickBtn;
@synthesize nextBtn;
@synthesize processName;
@synthesize backBtn;
@synthesize popoverController;

+ (ImageViewController *)getSingletonInstance
{
    static ImageViewController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[ImageViewController alloc] init];
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
    questionTitle.text = [DataAdapters getQuestionDetail].questionLabel;
    processName.text = [DataAdapters getProcessName];
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

- (IBAction)pickImage
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: nil
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"From Album", @"From Camera", nil];
    [menu showFromTabBar:(UITabBar *)self.view.superview.superview];
    [menu release];
}

- (IBAction)goToNextQuestion:(id)sender
{
    if(sendedImage == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Attention" 
                              message:@"You Must Pick An Image!" 
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
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
        
        [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self 
                               withObject:nil];
        
        
        
    }
}

- (void)threadStart
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    QuestionProcessingController *qpController = [[QuestionProcessingController alloc] init];
    qpController.currentView = @"image";
    qpController.delegate = self;
    [qpController processNextQuestion:sendedImage];

    [self performSelectorOnMainThread:@selector(threadStop) withObject:nil waitUntilDone:NO];
    [pool release];
    [qpController release];
}

- (void)threadStop
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    [TagitUtil startQuestion:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(isPad)
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            self.popoverController = popover;          
            popoverController.delegate = self;
            //[popoverController presentPopoverFromBarButtonItem:sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            [popoverController presentPopoverFromRect:self.myImage.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            [imagePicker release];
            [popover release];
        }
        else 
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
        }
        
    }
    else if(buttonIndex == 1)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        
        [self presentModalViewController:imagePicker animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if(isPad)
    {
        //Dismiss the popover view if user picked image from album
        if(self.popoverController != nil)
        {
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = nil;
        }
        //Dismiss the camera view
        else 
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else 
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    myImage.image = image;
    sendedImage = image;
    //NSLog(@"%@", [[editingInfo objectForKey:UIImagePickerControllerReferenceURL] relativePath]);
    if(nextBtn.hidden)
    {
        nextBtn.hidden = NO;
    }
    if(![pickBtn.titleLabel.text isEqualToString:@"Repick"])
    {
        [pickBtn setTitle:@"Repick" forState:UIControlStateNormal];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)finishProcessWithError
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry we can't process this TAG. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)processFail
{
    [processingIndicator dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Upload Timeout. Please check your network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)dealloc
{
    //[myImage release];
    //[sendedImage release];
    [questionTitle release];
    [nextBtn release];
    [pickBtn release];
    [popoverController release];
//    [processingIndicator release];
    [super dealloc];
}

@end
