//
//  DetailTwoCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/6.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "DetailTwoCell.h"

@interface DetailTwoCell()
{
    NSString * _sizeName;
    GoodsDetailData * _goodsDetailData;
}
@property (nonatomic, strong) NSArray * sizeMutArray;
@property (nonatomic, assign) NSInteger sizeBtnTag;
@end
@implementation DetailTwoCell
- (void)setData:(GoodsDetailData *)data{
    //绘制颜色部分
    _goodsDetailData = data;
    UILabel * colorLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
    colorLab.text = @"规格";
    colorLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:colorLab];
    CGRect colorRect = CGRectMake(0, 45, 0, 20);

    _sizeMutArray = [self createBtnWithTitleArray: data.sizeArray andfirstRect:colorRect andTagCount:1000];
    _sizeBtnTag = 1000;
    for(UIButton * btn in _sizeMutArray){
        [self.contentView addSubview:btn];
    }
    UIButton * lastSizeBtn = (UIButton *)[_sizeMutArray lastObject];


    
    //绘制脚步view
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, lastSizeBtn.frame.origin.y + lastSizeBtn.frame.size.height + 10, GGUISCREENWIDTH, 8)];
    footView.backgroundColor = GGColor(240, 240, 240);
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
        NSString * name = ((SizeData *)array[i]).itemSize;
        NSString * state = ((SizeData *)array[i]).state;//是否下架
        if(![state isEqualToString:@"Y"]){//非正常状态，按钮不让点击
            button.userInteractionEnabled = NO;
            button.alpha = 0.3;
        }
        [button setTitle:name forState:UIControlStateNormal];
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
        [button addTarget:self  action:@selector(theButtonClick:)  forControlEvents:UIControlEventTouchDown];
        
        [button.layer setCornerRadius:5];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
        [button setBackgroundColor:[UIColor whiteColor]];
        //当进入页面选中的颜色或者尺寸和列表里面相同的时候就把这个按钮变红
        if(((SizeData *)array[i]).orMasterInv){
            _sizeName = ((SizeData *)array[i]).itemSize;
            if([state isEqualToString:@"Y"]){//非正常状态，按钮不让点击
                [button setTitleColor:GGMainColor forState:UIControlStateNormal];
                [button.layer setBorderColor:GGMainColor.CGColor];
            }
        }
        CGSize size  = [PublicMethod getSize:name Font:11 Width:GGUISCREENWIDTH-20-20 Height:20];
        
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
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    if(ceil(_sizeBtnTag/1000) == ceil(btn.tag/1000)){
        NSString * sizeString =  btn.titleLabel.text;
        if([_sizeName isEqualToString:sizeString]){
            return;
        }
        NSMutableArray * array = [_goodsDetailData.sizeArray mutableCopy];
        for(int i = 0;i < array.count; i++ ){
            SizeData * sData = array[i];
            if([sData.itemSize isEqualToString:_sizeName]){
                SizeData * sDataUpdate = [SizeData new];
                sDataUpdate = sData;
                sDataUpdate.orMasterInv = false;
                [array replaceObjectAtIndex:i withObject:sDataUpdate];
            }
            
            if([sData.itemSize isEqualToString:sizeString]){
                SizeData * sDataUpdate = [SizeData new];
                sDataUpdate = sData;
                sDataUpdate.orMasterInv = true;
                [array replaceObjectAtIndex:i withObject:sDataUpdate];
            }
        }
        
        
        
        
        for(UIButton * button in _sizeMutArray){
            if([button.titleLabel.text isEqualToString:_sizeName]){
                [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
                [button.layer setBorderColor:[UIColor grayColor].CGColor];
            }
        }
        _goodsDetailData.sizeArray = array;
        _sizeName = sizeString;
        [btn setTitleColor:GGMainColor forState:UIControlStateNormal];
        [btn.layer setBorderColor:GGMainColor.CGColor];


    }
   
    
    if([self.delegate respondsToSelector:@selector(getNewData:)]){
        [self.delegate getNewData:_goodsDetailData];
    }

}


@end
