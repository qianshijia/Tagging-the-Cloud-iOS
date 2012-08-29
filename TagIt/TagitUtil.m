//
//  TagitUtil.m
//  TagIt
//
//  Created by Shijia Qian on 1/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "TagitUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <AudioToolbox/AudioToolbox.h>

#import "DataAdapters.h"
#import "TextFieldViewController.h"
#import "MediaViewController.h"
#import "ImageViewController.h"
#import "VideoViewController.h"
#import "CheckBoxViewController.h"
#import "RadioViewController.h"
#import "HiddenViewController.h"
#import "UrlViewController.h"
#import "ThankYouViewController.h"
#import "AudioViewController.h"


@implementation TagitUtil

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSString *)getTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss a"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    return time;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (UIColor *)getColor:(NSString *)hexColor
{
	unsigned int red,green,blue;
	NSRange range;
	range.length = 2;
	
	range.location = 0;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	
	range.location = 2;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	
	range.location = 4;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
	
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (void)playSound:(NSString *)fileName type:(NSString *)fileType
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    SystemSoundID soundEffect;
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef)fileURL, &soundEffect);
        AudioServicesPlaySystemSound(soundEffect);
    }
    else
    {
        NSLog(@"error, audio file not found");
    }
    
    AudioServicesDisposeSystemSoundID(soundEffect);
}

+ (void)startQuestion:(UIViewController *)viewController
{
    if([[[DataAdapters getQuestionDetail].questionType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"textbox"])
    {
        if([[[DataAdapters getQuestionDetail].mediaData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            TextFieldViewController *tfViewController = nil;
            if(isPad)
            {
                tfViewController = [[TextFieldViewController alloc] initWithNibName:@"iPadTextFieldViewController" bundle:nil];
            }
            else 
            {
                tfViewController = [[TextFieldViewController alloc] init];
            }
            
            [viewController.navigationController pushViewController:tfViewController animated:YES];
            [tfViewController release];
        }
        else
        {
            MediaViewController *mViewController = [[MediaViewController alloc] init];
            [viewController.navigationController pushViewController:mViewController animated:YES];
            [mViewController release];
        }
    }
    else if([[[DataAdapters getQuestionDetail].questionType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"action:photo"])
    {
        if([[[DataAdapters getQuestionDetail].mediaData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            ImageViewController *iViewController = nil;
            if(isPad)
            {
                iViewController = [[ImageViewController alloc] initWithNibName:@"iPadImageViewController" bundle:nil];
            }
            else 
            {
                iViewController = [[ImageViewController alloc] init];
            }
            [viewController.navigationController pushViewController:iViewController animated:YES];
            [iViewController release];
        }
        else
        {
            MediaViewController *mViewController = [[MediaViewController alloc] init];
            [viewController.navigationController pushViewController:mViewController animated:YES];
            [mViewController release];
        }
    }
    else if([[[DataAdapters getQuestionDetail].questionType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"checkbox"])
    {
        if([[[DataAdapters getQuestionDetail].mediaData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            CheckBoxViewController *cbViewController = nil;
            if(isPad)
            {
                cbViewController = [[CheckBoxViewController alloc] initWithNibName:@"iPadCheckBoxViewController" bundle:nil];
            }
            else 
            {
                cbViewController = [[CheckBoxViewController alloc] init];
            }
            
            [viewController.navigationController pushViewController:cbViewController animated:YES];
            [cbViewController release];
        }
        else
        {
            MediaViewController *mViewController = [[MediaViewController alloc] init];
            [viewController.navigationController pushViewController:mViewController animated:YES];
            [mViewController release];
        }
    }
    else if([[[DataAdapters getQuestionDetail].questionType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"radio"])
    {
        if([[[DataAdapters getQuestionDetail].mediaData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            RadioViewController *rViewController = nil;
            if(isPad)
            {
                rViewController = [[RadioViewController alloc] initWithNibName:@"iPadRadioViewController" bundle:nil];
            }
            else 
            {
                rViewController = [[RadioViewController alloc] init];
            }
            
            [viewController.navigationController pushViewController:rViewController animated:YES];
            [rViewController release];
        }
        else
        {
            MediaViewController *mViewController = [[MediaViewController alloc] init];
            [viewController.navigationController pushViewController:mViewController animated:YES];
            [mViewController release];
        }
    }
    else if([[[DataAdapters getQuestionDetail].questionType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"action:video"])
    {
        if([[[DataAdapters getQuestionDetail].mediaData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            VideoViewController *vViewController = nil;
            if(isPad)
            {
                vViewController = [[VideoViewController alloc] initWithNibName:@"iPadVideoViewController" bundle:nil];
            }
            else 
            {
                vViewController = [[VideoViewController alloc] init];
            }
            [viewController.navigationController pushViewController:vViewController animated:YES];
            [vViewController release];
        }
        else
        {
            MediaViewController *mViewController = [[MediaViewController alloc] init];
            [viewController.navigationController pushViewController:mViewController animated:YES];
            [mViewController release];
        }
    }
    else if([[[DataAdapters getQuestionDetail].questionType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"action:audio"])
    {
        if([[[DataAdapters getQuestionDetail].mediaData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            AudioViewController *aViewController = nil;
            if(isPad)
            {
                aViewController = [[AudioViewController alloc] initWithNibName:@"iPadAudioViewController" bundle:nil];
            }
            else 
            {
                aViewController = [[AudioViewController alloc] init];
            }
            
            [viewController.navigationController pushViewController:aViewController animated:YES];
            [aViewController release];
        }
        else
        {
            MediaViewController *mViewController = [[MediaViewController alloc] init];
            [viewController.navigationController pushViewController:mViewController animated:YES];
            [mViewController release];
        }
    }
    else if([[[DataAdapters getQuestionDetail].questionType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"url"])
    {
        if([[[DataAdapters getQuestionDetail].mediaData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            UrlViewController *uViewController = nil;
            if(isPad)
            {
                uViewController = [[UrlViewController alloc] initWithNibName:@"iPadUrlViewController" bundle:nil];
            }
            else 
            {
                uViewController = [[UrlViewController alloc] init];
            }
            
            [viewController.navigationController pushViewController:uViewController animated:NO];
            [uViewController release];
        }
        else
        {
            MediaViewController *mViewController = [[MediaViewController alloc] init];
            [viewController.navigationController pushViewController:mViewController animated:YES];
            [mViewController release];
        }
    }
    else if([[[DataAdapters getQuestionDetail].questionType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"hidden"])
    {
        if([[[DataAdapters getQuestionDetail].mediaData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            HiddenViewController *hViewController = [[HiddenViewController
                                                      alloc] init];
            [viewController.navigationController pushViewController:hViewController animated:YES];
            [hViewController release];
        }
        else
        {
            MediaViewController *mViewController = [[MediaViewController alloc] init];
            [viewController.navigationController pushViewController:mViewController animated:YES];
            [mViewController release];
        }
    }
    else if([[[DataAdapters getQuestionDetail].questionId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"-1"])
    {
        ThankYouViewController *tyViewController = nil;
        if(isPad)
        {
            tyViewController = [[ThankYouViewController alloc] initWithNibName:@"iPadThankYouViewController" bundle:nil];
        }
        else 
        {
            tyViewController = [[ThankYouViewController alloc] init];
        }
        [viewController.navigationController pushViewController:tyViewController animated:YES];
        [tyViewController release];
    }
}

+ (NSString *)getFilePath:(NSString *)fileName
{
    NSString *result = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], fileName];
    return result;
}


@end
