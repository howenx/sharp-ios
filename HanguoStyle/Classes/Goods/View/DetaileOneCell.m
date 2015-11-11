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

- (void)setData:(ThreeViewData *)data
{
    _scrollArr =@[@"http://img3.douban.com/view/movie_poster_cover/lpst/public/p480747492.jpg",
                  @"http://img3.douban.com/view/movie_poster_cover/lpst/public/p1356576774.jpg",
                  @"http://img3.douban.com/view/movie_poster_cover/lpst/public/p510876400.jpg",
                  @"http://x1.zhuti.com/down/2012/11/29-win7/3D-1.jpg"];
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

    

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_detailLab.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,6)];
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
    if (data.isStore) {
        image = [UIImage imageNamed:@"redStore"];
    }else{
        image = [UIImage imageNamed:@"grayStore"];
    }
    [self.storeBtn setImage:image forState:UIControlStateNormal];
    [self.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",(long)data.storeCount] forState:UIControlStateNormal];
    
//    [self.storeBtn setImage:image withTitle:[NSString stringWithFormat:@"（%d)",data.storeCount] forState:UIControlStateNormal];
}
@end
