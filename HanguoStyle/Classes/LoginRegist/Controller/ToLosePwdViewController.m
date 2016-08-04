//
//  ToLosePwdViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/15.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//
#import "ToLosePwdViewController.h"
#import "ReturnResult.h"
#import "RegistViewController.h"
#import "LosePwdViewController.h"
#import "UIBarButtonItem+GG.h"
@interface ToLosePwdViewController ()<UITextFieldDelegate>
{
    NSString * sendCode;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneLab;
@property (nonatomic) UIView * verifyBg;
@property (nonatomic) UIView * verifyView;
@property (nonatomic) UITextField * textF;
@property (nonatomic) UIImageView * verifyImageView;


@property (nonatomic) UIView * noRegistBg;
@property (nonatomic) UIView * noRegistView;

@end

@implementation ToLosePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //左上角添加按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,10,20)];
    [leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"找回密码";
    _textF = [[UITextField alloc]init];
    _phoneLab.returnKeyType = UIReturnKeyDone;
    _textF.returnKeyType = UIReturnKeyDone;
    _phoneLab.delegate = self;
    _textF.delegate = self;

    _phoneLab.tag = 10011;
    _textF.tag = 10014;

    [self createVerifyView];
    [self createNoRegistView];

}
-(void)back{
    [_phoneLab resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
//通过委托来放弃第一响应者
//点击键盘上的return键调用的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //判断哪个控件是第一响应者
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL canChange = YES;
    if(textField.tag == 10011){
        if([@"" isEqualToString:string]){
            canChange = YES;
        }else{
            canChange = [NSString isNum:string];
            if(!canChange){
                
                [self showHud:@"手机号为数字"];
            }
            
            if(GGTRIM(_phoneLab.text).length+string.length >11){
                canChange = NO;
                if(!canChange){
                    [self showHud:@"手机号码为11位"];
                }
            }
            
        }
        return canChange;
        
    }else if(textField.tag == 10014){
        if([@"" isEqualToString:string]){
            canChange = YES;
        }else{
            canChange = [NSString isNumAndLetter:string];
            if(!canChange){
                [self showHud:@"验证码只能包含字母和数字"];
            }
            if(_textF.text.length+string.length>4){
                canChange = NO;
                if(!canChange){
                    [self showHud:@"验证码只能4位"];
                }
            }
            
        }
        return canChange;
    }
    return canChange;
}
//创建手机号尚未注册弹出页
-(void)createNoRegistView{
    _noRegistBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    _noRegistBg.backgroundColor = [UIColor blackColor];
    _noRegistBg.alpha = 0.3;
    [self.view addSubview:_noRegistBg];
    
    _noRegistView = [[UIView alloc]initWithFrame:CGRectMake(50, 164, GGUISCREENWIDTH-100,100)];
    _noRegistView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_noRegistView];
    
    UILabel * tiShiLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, GGUISCREENWIDTH-100, 20)];
    tiShiLab.text =@"该手机号尚未注册";
    tiShiLab.textAlignment = NSTextAlignmentCenter;
    tiShiLab.font = [UIFont systemFontOfSize:13];
    [_noRegistView addSubview:tiShiLab];
    
    
    
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, _noRegistView.width, 1)];
    line1.backgroundColor = GGBgColor;
    [_noRegistView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_noRegistView.width/2, 60, 1, 40)];
    line2.backgroundColor = GGBgColor;
    [_noRegistView addSubview:line2];
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 60, _noRegistView.width/2, 40);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancleBtn addTarget:self action:@selector(noRegistCancleClick) forControlEvents:UIControlEventTouchUpInside];
    [_noRegistView addSubview:cancleBtn];
    
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(_noRegistView.width/2, 60, _noRegistView.width/2, 40);
    [sureBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [sureBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sureBtn addTarget:self action:@selector(toRegistClick) forControlEvents:UIControlEventTouchUpInside];
    [_noRegistView addSubview:sureBtn];
    
    _noRegistView.hidden = YES;
    _noRegistBg.hidden = YES;
    
}
-(void)noRegistCancleClick{
    _noRegistView.hidden = YES;
    _noRegistBg.hidden = YES;
}
-(void)toRegistClick{
    _noRegistView.hidden = YES;
    _noRegistBg.hidden = YES;
    RegistViewController * rvc = [[RegistViewController alloc]init];
    rvc.phone = _phoneLab.text;
    rvc.comeFrom = self.comeFrom;
    rvc.accessToken = self.accessToken;
    rvc.openId = self.openId;
    rvc.idType = self.idType;
    rvc.unionId = self.unionId;

    [self.navigationController pushViewController:rvc animated:YES];


}
//创建图文验证码页面
-(void)createVerifyView{
    _verifyBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    _verifyBg.backgroundColor = [UIColor blackColor];
    _verifyBg.alpha = 0.3;
    [self.view addSubview:_verifyBg];
    
    _verifyView = [[UIView alloc]initWithFrame:CGRectMake(50, 164, GGUISCREENWIDTH-100,100)];
    _verifyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_verifyView];
    _textF.frame = CGRectMake(10, 20, 100, 30);
    _textF.layer.borderColor = [UIColor grayColor].CGColor;
    _textF.layer.borderWidth = 1;
    [_verifyView addSubview:_textF];
    _verifyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_verifyView.width-100, 20, 60, 30)];
    [_verifyView addSubview:_verifyImageView];
    
    
    UIButton * refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(_verifyView.width-30, 25, 20, 20);
    [refreshBtn setImage: [UIImage imageNamed:@"icon_shuaxin"] forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_verifyView addSubview:refreshBtn];
    
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, _verifyView.width, 1)];
    line1.backgroundColor = GGBgColor;
    [_verifyView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_verifyView.width/2, 60, 1, 40)];
    line2.backgroundColor = GGBgColor;
    [_verifyView addSubview:line2];
    
    
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 60, _verifyView.width/2, 40);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_verifyView addSubview:cancleBtn];
    
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(_verifyView.width/2, 60, _verifyView.width/2, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_verifyView addSubview:sureBtn];
    
    
    
    _verifyView.hidden = YES;
    _verifyBg.hidden = YES;
    _textF.text = nil;
    
}
-(void)cancleBtnClick{
    _verifyImageView.image = nil;
    _verifyView.hidden = YES;
    _verifyBg.hidden = YES;
}

-(void)sureBtnClick{
    
    sendCode = _textF.text;
    if(sendCode.length != 4){
        [self showHud:@"请输4位入验证码"];
        return;
    }
    [self checkRegist];
    _verifyImageView.image = nil;
    _textF.text = nil;
    _verifyView.hidden = YES;
    _verifyBg.hidden = YES;
    
}

-(void)refreshBtnClick{
    [self getVerifyData];
}
- (IBAction)nextBtn:(id)sender {
    //验证手机号
    if(![self isUrl]){
        return;
    }
    [_textF becomeFirstResponder];
    [self getVerifyData];
}
-(void)getVerifyData{
    NSString * urlString =[HSGlobal verifyCodeUrl];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareNoHeadRequestManager];
    
    [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData * dt = responseObject;
        UIImage * image = [UIImage imageWithData:dt];
        _verifyBg.hidden = NO;
        _verifyView.hidden = NO;
        _textF.text = nil;
        _verifyImageView.image = image;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showHud:@"获取验证码失败"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkRegist{
    NSString * urlString =[HSGlobal checkRegist];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareNoHeadRequestManager];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneLab.text,@"phone",sendCode,@"code",nil];
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager POST:urlString  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        
        if(returnResult.code == 4003){//未注册
            
            _noRegistView.hidden = NO;
            _noRegistBg.hidden = NO;
        }else if(returnResult.code == 5001){//已注册
            
            LosePwdViewController * lpvc = [[LosePwdViewController alloc]init];
            lpvc.phone = _phoneLab.text;
            lpvc.comeFrom = self.comeFrom;
            lpvc.accessToken = self.accessToken;
            lpvc.openId = self.openId;
            lpvc.idType = self.idType;
            lpvc.unionId = self.unionId;
            [self.navigationController pushViewController:lpvc animated:YES];
        }else {
            [self showHud:returnResult.message];
        }
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GiFHUD dismiss];
        NSLog(@"Error: %@", error);
        [self showHud:@"请求失败"];
    }];

}
//验证手机号
- (BOOL)isUrl
{
    //校验空
    if([NSString isBlankString:GGTRIM(_phoneLab.text)]){
        [self showHud:@"请输入手机号码"];
        return false;
    }
    //校验密码长度
    if(GGTRIM(_phoneLab.text).length !=11){
        [self showHud:@"请输入11位手机号码"];
        return false;
    }
    
    NSString * regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    if(![pred evaluateWithObject:GGTRIM(_phoneLab.text)]){
        [self showHud:@"请输入正确手机号码"];
        return false;
    }
    return 1;
}

-(void)showHud:(NSString *) message{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:11];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
    hud.labelText = message;
}

@end
