//
//  GoodsShowCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/19.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsShowCell.h"
#import "UIImageView+WebCache.h"

@interface GoodsShowCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *describeLab;

@property (weak, nonatomic) IBOutlet UILabel *saleOutLab;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

//@property (nonatomic ,strong) UIButton * textView;
@end
@implementation GoodsShowCell

//+(id)subjectCell
//{
//    UINib * nib = [UINib nibWithNibName:@"GoodsShowCell" bundle:[NSBundle mainBundle]];
//    return [[nib instantiateWithOwner:self options:nil]lastObject];
//}
- (void)setData:(GoodsShowData *)data
{

//    for(int i = 0; i < self.titleImageView.subviews.count;i++){
//        [[ self.titleImageView.subviews objectAtIndex:i] removeFromSuperview];   
//    }
    for(UIView *view in [self.titleImageView subviews])
    {
        [view removeFromSuperview];
    }

    if([@"Y" isEqualToString: data.state]){
        _saleOutLab.hidden = YES;
    }
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:data.itemImg]];
    self.describeLab.text = data.itemTitle;
    self.moneyLab.text = [NSString stringWithFormat:@"%.2f",data.itemPrice];
    if(data.orMasterItem){
        for(MasterItemTagData *tagData in data.masterItemTag){
            [self drawRectFlag:tagData];
        }
    }
}
    
-(void)drawRectFlag:(MasterItemTagData *)data{

    CGRect rect = CGRectMake(self.bounds.size.width * data.left , self.bounds.size.width/2 * data.top, 8, 8);
    
   
    UIButton * animationBG = [UIButton buttonWithType:UIButtonTypeSystem];
    animationBG.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width/2);
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
    UIButton * _textView= [UIButton buttonWithType:UIButtonTypeSystem];
    
    
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
    //    _textView.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_textView setTitle:strContentLab forState:UIControlStateNormal];
    
    
    [_titleImageView addSubview:_textView];

    
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
