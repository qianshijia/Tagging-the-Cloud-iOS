//
//  LoginController.m
//  TagIt
//
//  Created by Shijia Qian on 1/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "LoginController.h"
#import "TagitUtil.h"
#import "LoginInfo.h"
#import "DataAdapters.h"
#import "ASIFormDataRequest.h"

@implementation LoginController

@synthesize xmlParser;
@synthesize timeout;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)login:(NSString *)userName password:(NSString *)passWord
{
    timeout = NO;
    UIDevice *device = [[UIDevice alloc] init];
    NSString *imei = [device uniqueIdentifier];
    [device release];
    NSString *gmtTime = [TagitUtil getTime];
    NSString *hash = [TagitUtil md5:[NSString stringWithFormat:@"%@%@%@%@", userName, passWord, imei, gmtTime]];
    
    NSURL *url = [NSURL URLWithString:NSLocalizedString(@"LoginUrl", nil)];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:passWord forKey:@"password"];
    [request setPostValue:imei forKey:@"imei"];
    [request setPostValue:gmtTime forKey:@"timestamp"];
    [request setPostValue:hash forKey:@"md5"];
    [request setDelegate:self];
    [request setTimeOutSeconds:10];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request startSynchronous];
    
    NSData *responseData = [request responseData];
    NSLog(@"%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
    
    self.xmlParser = [[[NSXMLParser alloc] initWithData:responseData] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", @"login thread fail");
    timeout = YES;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"ret"])
    {
        login = [[LoginInfo alloc] init];
        currentElement = @"ret";
    }
    
    if([elementName isEqualToString:@"validLogin"])
    {
        currentElement = @"validLogin";
    }
    
    if([elementName isEqualToString:@"retMessage"])
    {
        currentElement = @"retMessage";
    }
    
    if([elementName isEqualToString:@"token"])
    {
        currentElement = @"token";
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([currentElement isEqualToString:@"validLogin"])
    {
        login.validLogin = string;
    }
    
    if([currentElement isEqualToString:@"retMessage"])
    {
        login.retMessage = string;
    }
    
    if([currentElement isEqualToString:@"token"])
    {
        login.token = string;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [DataAdapters setLogin:login];
}

-(void)dealloc
{
    [login release];
    [xmlParser release];
    [currentElement release];
    [super dealloc];
}
@end
