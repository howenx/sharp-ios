//
//  JoinTeamMethodViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/18.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "JoinTeamMethodViewController.h"
#import "PhotoAndTextView.h"
@interface JoinTeamMethodViewController ()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView *scrollView;
@end

@implementation JoinTeamMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"拼团流程";
    PhotoAndTextView * ptv = [[PhotoAndTextView alloc]init];
    UIImage * image = [ptv imageCompressForWidth:[UIImage imageNamed:@"pingou_liucheng.png"] targetWidth:GGUISCREENWIDTH];
    UIImageView *imv = [[UIImageView alloc] init];
    imv.frame =  CGRectMake(0,0, image.size.width, image.size.height);
    imv.image = image;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(0,image.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:imv];
    [self.view addSubview:_scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
