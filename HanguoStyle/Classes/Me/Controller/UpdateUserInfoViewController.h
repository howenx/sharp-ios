//
//  UpdateUserInfoViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/2.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"
@protocol  UpdateUserInfoDelegate <NSObject>
-(void)backIcon:(UIImage *)image andName :(NSString *)name andSex :(NSString *)sex;
@end
@interface UpdateUserInfoViewController : BaseViewController
@property(nonatomic) NSString * userName;
@property(nonatomic) NSString * gender;
@property(nonatomic) UIImage * comeImage;

@property(nonatomic,weak) id <UpdateUserInfoDelegate> delegate;
@end
