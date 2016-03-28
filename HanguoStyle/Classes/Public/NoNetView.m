//
//  NoNetView.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "NoNetView.h"

@implementation NoNetView
-(id)initWithFrame :(CGRect)rect{
    if (self = [super initWithFrame:rect]) {
        UIView * _bgView = [[UIView alloc]initWithFrame:rect];
        _bgView.backgroundColor = GGColor(244, 244, 244);
        UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH-200)/2, 150, 200, 200)];
        bgImageView.image = [UIImage imageNamed:@"icon-duanwang"];
        
        
        UIButton * bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bgButton.frame = CGRectMake((GGUISCREENWIDTH-80)/2, bgImageView.height + bgImageView.y + 20, 80, 30) ;
        bgButton.backgroundColor = [UIColor lightGrayColor];
        [bgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bgButton setTitle:@"重新加载" forState:UIControlStateNormal];
        bgButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [bgButton.layer setMasksToBounds:YES];
        [bgButton.layer setCornerRadius:3.0];
        [bgButton addTarget:self  action:@selector(bgButtonClick)  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgView];
        [self addSubview:bgButton];
        [self addSubview:bgImageView];
        
    }
    return self;
}

-(void)bgButtonClick{
    if([PublicMethod isConnectionAvailable]){
        [self.delegate backController];
        [self removeFromSuperview];
    }
}
@end
