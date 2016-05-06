//
//  ShowBigImageForShowImageViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/5/4.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "ShowBigImageForShowImageViewController.h"
#import "UIImage+GG.h"
#import "ShowImageEvaluateModel.h"
@interface ShowBigImageForShowImageViewController ()<UIScrollViewDelegate>

@end

@implementation ShowBigImageForShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.titleView.textAlignment  = NSTextAlignmentCenter;
    self.titleView.textColor = [UIColor whiteColor];
    //    self.titleView.backgroundColor = [UIColor cyanColor];
    self.titleView.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.array.count];
    
    self.navigationItem.titleView = self.titleView;
    
    [self setupSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    .barTintColor  [UIColor blueColor];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage createImageWithColor:[UIColor blackColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage createImageWithColor:GGMainColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
}


-(void)setupSubViews
{
    self.imageScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.imageScrollView_.backgroundColor = [UIColor blackColor];
    
    self.imageScrollView_.showsVerticalScrollIndicator= NO;
    self.imageScrollView_.showsHorizontalScrollIndicator= NO;
    self.imageScrollView_.alwaysBounceVertical = YES;
    self.imageScrollView_.alwaysBounceHorizontal = YES;
    //    self.imageScrollView_.backgroundColor = [UIColor yellowColor];
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    self.imageScrollView_.delegate = self;
    // 设置内容大小
    self.imageScrollView_.contentSize = CGSizeMake(SCREEN_WIDTH* self.array.count, SCREEN_HEIGHT-200-64);
    // 是否反弹
    self.imageScrollView_.bounces = NO;
    // 是否分页
    self.imageScrollView_.pagingEnabled = YES;
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
    //    self.imageScrollView_.directionalLockEnabled = YES;
    [self.view addSubview:self.imageScrollView_];
    
    self.imageScrollView_.contentOffset = CGPointMake(self.index * SCREEN_WIDTH, 0);
    
    for (int i = 0; i<self.array.count; i++) {
        UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        [view sd_setImageWithURL:[NSURL URLWithString:((ShowImageEvaluateModel *)self.array[i]).picture] placeholderImage:[UIImage imageNamed:@"loading1"]];
        [self.imageScrollView_ addSubview:view];
        
        
        UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, SCREEN_HEIGHT-64-150, SCREEN_WIDTH, 150)];
            downView.backgroundColor = [UIColor colorWithRed:((float)((0x303030 & 0xFF0000) >> 16))/255.0 green:((float)((0x303030 & 0xFF00) >> 8))/255.0 blue:((float)(0x303030 & 0xFF))/255.0 alpha:0.4];
        
//        downView.backgroundColor = RandomColor;
        
        
        UIImageView * starView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 66, 10)];
        starView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ldstar",(long)((ShowImageEvaluateModel *)self.array[i]).grade]];
        
        
        
        UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(starView, 10), SCREEN_WIDTH-20, 100)];
         contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:13];
        //    contentLabel.backgroundColor = [UIColor redColor];
        contentLabel.text = ((ShowImageEvaluateModel *)self.array[i]).content;
        contentLabel.textColor = [UIColor whiteColor];
        
        
        CGSize maxSize1 = CGSizeMake(GGUISCREENWIDTH - 20, MAXFLOAT);
        NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGSize  lastSize1 = [((ShowImageEvaluateModel *)self.array[i]).content boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
        
        downView.frame =  CGRectMake(i*SCREEN_WIDTH, SCREEN_HEIGHT-64-(lastSize1.height + 10 + 10 + 10+10), SCREEN_WIDTH, lastSize1.height + 10 + 10 + 10+10);
        starView.frame = CGRectMake(10, 10 , 66, 10);
        contentLabel.frame = CGRectMake(10, PosYFromView(starView, 10) , SCREEN_WIDTH-20, lastSize1.height);
         
        [self.imageScrollView_ addSubview:downView];
        [downView addSubview:starView];
        [downView addSubview:contentLabel];
        
        
        
        
    }
    
    

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    int page = x /  SCREEN_WIDTH;
    self.titleView.text = [NSString stringWithFormat:@"%d/%ld",page+1,self.array.count];
}

@end
