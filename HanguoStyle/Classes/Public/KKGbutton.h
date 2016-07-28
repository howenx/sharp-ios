//
//  KKGbutton.h
//  HanguoStyle
//
//  Created by wayne on 16/7/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKGbutton : UIButton
- (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)size imageAndTitleSpaceing:(CGFloat)spaceing baifenbi:(CGFloat)baifenbi;
@property (nonatomic) CGFloat imageAndTitleSpaceing;
@property (nonatomic) CGFloat baifebi;
@property (nonatomic) CGFloat fontSize;
@end
