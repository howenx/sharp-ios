//
//  UIView+frame.h
//  NSOperationQueueDemo
//
//  Created by vera on 15/7/31.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

/**
 设置x坐标
 */
- (void)setX:(CGFloat)x;

/**
 获取x坐标
 */
- (CGFloat)x;

/**
 设置y坐标
 */
- (void)setY:(CGFloat)y;

/**
 获取y坐标
 */
- (CGFloat)y;


@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

/**
 设置width
 */
- (void)setWidth:(CGFloat)width;

/**
 获取width
 */
- (CGFloat)width;

/**
 设置height
 */
- (void)setHeight:(CGFloat)height;

/**
 获取height
 */
- (CGFloat)height;

/**
 设置size
 */
- (void)setSize:(CGSize)size;
/**
 获取size
 */
- (CGSize)size;

/**
 设置origin
 */
- (void)setOrigin:(CGPoint)origin;
/**
 获取origin
 */
- (CGPoint)origin;

@end
