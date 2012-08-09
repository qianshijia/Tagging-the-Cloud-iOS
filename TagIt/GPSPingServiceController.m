//
//  GPSPingServiceController.m
//  TagIt
//
//  Created by Shijia Qian on 13/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import "GPSPingServiceController.h"
#import "TagitUtil.h"
#import "DataAdapters.h"
#import "QuestionDetail.h"

@implementation GPSPingServiceController

@synthesize locManager;
@synthesize lat;
@synthesize lon;
@synthesize alt;
@synthesize gpsTime;
@synthesize xmlParser;
@synthesize done;

+ (GPSPingServiceController *)getSingletonInstance
{
    static GPSPingServiceController *instance;
    @synchronized(self) 
    {
        if(!instance)
        {
            instance = [[GPSPingServiceController alloc] init];
        }
    }
    return instance;
}

- (void)runGPSPingService
{
    done = NO;
    if(self.locManager != nil)
    {
        howManyUpdates = 0;
        [self.locManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.lat = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    self.lon = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    self.alt = [NSString stringWithFormat:@"%f", newLocation.altitude];
    self.gpsTime = [NSString stringWithFormat:@"%f", [[newLocation timestamp] timeIntervalSince1970]];
//    NSLog(@"Lat:%@", self.lat);
//    NSLog(@"Long:%@", self.lon);
//    NSLog(@"Alt:%@", self.alt);
//    NSLog(@"Time:%@", self.gpsTime);
    if(howManyUpdates == 0)
    {
        [self sendCoordToServer];
        howManyUpdates++;
    }
    [self.locManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"LocationManager didFailWithError: %@", [error localizedDescription]);
}

- (void)sendCoordToServer
{
    UIDevice *device = [[UIDevice alloc] init];
    NSString *imei = [device uniqueIdentifier];
    [device release];
    
    NSString *gmtTime = [TagitUtil getTime];
    NSString *token = [DataAdapters getLogin].token;
    
    NSString *hash = [TagitUtil md5:[NSString stringWithFormat:@"%@%@%@", imei, gmtTime, token]];
    
    NSString *postString = [NSString stringWithFormat:
                            @"lat=%@&long=%@&alt=%@&imei=%@&timestamp=%@&md5=%@&gpsTime=%@&token=%@&uid=", self.lat, self.lon, self.alt, imei, gmtTime, hash, self.gpsTime, token];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:NSLocalizedString(@"GPSPingUrl", nil)]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseDetail = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseDetail);
    [responseDetail release];
    
    xmlParser = [[NSXMLParser alloc] initWithData:responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
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
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([currentElement isEqualToString:@"question"])
    {
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
    if([currentElement isEqualToString:@"questionairelist"])
    {
        NSArray *arrTemp1 = [string componentsSeparatedByString:@"^^"];
        NSArray *arrTemp2 = [[arrTemp1 objectAtIndex:1] componentsSeparatedByString:@"^"];
        for(NSString *q in arrTemp2)
        {
            NSArray *arrTemp3 = [q componentsSeparatedByString:@"|"];
            Question *question = [[Question alloc] init];
            
            question.qCode = [arrTemp3 objectAtIndex:1];
            question.qTitle = [arrTemp3 objectAtIndex:0];
            
            [DataAdapters addQuestionToList:[question retain]];
            [question release];
        }
    }
    done = YES;
}

-(void)dealloc
{
    [xmlParser release];
    [super dealloc];
}

@end
