
#import <UIKit/UIKit.h>
#import "UMSocialDataService.h"
#import "UMSocialControllerService.h"
@protocol ShareDelegate <NSObject>

-(void)shareViewClick:(int)buttonIndex;

@end



@interface ShareView : UIView <UMSocialDataDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)id <ShareDelegate>delegate;
@property(nonatomic,strong)NSString *shareStr;
@property(nonatomic,strong)NSString *shareTitle;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *shareImage;

@property(nonatomic,strong)NSString *shareDetailPage;//秘口令


@property(nonatomic,strong)NSString *shareFrom;//从哪分享,T代表拼团成功后分享给好友

-(void)makeUI;

@end
