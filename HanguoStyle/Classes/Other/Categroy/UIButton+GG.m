//
//  UIButton+GG.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/5.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "UIButton+GG.h"

@implementation UIButton (GG)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
//    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12]];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              0.0,
                                              0.0,
                                              0.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(10.0,
                                              0.0,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}
@end
