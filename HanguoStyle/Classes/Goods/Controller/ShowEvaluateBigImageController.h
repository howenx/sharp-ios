//
//  ShowEvaluateBigImageController.h
//  HanguoStyle
//
//  Created by wayne on 16/5/3.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"
#import "ShowEvaluateModel.h"
@interface ShowEvaluateBigImageController : BaseViewController

@property (nonatomic,strong)ShowEvaluateModel * evaluateModel;
@property (nonatomic,strong)UIScrollView * imageScrollView_;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong) UILabel * titleView ;
@end
