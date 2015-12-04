//
//  HSGlobal.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface HSGlobal : NSObject <MBProgressHUDDelegate>

+ (NSString *) goodsPackMoreUrl: (NSInteger)addon;
+ (NSString *) testingCodeUrl;
+ (NSString *) registUrl;
+ (NSString *) loginUrl;
+ (NSString *) sendCartUrl;
+ (NSString *) resetPwdUrl;
+ (NSString *) refreshToken;
+ (NSString *) getCartUrl;
+ (NSString *) getCartByPidUrl;
+ (NSString *) mineUrl;
+ (NSString *) updateUserInfo;
+ (NSString *) getAddressListInfo;
+ (NSString *) updateAddressInfo;
//提示框
+(void)printAlert:(NSString *) message;
//根据文字获取大小
+(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height;
+(BOOL)checkLogin;
+(FMDatabase *)shareDatabase;
+(AFHTTPRequestOperationManager *)shareRequestManager;
+(AFHTTPRequestOperationManager *)shareNoHeadRequestManager;
+(MBProgressHUD *)getHUD :(UIViewController *)controller;
@end
