//
//  InitAppDelegate.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/26.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "HSGlobal.h"
@interface InitAppDelegate : NSObject

- (NSString *)intervalSinceNow: (NSDate *) theDate;
@end
