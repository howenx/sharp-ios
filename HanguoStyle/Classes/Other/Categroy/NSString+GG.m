//
//  NSString+GG.m
//  GiftGuide
//
//  Created by qianfeng on 15-8-18.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "NSString+GG.h"
#define NUMBERS @"0123456789"
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@implementation NSString (GG)

- (float) heightWithFont: (UIFont *)font withinWidth: (float)width
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName: font}
                                         context:nil];
    
    return  textRect.size.height;
}
- (float) widthWithFont: (UIFont *)font
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize)
                                         options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    return textRect.size.width;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}
//+ (BOOL) isEmptyString:(NSString *)string {
//
//}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+ (BOOL) isNSNull:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}
//校验只能输入汉字，字母，数字
+ (BOOL)isNumAndLetterAndChinese:(NSString *)string

{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]*";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:string];
}
+ (BOOL) isNum:(NSString *)string{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}
+ (BOOL)isNumAndLetter:(NSString *)string

{

    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

@end
