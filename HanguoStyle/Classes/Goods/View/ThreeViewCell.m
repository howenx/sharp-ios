//
//  ThreeViewCell.m
//  UITableViewDemo3
//
//  Created by liudongsheng on 15/10/26.
//  Copyright (c) 2015年 KG. All rights reserved.
//

#import "ThreeViewCell.h"
#import "PhotoAndTextView.h"
#import "GoodsParaView.h"

@interface ThreeViewCell()<UIScrollViewDelegate>



@end
@implementation ThreeViewCell
+(id)subjectCell
{
    UINib * nib = [UINib nibWithNibName:@"ThreeViewCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:self options:nil]lastObject];
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setData:(GoodsDetailData *)data
{
    //设置scrollview
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, 3000);
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(GGUISCREENWIDTH * 3, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    if (_pageNum == 0) {
        
        NSArray * arr =data.itemDetailImgs;
//        NSArray * arr =@[@"http://img3.douban.com/view/movie_poster_cover/lpst/public/p480747492.jpg",
//                      @"http://img3.douban.com/view/movie_poster_cover/lpst/public/p1356576774.jpg",
//                      @"http://img3.douban.com/view/movie_poster_cover/lpst/public/p510876400.jpg",
//                      @"http://x1.zhuti.com/down/2012/11/29-win7/3D-1.jpg"];
        
        PhotoAndTextView * ptv = [[PhotoAndTextView alloc]init];
        [ptv createPhotoTextView:arr andNotice:data.itemNotice];
         _scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, ptv.frame.size.height);
        [_scrollView addSubview:ptv];
        [self.delegate getFourCellH:ptv.frame.size.height];
    }
    
    
    if (_pageNum == 1) {
        
        GoodsParaView * gpv = [[GoodsParaView alloc]init];
        [gpv createParaView:data.itemFeatures];
        _scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, gpv.frame.size.height);
        [_scrollView addSubview:gpv];
        _scrollView.contentOffset = CGPointMake(GGUISCREENWIDTH, 0);
        [self.delegate getFourCellH:gpv.frame.size.height];

    }
    if (_pageNum == 2) {
        UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH*2, 0, GGUISCREENWIDTH, 10000)];
        view3.backgroundColor = [UIColor lightGrayColor];
         _scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, view3.frame.size.height);
        [_scrollView addSubview:view3];
        _scrollView.contentOffset = CGPointMake(GGUISCREENWIDTH*2, 0);
        [self.delegate getFourCellH:view3.frame.size.height];
    }
    
   [self.contentView addSubview:_scrollView];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if(scrollView.contentOffset.x/GGUISCREENWIDTH != _pageNum){
        [self.delegate scrollPage:scrollView.contentOffset.x/GGUISCREENWIDTH];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



@end
