//
//  MiPwdView.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//
#import "AppDelegate.h"
#import "MiPwdView.h"
#import "GoodsDetailViewController.h"
#import "PinDetailViewController.h"
#import "PinGoodsDetailViewController.h"
#import "PinDetailData.h"
#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface MiPwdView ()
{
    NSString * detailStr;
    UIImageView * imageView;
    UILabel * priceLab;
}
@end

@implementation MiPwdView



- (instancetype)initWithDetail :(NSString *)detail{
    detailStr = detail;
    if ((self = [super initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)])) {
        [self setCenter:APPDELEGATE.window.center];
        [self setClipsToBounds:NO];
        
        //背景
        UIView * overlayView = [[UIView alloc] initWithFrame:APPDELEGATE.window.frame];
        [overlayView setBackgroundColor:[UIColor blackColor]];
        [overlayView setAlpha:0.3];
        [self addSubview:overlayView];
        
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(20,200 ,GGUISCREENWIDTH-40, 200)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        
        
        
        
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,GGUISCREENWIDTH-40, 40)];
        titleLab.backgroundColor = GGBgColor;
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor blackColor];
        titleLab.text = @"秘口令";
        [view addSubview:titleLab];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 70, 90)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        [self addSubview:view];
        
        NSArray *arry1=[detail componentsSeparatedByString:@"【"];
        if(arry1.count >1){
            NSArray *arry2=[arry1[1] componentsSeparatedByString:@"】"];
            if(arry2.count>0){
                UILabel * detailLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 50,GGUISCREENWIDTH-60-80, 70)];
                detailLab.textAlignment = NSTextAlignmentLeft;
                detailLab.font = [UIFont systemFontOfSize:12];
                detailLab.numberOfLines = 4;
                detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
                detailLab.textColor = [UIColor grayColor];
                detailLab.text = arry2[0];
                [view addSubview:detailLab];

            }
        }
        
        
        
        
        priceLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 125,GGUISCREENWIDTH-60-80, 15)];
        priceLab.textAlignment = NSTextAlignmentLeft;
        priceLab.font = [UIFont systemFontOfSize:12];
        priceLab.textColor = GGMainColor;
        priceLab.numberOfLines = 1;
        priceLab.lineBreakMode = NSLineBreakByTruncatingTail;
        [view addSubview:priceLab];

        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, GGUISCREENWIDTH-40, 1)];
        lineView.backgroundColor = GGBgColor;
        [view addSubview:lineView];

        
        
        UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(0, 151, (GGUISCREENWIDTH-40)/2, 49) ;
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancleBtn addTarget:self  action:@selector(cancleBtnClick)  forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancleBtn];
        
        
        
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake((GGUISCREENWIDTH-40)/2, 151, (GGUISCREENWIDTH-40)/2, 49) ;
        sureBtn.backgroundColor = GGMainColor;
        
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [sureBtn addTarget:self  action:@selector(sureBtnClick)  forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sureBtn];

       
        
        [APPDELEGATE.window addSubview:self];
    }
    
    [self prepareDataSource];
    return self;
}
-(void)cancleBtnClick{
     [self removeFromSuperview];
}
-(void)sureBtnClick{
    [self removeFromSuperview];
    UIViewController * controller = [self getCurrentVC];

    NSArray  * array= [detailStr componentsSeparatedByString:@"】,"];
    NSArray * jumpArray = [[[array objectAtIndex:[array count]-1] componentsSeparatedByString:@"－"][0] componentsSeparatedByString:@"https://style.hanmimei.com"];
    

    if ([detailStr rangeOfString:@"<C>"].location != NSNotFound) {
        //进入普通商品详情页
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = [NSString stringWithFormat:@"%@/comm%@",[HSGlobal shareGoodsHeaderUrl],jumpArray[1]];
        [(UINavigationController *)controller pushViewController:gdViewController animated:YES];
    }else if ([detailStr rangeOfString:@"<P>"].location != NSNotFound) {
        //进入拼购商品详情页
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = [NSString stringWithFormat:@"%@/comm%@",[HSGlobal shareGoodsHeaderUrl],jumpArray[1]];

        [(UINavigationController *)controller pushViewController:pinViewController animated:YES];
    }else if ([detailStr rangeOfString:@"<T>"].location != NSNotFound) {
        //进入拼团详情页
        PinDetailViewController * detailVC = [[PinDetailViewController alloc]init];
        detailVC.url = [NSString stringWithFormat:@"%@/promotion%@",[HSGlobal shareTuanHeaderUrl],jumpArray[1]];
        [(UINavigationController *)controller pushViewController:detailVC animated:YES];
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


-(void)prepareDataSource
{
    
    NSArray  * array= [detailStr componentsSeparatedByString:@"】,"];
    
    if([array count]>=2){
        NSArray * jumpArray = [[[array objectAtIndex:[array count]-1] componentsSeparatedByString:@"－"][0] componentsSeparatedByString:@"https://style.hanmimei.com"];
        NSString * url ;
        
        if ([detailStr rangeOfString:@"<C>"].location != NSNotFound) {
            //进入普通商品详情页

            url = [NSString stringWithFormat:@"%@/comm%@",[HSGlobal shareGoodsHeaderUrl],jumpArray[1]];

        }else if ([detailStr rangeOfString:@"<P>"].location != NSNotFound) {
            //进入拼购商品详情页
            url = [NSString stringWithFormat:@"%@/comm%@",[HSGlobal shareGoodsHeaderUrl],jumpArray[1]];

        }else if ([detailStr rangeOfString:@"<T>"].location != NSNotFound) {
            //进入拼团详情页
            url = [NSString stringWithFormat:@"%@/promotion%@",[HSGlobal shareTuanHeaderUrl],jumpArray[1]];
        }

        
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSInteger code = [[[dict objectForKey:@"message"] objectForKey:@"code"]integerValue];
            
            if(code == 200){
                
                if ([detailStr rangeOfString:@"<C>"].location != NSNotFound) {
                    
                    GoodsDetailData * detailData = [[GoodsDetailData alloc] initWithJSONNode:dict];
                    
                    for(SizeData * sizeData in detailData.sizeArray){
                        if(sizeData.orMasterInv){
                            [imageView sd_setImageWithURL:[NSURL URLWithString:sizeData.invImg]];
                            priceLab.text =[NSString stringWithFormat:@"￥ %.2f",sizeData.itemSrcPrice];
                            break;
                        }
                    }
                    
                }else if ([detailStr rangeOfString:@"<P>"].location != NSNotFound) {
                    //进入拼购商品详情页
                    PinGoodsDetailData * detailData = [[PinGoodsDetailData alloc] initWithJSONNode:dict];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:detailData.invImg]];
                    priceLab.text =[NSString stringWithFormat:@"￥ %@",detailData.invPrice];
                    
                }else if ([detailStr rangeOfString:@"<T>"].location != NSNotFound) {
                    NSDictionary * dataDict = [dict objectForKey:@"activity"];
                    PinDetailData * data = [[PinDetailData alloc] initWithJSONNode:dataDict];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:data.pinImg]];
                    priceLab.text =[NSString stringWithFormat:@"￥ %@",data.pinPrice];
                }


            }else{
                [self cancleBtnClick];
                [PublicMethod printAlert:@"错误的秘口令"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self cancleBtnClick];
            [PublicMethod printAlert:@"错误的秘口令"];
            
        }];

    }else{
        [self cancleBtnClick];
    }
   
}
@end
