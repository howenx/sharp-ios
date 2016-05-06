//
//  AssessListCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/26.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "AssessListCell.h"
#import "AssessViewController.h"
#import "AssessSearchViewController.h"
@interface AssessListCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;


@end
@implementation AssessListCell

- (void)awakeFromNib {

}
- (void)setData:(AssessListData *)data{
    _data = data;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:data.orderLine.invImg]];
    self.titleLab.text = data.orderLine.skuTitle;
    if(data.comment==nil){
        [self.commitBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
    }else{
        [self.commitBtn setTitle:@"查看评价" forState:UIControlStateNormal];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)commitClick:(UIButton *)sender {
    if(_data.comment==nil){
        UIViewController * controller = [self getCurrentVC];
        AssessViewController * assess = [[AssessViewController alloc]init];
        assess.assessListData = _data;
        [(UINavigationController *)controller pushViewController:assess animated:YES];
    }else{
        UIViewController * controller = [self getCurrentVC];
        AssessSearchViewController * assessSearch = [[AssessSearchViewController alloc]init];
        assessSearch.assessListData = _data;
        [(UINavigationController *)controller pushViewController:assessSearch animated:YES];
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

@end
