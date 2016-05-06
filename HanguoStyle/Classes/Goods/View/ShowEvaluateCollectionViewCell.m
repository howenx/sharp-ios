//
//  ShowEvaluateCollectionViewCell.m
//  HanguoStyle
//
//  Created by wayne on 16/4/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#define space 10
#define imageH 238/2
#import "ShowEvaluateCollectionViewCell.h"

@implementation ShowEvaluateCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initsubviews];
    }
    return self;
}

-(void)initsubviews
{
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.bgView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:self.bgView];
    
    self.titleIconImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(10, PosYFromView(self.bgView, space), 40, 40)];
//    self.titleIconImageView_.image = [UIImage imageNamed:@"hmm_zutuan"];
    self.titleIconImageView_.layer.cornerRadius = 20;
    self.titleIconImageView_.layer.masksToBounds = YES;
    [self.contentView addSubview:self.titleIconImageView_];
    
    self.nameLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.titleIconImageView_, 14), 20+10+6, 100, 15)];
    self.nameLabel_.font = [UIFont systemFontOfSize:13];
    self.nameLabel_.textColor = UIColorFromRGB(0x333333);
//    self.nameLabel_.text = @"张三";
    [self.contentView addSubview:self.nameLabel_];
    
    
    self.timeLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -200 - 10, 20+10+6, 200, 12)];
    self.timeLabel_.font = [UIFont systemFontOfSize:11];
    self.timeLabel_.textAlignment = NSTextAlignmentRight;
    self.timeLabel_.textColor = UIColorFromRGB(0x999999);
//    self.timeLabel_.text = @"2015-12-32 12:11:33";
    [self.contentView addSubview:self.timeLabel_];
    
    self.startImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(10, PosYFromView(self.titleIconImageView_, space), 66, 10)];
    self.startImageView_.image = [UIImage imageNamed:@"1star"];
    [self.contentView addSubview:self.startImageView_];
    //内容
    self.contentLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(self.startImageView_, space), SCREEN_WIDTH-20, 20)];
    self.contentLabel_.font = [UIFont systemFontOfSize:13];
    self.contentLabel_.textColor = UIColorFromRGB(0x333333);
//    self.contentLabel_.text = @"上刊登看到拉客的拉动和卡接电话卡接电话卡接电话看到哈克斯安航空 ";
    [self.contentView addSubview:self.contentLabel_];
    
    
    self.sizeLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(self.contentLabel_, space), SCREEN_WIDTH, 14)];
    self.sizeLabel_.font = [UIFont systemFontOfSize:13];
    self.sizeLabel_.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.sizeLabel_];
    
    self.buyAtLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(self.sizeLabel_, space), SCREEN_WIDTH, 14)];
    self.buyAtLabel_.font = [UIFont systemFontOfSize:13];
    self.buyAtLabel_.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.buyAtLabel_];
    
    
    self.imageScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PosYFromView(self.buyAtLabel_, space), SCREEN_WIDTH, imageH)];
    self.imageScrollView_.delegate = self;
    self.imageScrollView_.backgroundColor = [UIColor whiteColor];
    self.imageScrollView_.showsHorizontalScrollIndicator= NO;
    self.imageScrollView_.showsVerticalScrollIndicator= NO;
    self.imageScrollView_.alwaysBounceVertical = YES;
    self.imageScrollView_.alwaysBounceHorizontal = YES;
//    self.imageScrollView_.backgroundColor = [UIColor yellowColor];
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    //    self.imageScrollView_.delegate = self;
    // 设置内容大小
    self.imageScrollView_.contentSize = CGSizeMake(100*5, 100);
    // 是否反弹
    //    scrollView.bounces = NO;
    // 是否分页
    //    scrollView.pagingEnabled = YES;
    // 是否滚动
    //    scrollView.scrollEnabled = NO;
    //    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    //    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    //    scrollView.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    //    [self.imageScrollView_ flashScrollIndicators];
    // 是否同时运动,lock
    self.imageScrollView_.directionalLockEnabled = YES;
    [self.contentView addSubview:self.imageScrollView_];
    
    
    self.view1 = [[UIImageView alloc]initWithFrame:CGRectMake(imageH*0+5, 0, imageH, imageH)];
    self.view1.userInteractionEnabled = YES;
//    self.view1.backgroundColor = RandomColor;
    
    [self.imageScrollView_ addSubview:self.view1];
     UITapGestureRecognizer * view1Tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap1:)];
    [self.view1 addGestureRecognizer:view1Tap];
    
    self.view2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageH*1+10, 0, imageH, imageH)];
//    self.view2.backgroundColor = RandomColor;
    self.view2.userInteractionEnabled = YES;
    [self.imageScrollView_ addSubview:self.view2];
    UITapGestureRecognizer * view2Tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap2:)];
    [self.view2 addGestureRecognizer:view2Tap];
    
    
    
    self.view3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageH*2+15, 0, imageH, imageH)];
//    self.view3.backgroundColor = RandomColor;
    self.view3.userInteractionEnabled = YES;
    [self.imageScrollView_ addSubview:self.view3];
    UITapGestureRecognizer * view3Tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap3:)];
    [self.view3 addGestureRecognizer:view3Tap];
    
    
    self.view4 = [[UIImageView alloc]initWithFrame:CGRectMake(imageH*3+20, 0, imageH, imageH)];
//    self.view4.backgroundColor = RandomColor;
    self.view4.userInteractionEnabled = YES;
    [self.imageScrollView_ addSubview:self.view4];
    
    UITapGestureRecognizer * view4Tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap4:)];
    [self.view4 addGestureRecognizer:view4Tap];
    
    
    
    self.view5 = [[UIImageView alloc]initWithFrame:CGRectMake(imageH*4+25, 0, imageH, imageH)];
//    self.view5.backgroundColor = RandomColor;
    self.view5.userInteractionEnabled = YES;
    [self.imageScrollView_ addSubview:self.view5];
    
    UITapGestureRecognizer * view5Tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap5:)];
    [self.view5 addGestureRecognizer:view5Tap];
    
}


-(void)setEvaluateModel:(ShowEvaluateModel *)evaluateModel
{
    _evaluateModel = evaluateModel;
    [self.titleIconImageView_ sd_setImageWithURL:[NSURL URLWithString:evaluateModel.userImg] placeholderImage:[UIImage imageNamed:@"loading2"]];
    
    self.nameLabel_.text = evaluateModel.userName;
    self.timeLabel_.text = evaluateModel.createAt;
    self.startImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ldstar",(long)evaluateModel.grade]];
    self.contentLabel_.text = evaluateModel.content;
    self.sizeLabel_.text = [NSString stringWithFormat:@"%@%@",@"规格:",evaluateModel.size];
    self.buyAtLabel_.text = [NSString stringWithFormat:@"%@%@",@"购买时间:",evaluateModel.buyAt];
    
    CGSize maxSize1 = CGSizeMake(GGUISCREENWIDTH - 20, MAXFLOAT);
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize  lastSize1 = [evaluateModel.content boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    
    self.contentLabel_.frame = CGRectMake(10, PosYFromView(self.startImageView_, space), SCREEN_WIDTH-20, lastSize1.height);
    self.contentLabel_.numberOfLines = 0;
    
    self.sizeLabel_.frame = CGRectMake(10, PosYFromView(self.contentLabel_, space), SCREEN_WIDTH, 14);
    self.buyAtLabel_.frame =CGRectMake(10, PosYFromView(self.sizeLabel_, space), SCREEN_WIDTH, 14);
    self.imageScrollView_.frame = CGRectMake(0, PosYFromView(self.buyAtLabel_, space), SCREEN_WIDTH, imageH);
    
    if (evaluateModel.picture.count != 0 && evaluateModel.picture != nil) {
        self.imageScrollView_.hidden = NO;
        if (evaluateModel.picture.count == 1) {
            self.view1.hidden = NO;
            self.view2.hidden = YES;
            self.view3.hidden = YES;
            self.view4.hidden = YES;
            self.view5.hidden = YES;
            self.imageScrollView_.contentSize = CGSizeMake(imageH+10, 100);
            [self.view1 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[0]] placeholderImage:[UIImage imageNamed:@"loading2"]];
        }else if (evaluateModel.picture.count == 2)
        {
            self.view1.hidden = NO;
            self.view2.hidden = NO;
            self.view3.hidden = YES;
            self.view4.hidden = YES;
            self.view5.hidden = YES;
            
            self.imageScrollView_.contentSize = CGSizeMake(imageH*2+20, 100);
            
            [self.view1 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[0]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view2 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[1]] placeholderImage:[UIImage imageNamed:@"loading2"]];
        }else if (evaluateModel.picture.count == 3)
        {
            self.view1.hidden = NO;
            self.view2.hidden = NO;
            self.view3.hidden = NO;
            self.view4.hidden = YES;
            self.view5.hidden = YES;
            
            self.imageScrollView_.contentSize = CGSizeMake(imageH*3 + 30, 100);
            
            [self.view1 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[0]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view2 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[1]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view3 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[2]] placeholderImage:[UIImage imageNamed:@"loading2"]];
        }else if (evaluateModel.picture.count == 4)
        {
            self.view1.hidden = NO;
            self.view2.hidden = NO;
            self.view3.hidden = NO;
            self.view4.hidden = NO;
            self.view5.hidden = YES;
            self.imageScrollView_.contentSize = CGSizeMake(imageH*4+40, 100);
            
            [self.view1 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[0]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view2 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[1]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view3 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[2]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view4 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[3]] placeholderImage:[UIImage imageNamed:@"loading2"]];
        }else if (evaluateModel.picture.count == 5)
        {
            self.view1.hidden = NO;
            self.view2.hidden = NO;
            self.view3.hidden = NO;
            self.view4.hidden = NO;
            self.view5.hidden = NO;
            
            self.imageScrollView_.contentSize = CGSizeMake(imageH*5+50, 100);
            
            [self.view1 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[0]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view2 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[1]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view3 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[2]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view4 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[3]] placeholderImage:[UIImage imageNamed:@"loading2"]];
            [self.view5 sd_setImageWithURL:[NSURL URLWithString:evaluateModel.picture[4]] placeholderImage:[UIImage imageNamed:@"loading2"]];
        }
    }else
    {
        self.imageScrollView_.hidden = YES;
        self.view1.hidden = YES;
        self.view2.hidden = YES;
        self.view3.hidden = YES;
        self.view4.hidden = YES;
        self.view5.hidden = YES;
        
    }
  
}


+(CGFloat)CellHight:(ShowEvaluateModel *)model
{
    
    CGSize maxSize1 = CGSizeMake(GGUISCREENWIDTH - 20, MAXFLOAT);
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize  lastSize1 = [model.content boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    
    
    if (model.picture.count == 0 ) {
        return lastSize1.height + 90 + 10+28+20;
    }else
    {
       return lastSize1.height + 90 + 10+28+20 + imageH;
    }
    
}

-(void)handleDoubleTap1:(UITapGestureRecognizer *)tap
{
    UIViewController * controller = [self getCurrentVC];
    
    ShowEvaluateBigImageController * vc = [[ShowEvaluateBigImageController alloc]init];
    vc.evaluateModel = _evaluateModel;
    vc.index = 0;
    [(UINavigationController *)controller pushViewController:vc animated:NO];
}
-(void)handleDoubleTap2:(UITapGestureRecognizer *)tap
{
    UIViewController * controller = [self getCurrentVC];
    
    ShowEvaluateBigImageController * vc = [[ShowEvaluateBigImageController alloc]init];
    vc.index = 1;
    vc.evaluateModel = _evaluateModel;
    [(UINavigationController *)controller pushViewController:vc animated:NO];
}
-(void)handleDoubleTap3:(UITapGestureRecognizer *)tap
{
    UIViewController * controller = [self getCurrentVC];
    
    ShowEvaluateBigImageController * vc = [[ShowEvaluateBigImageController alloc]init];
    vc.index = 2;
    vc.evaluateModel = _evaluateModel;
    [(UINavigationController *)controller pushViewController:vc animated:NO];
}
-(void)handleDoubleTap4:(UITapGestureRecognizer *)tap
{
    UIViewController * controller = [self getCurrentVC];
    
    ShowEvaluateBigImageController * vc = [[ShowEvaluateBigImageController alloc]init];
    vc.index = 3;
    vc.evaluateModel = _evaluateModel;
    [(UINavigationController *)controller pushViewController:vc animated:NO];
}
-(void)handleDoubleTap5:(UITapGestureRecognizer *)tap
{
    UIViewController * controller = [self getCurrentVC];
    
    ShowEvaluateBigImageController * vc = [[ShowEvaluateBigImageController alloc]init];
    vc.index = 4;
    vc.evaluateModel = _evaluateModel;
    [(UINavigationController *)controller pushViewController:vc animated:NO];
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    UITabBarController *tab = (UITabBarController *)result;
    return tab.selectedViewController;
}

@end
