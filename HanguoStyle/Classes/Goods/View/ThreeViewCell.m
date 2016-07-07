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
#import "BestSaleView.h"

@interface ThreeViewCell()<UIScrollViewDelegate,UIWebViewDelegate>
{
    UIWebView * twWebView;
}


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
    _data = data;
    //设置scrollview
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, 3000);
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(GGUISCREENWIDTH * 3, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.scrollsToTop = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.minimumZoomScale=1;
    _scrollView.maximumZoomScale=2.0;
    [_scrollView setZoomScale:1.0];
    if (_pageNum == 0) {
        
//        NSArray * arr =data.itemDetailImgs;
//        PhotoAndTextView * ptv = [[PhotoAndTextView alloc]init];
//        [ptv createPhotoTextView:arr andNotice:data.itemNotice];
//        UIPinchGestureRecognizer * pinch =  [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchingTap:)];
//        [_scrollView addGestureRecognizer:pinch];
        
        
        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//        [twWebView addGestureRecognizer:pan];
//        
//        
//        UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//        [_scrollView addGestureRecognizer:pan1];
        
//        twWebView.scalesPageToFit = YES

        twWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 1000)];
        
        twWebView.scrollView.scrollsToTop = NO;
        twWebView.delegate = self;
        twWebView.userInteractionEnabled = NO;
        [twWebView loadHTMLString:data.itemDetailImgs baseURL:nil];       
    }
    
    
    if (_pageNum == 1) {
        
        GoodsParaView * gpv = [[GoodsParaView alloc]init];
        
        NSLog(@"-----------!!!!!!!!----%@",data.itemFeatures);
        
        [gpv createParaView:data.itemFeatures];
        _scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, gpv.frame.size.height);
        [_scrollView addSubview:gpv];
        _scrollView.contentOffset = CGPointMake(GGUISCREENWIDTH, 0);
        [self.delegate getFourCellH:gpv.frame.size.height];

    }
    if (_pageNum == 2) {
        BestSaleView * bestSale = [[BestSaleView alloc]init];
        [bestSale createBestSale:data.pushArray];

         _scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, bestSale.frame.size.height);
        [_scrollView addSubview:bestSale];
        _scrollView.contentOffset = CGPointMake(GGUISCREENWIDTH*2, 0);
        [self.delegate getFourCellH:bestSale.frame.size.height];
    }
    
   [self.contentView addSubview:_scrollView];
    
}


//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//
//{
//    return twWebView;
//    
//}
//-(void)pinchingTap:(UIPinchGestureRecognizer*)gesture{
////    twWebView.userInteractionEnabled = YES;
////    CGRect zoomRect = [self zoomRectForScale:gesture.scale withCenter:[gesture locationInView:gesture.view]];
////    [(UIScrollView * )gesture.view.superview zoomToRect:zoomRect animated:YES];
//    NSLog(@"-----------%f",gesture.scale);
////    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
////    gesture.scale = 1;
//    [UIView animateWithDuration:gesture.velocity animations:^{
//        
//        //self.imageView.transform = CGAffineTransformMakeScale(pinchGesture.scale, pinchGesture.scale);
//        
//        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
//        //为了防止在缩放时,图片缩放过快,将缩放比例置1
//        gesture.scale = 1;
//        
//    }];
//    
//}
//-(void)handlePan:(UIPinchGestureRecognizer*)gesture{
//    twWebView.userInteractionEnabled = NO;
//}
//
//- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
//{
//    CGRect zoomRect;
//    zoomRect.size.height=self.contentView.frame.size.height/ scale;
//    zoomRect.size.width=self.contentView.frame.size.width/ scale;
//    zoomRect.origin.x= center.x- (zoomRect.size.width/2.0);
//    zoomRect.origin.y= center.y- (zoomRect.size.height/2.0);
//    return zoomRect;
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if(scrollView.contentOffset.x/GGUISCREENWIDTH != _pageNum){
        [self.delegate scrollPage:scrollView.contentOffset.x/GGUISCREENWIDTH];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGRect frame = twWebView.frame;
    twWebView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    
    
    _scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, height);
    [_scrollView addSubview:twWebView];
    [self.delegate getFourCellH:height];
}


@end
