//
//  LoginInfo.h
//  TagIt
//
//  Created by Shijia Qian on 1/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfo : NSObject
{
    NSString *validLogin;
    NSString *retMessage;
    NSString *token;
}

@property (copy) NSString *validLogin;
@property (copy) NSString *retMessage;
@property (copy) NSString *token;

@end
