//
//  MyPinTeamCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/29.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//


#import "PinTeamData.h"
#import "BaseView.h"
@protocol MyPinTeamCellDelegate <NSObject>

//点击查看团详情回调地址

-(void)sendTeamDetailUrl:(NSString *)url;

@end

@interface MyPinTeamCell : UITableViewCell
@property (nonatomic, weak) id <MyPinTeamCellDelegate> delegate;
@property(nonatomic,strong) PinTeamData * data;
@end
