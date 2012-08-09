//
//  DataAdapters.h
//  TagIt
//
//  Created by Shijia Qian on 1/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginInfo.h"
#import "Question.h"
#import "QuestionDetail.h"

@interface DataAdapters : NSObject

+ (void) setLogin:(LoginInfo *)loginInfo;
+ (LoginInfo *) getLogin;
+ (void) clearLogin;

+ (void) addQuestionToList:(Question *)question;
+ (NSMutableArray *) getQuestionList;
+ (void)clearQuestionList;

+ (void) setQuestionDetial:(QuestionDetail *)qd;
+ (QuestionDetail *) getQuestionDetail;
+ (void) clearQuestionDetail;

+ (void)setProcessName:(NSString *)name;
+ (NSString *)getProcessName;
+ (void)clearProcessName;

+ (void)clearAll;

@end
