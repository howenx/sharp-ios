//
//  UpdateUserInfoViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/2.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  UpdateUserInfoDelegate <NSObject>
-(void)backIcon:(UIImage *)image;
@end
@interface UpdateUserInfoViewController : UIViewController
@property(nonatomic) NSString * userName;
@property(nonatomic,weak) id <UpdateUserInfoDelegate> delegate;
@end
