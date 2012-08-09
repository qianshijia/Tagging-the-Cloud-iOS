//
//  QuestionDetail.h
//  TagIt
//
//  Created by Shijia Qian on 4/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionDetail : NSObject
{
    NSString *answersetId;
    NSString *questionId;
    NSString *questionLabel;
    NSString *questionType;
    NSString *questionData;
    NSString *mediaLength;
    NSString *validationType;
    NSString *validationMsg;
    NSString *mediaData;
}

@property (copy) NSString *answersetId;
@property (copy) NSString *questionId;
@property (copy) NSString *questionLabel;
@property (copy) NSString *questionType;
@property (copy) NSString *questionData;
@property (copy) NSString *mediaLength;
@property (copy) NSString *validationType;
@property (copy) NSString *validationMsg;
@property (copy) NSString *mediaData;

@end
