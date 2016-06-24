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
    gap = GGUISCREENWIDTH/2+58;
    self.backgroundColor = GGBgColor;
    CGRect rect = CGRectMake(0, 0, GGUISCREENWIDTH, 0);
    
    for(int i = 1;i <= pushArray.count; i++){
        UIView * view = [self createGoodsView:((GoodsShowData*)pushArray[i-1])];
        view.backgroundColor = [UIColor whiteColor];
        if(i%2!=0){
            view.frame = CGRectMake(0, (ceilf([NSString stringWithFormat: @"%d",i].floatValue/2)-1) * gap, GGUISCREENWIDTH/2, gap);
        }else{
            view.frame = CGRectMake(GGUISCREENWIDTH/2, (ceilf([NSString stringWithFormat: @"%d",i].floatValue/2)-1) * gap, GGUISCREENWIDTH/2, gap);
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
    
    float viewW = GGUISCREENWIDTH/2;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewW, gap)];
    
    UIView* leftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, gap)];
    leftView.backgroundColor = GGBgColor;
    [view addSubview:leftView];
    
    UIView* rightView =[[UIView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH/2-5, 0, 5, gap)];
    rightView.backgroundColor = GGBgColor;
    [view addSubview:rightView];
    
    
    UIImageView * goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, viewW-10, viewW-10)];
    goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:showData.itemImg]];
    [view addSubview:goodsImageView];
    
    
//    UIView* lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 156, GGUISCREENWIDTH/2, 1)];
//    lineView.backgroundColor = GGBgColor;
//    [view addSubview:lineView];
    
    UILabel  * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, goodsImageView.height +4, viewW-20, 32)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.numberOfLines = 2;
    titleLabel.text = showData.itemTitle;
    [view addSubview:titleLabel];
    
    
    UILabel  * moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.y+titleLabel.height + 6, 100, 21)];
    moneyLab.font = [UIFont systemFontOfSize:14];
    moneyLab.textColor = GGMainColor;
    moneyLab.numberOfLines = 1;
    moneyLab.text = [NSString stringWithFormat:@"￥ %@",showData.itemPrice];
    [view addSubview:moneyLab];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, moneyLab.y + moneyLab.height, viewW, 5)];
    bottomView.backgroundColor = GGBgColor;
    [view addSubview:bottomView];
    
    
    
    if([showData.itemType isEqualToString:@"pin"]){
        
        UIImageView * pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 140, 29)];
        [pinImageView setImage:[UIImage imageNamed:@"biaoqian"]];
        [view addSubview:pinImageView];
        
        UILabel  * _pinTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(24, 6, 98, 21)];
        _pinTimeLab.font = [UIFont systemFontOfSize:9];
        _pinTimeLab.textColor = [UIColor whiteColor];
        _pinTimeLab.numberOfLines = 1;
        [view addSubview:_pinTimeLab];
        
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
            
            
            UIView* willSaleView =[[UIView alloc]initWithFrame:CGRectMake(5, 0, GGUISCREENWIDTH/2-10, gap)];
            willSaleView.backgroundColor = [UIColor blackColor];
            willSaleView.alpha = 0.5;
            [view addSubview:willSaleView];
            
            UIImageView * willSaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (willSaleView.height - 54)/2, willSaleView.width, 54)];
            willSaleImageView.contentMode =UIViewContentModeScaleAspectFit;
            [willSaleImageView setImage:[UIImage imageNamed:@"yushou"]];
            [willSaleView addSubview:willSaleImageView];

            
            
        }else{
            _pinTimeLab.text  = @"此团拼购已结束";
            UILabel * _saleOutLab = [[UILabel alloc]initWithFrame:CGRectMake((view.width-66)/2, (view.height-66)/2, 66, 66)];
            _saleOutLab.font = [UIFont systemFontOfSize:13];
            _saleOutLab.textColor = [UIColor whiteColor];
            _saleOutLab.textAlignment = NSTextAlignmentCenter;
            _saleOutLab.backgroundColor = GGColor(111, 113, 121);
            _saleOutLab.alpha = 0.7;
            [_saleOutLab.layer setCornerRadius:33];
            [_saleOutLab.layer setMasksToBounds:YES];
            _saleOutLab.text = @"已结束";
            [view addSubview:_saleOutLab];
            
        }
    }else{
        if([@"P" isEqualToString: showData.state]){
            
            UIView* willSaleView =[[UIView alloc]initWithFrame:CGRectMake(5, 0, GGUISCREENWIDTH/2-10, gap)];
            willSaleView.backgroundColor = [UIColor blackColor];
            willSaleView.alpha = 0.5;
            [view addSubview:willSaleView];
            
            UIImageView * willSaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (willSaleView.height - 54)/2, willSaleView.width, 54)];
            willSaleImageView.contentMode =UIViewContentModeScaleAspectFit;
            [willSaleImageView setImage:[UIImage imageNamed:@"yushou"]];
            [willSaleView addSubview:willSaleImageView];
            
        }else if(![@"Y" isEqualToString: showData.state]&&![@"P" isEqualToString: showData.state]){// 状态  'Y'--正常,'D'--下架,'N'--删除,'K'--售空，'P'--预售
            UILabel * _saleOutLab = [[UILabel alloc]initWithFrame:CGRectMake((view.width-66)/2, (view.height-66)/2, 66, 66)];
            _saleOutLab.font = [UIFont systemFontOfSize:13];
            _saleOutLab.textColor = [UIColor whiteColor];
            _saleOutLab.textAlignment = NSTextAlignmentCenter;
            _saleOutLab.backgroundColor = GGColor(111, 113, 121);
            _saleOutLab.alpha = 0.7;
            [_saleOutLab.layer setCornerRadius:33];
            [_saleOutLab.layer setMasksToBounds:YES];
            _saleOutLab.text = @"已抢光";
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
