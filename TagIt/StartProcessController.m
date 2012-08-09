//
//  StartProcessController.m
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//  Start the corresponding process when user click one process in question list view.
//

#import "StartProcessController.h"
#import "TagitUtil.h"
#import "DataAdapters.h"
#import "ASIFormDataRequest.h"

@implementation StartProcessController

@synthesize done, timeout;
@synthesize xmlParser;

- (void)startProcess:(NSString *)qCode
{
    done = NO;
    
    UIDevice *device = [[UIDevice alloc] init];
    NSString *imei = [device uniqueIdentifier];
    [device release];
    
    NSString *gmtTime = [TagitUtil getTime];
    NSString *token = [DataAdapters getLogin].token;
    
    NSString *hash = [TagitUtil md5:[NSString stringWithFormat:@"%@%@%@", imei, gmtTime, token]];
    [[NSUserDefaults standardUserDefaults] setObject:qCode forKey:@"repeatqcode"];
    
    NSURL *url = [NSURL URLWithString:NSLocalizedString(@"StartProcessUrl", nil)];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:qCode forKey:@"questionnaireId"];
    [request setPostValue:imei forKey:@"imei"];
    [request setPostValue:gmtTime forKey:@"timestamp"];
    [request setPostValue:token forKey:@"token"];
    [request setPostValue:hash forKey:@"md5"];
    
    [request setDelegate:self];
    [request setTimeOutSeconds:10];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request startSynchronous];

    NSData *responseData = [request responseData];
    NSString *response = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", response);
    
    xmlParser = [[NSXMLParser alloc] initWithData:responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    done = YES;
    timeout = YES;
    NSLog(@"request fail");
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"question"])
    {
        currentElement = @"question";
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([currentElement isEqualToString:@"question"])
    {
        [DataAdapters clearQuestionDetail];
        NSArray *arr = [string componentsSeparatedByString:@"|"];
        
        QuestionDetail *qd = [[QuestionDetail alloc] init];
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
        [qd release];
        
    }
    done = YES;
}

-(void)dealloc
{
    [xmlParser release];
    [super dealloc];
}

@end
