//
//  DetailThreeCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "DetailThreeCell.h"

@implementation DetailThreeCell
- (void)setData:(ThreeViewData *)data{
     NSArray * nameArray = @[@"【折扣】7.3折优惠",@"【满减】订单满99元减10元",@"【包邮】99元包邮",@"【新户】注册立减160元"];
    [self createView:nameArray];

}
-(void)createView :(NSArray *)array{
    CGRect rect = CGRectMake(10, 0, 0, 0);
    for(int i = 0;i<array.count;i++){
        
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = array[i];
        label.numberOfLines = 0;
        CGSize size  = [self getSize:array[i] Font:12 Width:GGUISCREENWIDTH-20 Height:100];
        label.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 10, size.width, size.height);
        rect = label.frame;
        [self.contentView addSubview:label];
    }
    //绘制脚步view
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height + 10, GGUISCREENWIDTH, 8)];
    footView.backgroundColor = GGColor(234, 234, 234);
    [self.contentView addSubview:footView];
    if([self.delegate respondsToSelector:@selector(getThreeCellH:)]){
        [self.delegate getThreeCellH:(footView.frame.origin.y + footView.frame.size.height)];
    }
}
-(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeofstr]} context:nil].size;
    }
    else
    {
        size = [str sizeWithFont:[UIFont systemFontOfSize:sizeofstr]constrainedToSize:CGSizeMake(width, height)];
    }
    return size;
}

@end
