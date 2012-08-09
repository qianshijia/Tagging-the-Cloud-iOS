//
//  GPSPingServiceController.h
//  TagIt
//
//  Created by Shijia Qian on 13/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GPSPingServiceController : NSObject <CLLocationManagerDelegate, NSXMLParserDelegate>
{
    CLLocationManager *locManager;
    NSString *lat;
    NSString *lon;
    NSString *alt;
    NSString *gpsTime;
    
    NSXMLParser *xmlParser;
    NSString *currentElement;
    
    bool done;
    int howManyUpdates;
}

@property (nonatomic, retain) CLLocationManager *locManager;
@property (copy) NSString *lat;
@property (copy) NSString *lon;
@property (copy) NSString *alt;
@property (copy) NSString *gpsTime;
@property (nonatomic, retain) NSXMLParser *xmlParser;
@property bool done;

+ (GPSPingServiceController *)getSingletonInstance;
- (void)runGPSPingService;
- (void)sendCoordToServer;

@end
