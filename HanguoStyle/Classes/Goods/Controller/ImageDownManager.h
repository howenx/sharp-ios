//
//  ImageDownManager.h
//  TestAppstoreRss
//
//  Created by hepburn X on 11-10-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownManager : NSObject {
    NSMutableData *mWebData;
    long long miFileSize;
    long long miDownSize;
    int tag;
    BOOL mbGb2312;
    NSURLConnection *theConncetion;
}

@property (nonatomic, assign) BOOL mbGb2312;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnImageDown;
@property (nonatomic, assign) SEL OnImageFail;
@property (nonatomic, assign) NSMutableData *mWebData;
@property (nonatomic, assign) int tag;
@property (nonatomic, retain) id userInfo;
@property (readonly, assign) NSString *mWebStr;



- (void)GetImageByUrl:(NSURL *)url;
- (void)GetImageByStr:(NSString *)path;
- (void)GetImageByStr:(NSString *)path :(NSStringEncoding)enc;
- (void)Cancel;
- (void)PostHttpRequest:(NSString *)urlString :(NSDictionary *)dict;
- (void)GetHttpRequest:(NSString *)urlString :(NSDictionary *)dict;

- (NSString *)GetWebStrEncoding:(CFStringEncodings)encoding;

+ (void)ShowNetworkAnimate;
+ (void)HideNetworkAnimate;

#define SAFE_CANCEL(a) if (a) {a.delegate = nil;[a Cancel];[a release];a = nil;}
#define SAFE_CANCEL_ARC(a) if (a) {a.delegate = nil;[a Cancel];a = nil;}

@end
