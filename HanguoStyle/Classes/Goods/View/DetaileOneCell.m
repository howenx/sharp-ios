//
//  DetaileOneCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/2.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "DetaileOneCell.h"
#import "HeadView.h"
@interface DetaileOneCell ()<HeadViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *costPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLab;
//@property (weak, nonatomic) IBOutlet UILabel *weightLab;
@property (weak, nonatomic) IBOutlet UILabel *postalTaxRateLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;

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
            if([[NSString stringWithFormat:@"%.1f",sizeData.itemDiscount] isEqualToString:@"0.0"]){
                 _detailLab.text = sizeData.invTitle;
            }else{
                _detailLab.text = [[[@"[" stringByAppendingString:[NSString stringWithFormat:@"%.1f",sizeData.itemDiscount]] stringByAppendingString:@"折]"] stringByAppendingString:sizeData.invTitle];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_detailLab.text];
                [str addAttribute:NSForegroundColorAttributeName value:GGMainColor range:NSMakeRange(0,itemDiscountCount)];
                _detailLab.attributedText = str;
            }
            
            itemDiscountCount = (int)[[NSString stringWithFormat:@"%.1f",sizeData.itemDiscount] length] + 3;
            
            self.areaLab.text = [NSString stringWithFormat:@"邮寄方式：%@",sizeData.invAreaNm];
            self.postalTaxRateLab.text = [NSString stringWithFormat:@"税率：%@",sizeData.postalTaxRate];
            self.postalTaxRateLab.text = [self.postalTaxRateLab.text stringByAppendingString:@"%"];
            
            
            
            //设置收藏
            UIImage * image ;
            if (sizeData.collectId == 0) {
                image = [UIImage imageNamed:@"grayStore"];
            }else{
                image = [UIImage imageNamed:@"redStore"];
            }
//            self.storeBtn.imageEdgeInsets = UIEdgeInsetsMake(10,GGUISCREENWIDTH/4-30,10,GGUISCREENWIDTH/4);
            [self.storeBtn setImage:image forState:UIControlStateNormal];
//            [self.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",(long)sizeData.collectCount] forState:UIControlStateNormal];
  
        }
    }

    if(_scrollArr.count>1){
        
        NSMutableArray * imageArr = [NSMutableArray array];
//        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, ((itemPreviewImgsData *)_scrollArr[0]).height * GGUISCREENWIDTH/((itemPreviewImgsData *)_scrollArr[0]).width)];
        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH)];
        hView.delegate =self;
        [hView shouldAutoShow:NO];
        for (int i = 0; i < _scrollArr.count; i++)
        {
            UIImageView *imv = [[UIImageView alloc] init];
//            imv.contentMode = UIViewContentModeScaleAspectFit;
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((itemPreviewImgsData *)_scrollArr[i]).url]];
            [imv sd_setImageWithURL:[NSURL URLWithString:((itemPreviewImgsData *)_scrollArr[i]).url] placeholderImage:[UIImage  imageNamed:@"load1ing"]];
//            imv.image = [UIImage imageWithData:data];
            [imageArr addObject:imv];
        }
        hView.imageViewAry = imageArr;
        hView.scrollView.scrollsToTop = NO;
        [_headView addSubview:hView];
    }else if(_scrollArr.count == 1){
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH)];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((itemPreviewImgsData *)_scrollArr[0]).url]];
        imv.image = [UIImage imageWithData:data];
        imv.userInteractionEnabled = YES;
        [imv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageUpInside:)]];
        [_headView addSubview: imv];
    }


    

    
    
    
    //设置原价上面删除线
    NSString * oldPrice = _costPriceLab.text;
    NSUInteger length = [oldPrice length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
    [_costPriceLab setAttributedText:attri];
    
    
}
-(void) touchImageUpInside:(UITapGestureRecognizer *)recognizer{
    [self touchPage:0];
}
-(void)touchPage:(NSInteger)index{

    [self.delegate touchPage:index andImageArray:_scrollArr];
    
}
@end
