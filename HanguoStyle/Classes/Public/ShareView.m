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
    
    float bWidth =GGUISCREENWIDTH/4-20;
    
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
    UIView *shareView = [[UIView alloc ]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT, self.frame.size.width, 50+bWidth+20+20+20+40+10+90)];
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame =CGRectMake(0, GGUISCREENHEIGHT -(50+bWidth+20+20+20+40+10+90), self.frame.size.width, 50+bWidth+20+20+20+40+10+90);
    }];
    shareView.tag = 70;
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.userInteractionEnabled = YES;
    [self addSubview:shareView];
    
    UILabel *tishi = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-200)/2, 20, 200, 20)];
    
    tishi.text = @"分享到";
    tishi.font = [UIFont systemFontOfSize:18];
    tishi.numberOfLines = 0;
    tishi.lineBreakMode = NSLineBreakByWordWrapping;
    tishi.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:tishi];
    
    
    UIButton * copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.frame = CGRectMake(20, 50, 40, 40);
    
    [copyButton setBackgroundImage:[UIImage imageNamed:@"icon_fuzhi"] forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    copyButton.tag = 100005;
    [shareView addSubview:copyButton];

    
    UILabel *copyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 50 + 40+10, 40, 20)];
    
    copyLab.text = @"复制";
    copyLab.font = [UIFont systemFontOfSize:14];
    copyLab.numberOfLines = 0;
    copyLab.lineBreakMode = NSLineBreakByWordWrapping;
    copyLab.textAlignment = NSTextAlignmentCenter;
    copyLab.textColor = [UIColor lightGrayColor];
    [shareView addSubview:copyLab];
    
    
    if(![_shareFrom isEqualToString:@"T"]){
        UIButton * wbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        wbButton.frame = CGRectMake(10, 50+90, self.frame.size.width/4 - 20, self.frame.size.width/4 - 20);
        
        [wbButton setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
        [wbButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        wbButton.tag = 100000;
        [shareView addSubview:wbButton];
        
        
        
        UILabel *wbLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 50 + self.frame.size.width/4+90, self.frame.size.width/4, 20)];
        
        wbLab.text = @"新浪微博";
        wbLab.font = [UIFont systemFontOfSize:14];
        wbLab.numberOfLines = 0;
        wbLab.lineBreakMode = NSLineBreakByWordWrapping;
        wbLab.textAlignment = NSTextAlignmentCenter;
        wbLab.textColor = [UIColor lightGrayColor];
        [shareView addSubview:wbLab];
        
        
        
        float btnWidth = self.frame.size.width/4;
        float width_wx = 0;
        
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
        {
            UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 + btnWidth * 1 , 50+90, self.frame.size.width/4 - 20, self.frame.size.width/4 - 20)];
            wxBtn.layer.cornerRadius = 5;
            wxBtn.clipsToBounds = YES;
            wxBtn.tag = 100001;
            [wxBtn setBackgroundImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
            [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:wxBtn];
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth * 1 , 50 + self.frame.size.width/4+90, btnWidth, 20)];
            l.textColor = [UIColor lightGrayColor];
            l.text =@"朋友圈";
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:14];
            [shareView addSubview:l];
            width_wx = btnWidth;
        }
        else
        {
            
        }
        
        float width_hy = 0;
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
        {
            UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 + btnWidth * 1 + width_wx , 50+90, self.frame.size.width/4 - 20, self.frame.size.width/4 - 20)];
            wxBtn.layer.cornerRadius = 5;
            wxBtn.clipsToBounds = YES;
            wxBtn.tag = 100002;
            [wxBtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
            [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:wxBtn];
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth * 1+ width_wx , 50 + self.frame.size.width/4+90, btnWidth, 20)];
            l.textColor = [UIColor lightGrayColor];
            l.text =@"微信好友";
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:14];
            [shareView addSubview:l];
            width_hy = btnWidth;
        }
        else
        {
            
        }
        
        
        
        if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi])
        {
            UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 + btnWidth*1 + width_wx +width_hy, 50+90, self.frame.size.width/4 - 20, self.frame.size.width/4 - 20)];
            wxBtn.layer.cornerRadius = 5;
            wxBtn.clipsToBounds = YES;
            wxBtn.tag = 100003;
            [wxBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
            [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:wxBtn];
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth*2 + width_wx , 50 + self.frame.size.width/4+90, btnWidth, 20)];
            l.textColor = [UIColor lightGrayColor];
            l.text =@"QQ好友";
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:14];
            [shareView addSubview:l];
        }
        else
        {
            
        }
    }
    
    
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake((self.frame.size.width-300)/2,shareView.frame.size.height-50, 300, 40);
    [cancelBtn setImage:[UIImage imageNamed:@"64"] forState:UIControlStateNormal];

    
    [cancelBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];

//    wbButton.tag = 100004;
    [shareView addSubview:cancelBtn];
    
    
    
}
-(void)shareBtnClick:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.title = _shareTitle;
    NSString *shareText =_shareStr;
    int index = (int)sender.tag;
    UIImage *image = [UIImage imageNamed:@"0"];
    if (index == 100000) {
        if (!_shareImage) {
            
            [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
            //进入授权页面
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler((UIViewController*)_delegate,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //获取微博用户名、uid、token等
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                    //进入你的分享内容编辑页面
                    [[UMSocialControllerService defaultControllerService]
                     setShareText:[NSString stringWithFormat:@"%@--%@",shareText,_shareUrl] shareImage:image
                     socialUIDelegate:self];
                    //设置分享内容和回调对象
                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler((UIViewController*)_delegate,[UMSocialControllerService defaultControllerService],YES);
                }
                else
                {
                    
                }
            });
        }
        else
        {
            [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
            //进入授权页面
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler((UIViewController*)_delegate,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //获取微博用户名、uid、token等
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                    //进入你的分享内容编辑页面
                    [[UMSocialControllerService defaultControllerService]
                     setShareText:[NSString stringWithFormat:@"%@--%@",shareText,_shareUrl] shareImage:image
                     socialUIDelegate:self];
                    //设置分享内容和回调对象
                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler((UIViewController *)_delegate,[UMSocialControllerService defaultControllerService],YES);
                }
                else
                {
                    
                }
            });
        }
    }
    else if (index == 100001)
    {
        [UMSocialData defaultData].extConfig.title = _shareStr;
        [UMSocialWechatHandler setWXAppId:@"wx4ee4a992a10d1253" appSecret:@"b1a54352a4e78028fc54de89b29505a6" url:_shareUrl];
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
        [UMSocialWechatHandler setWXAppId:@"wx4ee4a992a10d1253" appSecret:@"b1a54352a4e78028fc54de89b29505a6" url:_shareUrl];
        
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
         [UMSocialQQHandler setQQWithAppId:@"1104980747" appKey:@"eDLFyqWCM2GzdkMB" url:_shareUrl];
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
    float bWidth =GGUISCREENWIDTH/4-20;
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame =CGRectMake(0, GGUISCREENHEIGHT, self.frame.size.width, 50+bWidth+20+20+20+40+10);
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
@end
