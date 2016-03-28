//
//  MyBaseViewController.h
//  NewZhuaMa
//
//  Created by admin on 15/6/1.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface MyBaseViewController : UIViewController{
    UILabel *mlbTitle;
    MBProgressHUD *mLoadView;

    UIImageView *mShadowView;
    
    UILabel *remindWordLabel;
}
//@property(nonatomic,retain) UIImageView *mShadowView;
@property (nonatomic, retain) NSString *mLoadMsg;
@property (nonatomic, assign) id delegate;
//@property (nonatomic, assign) SEL OnGoBack;

//topbar
@property (nonatomic, readonly) UILabel *mlbTitle;
@property (nonatomic, assign) UIImage *mShadowImage;
@property (nonatomic, retain) UIColor *mTitleColor;
@property (nonatomic, retain) UIColor *mTopColor;
@property (nonatomic, retain) UIImage *mTopImage;
@property (nonatomic, assign) BOOL mbLightNav;
@property (nonatomic, assign) int mFontSize;


- (void)GoBack;
- (void)GoHome;
- (void)StartLoading;
- (void)StopLoading;
- (void)showMsg:(NSString *)msg;

- (void)ClearNavItem;
- (void)AddRightTextBtnFrame:(CGRect)frame Name:(NSString *)name target:(id)target action:(SEL)action;
- (void)AddRightImageBtn:(CGRect)frame Image:(UIImage *)image target:(id)target action:(SEL)action;
- (void)AddLeftImageBtn:(CGRect)frame Image:(UIImage *)image target:(id)target action:(SEL)action;

//-(void)showRemindLabel:(NSString *)remindWord;
-(void)showRemindLabel:(NSString *)remindWord inView:(UIView *)fatherView;
-(void)hideRemindLabel;
@end
