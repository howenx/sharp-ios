//
//  ShowEvaluateCollectionViewCell.h
//  HanguoStyle
//
//  Created by wayne on 16/4/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowEvaluateModel.h"
#import "ShowEvaluateBigImageController.h"
@interface ShowEvaluateCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property (nonatomic,strong)UIImageView * titleIconImageView_;
@property (nonatomic,strong)UILabel * nameLabel_;
@property (nonatomic,strong)UILabel * timeLabel_;
@property (nonatomic,strong)UIImageView * startImageView_;
@property (nonatomic,strong)UILabel * contentLabel_;

@property (nonatomic,strong) UILabel * sizeLabel_;
@property (nonatomic,strong) UILabel * buyAtLabel_;
@property (nonatomic,strong)UIScrollView * imageScrollView_;

@property (nonatomic,strong)UIView * bgView;

@property (nonatomic,strong) UIImageView * view1;
@property (nonatomic,strong) UIImageView * view2;
@property (nonatomic,strong) UIImageView * view3;
@property (nonatomic,strong) UIImageView * view4;
@property (nonatomic,strong) UIImageView * view5;

@property (nonatomic,strong)ShowEvaluateModel * evaluateModel;

+(CGFloat)CellHight:(ShowEvaluateModel *)Model;
@end
