//
//  DetailThreeCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "DetailThreeCell.h"
#import "ShowEvaluateViewController.h"
@interface DetailThreeCell ()
@property (nonatomic,strong)NSArray * nameArray;
@end
@implementation DetailThreeCell
- (void)setData:(GoodsDetailData *)data{
    _data = data;
    CGRect rect = CGRectMake(15, 0, 0, 0);
    
    //增加好评按钮
    if(data.remarkRate!=nil){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  GGUISCREENWIDTH, 40)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pjGesture)]];
        [self.contentView addSubview:view];
        UILabel * goodsPjLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 40)];
        goodsPjLab.text = [NSString stringWithFormat:@"商品评价  (%ld)",data.remarkCount];
        goodsPjLab.textColor = UIColorFromRGB(0x999999);
        goodsPjLab.font = [UIFont systemFontOfSize:15];
        [view addSubview:goodsPjLab];
        
        
        UILabel * hpLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-135, 0, 120, 40)];
        hpLab.textAlignment = NSTextAlignmentRight;
        hpLab.textColor = UIColorFromRGB(0x242424);
        NSString * rRate =  [NSString stringWithFormat:@"好评率%@%%",data.remarkRate];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:rRate];
        [str addAttribute:NSForegroundColorAttributeName value:GGMainColor range:NSMakeRange(3,rRate.length-3)];
        hpLab.attributedText = str;
        hpLab.font = [UIFont systemFontOfSize:15];
        [view addSubview:hpLab];
        

        
        //绘制脚步view
        UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, view.origin.y + view.size.height, GGUISCREENWIDTH, 10)];
        footView.backgroundColor = GGBgColor;
        [self.contentView addSubview:footView];
        
        rect = footView.frame;

    }
    
    if([self.delegate respondsToSelector:@selector(getThreeCellH:)]){
        [self.delegate getThreeCellH:(rect.origin.y + rect.size.height)];
    }


}
-(void)pjGesture{
    UIViewController * controller = [self getCurrentVC];
    
    ShowEvaluateViewController * vc = [[ShowEvaluateViewController alloc]init];
    
    for(SizeData * sizeData in _data.sizeArray){
        
        if(sizeData.orMasterInv){
            vc.skuType = sizeData.skuType;
            vc.orderID = sizeData.skuTypeId;
        }
    }
    
    [(UINavigationController *)controller pushViewController:vc animated:YES];
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
