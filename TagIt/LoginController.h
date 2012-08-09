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

@interface LoginController : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *xmlParser;
    NSString *currentElement;
    LoginInfo *login;
    BOOL timeout;
}

@property (nonatomic, retain) NSXMLParser *xmlParser;
@property BOOL timeout;

- (void)login:(NSString *)userName password:(NSString *)passWord;

@end
