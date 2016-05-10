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
    CGRect rect = CGRectMake(10, 0, 0, 0);
    if(data.publicity!=nil){
        
        for(int i = 0;i<data.publicity.count;i++){
            
            UILabel * label = [[UILabel alloc]init];
            label.textColor = [UIColor orangeColor];
            label.font = [UIFont systemFontOfSize:12];
            label.text = data.publicity[i];
            label.numberOfLines = 0;
            CGSize size  = [PublicMethod getSize:data.publicity[i] Font:12 Width:GGUISCREENWIDTH-20 Height:100];
            label.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 10, size.width, size.height);
            rect = label.frame;
            [self.contentView addSubview:label];
        }
        
        //绘制脚步view
        UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height + 10, GGUISCREENWIDTH, 8)];
        footView.backgroundColor = GGBgColor;
        [self.contentView addSubview:footView];
        rect = footView.frame;
    }

    
    //增加好评按钮
    if(data.remarkRate!=nil){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height,  GGUISCREENWIDTH, 30)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pjGesture)]];
        [self.contentView addSubview:view];
        UILabel * goodsPjLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
        goodsPjLab.text = [NSString stringWithFormat:@"商品评价(%ld)",data.remarkCount];
        goodsPjLab.textColor = UIColorFromRGB(0x333333);
        goodsPjLab.font = [UIFont systemFontOfSize:12];
        [view addSubview:goodsPjLab];
        
        
        UILabel * hpLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-150, 0, 120, 30)];
        hpLab.textAlignment = NSTextAlignmentRight;
        hpLab.text = [NSString stringWithFormat:@"好评率(%@%%)",data.remarkRate];
        hpLab.textColor = UIColorFromRGB(0x333333);
        hpLab.font = [UIFont systemFontOfSize:12];
        [view addSubview:hpLab];
        
        
        UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PosXFromView(hpLab, 10), (30-12)/2, 10, 12)];
        iconImageView.image = [UIImage imageNamed:@"fanye"];
        [view addSubview:iconImageView];
        

        rect = view.frame;
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
