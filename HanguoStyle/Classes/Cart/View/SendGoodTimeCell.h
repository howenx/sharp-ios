//
//  SendGoodTimeCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/17.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
@protocol SendGoodTimeCellDelegate <NSObject>

-(void)sendTimeFlag:(NSString *)timeFlag;

@end

@interface SendGoodTimeCell : UITableViewCell
@property (nonatomic, weak) id <SendGoodTimeCellDelegate> delegate;

@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic) BOOL isTimeEdit;
@property (nonatomic, strong) UILabel * timeLab;
@property (nonatomic, strong) NSString * sendTime;

-(void)createView;

@end
