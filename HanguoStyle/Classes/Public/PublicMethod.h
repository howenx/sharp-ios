//
//  PublicMethod.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/22.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGlobal.h"
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface PublicMethod : NSObject<MBProgressHUDDelegate>
-(void)sendCustNum;
@property(nonatomic,assign)NSInteger cnt;


//提示框
+(void)printAlert:(NSString *) message;
//根据文字获取大小
+(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height;
+(BOOL)checkLogin;
+(FMDatabase *)shareDatabase;
+(AFHTTPRequestOperationManager *)shareRequestManager;
+(AFHTTPRequestOperationManager *)shareNoHeadRequestManager;
+(MBProgressHUD *)getHUD :(UIViewController *)controller;
+(BOOL) isConnectionAvailable;
@property (nonatomic,strong)NSString * contentType;
@end
