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
    if(![data.status isEqualToString:@"Y"]){

        UILabel* saleOutLab = [[UILabel alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH-104)/2, 105, 104, 104)];
        saleOutLab.textAlignment = NSTextAlignmentCenter;
        saleOutLab.backgroundColor = UIColorFromRGB(0x000000);
        saleOutLab.alpha = 0.7;
        saleOutLab.font = [UIFont systemFontOfSize:17];
        [saleOutLab setTextColor:UIColorFromRGB(0xffffff)];
        [saleOutLab.layer setMasksToBounds:YES];
        saleOutLab.layer.cornerRadius = 52;
        saleOutLab.hidden =YES;
        
        if([data.status isEqualToString:@"P"]){
            saleOutLab.text = @"预售中";
            saleOutLab.hidden =NO;
        } else if ([data.status isEqualToString:@"K"]){
            saleOutLab.text = @"已售罄";
            saleOutLab.hidden =NO;
        } else if ([data.status isEqualToString:@"D"]){
            saleOutLab.text = @"已下架";
            saleOutLab.hidden =NO;
        }
        [self.contentView addSubview:saleOutLab];
        
    }
    
    _scrollArr = data.itemPreviewImgs;
    self.titleLab.text = data.pinTitle;
    CGSize size  = [PublicMethod getSize:data.pinTitle Font:14 Width:GGUISCREENWIDTH-20 Height:1000];
    _detailConstraint.constant = size.height+1;
    _footViewConstraint.constant = 110 + size.height + 1 + GGUISCREENWIDTH/5;//GGUISCREENWIDTH/5是拼团玩法的高度
    if([self.delegate respondsToSelector:@selector(getOneCellH:)]){
        [self.delegate getOneCellH:(GGUISCREENWIDTH + 110 + size.height + 1 + GGUISCREENWIDTH/5)];
    }

    self.alreadySaleLab.text = [NSString stringWithFormat:@"已售：%ld件",(long)data.soldAmount];
    NSDictionary * dict =  data.floorPrice;
    if([dict allKeys].count>0){
        [self.pinSaleTopBtn setTitle:[NSString stringWithFormat:@"%@元/件起",[dict objectForKey:@"price"]] forState:UIControlStateNormal];
        if(data.pinTieredPricesArray.count == 1){
            [self.pinSaleBottomBtn setTitle:[NSString stringWithFormat:@"%@人团",[dict objectForKey:@"person_num"]] forState:UIControlStateNormal];
        }else{
            [self.pinSaleBottomBtn setTitle:[NSString stringWithFormat:@"最多%@人团",[dict objectForKey:@"person_num"]] forState:UIControlStateNormal];
        }

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
        imv.userInteractionEnabled = YES;
        [imv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageUpInside:)]];
        [_headView addSubview: imv];
    }
  
    
}
-(void) touchImageUpInside:(UITapGestureRecognizer *)recognizer{
    [self touchPage:0];
}
-(void)touchPage:(NSInteger)index{
    
    [self.delegate touchPage:index andImageArray:_scrollArr];
    
}

@end
