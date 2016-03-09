//
//  PinDetailOneCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/18.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import "PinDetailOneCell.h"
#import "HeadView.h"
@interface PinDetailOneCell ()<HeadViewDelegate>

@property (nonatomic,strong)NSArray * scrollArr;

@end

@implementation PinDetailOneCell
+(id)subjectCell
{
    UINib * nib = [UINib nibWithNibName:@"PinDetailOneCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:self options:nil]lastObject];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setData:(PinGoodsDetailData *)data

{


    _scrollArr = data.itemPreviewImgs;
    self.titleLab.text = data.pinTitle;
    self.alreadySaleLab.text = [NSString stringWithFormat:@"已售：%ld件",(long)data.soldAmount];
    NSDictionary * dict =  data.floorPrice;
    
    if([dict allKeys].count>0){
        [self.pinSaleTopBtn setTitle:[NSString stringWithFormat:@"%@元/件起",[dict objectForKey:@"price"]] forState:UIControlStateNormal];
        [self.pinSaleBottomBtn setTitle:[NSString stringWithFormat:@"最多%@人团",[dict objectForKey:@"person_num"]] forState:UIControlStateNormal];
    }
    [self.singleSaleTopBtn setTitle:[NSString stringWithFormat:@"%@元/件",data.invPrice] forState:UIControlStateNormal];
    
    [self.pinMethodBtn setBackgroundImage:[UIImage imageNamed:@"pingou_wanfa"] forState:UIControlStateNormal];
    
    //当status为P的时候是预售，团购和立即购买按钮不能点
    if(![data.status isEqualToString:@"Y"]){
        self.pinSaleTopBtn.enabled = NO;
        self.pinSaleBottomBtn.enabled = NO;
        self.singleSaleTopBtn.enabled = NO;
        self.singleSaleBottomBtn.enabled = NO;
        self.pinSaleTopBtn.alpha = 0.4;
        self.pinSaleBottomBtn.alpha = 0.4;
        self.singleSaleTopBtn.alpha = 0.4;
        self.singleSaleBottomBtn.alpha = 0.4;
    }
    
    
    
    if(_scrollArr.count>1){
        
        NSMutableArray * imageArr = [NSMutableArray array];
//        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, ((ItemPreviewImgsData *)_scrollArr[0]).height * GGUISCREENWIDTH/((ItemPreviewImgsData *)_scrollArr[0]).width)];
        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH)];

        hView.delegate =self;
        [hView shouldAutoShow:NO];
        for (int i = 0; i < _scrollArr.count; i++)
        {
            UIImageView *imv = [[UIImageView alloc] init];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((ItemPreviewImgsData *)_scrollArr[i]).url]];
            imv.image = [UIImage imageWithData:data];
            [imageArr addObject:imv];
        }
        hView.imageViewAry = imageArr;
        hView.scrollView.scrollsToTop = NO;
        [_headView addSubview:hView];
    }else if(_scrollArr.count == 1){
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH)];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((ItemPreviewImgsData *)_scrollArr[0]).url]];
        imv.image = [UIImage imageWithData:data];
        [_headView addSubview: imv];
    }
  
    
}
-(void)touchPage:(NSInteger)index{
    
    [self.delegate touchPage:index andImageArray:_scrollArr];
    
}

@end
