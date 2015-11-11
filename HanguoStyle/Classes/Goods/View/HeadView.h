//
//  HeadView.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/14.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeadView;
@protocol HeadViewDelegate <NSObject>
@optional
- (void)didClickPage:(HeadView *)view atIndex:(NSInteger)index;

@end
@interface HeadView : UIView <UIScrollViewDelegate>
@property (nonatomic, assign) id <HeadViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *imageViewAry;

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, readonly) UIPageControl *pageControl;

-(void)shouldAutoShow:(BOOL)shouldStart;
@end
