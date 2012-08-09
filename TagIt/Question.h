//
//  Question.h
//  TagIt
//
//  Created by Shijia Qian on 4/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
{
    NSString *qCode;
    NSString *qTitle;
}

@property (copy) NSString *qCode;
@property (copy) NSString *qTitle;

@end
