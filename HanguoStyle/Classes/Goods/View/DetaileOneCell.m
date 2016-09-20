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
@property (weak, nonatomic) IBOutlet UILabel *costPriceLab;//原价
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLab;//现价
//@property (weak, nonatomic) IBOutlet UILabel *weightLab;
//@property (weak, nonatomic) IBOutlet UILabel *postalTaxRateLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footViewConstraint;
@property (weak, nonatomic) IBOutlet UILabel *restrictLab;
@property (nonatomic,strong)NSArray * scrollArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPriceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *costPriceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restrictConstraint;
@property (weak, nonatomic) IBOutlet UIView *publicityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publicityHConstraint;

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
    _detailLab.lineBreakMode = NSLineBreakByCharWrapping;
    int itemDiscountCount = 0;
    
    
    //P 状态显示预售中 K 状态显示已售罄  D 状态显示已下架 Y正常状态
    //当全部非正常状态（Y）的时候，显主sku的商品状态
    NSString* status = @"other";
    NSString* mainSkuStatus = @"";
    
    for(SizeData * sizeData in data.sizeArray){
        if([sizeData.state isEqualToString:@"Y"]){
            status = @"Y";
        }
        if(sizeData.orMasterInv){
            _scrollArr = sizeData.itemPreviewImgs;
            mainSkuStatus = sizeData.state;
            _costPriceLab.text = [NSString stringWithFormat:@"￥%@",sizeData.itemSrcPrice];
            CGSize costPriceSize  = [PublicMethod getSize:_costPriceLab.text Font:12 Width:GGUISCREENWIDTH-100 Height:1000];
            _costPriceConstraint.constant = costPriceSize.width+1;
            
            
            _currentPriceLab.text = [NSString stringWithFormat:@"￥%@",sizeData.itemPrice];
            CGSize currentPriceSize  = [PublicMethod getSize:_currentPriceLab.text Font:21 Width:GGUISCREENWIDTH-100 Height:1000];
            _currentPriceConstraint.constant = currentPriceSize.width+1;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_currentPriceLab.text];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,1)];
            _currentPriceLab.attributedText = str;
            
            
            itemDiscountCount = (int)[sizeData.itemDiscount length] + 3;
            if([sizeData.itemDiscount floatValue]<=0 || [sizeData.itemDiscount floatValue]>=10){
                //不在折扣范围的折扣，不显示折扣并且不显示原价
                _detailLab.text = sizeData.invTitle;
                _costPriceLab.hidden = YES;
            }else{
                _costPriceLab.hidden = NO;
                
                //设置原价上面删除线
                NSString * oldPrice = _costPriceLab.text;
                NSUInteger length = [oldPrice length];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
                [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
                [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
                [_costPriceLab setAttributedText:attri];

                
                _detailLab.text = [[[@" " stringByAppendingString:sizeData.itemDiscount] stringByAppendingString:@"折  "] stringByAppendingString:sizeData.invTitle];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_detailLab.text];
                [str addAttribute:NSBackgroundColorAttributeName value:UIColorFromRGB(0xff4242) range:NSMakeRange(0,itemDiscountCount)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,itemDiscountCount)];
                _detailLab.attributedText = str;
            }
            CGSize size  = [PublicMethod getSize:_detailLab.text Font:16 Width:GGUISCREENWIDTH-20 Height:1000];
            _detailConstraint.constant = size.height+1;//不加1不显示下一行
            
//            if([self.delegate respondsToSelector:@selector(getOneCellH:)]){
//                [self.delegate getOneCellH:(GGUISCREENWIDTH + 167 + size.height)];
//            }
            //邮寄方式
            self.areaLab.text = sizeData.invAreaNm;
//            self.postalTaxRateLab.text = [NSString stringWithFormat:@"税率：%@",sizeData.postalTaxRate];
//            self.postalTaxRateLab.text = [self.postalTaxRateLab.text stringByAppendingString:@"%"];
            if(sizeData.restrictAmount != 0){
                _restrictLab.text = [NSString stringWithFormat:@"限购%ld件",(long)sizeData.restrictAmount];
                CGSize restrictSize  = [PublicMethod getSize:_restrictLab.text Font:12 Width:GGUISCREENWIDTH-100 Height:1000];
                _restrictConstraint.constant = restrictSize.width+1;
            }else{
                _restrictLab.hidden = YES;
            }
            
  
        }
    }
    
    
    if(![status isEqualToString:@"Y"]){
        
        UILabel* saleOutLab = [[UILabel alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH-104)/2, 105, 104, 104)];
        saleOutLab.textAlignment = NSTextAlignmentCenter;
        saleOutLab.backgroundColor = UIColorFromRGB(0x000000);
        saleOutLab.alpha = 0.7;
        saleOutLab.font = [UIFont systemFontOfSize:17];
        [saleOutLab setTextColor:UIColorFromRGB(0xffffff)];
        
        [saleOutLab.layer setMasksToBounds:YES];
        saleOutLab.layer.cornerRadius = 52;
        saleOutLab.hidden =YES;
        if([mainSkuStatus isEqualToString:@"P"]){
            saleOutLab.text = @"预售中";
            saleOutLab.hidden =NO;
        } else if ([mainSkuStatus isEqualToString:@"K"]){
            saleOutLab.text = @"已售罄";
            saleOutLab.hidden =NO;
        } else if ([mainSkuStatus isEqualToString:@"D"]){
            saleOutLab.text = @"已下架";
            saleOutLab.hidden =NO;
        } 
        
        [self.contentView addSubview:saleOutLab];

    }

    
    

    if(_scrollArr.count>1){
        
        NSMutableArray * imageArr = [NSMutableArray array];

        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH)];
        hView.delegate =self;
        [hView shouldAutoShow:NO];
        for (int i = 0; i < _scrollArr.count; i++)
        {
            UIImageView *imv = [[UIImageView alloc] init];
            [imv sd_setImageWithURL:[NSURL URLWithString:((itemPreviewImgsData *)_scrollArr[i]).url] placeholderImage:[UIImage  imageNamed:@"load1ing"]];
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


    

    
    
    

    
    
    
    CGRect rect = CGRectMake(15, -10, 0, 0);
    CGFloat publicityHei = 0;
    if(data.publicity != nil){
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, -8, GGUISCREENWIDTH-15, 1)];
        line.backgroundColor= [UIColor blackColor];
        line.alpha = 0.06;
        [_publicityView addSubview:line];
        for(int i = 0;i<data.publicity.count;i++){
            
            UILabel * label = [[UILabel alloc]init];
            label.textColor = UIColorFromRGB(0x242424);
            label.font = [UIFont systemFontOfSize:15];
            label.text = data.publicity[i];
            label.numberOfLines = 0;
            CGSize size  = [PublicMethod getSize:data.publicity[i] Font:15 Width:GGUISCREENWIDTH-30 Height:1000];
            label.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 10, size.width, size.height);
            rect = label.frame;
            [_publicityView addSubview:label];
        }
        _publicityHConstraint.constant = rect.origin.y + rect.size.height +10;
        publicityHei = rect.origin.y + rect.size.height +10;
    }else{
        _publicityView.hidden  = YES;
    }

    CGSize detSize  = [PublicMethod getSize:_detailLab.text Font:16 Width:GGUISCREENWIDTH-20 Height:1000];
    _footViewConstraint.constant = 130 + detSize.height+ publicityHei;
    if([self.delegate respondsToSelector:@selector(getOneCellH:)]){
        [self.delegate getOneCellH:(GGUISCREENWIDTH + 130 + detSize.height + publicityHei)];
    }

    
}
-(void) touchImageUpInside:(UITapGestureRecognizer *)recognizer{
    [self touchPage:0];
}
-(void)touchPage:(NSInteger)index{

    [self.delegate touchPage:index andImageArray:_scrollArr];
    
}
@end
