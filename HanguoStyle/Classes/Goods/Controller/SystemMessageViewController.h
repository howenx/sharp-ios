//
//  SystemMessageViewController.h
//  HanguoStyle
//
//  Created by wayne on 16/4/7.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageTypeModel.h"
@interface SystemMessageViewController : BaseViewController
@property (nonatomic,strong)NSString * messageType;

@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * arrayData;
@property (nonatomic,strong)MessageTypeModel * messageModel;

@end
