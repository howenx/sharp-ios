//
//  BestSaleView.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/18.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BestSaleView.h"
#import "GoodsShowData.h"
#import "PinGoodsDetailViewController.h"
#import "GoodsDetailViewController.h"
@interface BestSaleView ()
{
    NSArray * array;
    float gap;
}
@end
@implementation BestSaleView

-(void)createBestSale:(NSArray *)pushArray{
    array = pushArray;
    gap = 215;
    self.backgroundColor = GGBgColor;
    CGRect rect = CGRectMake(0, 0, GGUISCREENWIDTH, 0);
    
    for(int i = 1;i <= pushArray.count; i++){
        UIView * view = [self createGoodsView:((GoodsShowData*)pushArray[i-1])];
        view.backgroundColor = [UIColor whiteColor];
        if(i%2!=0){
            view.frame = CGRectMake(5, (ceilf([NSString stringWithFormat: @"%d",i].floatValue/2)-1) * gap, (GGUISCREENWIDTH-15)/2, gap);
        }else{
            view.frame = CGRectMake((GGUISCREENWIDTH-15)/2+10, (ceilf([NSString stringWithFormat: @"%d",i].floatValue/2)-1) * gap, (GGUISCREENWIDTH-15)/2, gap);
        }
        NSLog(@"%f  %f  %f   %f",view.x,view.y,view.width,view.height);
        view.tag = 43000+i-1;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)]];
        rect = view.frame;
        [self addSubview:view];
    }
    self.frame = CGRectMake(GGUISCREENWIDTH*2, 0, GGUISCREENWIDTH, rect.origin.y +rect.size.height);
    if(self.height<GGUISCREENHEIGHT-64-40){
        self.height = GGUISCREENHEIGHT-64-40;
    }
}
-(UIView *)createGoodsView:(GoodsShowData*)showData{
    
    float viewW = (GGUISCREENWIDTH-15)/2;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewW, gap)];
    
    
    UIImageView * goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, 155)];
    goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:showData.itemImg]];
    [view addSubview:goodsImageView];
    
    UILabel  * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 157, viewW-10, 30)];
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.numberOfLines = 2;
    titleLabel.text = showData.itemTitle;
    [view addSubview:titleLabel];
    
    
    UILabel  * moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 189, 100, 21)];
    moneyLab.font = [UIFont systemFontOfSize:14];
    moneyLab.textColor = GGMainColor;
    moneyLab.numberOfLines = 1;
    moneyLab.text = [NSString stringWithFormat:@"￥ %.2f",showData.itemPrice];
    [view addSubview:moneyLab];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 210, viewW, 5)];
    bottomView.backgroundColor = GGBgColor;
    [view addSubview:bottomView];
    
    
    
    if([showData.itemType isEqualToString:@"pin"]){
        
        UIView * _pinFlagView = [[UIView alloc]initWithFrame:CGRectMake(2, 2, 145, 30)];
        _pinFlagView.backgroundColor = GGMainColor;
        _pinFlagView.alpha = 0.8;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_pinFlagView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _pinFlagView.bounds;
        maskLayer.path = maskPath.CGPath;
        _pinFlagView.layer.mask = maskLayer;
        [view addSubview:_pinFlagView];
        
        UIImageView * pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 26, 26)];
        [pinImageView setImage:[UIImage imageNamed:@"hmm_klmpintuan"]];
        [view addSubview:pinImageView];
        
        UILabel  * _pinTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(28, 4, 117, 21)];
        _pinTimeLab.font = [UIFont systemFontOfSize:10];
        _pinTimeLab.textColor = [UIColor whiteColor];
        _pinTimeLab.numberOfLines = 1;
        [_pinFlagView addSubview:_pinTimeLab];
        //在售
        if([@"Y" isEqualToString: showData.state]){
            //2016-01-30 17:16:55
            int month= [[showData.endAt substringWithRange:NSMakeRange(5,2)] intValue];
            int day= [[showData.endAt substringWithRange:NSMakeRange(8,2)] intValue];
            int hour= [[showData.endAt substringWithRange:NSMakeRange(11,2)] intValue];
            int minute= [[showData.endAt substringWithRange:NSMakeRange(14,2)] intValue];
            
            NSString * strTime = [NSString stringWithFormat:@"截止到%d月%d日 %d:%d",month,day,hour,minute];
            _pinTimeLab.text  = strTime;
        }else if([@"P" isEqualToString: showData.state]){//预售
            int month= [[showData.startAt substringWithRange:NSMakeRange(5,2)] intValue];
            int day= [[showData.startAt substringWithRange:NSMakeRange(8,2)] intValue];
            int hour= [[showData.startAt substringWithRange:NSMakeRange(11,2)] intValue];
            int minute= [[showData.startAt substringWithRange:NSMakeRange(14,2)] intValue];
            
            NSString * strTime = [NSString stringWithFormat:@"开始于%d月%d日 %d:%d",month,day,hour,minute];
            _pinTimeLab.text  = strTime;
        }else{
            _pinFlagView.frame = CGRectMake(2, 2, 70, 30);
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_pinFlagView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _pinFlagView.bounds;
            maskLayer.path = maskPath.CGPath;
            _pinFlagView.layer.mask = maskLayer;
            NSString * strTime = @"已结束";
            _pinTimeLab.text  = strTime;
        }
    }else{
        if(![@"Y" isEqualToString: showData.state]&&![@"P" isEqualToString: showData.state]){// 状态  'Y'--正常,'D'--下架,'N'--删除,'K'--售空，'P'--预售
            UILabel * _saleOutLab = [[UILabel alloc]initWithFrame:CGRectMake(87, 88, 67, 35)];
            _saleOutLab.font = [UIFont systemFontOfSize:17];
            _saleOutLab.textColor = [UIColor whiteColor];
            _saleOutLab.backgroundColor = GGColor(111, 113, 121);
            _saleOutLab.text = @"已售完";
            [view addSubview:_saleOutLab];
        }
    }
    return view;
}
-(void) touchUpInside:(UITapGestureRecognizer *)recognizer{
    NSInteger tag = recognizer.view.tag - 43000;
    UIViewController * controller = [self getCurrentVC];
    NSString * itemType = ((GoodsShowData*)array[tag]).itemType;
    NSString * _pushUrl = ((GoodsShowData*)array[tag]).itemUrl;
    if ([@"pin" isEqualToString:itemType]) {
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = _pushUrl;
        [(UINavigationController *)controller pushViewController:pinViewController animated:YES];
    }else{
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = _pushUrl;
        [(UINavigationController *)controller pushViewController:gdViewController animated:YES];
    }

}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    UITabBarController *tab = (UITabBarController *)result;
    return tab.selectedViewController;
}
@end
