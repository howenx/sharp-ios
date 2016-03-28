//
//  PhotoAndTextView.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/10.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"

@interface PhotoAndTextView : UIView
-(UIView *) createPhotoTextView :(NSArray *)array andNotice :(NSString *)notice ;


-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
