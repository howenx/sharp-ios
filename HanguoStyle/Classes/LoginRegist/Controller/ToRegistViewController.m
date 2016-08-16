//
//  ToRegistViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/13.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import "ToRegistViewController.h"
#import "ReturnResult.h"
#import "RegistViewController.h"
#import "LosePwdViewController.h"
@interface ToRegistViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneLab;

@property (nonatomic) UIView * verifyBg;
@property (nonatomic) UIView * verifyView;
@end

@implementation ToRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"账号注册";

    _phoneLab.returnKeyType = UIReturnKeyDone;
    _phoneLab.delegate = self;
    _phoneLab.tag = 10011;


    [self createVerifyView];
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
        
    }
    return canChange;
}

-(void)createVerifyView{
    _verifyBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    _verifyBg.backgroundColor = [UIColor blackColor];
    _verifyBg.alpha = 0.3;
    [self.view addSubview:_verifyBg];
    
    _verifyView = [[UIView alloc]initWithFrame:CGRectMake(50, 164, GGUISCREENWIDTH-100,100)];
    _verifyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_verifyView];
    
    UILabel * tiShiLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, GGUISCREENWIDTH-100, 20)];
    tiShiLab.text =@"该手机号已经注册";
    tiShiLab.textAlignment = NSTextAlignmentCenter;
    tiShiLab.font = [UIFont systemFontOfSize:13];
    [_verifyView addSubview:tiShiLab];
    

    
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, _verifyView.width, 1)];
    line1.backgroundColor = GGBgColor;
    [_verifyView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_verifyView.width/2, 60, 1, 40)];
    line2.backgroundColor = GGBgColor;
    [_verifyView addSubview:line2];
    
    
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 60, _verifyView.width/2, 40);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_verifyView addSubview:cancleBtn];
    
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(_verifyView.width/2, 60, _verifyView.width/2, 40);
    [sureBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [sureBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_verifyView addSubview:sureBtn];
  
    _verifyView.hidden = YES;
    _verifyBg.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextBtn:(UIButton *)sender {
    //验证手机号
    if(![self isUrl]){
        return;
    }
    NSString * urlString =[HSGlobal checkRegist];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareNoHeadRequestManager];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneLab.text,@"phone",@"-1",@"code",nil];
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager POST:urlString  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        
        if(returnResult.code == 4003){//未注册
            RegistViewController * rvc = [[RegistViewController alloc]init];
            rvc.comeFrom = self.comeFrom;
            rvc.phone = _phoneLab.text;
            [self.navigationController pushViewController:rvc animated:YES];

            
            
        }else if(returnResult.code == 5001){//已注册
            _verifyView.hidden = NO;
            _verifyBg.hidden = NO;
        }
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GiFHUD dismiss];
        NSLog(@"Error: %@", error);
        [PublicMethod printAlert:@"登录失败"];
    }];

}
- (IBAction)toLogin:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)cancleBtnClick{
    _verifyView.hidden = YES;
    _verifyBg.hidden = YES;
}
-(void)sureBtnClick{
    _verifyView.hidden = YES;
    _verifyBg.hidden = YES;
    LosePwdViewController * lpvc = [[LosePwdViewController alloc]init];
    lpvc.phone = _phoneLab.text;
    lpvc.comeFrom = self.comeFrom;
    [self.navigationController pushViewController:lpvc animated:YES];
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
