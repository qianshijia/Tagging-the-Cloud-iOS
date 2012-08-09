//
//  QuestionProcessingController.m
//  TagIt
//
//  Created by Shijia Qian on 25/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "QuestionProcessingController.h"
#import "DataAdapters.h"
#import "TagitUtil.h"
#import "ASIFormDataRequest.h"

@implementation QuestionProcessingController

@synthesize xmlParser;
@synthesize done;
@synthesize currentView;
@synthesize delegate;

- (void)processNextQuestion:(id)value
{
    done = NO;
    
    UIDevice *device = [[UIDevice alloc] init];
    NSString *imei = [device uniqueIdentifier];
    [device release];
    
    NSString *gmtTime = [TagitUtil getTime];
    NSString *token = [DataAdapters getLogin].token;
    NSString *hash = [TagitUtil md5:[NSString stringWithFormat:@"%@%@%@", imei, gmtTime, token]];
    
    NSURL *url = nil;
    if([self.currentView isEqualToString:@"image"] || [self.currentView isEqualToString:@"video"] || [self.currentView isEqualToString:@"audio"])
    {
        url = [NSURL URLWithString:NSLocalizedString(@"MultiMediaProcessUrl", nil)];
    }
    else
    {
        url = [NSURL URLWithString:NSLocalizedString(@"PlainMediaProcessUrl", nil)];
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[DataAdapters getQuestionDetail].answersetId forKey:@"answersetid"];
    [request setPostValue:[DataAdapters getQuestionDetail].questionId forKey:@"questionId"];
    [request setPostValue:imei forKey:@"imei"];
    [request setPostValue:gmtTime forKey:@"timestamp"];
    [request setPostValue:hash forKey:@"md5"];
    [request setPostValue:token forKey:@"token"];
    
    if([self.currentView isEqualToString:@"textbox"] || [self.currentView isEqualToString:@"radio"] || [self.currentView isEqualToString:@"media"] || 
       [self.currentView isEqualToString:@"hidden"] || [self.currentView isEqualToString:@"url"])
    {  
        [request setPostValue:(NSString *)value forKey:@"value"];
    }
    else if([self.currentView isEqualToString:@"checkbox"])
    {
        for(NSString *item in (NSMutableArray *)value)
        {
            [request addPostValue:item forKey:@"value"];
        }
    }
    else if([self.currentView isEqualToString:@"image"])
    {
        UIImage *image = (UIImage *)value;
        NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
        NSLog(@"%d", [imgData length]);
        
        NSDate *senddate=[NSDate date];  
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];    
        [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];  
        NSString *fileName=[dateformatter stringFromDate:senddate];
        [request setData:imgData withFileName:[fileName stringByAppendingFormat:@".jpg"] andContentType:@"image/jpeg" forKey:@"fil"];
    }
    else if([self.currentView isEqualToString:@"audio"])
    {
        //NSString *filePath = [NSString stringWithString:(NSString *)value];
        NSLog(@"%@", (NSString *)value);
        [request setFile:(NSString *)value forKey:@"fil"];
    }
    else if([self.currentView isEqualToString:@"video"])
    {
        NSData *videoData = [NSData dataWithContentsOfURL:(NSURL *)value];
        NSDate *senddate=[NSDate date];  
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];    
        [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];  
        NSString *fileName=[dateformatter stringFromDate:senddate];
        [request setData:videoData withFileName:[fileName stringByAppendingFormat:@".MOV"] andContentType:@"video/quicktime" forKey:@"fil"];
        //[request setData:videoData forKey:@"fil"];
    }
    [request setDelegate:self];
    [request setTimeOutSeconds:20];
    [request setShouldContinueWhenAppEntersBackground:YES];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) 
    {
        NSData *response = [request responseData];
        xmlParser = [[NSXMLParser alloc] initWithData:response];
        NSLog(@"%@", [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease]);
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        [xmlParser parse];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding].length > 200)
    {
        [delegate finishProcessWithError];
    }
    done = YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [delegate processFail];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"question"])
    {
        currentElement = @"question";
    }
    if([elementName isEqualToString:@"mediaid"])
    {
        currentElement = @"mediaid";
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([currentElement isEqualToString:@"question"])
    {
        NSArray *arr = [string componentsSeparatedByString:@"|"];
        
        qd = [[QuestionDetail alloc] init];
        qd.answersetId = [[arr objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.questionId = [[arr objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.questionLabel = [[arr objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.questionType = [[arr objectAtIndex:4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.questionData = [[arr objectAtIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.mediaLength = [[arr objectAtIndex:6] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.validationType = [[arr objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.validationMsg = [[arr objectAtIndex:8] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.mediaData = [[arr objectAtIndex:9] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [DataAdapters setQuestionDetial:qd];
    }
    else if([currentElement isEqualToString:@"mediaid"])
    {
        self.currentView = @"media";
        [self processNextQuestion:string];
    }
    
}

- (void)dealloc
{
    [qd release];
    [xmlParser release];
    [super dealloc];
}

@end
