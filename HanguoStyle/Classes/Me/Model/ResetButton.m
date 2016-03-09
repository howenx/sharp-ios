//
//  ResetButton.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/15.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "ResetButton.h"

@implementation ResetButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect

{
    
    return CGRectMake(60, 0, 200, contentRect.size.height);
    
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect

{

    return CGRectMake(10, 10, 20, 20);
    
}
@end
