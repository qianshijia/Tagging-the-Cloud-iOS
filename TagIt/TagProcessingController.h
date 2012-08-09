//
//  TagProcessingController.h
//  TagIt
//
//  Created by Shijia Qian on 8/01/12.
//  Copyright (c) 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TagProcessDelegate <NSObject>
@optional
-(void)finishProcessingWithError;
@end

@interface TagProcessingController : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *xmlParser;
    NSString *currentElement; 
    BOOL done, timeout;
    NSString *processType;
    id<TagProcessDelegate> delegate;
}

@property (nonatomic, retain) NSXMLParser *xmlParser;
@property BOOL done, timeout;
@property (nonatomic, retain) id<TagProcessDelegate> delegate;

- (NSString *)processTag:(NSString *)tag;


@end
