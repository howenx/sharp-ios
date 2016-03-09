//
//  SettingViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/14.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"
@protocol  SettingDelegate <NSObject>
-(void)backMeFromSetting;
@end
@interface SettingViewController : BaseViewController
@property(nonatomic,weak) id <SettingDelegate> delegate;
@end
