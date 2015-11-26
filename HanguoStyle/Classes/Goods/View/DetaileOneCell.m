//
//  DetaileOneCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/2.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "DetaileOneCell.h"
#import "HeadView.h"
#import "UIButton+GG.h"
@interface DetaileOneCell ()<HeadViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *costPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLab;

@property (nonatomic,strong)NSArray * scrollArr;

@end
@implementation DetaileOneCell
+(id)subjectCell
{
    UINib * nib = [UINib nibWithNibName:@"DetaileOneCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:self options:nil]lastObject];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setData:(GoodsDetailData *)data

{
    int itemDiscountCount = 0;
    for(SizeData * sizeData in data.sizeArray){
        if(sizeData.orMasterInv){
            _scrollArr = sizeData.itemPreviewImgs;
            _costPriceLab.text = [NSString stringWithFormat:@"%.2f",sizeData.itemSrcPrice];
            _currentPriceLab.text = [NSString stringWithFormat:@"%.2f",sizeData.itemPrice];
            _detailLab.text = [[[@"[" stringByAppendingString:[NSString stringWithFormat:@"%.1f",sizeData.itemDiscount]] stringByAppendingString:@"折]"] stringByAppendingString:sizeData.invTitle];
            itemDiscountCount = [[NSString stringWithFormat:@"%.1f",sizeData.itemDiscount] length] + 3;
            
            
        }
    }
//    _scrollArr =@[@"http://img3.douban.com/view/movie_poster_cover/lpst/public/p480747492.jpg",
//                  @"http://img3.douban.com/view/movie_poster_cover/lpst/public/p1356576774.jpg"];
    if(_scrollArr.count>1){
        NSMutableArray * imageArr = [NSMutableArray array];
        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH)];
        [hView shouldAutoShow:YES];
        for (int i = 0; i < _scrollArr.count; i++)
        {
            UIImageView *imv = [[UIImageView alloc] init];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_scrollArr[i]]];
            imv.image = [UIImage imageWithData:data];
            [imageArr addObject:imv];
        }
        hView.imageViewAry = imageArr;
        [_headView addSubview:hView];
    }else if(_scrollArr.count == 1){
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH)];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_scrollArr[0]]];
        imv.image = [UIImage imageWithData:data];
        [_headView addSubview: imv];
    }


    

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_detailLab.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,itemDiscountCount)];
    _detailLab.attributedText = str;
    
    
    //设置原价上面删除线
    NSString * oldPrice = _costPriceLab.text;
    NSUInteger length = [oldPrice length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
    [_costPriceLab setAttributedText:attri];
    
    
    //设置收藏
    UIImage * image ;
    if (data.orCollect) {
        image = [UIImage imageNamed:@"redStore"];
    }else{
        image = [UIImage imageNamed:@"grayStore"];
    }
    [self.storeBtn setImage:image forState:UIControlStateNormal];
    [self.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",(long)data.collectCount] forState:UIControlStateNormal];
    
//    [self.storeBtn setImage:image withTitle:[NSString stringWithFormat:@"（%d)",data.storeCount] forState:UIControlStateNormal];
}
@end
