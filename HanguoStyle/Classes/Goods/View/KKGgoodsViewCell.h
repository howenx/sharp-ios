//
//  KKGgoodsViewCell.h
//  HanguoStyle
//
//  Created by wayne on 16/7/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsPackData.h"
@interface KKGgoodsViewCell : UITableViewCell
@property (nonatomic,strong)UILabel * titleLabel_;
@property (nonatomic,strong)UILabel * detailLabel_;
@property (nonatomic,strong)UIImageView * bgImageView_;
@property (nonatomic,strong) UIView * bgView;



//绑定数据
-(void)bindWithObject:(ThemeData *) obj;
//计算高度
+(float)bindWithObjectHeigh:(ThemeData *) obj;
@end
