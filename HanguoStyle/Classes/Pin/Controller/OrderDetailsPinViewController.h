//
//  OrderDetailsViewController.h
//  HanguoStyle
//
//  Created by wayne on 16/3/31.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"
#import "MyOrderData.h"
@interface OrderDetailsPinViewController : BaseViewController
@property (nonatomic,assign)long  orderId;
@property (nonatomic,strong) MyOrderData * singleData;
@property (nonatomic,strong)UITableView * tableView;
@end
