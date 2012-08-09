//
//  LoginController.h
//  TagIt
//
//  Created by Shijia Qian on 1/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginInfo.h"
@class ASIFormDataRequest;

@protocol LoginDelegate <NSObject>
@optional
-(void)finishProcessingWithError;
-(void)processFail;
@end

@interface LoginController : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *xmlParser;
    NSString *currentElement;
    LoginInfo *login;
    BOOL done;
    id<LoginDelegate> delegate;
}

@property (nonatomic, retain) NSXMLParser *xmlParser;
@property BOOL done;
@property (nonatomic, retain) id<LoginDelegate> delegate;

- (void)login:(NSString *)userName password:(NSString *)passWord;

@end
