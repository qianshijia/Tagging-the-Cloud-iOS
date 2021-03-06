//
//  TagitUtil.h
//  TagIt
//
//  Created by Shijia Qian on 1/01/12.
//  Copyright 2012 UTAS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface TagitUtil : NSObject

+ (NSString *)getTime;
+ (NSString *)md5:(NSString *)str;
+ (UIColor *)getColor:(NSString *)hexColor;
+ (void)startQuestion:(UIViewController *)viewController;
+ (NSString *)getFilePath:(NSString *)fileName;
+ (void)playSound:(NSString *)fileName type:(NSString *)fileType;

@end
