//
//  UIImage+GG.h
//  GiftGuide
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GG)

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

//UIColor 转UIImage
+ (UIImage*) createImageWithColor: (UIColor*) color;
@end
