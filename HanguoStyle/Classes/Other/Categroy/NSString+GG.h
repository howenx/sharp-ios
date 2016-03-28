//
//  NSString+GG.h
//  GiftGuide
//
//  Created by qianfeng on 15-8-18.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (GG)

- (float) heightWithFont: (UIFont *)font withinWidth: (float)width;
- (float) widthWithFont: (UIFont *)font;
+ (NSString *)md5:(NSString *)str;
+ (BOOL) isBlankString:(NSString *)string;
+ (BOOL) isNumAndLetterAndChinese:(NSString *)string;
+ (BOOL) isNum:(NSString *)string;
+ (BOOL)isNumAndLetter:(NSString *)string;
+ (BOOL) isNSNull:(NSString *)string;
@end
