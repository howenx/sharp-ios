//
//  ChoicePayTypeViewController.m
//  NewZhuaMa
//
//  Created by 王小帅 on 15/10/28.
//  Copyright © 2015年 xll. All rights reserved.
//

#import "ChoicePayTypeViewController.h"
#import "ZSDPaymentView.h"
#import "AuthenticationView.h"

@interface ChoicePayTypeViewController ()<ZSDPaymentViewDelegate,AuthenticationViewDelegate>
{
    UIScrollView *mainSC;
    UILabel *oneTitleLabel;
    UILabel *oneMoneyLabel;
    UIButton *oneSelectBtn;
    UIButton *twoSelectBtn;
    UIButton *threeSelectBtn;
    UIButton *payBtn;
//    float balance;
    NSString *show;
}
@property(nonatomic,strong)NSMutableDictionary *dataDict;
@property(nonatomic)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *oneDownManager;
@property(nonatomic,strong)ImageDownManager *twoDownManager;
@property(nonatomic,strong)ImageDownManager *threeDownManager;

@end

@implementation ChoicePayTypeViewController

-(void)dealloc
{
    self.mDownManager.delegate = nil;
    self.oneDownManager.delegate = nil;
    self.twoDownManager.delegate = nil;
    self.threeDownManager.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataDict = [NSMutableDictionary dictionaryWithCapacity:0];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"选择支付方式" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 44, 30) bgImageName:nil imageName:@"back" title:nil selector:@selector(GoBack) target:self];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
//    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, NONavHEIGHT)];
    mainSC.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.contentSize = CGSizeMake(WIDTH, 600);
    [self.view addSubview:mainSC];
    
    UILabel *typeLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, sWIDTH, 30) title:@"  选择支付方式" font:14];
//    typeLabel.textColor = [UIColor grayColor];
    [mainSC addSubview:typeLabel];
    
    UIView *oneView = [MyControll createViewWithFrame:CGRectMake(0, getMaxY(typeLabel) , sWIDTH, 60)];
    oneView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:oneView];
    UIImageView *oneImage = [MyControll createImageViewWithFrame:CGRectMake(15, 10, 40, 40) imageName:@"微信支付"];
    [oneView addSubview:oneImage];
    oneTitleLabel = [MyControll createLabelWithFrame:CGRectMake(getMaxX(oneImage) + 15, 10, 100, 15) title:@"我的钱包余额支付" font:16];
    [oneView addSubview:oneTitleLabel];
    oneMoneyLabel = [MyControll createLabelWithFrame:CGRectMake(getMaxX(oneImage) + 15, getMaxY(oneTitleLabel) + 10, 150, 15) title:[NSString stringWithFormat:@"余额：%.2f元",300.00] font:12];
    oneMoneyLabel.textColor = [UIColor grayColor];
    [oneView addSubview:oneMoneyLabel];
    
//    UIButton *oneSelectBtn = [MyControll createButtonWithFrame:CGRectMake(sWIDTH - 45, 35 / 2, 25, 25) bgImageName:nil imageName:nil title:nil selector:@selector(selectBtn:) target:self];
//    oneSelectBtn.layer.cornerRadius = 1;
    oneSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    oneSelectBtn.frame = CGRectMake(sWIDTH - 45, 35 / 2, 25, 25);
    [oneSelectBtn addTarget:self action:@selector(selectOneBtn:) forControlEvents:UIControlEventTouchUpInside];
    oneSelectBtn.highlighted = NO;
    [oneSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
//    [oneSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateSelected];
        [oneView addSubview:oneSelectBtn];
    UIView *oneLine = [MyControll createViewWithFrame:CGRectMake(0, 59, sWIDTH, 1)];
    oneLine.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [oneView addSubview:oneLine];
    
    UIView *twoView = [MyControll createViewWithFrame:CGRectMake(0, getMaxY(oneView), sWIDTH, 60)];
    twoView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:twoView];
    UIImageView *twoImage = [MyControll createImageViewWithFrame:CGRectMake(15, 10, 40, 40) imageName:@"支付宝 copy"];
    [twoView addSubview:twoImage];
    UILabel *twoLabel = [MyControll createLabelWithFrame:CGRectMake(getMaxX(twoImage) + 15, 45 / 2, 100, 15) title:@"支付宝支付" font:16];
    [twoView addSubview:twoLabel];
    twoSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    twoSelectBtn.frame = CGRectMake(sWIDTH - 45, 35 / 2, 25, 25);
    [twoSelectBtn addTarget:self action:@selector(selectTwoBtn:) forControlEvents:UIControlEventTouchUpInside];
    twoSelectBtn.highlighted = NO;
    [twoSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
//    [twoSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateSelected];
    [twoView addSubview:twoSelectBtn];
    UIView *twoLine = [MyControll createViewWithFrame:CGRectMake(0, 59, sWIDTH, 1)];
    twoLine.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [twoView addSubview:twoLine];
    
    UIView *threeView = [MyControll createViewWithFrame:CGRectMake(0, getMaxY(twoView), sWIDTH, 60)];
    threeView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:threeView];
    UIImageView *threeImage = [MyControll createImageViewWithFrame:CGRectMake(15, 10, 40, 40) imageName:@"微信支付"];
    [threeView addSubview:threeImage];
    UILabel *threeLabel = [MyControll createLabelWithFrame:CGRectMake(getMaxX(twoImage) + 15, 45 / 2, 100, 15) title:@"微信支付" font:16];
    [threeView addSubview:threeLabel];
    threeSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    threeSelectBtn.frame = CGRectMake(sWIDTH - 45, 35 / 2, 25, 25);
    [threeSelectBtn addTarget:self action:@selector(selectThreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    threeSelectBtn.highlighted = NO;
    [threeSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
//    [threeSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateSelected];
    [threeView addSubview:threeSelectBtn];
    UIView *threeLine = [MyControll createViewWithFrame:CGRectMake(0, 59, sWIDTH, 1)];
    threeLine.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [threeView addSubview:threeLine];

    payBtn = [MyControll createButtonWithFrame:CGRectMake((sWIDTH - 290) / 2, getMaxY(threeView) + 55, 290, 40) bgImageName:nil imageName:nil title:@"立即支付" selector:@selector(payBtnClick:) target:self];
    payBtn.clipsToBounds = YES;
    payBtn.layer.cornerRadius = 3;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.backgroundColor = [UIColor orangeColor];
    [mainSC addSubview:payBtn];

    
    [self display];
    
    
}
-(void)display
{
    if (_payMoney < _balance || _payMoney == _balance)
    {
        [oneSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateNormal];
        oneMoneyLabel.text = [NSString stringWithFormat:@"余额：%.2f元",_balance];
    }
    else
    {
        oneTitleLabel.textColor = [UIColor grayColor];
        oneSelectBtn.userInteractionEnabled = NO;
        [twoSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateNormal];
        oneMoneyLabel.text = [NSString stringWithFormat:@"余额不足(剩余%.2f元)",_balance];
    }
}
#pragma mark - 加载数据
-(void)loadData
{
//    yuE = 300.00;
//    if (_payMoney < yuE || _payMoney == yuE) {
//        [oneSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateNormal];
//        oneMoneyLabel.text = [NSString stringWithFormat:@"余额：%.2f元",yuE];
//    }
//    else
//    {
//        oneTitleLabel.textColor = [UIColor grayColor];
//        oneSelectBtn.userInteractionEnabled = NO;
//        [twoSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateNormal];
//        oneMoneyLabel.text = [NSString stringWithFormat:@"余额不足(剩余%.2f元)",yuE];
//    }
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@userpayinfo?uid=%@&token=%@&ver=%.2f&dtype=%d",SERVER_URL,uid,token,VERSION,DEVICETYPE];
    self.mDownManager = [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(onLoadFinish:);
    _mDownManager.OnImageFail = @selector(onLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)onLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary * dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[dict class]] && dict.count) {
        if ([[dict[@"code"] stringValue] isEqualToString:@"1"]) {
            NSDictionary *dic = dict[@"data"];
            self.dataDict = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            _balance = [[self.dataDict objectForKey:@"money"] floatValue];
            _isPass = [[self.dataDict objectForKey:@"pwd"] intValue];
            
            [self display];
            
            }
        }
}

-(void)onLoadFail:(ImageDownManager *)sender
{
    [self showMsg:@"网络出现问题，请检查网络~~~"];
    [self Cancel];
    
}
-(void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

-(void)loadDataOneWithPsw:(NSString *)str;
{
    if (_oneDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
//    ZSDPaymentView *zv = [[ZSDPaymentView alloc]init];
    self.onePsw = str;
    NSString *urlstr = [NSString stringWithFormat:@"%@userpaypwd?uid=%@&token=%@&pwd=%@&ver=%.2f&dtype=%d",SERVER_URL,uid,token,self.onePsw,VERSION,DEVICETYPE];
    self.oneDownManager = [[ImageDownManager alloc]init];
    _oneDownManager.delegate = self;
    _oneDownManager.OnImageDown = @selector(onLoadFinishForOne:);
    _oneDownManager.OnImageFail = @selector(onLoadFailForOne:);
    [_oneDownManager GetImageByStr:urlstr];
}
-(void)onLoadFinishForOne:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary * dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[dict class]] && dict.count) {
        if ([[dict[@"code"] stringValue] isEqualToString:@"1"]) {
            ZSDPaymentView *zv = [[ZSDPaymentView alloc]init];
            zv.title = @"请重复支付密码";
            zv.amount = _payMoney;
            zv.delegate = self;
            [zv show];
            

        }
    }
    
}
-(void)onLoadFailForOne:(ImageDownManager *)sender
{
    [self showMsg:@"网络出现问题，请检查网络~~~"];
    [self CancelForOne];
}
-(void)CancelForOne
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.oneDownManager);
}
-(void)loadDataTwoWithPsw:(NSString *)password
{
    if (_twoDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@checkpaypwd?uid=%@&token=%@&pwd=%@&ver=%.2f&dtype=%d",SERVER_URL,uid,token,password,VERSION,DEVICETYPE];
    self.twoDownManager = [[ImageDownManager alloc]init];
    _twoDownManager.delegate = self;
    _twoDownManager.OnImageDown = @selector(onTwoLoadFinish:);
    _twoDownManager.OnImageFail = @selector(onTwoLoadFail:);
    [_twoDownManager GetImageByStr:urlstr];

}
-(void)onTwoLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary * dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[dict class]] && dict.count) {
        if ([[dict[@"code"] stringValue] isEqualToString:@"1"]) {

            [self showMsg:@"正在支付"];
        }
        else
        {
            [self showMsg:@"两次密码不一致，请重试"];
            
        }
    }

}
-(void)next
{
    ZSDPaymentView * zpv = [[ZSDPaymentView alloc]init];
    zpv.delegate = self;
    zpv.title = @"请设置支付密码";
    zpv.amount = _payMoney;
    [zpv show];
}
-(void)onTwoLoadFail:(ImageDownManager *)sender
{
    [self showMsg:@"网络出现问题，请检查网络~~~"];
    [self CancelForTwo];
}
-(void)CancelForTwo
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.twoDownManager);
}
-(void)loadDataThree
{
    
}

-(void)selectOneBtn:(UIButton *)index
{
    [twoSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateSelected];
    [threeSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateSelected];
    [twoSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [threeSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
    
    [oneSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateNormal];
    oneSelectBtn.selected = !oneSelectBtn.selected;
    

    NSLog(@"*************");
}
-(void)selectTwoBtn:(UIButton *)index
{
    [oneSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateSelected];
    [threeSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateSelected];
    [oneSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [threeSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [twoSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateNormal];
    twoSelectBtn.selected = !twoSelectBtn.selected;

    
        NSLog(@"*************");
}
-(void)selectThreeBtn:(UIButton *)index
{
    [twoSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateSelected];
    [oneSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateSelected];
    [twoSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [oneSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [threeSelectBtn setImage:[UIImage imageNamed:@"选中对象"] forState:UIControlStateNormal];
    threeSelectBtn.selected = !threeSelectBtn.selected;


        NSLog(@"*************");
}
-(void)payBtnClick:(UIButton *)index
{
    NSLog(@"@@@@@@@@@@@@@@");

    _isPass = 0;
    if (_isPass) {
        ZSDPaymentView *pv = [[ZSDPaymentView alloc]init];
        pv.title = @"请输入支付密码";
        pv.amount = _payMoney;
        [pv show];
    }
    else
    {
        
        AuthenticationView *av = [[AuthenticationView alloc]init];
        av.delegate =self;
        av.amount = _payMoney;
        [av show];
    }
    
}
//设置支付密码
-(void)inputPassword:(NSString *)password{

    [self loadDataOneWithPsw:password];
}
//身份验证
-(void)inputLoginPwd1:(NSString *)password
{
     NSString *pd = @"11";
    if ([password isEqualToString:pd]) {
        ZSDPaymentView * zpv = [[ZSDPaymentView alloc]init];
        zpv.delegate = self;
        zpv.title = @"请设置支付密码";
        zpv.amount = _payMoney;
        [zpv show];
    }
}
//重复支付密码
-(void)repeatPassword:(NSString *)password
{
    [self loadDataTwoWithPsw:password];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
