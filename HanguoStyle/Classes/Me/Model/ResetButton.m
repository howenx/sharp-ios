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
    
    return CGRectMake(15, 0, 200, contentRect.size.height);
    
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect

{

    return CGRectMake(GGUISCREENWIDTH-28, 14, 13, 13);
    
}
@end
