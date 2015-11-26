//
//  DetailThreeCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "DetailThreeCell.h"
#import "HSGlobal.h"
@interface DetailThreeCell ()
@property (nonatomic,strong)NSArray * nameArray;
@end
@implementation DetailThreeCell
- (void)setData:(GoodsDetailData *)data{

    _nameArray = data.publicity;
    [self createView:_nameArray];

}
-(void)createView :(NSArray *)array{
    CGRect rect = CGRectMake(10, 0, 0, 0);
    for(int i = 0;i<array.count;i++){
        
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = array[i];
        label.numberOfLines = 0;
        CGSize size  = [HSGlobal getSize:array[i] Font:12 Width:GGUISCREENWIDTH-20 Height:100];
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
@end
