//
//  PinDetailOneCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/18.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
#import "PinGoodsDetailData.h"
@protocol PinDetailOneCellDelegate <NSObject>
//回传cell高度
-(void)getOneCellH:(CGFloat)cellHeight ;
- (void)touchPage:(NSInteger)index andImageArray :(NSArray *) imageArray;

@end
@interface PinDetailOneCell : UITableViewCell
+(id)subjectCell;
@property (nonatomic, weak) id <PinDetailOneCellDelegate> delegate;
@property (nonatomic, weak) PinGoodsDetailData * data;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *alreadySaleLab;
@property (weak, nonatomic) IBOutlet UIButton *pinSaleTopBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinSaleBottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *singleSaleTopBtn;
@property (weak, nonatomic) IBOutlet UIButton *singleSaleBottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinMethodBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailConstraint;

@end
