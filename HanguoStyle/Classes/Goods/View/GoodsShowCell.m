//
//  GoodsShowCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/19.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsShowCell.h"


@interface GoodsShowCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *describeLab;

@property (weak, nonatomic) IBOutlet UILabel *saleOutLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstraint;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyFlagConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAndTitleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleAndMoneyConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titlePicLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titlePicRightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *pinFlagImageView;

//@property (weak, nonatomic) IBOutlet UIView *pinFlagView;
@property (weak, nonatomic) IBOutlet UILabel *pinTimeLab;
@property (weak, nonatomic) IBOutlet UIView *willSaleView;
@property (weak, nonatomic) IBOutlet UIImageView *willSaleImageView;

@property (weak, nonatomic) IBOutlet UILabel *lowDiscountLab;


//@property (nonatomic ,strong) UIButton * textView;
@end
@implementation GoodsShowCell


- (void)setData:(GoodsShowData *)data
{

    _data = data;
//    for(int i = 0; i < self.titleImageView.subviews.count;i++){
//        [[ self.titleImageView.subviews objectAtIndex:i] removeFromSuperview];   
//    }
    for(UIView *view in [self.titleImageView subviews])
    {
        [view removeFromSuperview];
    }


    if([data.itemType isEqualToString:@"pin"]){
        
        _pinFlagImageView.hidden = NO;
        _pinTimeLab.hidden = NO;
        _lowDiscountLab.hidden = NO;

        //在售
        if([@"Y" isEqualToString: data.state]){
            _saleOutLab.hidden = YES;
            //2016-01-30 17:16:55
            int month= [[data.endAt substringWithRange:NSMakeRange(5,2)] intValue];
            int day= [[data.endAt substringWithRange:NSMakeRange(8,2)] intValue];
            NSString * hour= [data.endAt substringWithRange:NSMakeRange(11,2)];
            NSString * minute= [data.endAt substringWithRange:NSMakeRange(14,2)];
            
            NSString * strTime = [NSString stringWithFormat:@"%d月%d日%@:%@截止",month,day,hour,minute];
            _pinTimeLab.text  = strTime;
            _willSaleView.hidden = YES;
        }else if([@"P" isEqualToString: data.state]){//预售
            _saleOutLab.hidden = YES;
            int month= [[data.startAt substringWithRange:NSMakeRange(5,2)] intValue];
            int day= [[data.startAt substringWithRange:NSMakeRange(8,2)] intValue];
            NSString * hour= [data.startAt substringWithRange:NSMakeRange(11,2)];
            NSString * minute= [data.startAt substringWithRange:NSMakeRange(14,2)];
            
            NSString * strTime = [NSString stringWithFormat:@"%d月%d日%@:%@开始",month,day,hour,minute];
            _pinTimeLab.text  = strTime;
            _willSaleView.hidden = NO;
        }else{
            _saleOutLab.hidden = NO;
            if([@"K" isEqualToString: data.state]){
                _saleOutLab.text = @"已售罄";
            }else if([@"D" isEqualToString: data.state]){
                _saleOutLab.text = @"已下架";
            }
            
            NSString * strTime = @"拼购已结束";
            _pinTimeLab.text  = strTime;
            _willSaleView.hidden = YES;
        }
        
        _lowDiscountLab.text = [NSString stringWithFormat:@"低至%@折",data.itemDiscount];
        NSString * lowStr = @"最低";
        NSString * moneystr = [NSString stringWithFormat:@"%@  %@",data.itemPrice,lowStr];
        long len1 = [data.itemPrice length]+2;
        long len2 = [lowStr length];
        NSMutableAttributedString * str2 = [[NSMutableAttributedString alloc]initWithString:moneystr];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(len1,len2)];
        [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0f] range:NSMakeRange(len1,len2)];
        self.moneyLab.attributedText = str2;
    }else{
        if([@"Y" isEqualToString: data.state]){// 状态  'Y'--正常,'D'--下架,'N'--删除,'K'--售空，'P'--预售
            _saleOutLab.hidden = YES;
            _willSaleView.hidden = YES;
        }else if([@"P" isEqualToString: data.state]){
            _saleOutLab.hidden = YES;
            _willSaleView.hidden = NO;
        }else if([@"K" isEqualToString: data.state]){
            _saleOutLab.hidden = NO;
            _saleOutLab.text = @"已售罄";
            _willSaleView.hidden = YES;
        }else if([@"D" isEqualToString: data.state]){
            _saleOutLab.hidden = NO;
            _saleOutLab.text = @"已下架";
            _willSaleView.hidden = YES;
        }else{
            _saleOutLab.hidden = NO;
            _saleOutLab.text = @"已抢光";
            _willSaleView.hidden = YES;
        }
        
        _pinFlagImageView.hidden = YES;
        _pinTimeLab.hidden = YES;
        _lowDiscountLab.hidden = YES;
        self.moneyLab.text = data.itemPrice;
    }
    
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:data.itemImg] placeholderImage:[UIImage imageNamed:@"load2ing"]];
//    [self.titleImageView setImage:[UIImage imageNamed:@"zhanwei"]];
    self.describeLab.text = data.itemTitle;
    
    if(data.itemTitle ==nil || [@""isEqualToString: data.itemTitle]){
        _titleConstraint.constant = 0;
        _moneyFlagConstraint.constant = 0;
        _imageAndTitleConstraint.constant = 0;
        _titleAndMoneyConstraint.constant = 0;
        _titlePicLeftConstraint.constant = 0;
        _titlePicRightConstraint.constant = 0;
        _priceBottomConstraint.constant = 0;
        
    }else{
        _titleConstraint.constant = 32;
        _moneyFlagConstraint.constant = 21;
        _imageAndTitleConstraint.constant = 4;
        _titleAndMoneyConstraint.constant = 6;
        _titlePicLeftConstraint.constant = 5;
        _titlePicRightConstraint.constant = 5;
        _priceBottomConstraint.constant = 3;
    }
    _titleImageView.userInteractionEnabled = YES;
    if(data.masterItemTag!=nil){
        for(int i = 0;i<data.masterItemTag.count;i++){
            MasterItemTagData * tagData = data.masterItemTag[i];
            [self drawRectFlag:tagData andIndex:i ];
            
        }
    }
}
    
-(void)drawRectFlag:(MasterItemTagData *)data andIndex:(NSInteger) index{

    CGRect rect = CGRectMake(GGUISCREENWIDTH * data.left , _data.height*GGUISCREENWIDTH/_data.width * data.top, 8, 8);
    
   
    UIButton * animationBG = [UIButton buttonWithType:UIButtonTypeSystem];
    animationBG.frame = CGRectMake(0, 0, 8, 8);
    //    [super drawRect:rect];
    //    [KColor(22, 163, 130) setFill];
    UIRectFill(rect);
    NSInteger pulsingCount = 1;
    double animationDuration = 1;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = rect;
        pulsingLayer.borderColor = [UIColor blackColor].CGColor;
        pulsingLayer.borderWidth = 3;
        pulsingLayer.cornerRadius = rect.size.height / 2;

        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @0.3;
        scaleAnimation.toValue = @2.2;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [animationBG.layer addSublayer:animationLayer];
    [_titleImageView addSubview:animationBG];
    
    
    
    //添加label
    NSString * strContentLab;
    UIButton * _textView= [UIButton buttonWithType:UIButtonTypeCustom];
    _textView.tag = 45000+index;
    [_textView addTarget:self action:@selector(theButtonClick:)  forControlEvents:UIControlEventTouchUpInside];
    CGSize textMaxSize = CGSizeMake(150, MAXFLOAT);
    strContentLab  = [@"   " stringByAppendingString:data.name];//这块赋值为了下面算textRealSize，为了下面的代码逻辑简单
    CGSize textRealSize =  [strContentLab boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]} context:nil].size;
    
    
    //改变按钮的宽高
    CGSize btnRealSize = CGSizeMake(textRealSize.width+10, 13+7 );//这个13是字体为11号字的时候的字体的大约高度（注意：背景图片的高度像素是20，所以这个高度最多是20）
    //文字设置等，0代表右侧的标记，180表示左侧的标记
    if(data.angle==0){
        strContentLab  = [@"   " stringByAppendingString:data.name];
        _textView.frame = (CGRect){{rect.origin.x+15,rect.origin.y-5},btnRealSize};
        [_textView setBackgroundImage: [self resizeWithImage:@"talkbackRight"] forState:UIControlStateNormal];
        
    }else if (data.angle==180){
        strContentLab  = [data.name stringByAppendingString:@"   "];
        _textView.frame = (CGRect){{rect.origin.x-15-textRealSize.width,rect.origin.y-5},btnRealSize};
        [_textView setBackgroundImage: [self resizeWithImage:@"talkbackLeft"] forState:UIControlStateNormal];
    }
    _textView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _textView.titleLabel.font = [UIFont systemFontOfSize: 11];
    _textView.titleLabel.numberOfLines = 1;//自动换行
    [_textView setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_textView setTitle:strContentLab forState:UIControlStateNormal];


    [_titleImageView addSubview:_textView];
    
}
-(void)theButtonClick:(UIButton *) btn{
    MasterItemTagData * tagData = _data.masterItemTag[btn.tag-45000] ;
    [self.delegate flagUrl:tagData.url];
    
}
-(UIImage *)resizeWithImage:(NSString *)imageName
{
    UIImage  * normal = [UIImage imageNamed:imageName];
    
    CGFloat h = normal.size.height * 0.5 ;
    CGFloat w = normal.size.width * 0.5 ;
    UIImage * newImage =  [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
    
    return newImage;
}

- (void)awakeFromNib {
  
}

@end
