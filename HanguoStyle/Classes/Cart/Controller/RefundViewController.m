//
//  RefundViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/4/14.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "RefundViewController.h"
#import "PlaceholderTextView.h"
@interface RefundViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIView * bg1View;
    PlaceholderTextView * detailTextView;
    UILabel * detailLabel3;
    UITextField * nameTextfield;
    UITextField * telTextfield;
    UILabel * moneyLabel;
    UIScrollView * _scrollView;
}
@end

@implementation RefundViewController


//- (void)viewWillAppear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [super viewWillAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super viewWillDisappear:animated];
//}
//
//- (void)keyboardWillHide:(id)sender {
//    NSDictionary * info = [sender userInfo];
//    NSValue * value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    CGRect viewFrame = scrollView.frame;
//    viewFrame.size.height -= keyboardSize.height - (460 - scrollView.frame.size.height);
//    scrollView.contentSize = viewFrame.size;
//}
//
//- (void)keyboardWillShow:(id)sender {
//    NSDictionary * info = [sender userInfo];
//    NSValue * value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    CGRect viewFrame = scrollView.frame;
//    viewFrame.size.height += keyboardSize.height - (460 - scrollView.frame.size.height);
//    scrollView.contentSize = viewFrame.size;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"申请退款";
    self.view.backgroundColor = GGBgColor;
    
    [self createSettingView];
}
-(void)createSettingView{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(0,SCREEN_HEIGHT);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.backgroundColor = GGBgColor;
    
    [self.view addSubview:_scrollView];
    
    
    bg1View = [[UIView alloc]initWithFrame:CGRectMake(0, 25/2, SCREEN_WIDTH, 230/2)];
    bg1View.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bg1View];
    
    //说明
    UIImageView * startImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 10, 10)];
    startImageView.image = [UIImage imageNamed:@"xing"];
    [bg1View addSubview:startImageView];
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(startImageView, 5), 15, 100, 16)];
    detailLabel.text = @"退款说明:";
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.textColor  = [UIColor blackColor];
    [bg1View addSubview:detailLabel];
    
    //文本
    detailTextView=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(15, PosYFromView(startImageView, 15), GGUISCREENWIDTH-30, 114/2)];
    detailTextView.placeholder=@"最多200个字";
    detailTextView.font=[UIFont boldSystemFontOfSize:14];
    detailTextView.placeholderFont=[UIFont boldSystemFontOfSize:13];
    detailTextView.keyboardType = UIKeyboardTypeDefault;
    detailTextView.layer.borderWidth=0.5;
    detailTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [bg1View addSubview:detailTextView];
    
    
    UIView * bg2View = [[UIView alloc]initWithFrame:CGRectMake(0, PosYFromView(bg1View, 15), SCREEN_WIDTH, 86/2)];
    bg2View.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bg2View];
    
    UIImageView * startImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 10, 10)];
    startImageView2.image = [UIImage imageNamed:@"xing"];
    [bg2View addSubview:startImageView2];
    
    UILabel * detailLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(startImageView, 5), 15, 95, 16)];
    detailLabel2.text = @"退款金额:  ￥";
    detailLabel2.font = [UIFont systemFontOfSize:15];
    detailLabel2.textColor  = [UIColor blackColor];
    [bg2View addSubview:detailLabel2];
    
    //金额
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(detailLabel2, 0), 15, 200, 16)];
    moneyLabel.text = self.orderData.orderInfo.payTotal;
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textColor  = UIColorFromRGB(0xff5359);
    [bg2View addSubview:moneyLabel];
    
    UIView * bg3View = [[UIView alloc]initWithFrame:CGRectMake(0, PosYFromView(bg2View, 15), SCREEN_WIDTH, 290/2)];
    bg3View.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bg3View];
    
    
    
    detailLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 45, 15)];
    detailLabel3.text = @"非必填";
    detailLabel3.font = [UIFont systemFontOfSize:15];
    detailLabel3.textColor  = [UIColor blackColor];
    [bg3View addSubview:detailLabel3];
    
    
    UIView * bg4View = [[UIView alloc]initWithFrame:CGRectMake(15, PosYFromView(detailLabel3, 15), SCREEN_WIDTH-30, 176/2)];
    bg4View.backgroundColor = GGBgColor;
    [bg3View addSubview:bg4View];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 75, 176/4)];
    nameLabel.text = @"  联系人:";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor  = UIColorFromRGB(0x999999);
    [bg4View addSubview:nameLabel];
    
    nameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(PosXFromView(nameLabel, 14), 0, SCREEN_WIDTH-30-75-30-14, 176/4)];
    nameTextfield.textColor = UIColorFromRGB(0x666666);
    nameTextfield.delegate = self;
    [bg4View addSubview:nameTextfield];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, PosYFromView(nameTextfield, 0), SCREEN_WIDTH-30, 0.5)];
    lineView.backgroundColor = GGBgColor;
    [bg4View addSubview:lineView];
    
    UILabel * telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, PosYFromView(nameTextfield, 0), 90, 176/4)];
    telLabel.text = @"  联系电话:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.textColor  = UIColorFromRGB(0x999999);
    [bg4View addSubview:telLabel];
    
    telTextfield = [[UITextField alloc]initWithFrame:CGRectMake(PosXFromView(telLabel, 0), PosYFromView(nameTextfield, 0), SCREEN_WIDTH-30-90-30, 176/4)];
    telTextfield.textColor = UIColorFromRGB(0x666666);
    telTextfield.delegate = self;
    [bg4View addSubview:telTextfield];
    
    
    
    
    
    UIButton * commitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-41-21-64, SCREEN_WIDTH-30, 41)];
    [commitButton setBackgroundColor:UIColorFromRGB(0xff5359)];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    [commitButton.layer setMasksToBounds:YES];
    [commitButton.layer setCornerRadius:4.0];
    [_scrollView addSubview:commitButton];

}
-(void)commitClick:(UIButton *)btn
{

    if (!STR_IS_EMPTY(detailTextView.text)) {
        
        if (detailTextView.text.length > 200) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"文本过长,当前长度为:%ld",
                             detailTextView.text.length];
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            return;
        }
        
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"7777"] forHTTPHeaderField:@"Content-Type"];
        
        NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
        [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
        
        
        
        NSMutableDictionary * lastDict = [NSMutableDictionary new];
        
        
        [lastDict setObject: [NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderId] forKey:@"orderId"];
        [lastDict setObject: [NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderSplitId] forKey:@"splitOrderId"];
        [lastDict setObject: detailTextView.text forKey:@"reason"];
        [lastDict setObject: moneyLabel.text forKey:@"payBackFee"];
        [lastDict setObject: nameTextfield.text forKey:@"contactName"];
        [lastDict setObject: telTextfield.text forKey:@"contactTel"];
        [lastDict setObject: @"deliver" forKey:@"refundType"];
        
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];
        [manager POST:[HSGlobal refundUrl] parameters:lastDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSLog(@"Success: %@", [[responseObject objectForKey:@"message"] objectForKey:@"message"]);
             NSInteger code = [[[responseObject objectForKey:@"message"] objectForKey:@"code"]integerValue];
            
            if (code == 200) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString stringWithFormat:@"退款成功"];
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                 [self performSelector:@selector(back) withObject:nil afterDelay:1];
            }else
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString stringWithFormat:@"退款失败."];
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                [self performSelector:@selector(back) withObject:nil afterDelay:1];
            }
            [GiFHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            [GiFHUD dismiss];
            NSLog(@"Error: %@", error);
            [self back];
        }];
        
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"原因不能为空."];
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
    self.selectButtonBlock(nil);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [scrollView endEditing:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (SCREEN_WIDTH == 320) {
        if (textField == nameTextfield) {
            _scrollView.contentOffset = CGPointMake(0, 40);
        }
        if (textField == telTextfield) {
            _scrollView.contentOffset = CGPointMake(0, 80);
        }
    }

   
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     if (SCREEN_WIDTH == 320) {
         _scrollView.contentOffset = CGPointMake(0, 0);

     }
}
@end
