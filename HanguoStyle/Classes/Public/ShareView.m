//
//  shareView.m
//  ZhuaMa
//
//  Created by xll on 15/1/20.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ShareView.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialDataService.h"
#import "MBProgressHUD.h"
#import "UMSocialSnsService.h"
@implementation ShareView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.backgroundColor =[UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    [self addSubview:bgView];
    
    
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
    UIView *shareView = [[UIView alloc ]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT, self.frame.size.width, 291)];//25+48+15+20+20+48+15+20+20+60
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame =CGRectMake(0, GGUISCREENHEIGHT -291, self.frame.size.width, 291);
    }];
    shareView.tag = 70;
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.userInteractionEnabled = YES;
    [self addSubview:shareView];
    
//    UILabel *tishi = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-200)/2, 20, 200, 20)];
//    
//    tishi.text = @"分享到";
//    tishi.font = [UIFont systemFontOfSize:18];
//    tishi.numberOfLines = 0;
//    tishi.lineBreakMode = NSLineBreakByWordWrapping;
//    tishi.textAlignment = NSTextAlignmentCenter;
//    [ shareView  addSubview:tishi];
//    
    
    //    UIButton * copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    copyButton.frame = CGRectMake(20, 50, 40, 40);
    //
    //    [copyButton setBackgroundImage:[UIImage imageNamed:@"icon_fuzhi"] forState:UIControlStateNormal];
    //    [copyButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    copyButton.tag = 100005;
    //    [shareView addSubview:copyButton];
    //
    //
    //    UILabel *copyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 50 + 40+10, 40, 20)];
    //
    //    copyLab.text = @"复制";
    //    copyLab.font = [UIFont systemFontOfSize:14];
    //    copyLab.numberOfLines = 0;
    //    copyLab.lineBreakMode = NSLineBreakByWordWrapping;
    //    copyLab.textAlignment = NSTextAlignmentCenter;
    //    copyLab.textColor = [UIColor lightGrayColor];
    //    [shareView addSubview:copyLab];
    //
    
    float btnWidth = 48;
    float gap = (GGUISCREENWIDTH - 48*4)/5;
    UIButton * mklButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mklButton.frame = CGRectMake(gap, 128, btnWidth, btnWidth);
    
    [mklButton setBackgroundImage:[UIImage imageNamed:@"mimeiPwd"] forState:UIControlStateNormal];
    [mklButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    mklButton.tag = 100005;
    [shareView addSubview:mklButton];
    
    UILabel *mklLab =  [[UILabel alloc]initWithFrame:CGRectMake(gap-10 , 95 + btnWidth*2, btnWidth+20, 20)];
    
    mklLab.text = @"复制链接";
    mklLab.font = [UIFont systemFontOfSize:14];
    mklLab.numberOfLines = 0;
    mklLab.lineBreakMode = NSLineBreakByWordWrapping;
    mklLab.textAlignment = NSTextAlignmentCenter;
    mklLab.textColor = UIColorFromRGB(0x333333);
    [shareView addSubview:mklLab];
    
    
    
    
    float width_wx = 0;
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        UIButton *wxBtn =  [[UIButton alloc]initWithFrame:CGRectMake(gap*2+btnWidth + width_wx , 25, btnWidth, btnWidth)];
//        wxBtn.layer.cornerRadius = 5;
//        wxBtn.clipsToBounds = YES;
        wxBtn.tag = 100001;
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wxBtn];
        
//
        UILabel *l =  [[UILabel alloc]initWithFrame:CGRectMake(gap*2+btnWidth + width_wx-10 , 40 + btnWidth, btnWidth+20, 20)];
        l.textColor = UIColorFromRGB(0x333333);
        l.text =@"朋友圈";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:l];
        width_wx = btnWidth + gap;
    }
    else
    {
        
    }
    
    float width_hy = 0;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        UIButton *wxBtn = [[UIButton alloc]initWithFrame: CGRectMake(gap, 25, btnWidth, btnWidth)];//        wxBtn.layer.cornerRadius = 5;
//        wxBtn.clipsToBounds = YES;
        wxBtn.tag = 100002;
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wxBtn];
        
        UILabel *l =  [[UILabel alloc]initWithFrame:CGRectMake(gap-10, 40 + btnWidth, btnWidth+20, 20)];
        l.textColor = UIColorFromRGB(0x333333);
        l.text =@"微信好友";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:l];
        width_hy = btnWidth + gap;
    }
    else
    {
        
    }
    
    
    
    if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi])
    {
        UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap*2+btnWidth + width_wx + width_hy, 25, btnWidth, btnWidth)];
//        wxBtn.layer.cornerRadius = 5;
//        wxBtn.clipsToBounds = YES;
        wxBtn.tag = 100003;
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wxBtn];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(gap*2+btnWidth + width_wx + width_hy-10 , 40 + btnWidth, btnWidth+20, 20)];
        l.textColor = UIColorFromRGB(0x333333);
        l.text =@"QQ好友";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:l];
    }
    else
    {
        
    }
    
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://wb794664710"]])
//    {
    
        UIButton *wbButton = [[UIButton alloc]initWithFrame:CGRectMake(gap*2+btnWidth+width_wx ,25, btnWidth, btnWidth)];
        //        wxBtn.layer.cornerRadius = 5;
        //        wxBtn.clipsToBounds = YES;
        wbButton.tag = 100004;
        [wbButton setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
        [wbButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wbButton];
    
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(gap*2+btnWidth+ width_wx-10 , 40 + btnWidth, btnWidth+20, 20)];
        l.textColor = UIColorFromRGB(0x333333);
        l.text =@"新浪微博";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:l];
//    }
//    else
//    {
//        
//    }

    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(gap, 135 + btnWidth*2, GGUISCREENWIDTH-gap*2, 1)];
    line.backgroundColor = UIColorFromRGB(0x959595);
    [shareView addSubview:line];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0,136 + btnWidth*2, GGUISCREENWIDTH, 59);
    [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [shareView addSubview:cancelBtn];
    
    
    
}
-(void)shareBtnClick:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.title = _shareTitle;
    NSString *shareText =_shareStr;
    int index = (int)sender.tag;
    UIImage *image = [UIImage imageNamed:@"0"];
    //    if (index == 100000) {
    //        if (!_shareImage) {
    //
    //            [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
    //            //进入授权页面
    //            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler((UIViewController*)_delegate,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
    //                if (response.responseCode == UMSResponseCodeSuccess) {
    //                    //获取微博用户名、uid、token等
    //                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
    //                    NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
    //                    //进入你的分享内容编辑页面
    //                    [[UMSocialControllerService defaultControllerService]
    //                     setShareText:[NSString stringWithFormat:@"%@--%@",shareText,_shareUrl] shareImage:image
    //                     socialUIDelegate:self];
    //                    //设置分享内容和回调对象
    //                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler((UIViewController*)_delegate,[UMSocialControllerService defaultControllerService],YES);
    //                }
    //                else
    //                {
    //
    //                }
    //            });
    //        }
    //        else
    //        {
    //            [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
    //            //进入授权页面
    //            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler((UIViewController*)_delegate,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
    //                if (response.responseCode == UMSResponseCodeSuccess) {
    //                    //获取微博用户名、uid、token等
    //                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
    //                    NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
    //                    //进入你的分享内容编辑页面
    //                    [[UMSocialControllerService defaultControllerService]
    //                     setShareText:[NSString stringWithFormat:@"%@--%@",shareText,_shareUrl] shareImage:image
    //                     socialUIDelegate:self];
    //                    //设置分享内容和回调对象
    //                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler((UIViewController *)_delegate,[UMSocialControllerService defaultControllerService],YES);
    //                }
    //                else
    //                {
    //
    //                }
    //            });
    //        }
    //    }
    //    else
    if (index == 100001)
    {
        [UMSocialData defaultData].extConfig.title = _shareTitle;
        [UMSocialWechatHandler setWXAppId:@"wx578f993da4b29f97" appSecret:@"e78a99aec4b6860370107be78a5faf9d" url:_shareUrl];
        if (!_shareImage) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareText image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSLog(@"分享成功！");
                }
                else
                {
                    
                }
            }];
        }
        else
        {
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_shareImage];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareText image:nil location:nil urlResource:resource presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSLog(@"分享成功！");
                }
                else
                {
                    
                }
            }];
        }
    }
    else if (index == 100002)
    {
        [UMSocialWechatHandler setWXAppId:@"wx578f993da4b29f97" appSecret:@"e78a99aec4b6860370107be78a5faf9d" url:_shareUrl];
        
        if (!_shareImage) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareText image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSLog(@"分享成功！");
                }
                else
                {
                    
                }
            }];
        }
        else
        {
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_shareImage];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareText image:nil location:nil urlResource:resource presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSLog(@"分享成功！");
                }
                else
                {
                    
                }
            }];
        }
        
    }
    else if (index == 100003)
    {
        [UMSocialQQHandler setQQWithAppId:@"1105332776" appKey:@"CKevSfjxt0dXEq0y" url:_shareUrl];
        if (!_shareImage) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareText image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSLog(@"分享成功！");
                }
                else
                {
                    
                }
            }];
        }
        else
        {
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_shareImage];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareText image:nil location:nil urlResource:resource presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSLog(@"分享成功！");
                }
                else
                {
                    
                }
            }];
        }
    }
    else if (sender.tag == 100004) {
         [UMSocialSnsService presentSnsIconSheetView:[self getCurrentVC] appKey:@"567bb26867e58e3f670002fd" shareText:[NSString stringWithFormat:@"%@%@",_shareTitle,_shareUrl] shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImage]]] shareToSnsNames:@[UMShareToSina] delegate:[self getCurrentVC]];
    }else if (sender.tag == 100005) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _shareDetailPage;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"复制成功";
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
    [self tap:nil];
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    
}
-(void)tap:(UIGestureRecognizer *)sender
{
    UIView *shareView = [self viewWithTag:70];
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame =CGRectMake(0, GGUISCREENHEIGHT, self.frame.size.width, 291);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
    }
    else
    {
        
    }
}


//- (void)Cancel {
////    [self StopLoading];
//    SAFE_CANCEL_ARC(self.mDownManager);
//}

-(void)removeShareView{
    [self removeFromSuperview];
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
