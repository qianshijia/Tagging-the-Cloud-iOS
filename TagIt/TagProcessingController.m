//
//  TagProcessingController.m
//  TagIt
//
//  Created by Shijia Qian on 8/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "TagProcessingController.h"
#import "TagitUtil.h"
#import "DataAdapters.h"
#import "Question.h"
#import "ASIFormDataRequest.h"

@implementation TagProcessingController

@synthesize xmlParser;
@synthesize done;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)processTag:(NSString *)tag
{
    done = NO;
    UIDevice *device = [[UIDevice alloc] init];
    NSString *imei = [device uniqueIdentifier];
    [device release];
    NSString *gmtTime = [TagitUtil getTime]; 
    NSString *token = [DataAdapters getLogin].token;
    NSString *hash = [TagitUtil md5:[NSString stringWithFormat:@"%@%@%@", imei, gmtTime, token]];
    
    NSURL *url = [NSURL URLWithString:NSLocalizedString(@"TagPorcessUrl", nil)];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:tag forKey:@"uid"];
    [request setPostValue:imei forKey:@"imei"];
    [request setPostValue:gmtTime forKey:@"timestamp"];
    [request setPostValue:token forKey:@"token"];
    [request setPostValue:hash forKey:@"md5"];
    [request setPostValue:@"QR Tag" forKey:@"tagtype"];
    
    [request setDelegate:self];
    [request setTimeOutSeconds:10];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request startSynchronous];
    
    NSData *responseData = [request responseData];
    NSString *response = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", response);
    
    //Then parse the response message
    self.xmlParser = [[[NSXMLParser alloc] initWithData:responseData] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse]; 
    return processType;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding].length > 200)
    {
        [delegate finishProcessingWithError];
    }
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
    if([elementName isEqualToString:@"questionairelist"])
    {
        currentElement = @"questionairelist";
    }
    if([elementName isEqualToString:@"messages"])
    {
        currentElement = @"messages";
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //parse a question if return xml is a question
    if([currentElement isEqualToString:@"question"])
    {
        NSArray *arrTemp1 = [string componentsSeparatedByString:@"|"];
        
        QuestionDetail *qd = [[QuestionDetail alloc] init];
        qd.answersetId = [[arrTemp1 objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.questionId = [[arrTemp1 objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.questionLabel = [[arrTemp1 objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.questionType = [[arrTemp1 objectAtIndex:4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.questionData = [[arrTemp1 objectAtIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.mediaLength = [[arrTemp1 objectAtIndex:6] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.validationType = [[arrTemp1 objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.validationMsg = [[arrTemp1 objectAtIndex:8] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        qd.mediaData = [[arrTemp1 objectAtIndex:9] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [DataAdapters setQuestionDetial:qd];
        [qd release];
        processType = @"question";
        done = YES;
    }
    //parse a question list if return xml contains a questionairelist
    else if([currentElement isEqualToString:@"questionairelist"])
    {
        NSArray *arrTemp1 = [[NSArray alloc] initWithArray:[string componentsSeparatedByString:@"^^"]];
        NSArray *arrTemp2 = [[NSArray alloc] initWithArray:[[arrTemp1 objectAtIndex:1] componentsSeparatedByString:@"^"]];
        for(NSString *q in arrTemp2)
        {
            NSArray *arrTemp3 = [[NSArray alloc] initWithArray:[q componentsSeparatedByString:@"|"]];
            Question *question = [[Question alloc] init];
            
            question.qCode = [arrTemp3 objectAtIndex:1];
            question.qTitle = [arrTemp3 objectAtIndex:0];

            [DataAdapters addQuestionToList:question];
            done = YES;
            [question release];
            [arrTemp3 release];
        }
        [arrTemp1 release];
        [arrTemp2 release];
        processType = @"questionairelist";
    }
    //parse messages if return xml contains the tag <messages>
    else if([currentElement isEqualToString:@"messages"])
    {
        //******need to be finished********
        processType = @"messages";
        done = YES;
    }
    
}

@end
