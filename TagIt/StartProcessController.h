//
//  StartProcessController.h
//  TagIt
//
//  Created by Shijia Qian on 15/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionDetail.h"

@interface StartProcessController : NSObject<NSXMLParserDelegate>
{
    BOOL done, timeout;
    NSXMLParser *xmlParser;
    NSString *currentElement;
}

@property BOOL done, timeout;
@property (nonatomic, retain) NSXMLParser *xmlParser;

- (void)startProcess:(NSString *)qCode;

@end
