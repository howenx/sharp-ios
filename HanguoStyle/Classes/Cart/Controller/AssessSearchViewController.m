//
//  AssessSearchViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "AssessSearchViewController.h"
#import "PlaceholderTextView.h"
#define photoW (GGUISCREENWIDTH-60)/5

@interface AssessSearchViewController ()<UIScrollViewDelegate>

@end

@implementation AssessSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"查看评价";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createView];
    
}
- (void)createView{
    self.view.backgroundColor = GGBgColor;
    //设置scrollview
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    
    CGFloat picH = 0 ;
    if (_assessListData.comment.picArray.count>0) {
        picH = photoW;
    }
    CGSize size  = [PublicMethod getSize:_assessListData.comment.content Font:13 Width:GGUISCREENWIDTH-20 Height:1000];
    if(size.height<40){

        scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, 150+picH+15);
        scrollView.contentSize = CGSizeMake(0, 150+picH+15);
    }else{
        if(110 +picH + 15+size.height<GGUISCREENHEIGHT-64){
            scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, 110 +picH + 15+size.height);
        }else{
            scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64);
        }
        scrollView.contentSize = CGSizeMake(0, 110 + picH + 15+size.height);
    }
    
    
    scrollView.delegate = self;
    
    
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.pagingEnabled = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollsToTop = YES;
    [self.view addSubview:scrollView];

    
    
    UIImageView * goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,70,70)];
    goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    CALayer *layer = [goodsImageView layer];
    layer.borderColor = GGBgColor.CGColor;
    layer.borderWidth = 1.0f;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:_assessListData.orderLine.invImg]];
    [scrollView addSubview:goodsImageView];
    
    
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 55, 20)];
    titleLab.numberOfLines = 1;
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.text = @"描述相符";
    [scrollView addSubview:titleLab];
    CGRect starFrame = CGRectMake(150, 40, 30, 22);
    for (int i = 0; i<5; i++) {
        UIImageView * starImageView = [[UIImageView alloc] init];
        starImageView.frame = starFrame;
        starFrame.origin.x = starFrame.origin.x + starFrame.size.width;
        if (i < _assessListData.comment.grade) {
            starImageView.image = [UIImage imageNamed:@"foregroundStar"];
        }else{
            starImageView.image = [UIImage imageNamed:@"backgroundStar"];
        }
        [scrollView addSubview:starImageView];
    }
    
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 89, GGUISCREENWIDTH, 1)];
    line1.backgroundColor = GGBgColor;
    [scrollView addSubview:line1];
    
    
    UILabel * label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0xa9a9a9);
    label.text = _assessListData.comment.content;
    label.font=[UIFont boldSystemFontOfSize:13];
    
    if(size.height<40){
        label.frame = CGRectMake(10, 100, GGUISCREENWIDTH-20, 40);
    }else{
        label.frame = CGRectMake(10, 100, GGUISCREENWIDTH-20, size.height);
    }
    [scrollView addSubview:label];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, label.y + label.height+10, GGUISCREENWIDTH, photoW)];
    [scrollView addSubview:view];
    CGRect workingFrame = CGRectMake(10, 0, photoW, photoW);
    for(int i = 0;i<_assessListData.comment.picArray.count;i++){
        UIImageView * imageview = [[UIImageView alloc] init];
        [imageview sd_setImageWithURL:[NSURL URLWithString:_assessListData.comment.picArray[i]]];
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.frame = workingFrame;
        [view addSubview:imageview];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width + 10;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
