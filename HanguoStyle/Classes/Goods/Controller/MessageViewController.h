//
//  MessageViewController.h
//  HanguoStyle
//
//  Created by wayne on 16/4/6.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "BaseViewController.h"
@interface MessageViewController : BaseViewController
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * arrayData;
@property (nonatomic,strong)MessageModel * messageModel;
@property (nonatomic,copy) void (^selectButtonBlock)(NSString * str);
@end
