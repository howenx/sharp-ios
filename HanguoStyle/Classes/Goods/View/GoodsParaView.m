//
//  GoodsParaView.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/18.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsParaView.h"

//view 的高度
#define gap 40
@implementation GoodsParaView

-(void)createParaView:(NSDictionary *)dict{
    NSArray * keyArray = [dict allKeys];

    CGRect rect = CGRectMake(0, 0, GGUISCREENWIDTH, 0);
    
    for(int i = 0;i < keyArray.count; i++){
        UIView * view = [self createMsgViewWithKey:keyArray[i] andValue:[dict objectForKey:keyArray[i]]];
        view.frame = CGRectMake(0, i * gap, GGUISCREENWIDTH, gap);
        rect = view.frame;
        [self addSubview:view];
    }
    self.frame = CGRectMake(GGUISCREENWIDTH, 0, GGUISCREENWIDTH, rect.origin.y +rect.size.height);
    if(self.height<GGUISCREENHEIGHT-64-40){
        self.height = GGUISCREENHEIGHT-64-40;
    }
    
}
-(UIView *)createMsgViewWithKey:(NSString *)key andValue:(NSString *)value{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, gap)];
    UILabel * keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 90, gap)];
    keyLabel.textAlignment = NSTextAlignmentLeft;
    keyLabel.text = key;
    keyLabel.numberOfLines = 1;
    keyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    keyLabel.textColor = UIColorFromRGB(0x999999);
    keyLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:keyLabel];
    
    UILabel * valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 0, GGUISCREENWIDTH - 95 - 20, gap)];
    valueLabel.textAlignment = NSTextAlignmentLeft;
    valueLabel.font = [UIFont systemFontOfSize:15];
    valueLabel.numberOfLines = 1;
    valueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    valueLabel.textColor = UIColorFromRGB(0x242424);
    valueLabel.text = value;
    [view addSubview:valueLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(10, gap, GGUISCREENWIDTH - 20, 1)];
    line.backgroundColor = GGBgColor;
    [view addSubview:line];
    return view;
    
}
@end
