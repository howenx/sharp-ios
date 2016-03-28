//
//  PinDetailData.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/2.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinUsersData : NSObject

@property (nonatomic)  NSInteger  orMaster;//是否是团长
@property (nonatomic)  NSString *  joinAt;//参团时间
@property (nonatomic)  NSString *  userImg;//头像
@property (nonatomic)  NSString *  userNm;//名字
@end


@interface PinDetailData : NSObject

- (PinDetailData *) initWithJSONNode: (id) node;


@property (nonatomic)  long pinActiveId; // 拼购活动ID
@property (nonatomic)  NSString * pinUrl; // 此团的分享短连接
@property (nonatomic)  long pinId; // 拼购ID
@property (nonatomic)  long masterUserId; // 团长用户ID
@property (nonatomic)  NSInteger personNum; // 拼购人数
@property (nonatomic)  NSString * pinPrice; // 拼购价格
@property (nonatomic)  NSInteger joinPersons; // 已参加活动人数
//@property (nonatomic)  NSString * createAt; // 发起时间
@property (nonatomic)  NSString * status; //   状态   Y-正常， N－取消 ，C－完成 ，F-失败
@property (nonatomic)  long endCountDown; // 截止时间
@property (nonatomic)  NSString * pay; //new 参团成功查询  normal 普通查询


@property (nonatomic)  NSMutableArray * pinUsersArray; // 参与拼购活动的用于

@property (nonatomic)  NSString *          userType;       //订单支付成功后需要的用户类型,团长: master,团员:ordinary
@property (nonatomic)  NSInteger         orJoinActivity; //是否参团,0:未参团,1:参团
@property (nonatomic)  NSInteger          orMaster;       //订单支付成功后需要的用户类型,团长: 1,团员:0

//拼购商品数据
@property (nonatomic)  NSString *          pinImg;      //生成后列表图
@property (nonatomic)  NSString *          pinSkuUrl;   //拼购商品链接
@property (nonatomic)  NSString *          pinTitle;    //拼购商品标题

@property (nonatomic)  NSString * invArea;
@property (nonatomic)  NSString *  invCustoms;
@property (nonatomic)  NSString *  invAreaNm;
@property (nonatomic)  NSString *  postalTaxRate;
@property (nonatomic)  NSString *  postalStandard;
@property (nonatomic)  long  skuId;
@property (nonatomic)  NSString *  skuType;
@property (nonatomic)  long skuTypeId;
@property (nonatomic)  long pinTieredPriceId;

//@property (nonatomic)  NSString * orderId;

@end
