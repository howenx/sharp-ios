//
//  UIBarButtonItem+GG.h
//  GiftGuide
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (GG)
/**
 *  快速创建一个显示图片的item
 *
 *  @param action   监听方法
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;
+ (instancetype)itemWithImage:(NSString *)image
                    highImage:(NSString *)highImage
                       target:(id)target
                       action:(SEL)action;
@end
