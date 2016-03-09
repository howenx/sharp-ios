//
//  AddressCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/4.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
#import "AddressData.h"
@protocol AddressCellDelegate <NSObject>

-(void)updateAddr:(AddressData *) data ;
@end

@interface AddressCell : UITableViewCell
+(id)subjectCell;
@property (nonatomic) NSString * from;//去结算页面用这个cell时候传这个标志
@property (nonatomic, weak) AddressData * data;
@property(nonatomic,weak) id <AddressCellDelegate> delegate;
@property (nonatomic) NSString * comeFrom;
@end
