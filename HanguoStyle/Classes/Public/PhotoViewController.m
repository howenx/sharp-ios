//
//  PhotoViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/20.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()<UIScrollViewDelegate>
{
    BOOL tapClicks;
}
@property(nonatomic) UIScrollView * imageScrollView;
@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    tapClicks = NO;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.alpha = 0;
    self.view.backgroundColor= [UIColor blackColor];
    NSArray * array = _data;
    self.imageScrollView= [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,GGUISCREENWIDTH,GGUISCREENHEIGHT)];
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.backgroundColor= [UIColor clearColor];
    self.imageScrollView.scrollEnabled=YES;
    self.imageScrollView.pagingEnabled=YES;
    self.imageScrollView.delegate=self;

    self.imageScrollView.contentSize=CGSizeMake(array.count*GGUISCREENWIDTH,GGUISCREENHEIGHT);
    for(int i = 0; i < _data.count; i++){
        UITapGestureRecognizer * doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UITapGestureRecognizer * oneTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleOneTap:)];
        [oneTap setNumberOfTapsRequired:1];
        [oneTap requireGestureRecognizerToFail:doubleTap];
        
        UIPinchGestureRecognizer * pinch =  [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchingTap:)];
        
        
        UIScrollView * s = [[UIScrollView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH*i,0,GGUISCREENWIDTH,GGUISCREENHEIGHT)];
        s.backgroundColor= [UIColor clearColor];
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.contentSize=CGSizeMake(GGUISCREENWIDTH,GGUISCREENHEIGHT);
        s.delegate=self;
        s.minimumZoomScale=1;
        s.maximumZoomScale=2.0;
        [s setZoomScale:1.0];
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:_imageFrame];
        NSString * imageName = [_data objectAtIndex:i];
        [imageview sd_setImageWithURL:[NSURL URLWithString:imageName]];
        imageview.userInteractionEnabled=YES;
        imageview.tag= i+1;
        [imageview addGestureRecognizer:doubleTap];
        [imageview addGestureRecognizer:oneTap];
        [imageview addGestureRecognizer:pinch];
        [s addSubview:imageview];
        [self.imageScrollView addSubview:s];
    }

    [self.view addSubview:self.imageScrollView];
    self.imageScrollView.contentOffset =CGPointMake(GGUISCREENWIDTH * _order, 0);
}
#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for(UIView * v in scrollView.subviews){
        return v;
    }
    return nil;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    _imageScrollView=nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation ==UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown)
    {
        return YES;
    }
    return NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    if(scrollView == self.imageScrollView){

            for(UIScrollView * s in scrollView.subviews){
                if([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0]; //scrollView每滑动一次将要出现的图片较正常时候图片的倍数（将要出现的图片显示的倍数）
                }
        }
    }
}
#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer*)gesture{
    float newScale;
    if (!tapClicks) {
        newScale = [(UIScrollView*)gesture.view.superview zoomScale] *2;//每次双击放大倍数
    }else{
        newScale = [(UIScrollView*)gesture.view.superview zoomScale] *0;//每次双击放大倍数
    }

    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView * )gesture.view.superview zoomToRect:zoomRect animated:YES];
    tapClicks = !tapClicks;
}
-(void)handleOneTap:(UIGestureRecognizer*)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pinchingTap:(UIPinchGestureRecognizer*)gesture{
//    CGAffineTransform myTransformation = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
//    gesture.view.transform = myTransformation;
    
    
    CGRect zoomRect = [self zoomRectForScale:gesture.scale withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView * )gesture.view.superview zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height=self.view.frame.size.height/ scale;
    zoomRect.size.width=self.view.frame.size.width/ scale;
    zoomRect.origin.x= center.x- (zoomRect.size.width/2.0);
    zoomRect.origin.y= center.y- (zoomRect.size.height/2.0);
    return zoomRect;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
