//
//  UserNameViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/19.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"
@protocol  UserNameDelegate <NSObject>
-(void)backName:(NSString *)name;
@end
@interface UserNameViewController : BaseViewController
@property(nonatomic,weak) id <UserNameDelegate> delegate;
@property(nonatomic) NSString * comeName;
@end
