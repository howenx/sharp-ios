//
//  PhotoAndTextView.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/10.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "PhotoAndTextView.h"

@implementation PhotoAndTextView

-(UIView *) createPhotoTextView :(NSArray *)array {
    
    CGRect rect = CGRectMake(5, 0, GGUISCREENWIDTH-10, 0);
//    UIView * view = [[UIView alloc]init];
    for (int i = 0; i < array.count; i++)
    {
        UIImageView *imv = [[UIImageView alloc] init];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]];
        UIImage * image = [self imageCompressForWidth:[UIImage imageWithData:data] targetWidth:GGUISCREENWIDTH-10];
        imv.frame =  CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 5, image.size.width, image.size.height);
        imv.image = image;
        rect = imv.frame;
        [self addSubview:imv];
    }
    self.frame = CGRectMake(0, 0, GGUISCREENWIDTH, rect.origin.y +rect.size.height);
    return self;
}

//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

@end
