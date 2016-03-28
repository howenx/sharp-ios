//
//  CALayer+XibConfiguration.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/24.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)
-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
