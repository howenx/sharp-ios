//
//  DetailTwoCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/6.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "DetailTwoCell.h"

@implementation DetailTwoCell
- (void)setData:(ThreeViewData *)data{
    //绘制颜色部分

    UILabel * colorLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
    colorLab.text = @"颜色分类";
    colorLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:colorLab];
    
    
    CGRect colorRect = CGRectMake(0, 45, 0, 20);
    NSArray * colorArray = @[@"天空蓝",@"葡萄紫",@"白色",@"灰色",@"黑色",@"藏蓝色",@"蓝色",@"紫色"];
    _colorMutArray = [self createBtnWithTitleArray:colorArray andfirstRect:colorRect andTagCount:1000];
    _colorBtnTag = 1000;
    for(UIButton * btn in _colorMutArray){
        [self.contentView addSubview:btn];
    }
    UIButton * lastColorBtn = (UIButton *)[_colorMutArray lastObject];

    
    //绘制中间分割线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, lastColorBtn.frame.origin.y + lastColorBtn.frame.size.height + 10, GGUISCREENWIDTH-20, 1)];
    lineView.backgroundColor = GGColor(234, 234, 234);
    [self.contentView addSubview:lineView];
    
    //绘制尺寸部分
    
    UILabel * sizeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.frame.origin.y+15, 80, 20)];
    sizeLab.text = @"尺寸";
    sizeLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:sizeLab];
    
    CGRect sizeRect = CGRectMake(0, sizeLab.frame.origin.y + sizeLab.frame.size.height + 10, 0, 20);
    NSArray * sizeArray = @[@"m码",@"s码",@"L码",@"XL码",@"XXL码",@"XXXL码"];
    _sizeMutArray = [self createBtnWithTitleArray:sizeArray andfirstRect:sizeRect andTagCount:2000];
    _sizeBtnTag = 2000;
    for(UIButton * btn in _sizeMutArray){
        [self.contentView addSubview:btn];
    }
    UIButton * lastSizeBtn = (UIButton *)[_sizeMutArray lastObject];
    
    //绘制脚步view
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, lastSizeBtn.frame.origin.y + lastSizeBtn.frame.size.height + 10, GGUISCREENWIDTH, 8)];
    footView.backgroundColor = GGColor(234, 234, 234);
    [self.contentView addSubview:footView];
    
    if([self.delegate respondsToSelector:@selector(getTwoCellH:)]){
        [self.delegate getTwoCellH:(footView.frame.origin.y + footView.frame.size.height)];
    }
    
    

}

- (NSMutableArray *)createBtnWithTitleArray :(NSArray *) array andfirstRect :(CGRect) fistRect andTagCount :(NSInteger) tagCount{

    CGRect rect = fistRect;
    NSMutableArray * mutArray = [NSMutableArray array];
   
    
    for(int i = 0;i<array.count;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i + tagCount;
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
        [button addTarget:self  action:@selector(theButtonClick:)  forControlEvents:UIControlEventTouchDown];
        
        [button.layer setCornerRadius:5];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
        [button setBackgroundColor:[UIColor whiteColor]];
        if(i==0){
            [button setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
            [button.layer setBorderColor:[UIColor redColor].CGColor];
        }
        CGSize size  = [self getSize:array[i] Font:11 Width:GGUISCREENWIDTH-20-20 Height:20];
        
        if(rect.origin.x + rect.size.width + size.width + 20 + 20 > GGUISCREENWIDTH){
            button.frame = CGRectMake(10, rect.origin.y + rect.size.height +10, size.width+20, size.height+10);
        }else{
            button.frame = CGRectMake(rect.origin.x + rect.size.width +10, rect.origin.y, size.width+20, size.height+10);
        }
        
        rect = button.frame;
        [mutArray addObject:button];
        
    }
    return mutArray;
    
    
}
-(void)theButtonClick:(UIButton *) btn{
    //如果点的是颜色分类，把颜色分类里面的按钮flag赋值给全局的_colorBtnTag，反之size也是一样，最后在会掉颜色和尺寸的id给controller
    if(ceil(_colorBtnTag/1000) == ceil(btn.tag/1000)){
        for(UIButton * button in _colorMutArray){
            if(_colorBtnTag == button.tag ){
                [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
                [button.layer setBorderColor:[UIColor grayColor].CGColor];
                _colorBtnTag = btn.tag ;
            }
        }

    }
    if(ceil(_sizeBtnTag/1000) == ceil(btn.tag/1000)){
        for(UIButton * button in _sizeMutArray){
            if(_sizeBtnTag == button.tag){
                [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
                [button.layer setBorderColor:[UIColor grayColor].CGColor];
                _sizeBtnTag = btn.tag ;
            }
        }
    }
    
    [btn setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    [btn.layer setBorderColor:[UIColor redColor].CGColor];
    if([self.delegate respondsToSelector:@selector(getColorClassify:)]){
        [self.delegate getColorClassify:[NSString stringWithFormat:@"颜色ID%ld",(long)_colorBtnTag]];
    }
    if([self.delegate respondsToSelector:@selector(getSize:)]){
        [self.delegate getSize:[NSString stringWithFormat:@"尺寸%ld",(long)_sizeBtnTag]];
    }

    
}
-(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeofstr]} context:nil].size;
    }
    else
    {
        size = [str sizeWithFont:[UIFont systemFontOfSize:sizeofstr]constrainedToSize:CGSizeMake(width, height)];
    }
    return size;
}

@end
