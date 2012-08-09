//
//  DataAdapters.m
//  TagIt
//
//  Created by Shijia Qian on 1/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "DataAdapters.h"
#import "LoginInfo.h"
#import "Question.h"
#import "QuestionDetail.h"

static LoginInfo *login;
static NSMutableArray *questionList;
static QuestionDetail *questionDetail;
static NSString *processName;

@implementation DataAdapters

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (void)initialize
{
    login = nil;
    questionList = [[NSMutableArray alloc] init];
    questionDetail = nil;
}

//GET and SET logininfo
+ (void)setLogin:(LoginInfo *)loginInfo
{
    login = [loginInfo retain];
}

+ (LoginInfo *)getLogin
{
    return login;
}

+ (void)clearLogin
{
    login = nil;
}

//SET and GET question list
+ (void) addQuestionToList:(Question *)question
{
    [questionList addObject:question];
}

+ (NSMutableArray *) getQuestionList
{
    return questionList;
}

+ (void)clearQuestionList
{
    [questionList removeAllObjects];
}

//SET and GET the detail of a question
+ (void) setQuestionDetial:(QuestionDetail *)qd
{
    questionDetail = [qd retain];
}

+ (QuestionDetail *) getQuestionDetail
{
    return questionDetail;
}

+ (void) clearQuestionDetail
{
    questionDetail = nil;
}

+ (void)setProcessName:(NSString *)name
{
    processName = name;
}

+ (NSString *)getProcessName
{
    return processName;
}

+ (void)clearProcessName
{
    processName = nil;
}

+ (void)clearAll
{
    questionDetail = nil;
    questionList = nil;
    processName = nil;
}

- (void)dealloc
{
    [questionList release];
    [questionDetail release];
    [processName release];
    [super dealloc];
}

@end
