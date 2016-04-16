//
//  NetRequestClass.m
//  MVVMTest
//
//  Created by 李泽鲁 on 15/1/6.
//  Copyright (c) 2015年 李泽鲁. All rights reserved.
//

#import "NetRequestClass.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
@interface NetRequestClass ()

@end


@implementation NetRequestClass
#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    NSString *url = [NSString stringWithFormat:@"%@",strUrl];
    NSURL *reqURL = [NSURL URLWithString:url];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:reqURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}


/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

#pragma --mark GET请求方式
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    NSString *url = [NSString stringWithFormat:@"%@",requestURLString];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    AFHTTPRequestOperation *op = [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        block(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
        errorBlock(error);
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
}

#pragma --mark POST请求方式

+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{
    NSString *url = [NSString stringWithFormat:@"%@",requestURLString];
//    NSURL *reqURL = [NSURL URLWithString:url];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    NSString * str  = @"-_1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
//    NSArray * array = [str componentsSeparatedByString:@"2"];
//    
//    NSMutableString * remodStr =[NSMutableString string];
//    for (int i = 0; i<30;i++) {
//        NSString * str1 = array[arc4random() % str.length];
//        remodStr = [NSString stringWithFormat:@"%@%@",remodStr,str1];
//    }
//    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",str] forHTTPHeaderField:@"Content-Type"];
    
    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
    
   // NSString *reqStr = [NSString stringWithFormat:@"%@%@",kWGBaseURL,requestURLString];
    AFHTTPRequestOperation *op = [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
//        DDLog(@"%@", dic);
        
        block(dic);
        /***************************************
         在这做判断如果有dic里有errorCode
         调用errorBlock(dic)
         没有errorCode则调用block(dic
         ******************************/
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];

}

+ (void)cancelRequest {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager.operationQueue cancelAllOperations];
}




@end
