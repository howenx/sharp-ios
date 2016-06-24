//
//  RecommendGoodsView.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/8.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "RecommendGoodsView.h"
#import "GoodsShowCell.h"
#import "PinGoodsDetailViewController.h"
#import "GoodsDetailViewController.h"

@interface RecommendGoodsView()
{
    UIView *pushView;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation RecommendGoodsView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)makeUI
{
    
    self.backgroundColor =[UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    [self addSubview:bgView];
    
    
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
    pushView = [[UIView alloc ]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT, self.frame.size.width, GGUISCREENWIDTH/2+56+10)];
    [UIView animateWithDuration:0.3 animations:^{
        pushView.frame =CGRectMake(0, GGUISCREENHEIGHT - (GGUISCREENWIDTH/2+56+10), self.frame.size.width, GGUISCREENWIDTH/2+56+10);
    }];
    pushView.tag = 70;
    pushView.backgroundColor = GGBgColor;
    [self addSubview:pushView];
    
    _collectionView.scrollsToTop = NO;
    
    
    //注册xib
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodsShowCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsShowCell"];
    _collectionView.backgroundColor = GGBgColor;
    
    
    
    
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        /**
         流式布局
         */
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        

        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        //创建一个collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, GGUISCREENWIDTH, GGUISCREENWIDTH/2+56) collectionViewLayout:layout];
        _collectionView.backgroundColor = GGBgColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [pushView addSubview:_collectionView];
    }
    
    return _collectionView;
}
//去掉一横排两个cell之间的空隙
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
/**
 有多少组
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/**
 每组显示的item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     复用机制
     */
    
    GoodsShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsShowCell" forIndexPath:indexPath];
    
    if(_data.count>0){
        [cell setData:_data[indexPath.item]];
    }
    
    return cell;
}




//返回item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(GGUISCREENWIDTH/2,GGUISCREENWIDTH/2+56);
}

/**
 点击了某个item会调用
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self removeFromSuperview];
    UIViewController * controller = [self getCurrentVC];
    NSString * _pushUrl = ((GoodsShowData *)_data[indexPath.item]).itemUrl;
    NSString * itemType = ((GoodsShowData *)_data[indexPath.item]).itemType;
    //进入到商品展示页面
    if ([@"pin" isEqualToString:itemType]) {
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = _pushUrl;
        [(UINavigationController *)controller pushViewController:pinViewController animated:YES];
    }else{
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = _pushUrl;
        [(UINavigationController *)controller pushViewController:gdViewController animated:YES];
    }
    
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



-(void)tap:(UIGestureRecognizer *)sender
{
    UIView *shareView = [self viewWithTag:70];
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame =CGRectMake(0, GGUISCREENHEIGHT, self.frame.size.width, GGUISCREENWIDTH/2+56+10);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
