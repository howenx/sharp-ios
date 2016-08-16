//
//  ToBindingViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/5/19.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "ToBindingViewController.h"
#import "ReturnResult.h"
#import "RegistViewController.h"
#import "LoginViewController.h"
@interface ToBindingViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneLab;

@property (nonatomic) UIView * noRegistBg;
@property (nonatomic) UIView * noRegistView;
@end

@implementation ToBindingViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"绑定手机号";
    
    _phoneLab.returnKeyType = UIReturnKeyDone;
    _phoneLab.delegate = self;
    _phoneLab.tag = 10011;
    
    
    [self createNoRegistView];
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
    [manager POST:urlString  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        
        if(returnResult.code == 4003){//未注册
            _noRegistView.hidden = NO;
            _noRegistBg.hidden = NO;
            
            
        }else if(returnResult.code == 5001){//已注册
            LoginViewController * login = [[LoginViewController alloc]init];
            login.comeFrom = self.comeFrom;
            login.phone = _phoneLab.text;
            
            login.accessToken = self.accessToken;
            login.openId = self.openId;
            login.idType = self.idType;
            login.unionId = self.unionId;
            [self.navigationController pushViewController:login animated:YES];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [PublicMethod printAlert:@"登录失败"];
    }];
    
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
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    if(![pred evaluateWithObject:GGTRIM(_phoneLab.text)]){
        [self showHud:@"请输入正确手机号码"];
        return false;
    }
    return 1;
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
