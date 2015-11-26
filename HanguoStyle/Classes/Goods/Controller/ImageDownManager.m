//
//  ImageDownManager.m
//  TestAppstoreRss
//
//  Created by hepburn X on 11-10-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageDownManager.h"

@implementation ImageDownManager

@synthesize delegate, OnImageDown, OnImageFail, mWebData, tag, userInfo, mWebStr, mbGb2312;

- (void)PostHttpRequest:(NSString *)urlString :(NSDictionary *)dict {
    NSLog(@"PostHttpRequest:%@", dict);
    
    NSString *body = @"";
    for (NSString *key in dict.allKeys) {
        NSString *value = [dict objectForKey:key];
        body = [body stringByAppendingFormat:@"%@%@=%@", (body.length==0?@"":@"&"), key, value];
    }
    
    NSLog(@"urlString:%@?%@", urlString, body);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    
    if (mbGb2312) {
        [request setValue:@"application/x-www-form-urlencoded; charset=gb2312" forHTTPHeaderField:@"Content-Type"];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        [request setHTTPBody:[body dataUsingEncoding:enc]];
    }
    else {
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setTimeoutInterval:30];
    
    theConncetion = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	//如果连接已经建好，则初始化data
	if (!theConncetion) {
		NSLog(@"theConnection is NULL");
	}
    NSLog(@"PostHttpRequest OK");
}

- (void)GetHttpRequest:(NSString *)urlString :(NSDictionary *)dict {
    NSString *path = [NSString stringWithFormat:@"%@", urlString];
    for (int i = 0; i < dict.allKeys.count; i ++) {
        NSString *key = [dict.allKeys objectAtIndex:i];
        NSString *value = [dict objectForKey:key];
        if (i == 0) {
            path = [path stringByAppendingFormat:@"?%@=%@", key, value];
        }
        else {
            path = [path stringByAppendingFormat:@"&%@=%@", key, value];
        }
    }
    [self GetImageByStr:path];
}

- (void)GetImageByUrl:(NSURL *)url {
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30];
    theConncetion = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	//如果连接已经建好，则初始化data
	if (!theConncetion) {
		NSLog(@"theConnection is NULL");
	}
}

- (void)GetImageByStr:(NSString *)path {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"GetJsonByUrl:%@", path);
    NSURL * url = [[[NSURL alloc] initWithString:path] autorelease];
    [self GetImageByUrl:url];
}

- (void)GetImageByStr:(NSString *)path :(NSStringEncoding)enc {
    path = [path stringByAddingPercentEscapesUsingEncoding:enc];
    NSLog(@"%@", path);
    NSURL * url = [[[NSURL alloc] initWithString:path] autorelease];
    [self GetImageByUrl:url];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[mWebData setLength: 0];

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    miFileSize = 0;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *HeaderFields = [httpResponse allHeaderFields];
        miFileSize = [[HeaderFields objectForKey:@"Content-Length"] longLongValue];
        //NSLog(@"iTotalSize:%lld, %@", miFileSize, HeaderFields);
    }
    miDownSize = 0;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[mWebData appendData:data];
    miDownSize = mWebData.length;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
    theConncetion = nil;
    if (delegate && OnImageFail) {
        [delegate performSelector:OnImageFail withObject:self];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    theConncetion = nil;
    if (delegate != nil) {
        if (delegate && OnImageDown) {
            [delegate performSelector:OnImageDown withObject:self];
        }
    }
    
}

- (id)init {
    self = [super init];
    if (self) {
        miFileSize = 0;
        miDownSize = 0;
        mbGb2312 = NO;
        mWebData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)Cancel {
    if (theConncetion) {
        [theConncetion cancel];
        [theConncetion release];
        theConncetion = nil;
    }
}

- (void)dealloc {
    if (theConncetion) {
        [theConncetion cancel];
        [theConncetion release];
        theConncetion = nil;
    }
    self.delegate = nil;
    if (mWebData) {
        [mWebData release];
        mWebData = nil;
    }
    self.userInfo = nil;
    [super dealloc];
}

- (NSString *)GetWebStrEncoding:(CFStringEncodings)encoding {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (encoding);
    NSString *resStr = [[[NSString alloc] initWithBytes: [mWebData mutableBytes] length:[mWebData length] encoding:enc] autorelease];
    return resStr;
}

- (NSString *)mWebStr {
	NSString *resStr = [[[NSString alloc] initWithBytes: [mWebData mutableBytes] length:[mWebData length] encoding:NSUTF8StringEncoding] autorelease];
    if (!resStr) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        resStr = [[[NSString alloc] initWithBytes: [mWebData mutableBytes] length:[mWebData length] encoding:enc] autorelease];
    }
    if (resStr) {
        resStr = [resStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        resStr = [resStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return resStr;
}

+ (void)ShowNetworkAnimate
{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
}

+ (void)HideNetworkAnimate
{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
}

@end
