//
//  QuestionDetail.m
//  TagIt
//
//  Created by Shijia Qian on 4/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import "QuestionDetail.h"

@implementation QuestionDetail

@synthesize answersetId;
@synthesize questionId;
@synthesize questionLabel;
@synthesize questionType;
@synthesize questionData;
@synthesize mediaLength;
@synthesize validationType;
@synthesize validationMsg;
@synthesize mediaData;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
