//
//  AssessListData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "AssessListData.h"
#import <JSONKit.h>
#import "NSString+GG.h"
@implementation OrderLine

@end


@implementation Comment

@end
@implementation AssessListData
- (AssessListData *) initWithJSONNode: (id) node{
    self = [super init];
    if (self) {
        NSDictionary * orderDict = [node objectForKey:@"orderLine"];
        self.orderLine = [[OrderLine alloc]init];

        if(![NSString isNSNull:[orderDict objectForKey:@"skuId"]]){
            self.orderLine.skuId = [[orderDict objectForKey:@"skuId"]longValue];
        }
        if(![NSString isNSNull:[orderDict objectForKey:@"amount"]]){
            self.orderLine.amount = [[orderDict objectForKey:@"amount"]integerValue];
        }
        if(![NSString isNSNull:[orderDict objectForKey:@"skuTypeId"]]){
            self.orderLine.skuTypeId = [[orderDict objectForKey:@"skuTypeId"]longValue];
        }
        if(![NSString isNSNull:[orderDict objectForKey:@"orderId"]]){
            self.orderLine.orderId = [[orderDict objectForKey:@"orderId"]integerValue];
        }

        self.orderLine.itemColor = [orderDict objectForKey:@"itemColor"];
        self.orderLine.itemSize = [orderDict objectForKey:@"itemSize"];
        self.orderLine.invImg = [[[orderDict objectForKey:@"invImg"]objectFromJSONString]objectForKey:@"url"];
        self.orderLine.price = [orderDict objectForKey:@"price"];
        self.orderLine.invUrl = [orderDict objectForKey:@"invUrl"];
        self.orderLine.skuTitle = [orderDict objectForKey:@"skuTitle"];
        self.orderLine.skuType = [orderDict objectForKey:@"skuType"];
        
        
        
        NSDictionary * commentDict = [node objectForKey:@"comment"];
        if (![commentDict isKindOfClass:[NSNull class]] && commentDict != nil) {
            self.comment = [[Comment alloc]init];
            
            if(![NSString isNSNull:[commentDict objectForKey:@"skuTypeId"]]){
                self.comment.skuTypeId = [[commentDict objectForKey:@"skuTypeId"]longValue];
            }
            if(![NSString isNSNull:[commentDict objectForKey:@"grade"]]){
                self.comment.grade = [[commentDict objectForKey:@"grade"]integerValue];
            }
            self.comment.createAt = [commentDict objectForKey:@"createAt"];
            self.comment.content = [commentDict objectForKey:@"content"];
            
            self.comment.skuType = [commentDict objectForKey:@"skuType"];
            self.comment.picArray = [NSMutableArray array];
            
            if(![NSString isNSNull:[commentDict objectForKey:@"picture"]]){

                self.comment.picArray =[[commentDict objectForKey:@"picture"]objectFromJSONString];
                
            }
            
        }
    }
    return self;
}

@end
