//
//  QuestionProcessingController.h
//  TagIt
//
//  Created by Shijia Qian on 25/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionDetail.h"
#import "ASIHTTPRequestDelegate.h"
@class ASIFormDataRequest;

@protocol QuestionProcessDelegate <NSObject>
@optional
-(void)finishProcessWithError;
-(void)processFail;
@end

@interface QuestionProcessingController : NSObject<NSXMLParserDelegate, ASIHTTPRequestDelegate>
{
    NSXMLParser *xmlParser;
    NSString *currentElement; 
    BOOL done;
    NSString *currentView;
    QuestionDetail *qd;
    id<QuestionProcessDelegate> delegate;
}

@property (nonatomic, retain) NSXMLParser *xmlParser;
@property BOOL done;
@property (copy) NSString *currentView;
@property (nonatomic, retain) id<QuestionProcessDelegate> delegate;

- (void)processNextQuestion:(id)value;

@end
