//
//  LoginViewController.m
//  登录
//
//  Created by qianfeng on 15-8-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "LoginViewController.h"
#import "GGTabBarViewController.h"
#import "RegistViewController.h"
#import "LosePwdViewController.h"
#import "ReturnResult.h"
#import "ShoppingCart.h"
#import "CartData.h"
#import "ToRegistViewController.h"
#import "ToLosePwdViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    FMDatabase * database;
    NSString * sendCode;
}
- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)registButton:(UIButton *)sender;
- (IBAction)losePwd:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *mobel;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (nonatomic) UIImageView * verifyImageView;
@property (nonatomic) UIView * verifyBg;
@property (nonatomic) UIView * verifyView;
@property (nonatomic) UITextField * textF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.navigationItem.title = @"登录";
    database = [PublicMethod shareDatabase];
    [self registerForKeyboardNotifications];
    _textF = [[UITextField alloc]init];
    _mobel.returnKeyType = UIReturnKeyDone;
    _pwd.returnKeyType = UIReturnKeyDone;
    _textF.returnKeyType = UIReturnKeyDone;
    _mobel.delegate = self;
    _pwd.delegate = self;
    _mobel.tag = 10011;
    _pwd.tag = 10012;
    _textF.tag = 10014;
    sendCode = @"-1";
    [self createVerifyView];
}
-(void)createVerifyView{
    _verifyBg = [[UIView alloc]initWithFrame:CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-49)];
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
    line1.backgroundColor = GGColor(240, 240, 240);
    [_verifyView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_verifyView.width/2, 60, 1, 40)];
    line2.backgroundColor = GGColor(240, 240, 240);
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
        [self showHud:@"请输入4位验证码"];
    }
    [self getData];
    sendCode = @"-1";
    _verifyImageView.image = nil;
    _textF.text = nil;
    _verifyView.hidden = YES;
    _verifyBg.hidden = YES;
    
}
-(void)refreshBtnClick{
    _textF.text = nil;
   [self getVerifyData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //判断哪个控件是第一响应者
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    //控件下端frame的y值,+10为了下面的判断，让控件和键盘之间有点距离
    CGFloat viewY = firstResponder.frame.origin.y + firstResponder.frame.size.height + 10;
    //键盘上端的frame的y值
    CGFloat keyY = GGUISCREENHEIGHT - keyboardSize.height;
    if(viewY >= keyY){
        [UIView beginAnimations:@"up" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         self.view.frame = CGRectMake(0, -(viewY-keyY), GGUISCREENWIDTH, GGUISCREENHEIGHT);
        [UIView commitAnimations];
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT);
    [UIView commitAnimations];
    
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
            
            if(GGTRIM(_mobel.text).length+string.length >11){
                canChange = NO;
                if(!canChange){
                    [self showHud:@"手机号码为11位"];
                }
            }
            
        }
        return canChange;
        
    }else if(textField.tag == 10012){
        if([@"" isEqualToString:string]){
            canChange = YES;
        }else{
            canChange = [NSString isNumAndLetter:string];
            if(!canChange){
                [self showHud:@"密码只能包含字母和数字"];
            }
            if(_pwd.text.length+string.length>12){
                canChange = NO;
                if(!canChange){
                    [self showHud:@"密码为6-12位"];
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
-(void)showHud:(NSString *) message{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:11];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
    hud.labelText = message;
}
- (IBAction)loginButton:(UIButton *)sender {

    if(![self check]){
        return;
    }
    [self getData];
}

- (IBAction)registButton:(UIButton *)sender {


    ToRegistViewController * rvc = [[ToRegistViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (IBAction)losePwd:(UIButton *)sender {
    ToLosePwdViewController * lpvc = [[ToLosePwdViewController alloc]init];
    [self.navigationController pushViewController:lpvc animated:YES];
}


//发送注册数据
-(void)getData{
    NSString * urlString =[HSGlobal loginUrl];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareNoHeadRequestManager];
     NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_mobel.text,@"phone",_pwd.text,@"password",sendCode,@"code",nil];
    [manager POST:urlString  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];

        if(returnResult.code == 200){
//           //给极光发送别名
            [JPUSHService setAlias:returnResult.alias callbackSelector:nil object:self];

            //把用户账号存到内存中
            [[NSUserDefaults standardUserDefaults]setObject:returnResult.token forKey:@"userToken"];
            NSDate * lastDate = [[NSDate alloc] initWithTimeInterval:returnResult.expired sinceDate:[NSDate date]];
            [[NSUserDefaults standardUserDefaults]setObject:lastDate forKey:@"expired"];
            [self sendCart];
            [self.delegate backMe];
            //1.登陆成功,跳转到下主页面
            [self.navigationController popViewControllerAnimated:YES];
            
     
        }else if(returnResult.code == 4001){
            [self getVerifyData];
        }else{
            [self showHud:returnResult.message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showHud:@"登陆失败"];
    }];

}
-(void)getVerifyData{
    NSString * urlString =[HSGlobal verifyCodeUrl];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareNoHeadRequestManager];

    [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData * dt = responseObject;
        UIImage * image = [UIImage imageWithData:dt];
        _verifyBg.hidden = NO;
        _verifyView.hidden = NO;
        _verifyImageView.image = image;
        [_textF becomeFirstResponder];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showHud:@"获取验证码失败"];
    }];
}
-(BOOL)check{
    
    //验证手机号
    if(![self isUrl]){
        return false;
    }
    if([NSString isBlankString:GGTRIM(_pwd.text)]){
//        [HSGlobal printAlert:@"请输入密码"];
        [self showHud:@"请输入密码"];
        return false;
    }
    
    //校验密码长度
    if(_pwd.text.length<6 || _pwd.text.length>12){
//        [HSGlobal printAlert:@"请输入6-12位的密码"];
        [self showHud:@"请输入6-12位的密码"];
        return false;
    }
    return true;
}

//验证手机号
- (BOOL)isUrl
{
    //校验空
    if([NSString isBlankString:GGTRIM(_mobel.text)]){
//        [HSGlobal printAlert:@"请输入手机号码"];
        [self showHud:@"请输入手机号码"];
        return false;
    }
    //校验密码长度
    if(GGTRIM(_mobel.text).length !=11){
//        [HSGlobal printAlert:@"请输入11位手机号码"];
        [self showHud:@"请输入11位手机号码"];
        return false;
    }
    
    NSString * regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:GGTRIM(_mobel.text)]){
//        [HSGlobal printAlert:@"请输入正确手机号码"];
        [self showHud:@"请输入正确手机号码"];
        return false;
    }
    return 1;
}
-(void)sendCart{
  

    //开始添加事务
    [database beginTransaction];
    
    FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
    NSMutableArray * mutArray = [NSMutableArray array];
    while ([rs next]){
        
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"pid"]] forKey:@"skuId"];
        [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"cart_id"]] forKey:@"cartId"];
        [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"pid_amount"]] forKey:@"amount"];
        [myDict setObject:@"I" forKey:@"state"];
        [myDict setObject:[rs stringForColumn:@"sku_type"] forKey:@"skuType"];
        [myDict setObject:[NSNumber numberWithLong:[rs longForColumn:@"sku_type_id"]] forKey:@"skuTypeId"];
        [mutArray addObject:myDict];
        
    }

    //提交事务
    [database commit];
    
 
    if(mutArray.count >0){
        NSString * urlString =[HSGlobal addToCartUrl];
        AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
    
        
        [manager POST:urlString  parameters:[mutArray copy] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSInteger code =[[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            NSLog(@"message= %@",message);
            if(code == 200){
                [database beginTransaction];
                [database executeUpdate:@"DELETE FROM Shopping_Cart"];
                [database commit];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = message;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
            //修改购物车tabbar的badgeValue
            PublicMethod * pm = [[PublicMethod alloc]init];
            [pm sendCustNum];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
//            [HSGlobal printAlert:@"发送购物车数据失败"];
            [self showHud:@"发送购物车数据失败"];
        }];

    }else{
        //修改购物车tabbar的badgeValue
        PublicMethod * pm = [[PublicMethod alloc]init];
        [pm sendCustNum];
    }
    
    
}
@end
