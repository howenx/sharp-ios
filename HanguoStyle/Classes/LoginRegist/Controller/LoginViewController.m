//
//  LoginViewController.m
//  登录
//
//  Created by qianfeng on 15-8-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "LoginViewController.h"
#import "GGTabBarViewController.h"
#import "RegistViewController.h"
#import "LosePwdViewController.h"
#import "ReturnResult.h"
#import "HSGlobal.h"

@interface LoginViewController ()<UITextFieldDelegate>

- (IBAction)toLookLook:(UIButton *)sender;
- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)registButton:(UIButton *)sender;
- (IBAction)losePwd:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *mobel;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    _mobel.returnKeyType = UIReturnKeyDone;
    _pwd.returnKeyType = UIReturnKeyDone;
    _mobel.delegate = self;
    _pwd.delegate = self;
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


- (IBAction)toLookLook:(UIButton *)sender {
    
    //1.登陆成功,跳转到下主页面
    GGTabBarViewController * tabBar = [[GGTabBarViewController alloc]init];
    [self presentViewController:tabBar animated:YES completion:nil];

}

- (IBAction)loginButton:(UIButton *)sender {
//    if(![self check]){
//        return;
//    }
    [self getData];
}

- (IBAction)registButton:(UIButton *)sender {


    RegistViewController * rvc = [[RegistViewController alloc]init];
    [self  presentViewController:rvc animated:YES completion:nil];
}

- (IBAction)losePwd:(UIButton *)sender {
    LosePwdViewController * lpvc = [[LosePwdViewController alloc]init];
    [self presentViewController:lpvc animated:YES completion:nil];
}


//发送注册数据
-(void)getData{
    
//    NSString * urlString =[HSGlobal loginUrl];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //此处设置后返回的默认是NSData的数据
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager POST:urlString  parameters:@{@"name":GGTRIM(_mobel.text),@"password":GGTRIM(_pwd.text)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //转换为词典数据
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        //创建数据模型对象,加入数据数组
//        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
//
//        if(returnResult.result){
//            //1.登陆成功,跳转到下主页面
//            GGTabBarViewController * tabBar = [[GGTabBarViewController alloc]init];
//            [self presentViewController:tabBar animated:YES completion:nil];
//     
//        }else{
//            [self printAlert:returnResult.message];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [self printAlert:@"登陆失败"];
//    }];

    /**
     *  测试用
     */
    GGTabBarViewController * tabBar = [[GGTabBarViewController alloc]init];
    [self presentViewController:tabBar animated:YES completion:nil];
}

-(BOOL)check{
    
    //验证手机号
    if(![self isUrl]){
        return false;
    }
    if([@"" isEqualToString:GGTRIM(_pwd.text)]){
        [self printAlert:@"请输入密码"];
        return false;
    }
    
    //校验密码长度
    if(_pwd.text.length<6 || _pwd.text.length>20){
        [self printAlert:@"请输入6-12位的密码"];
        return false;
    }
    return true;
}

//验证手机号
- (BOOL)isUrl
{
    //校验空
    if([@"" isEqualToString:GGTRIM(_mobel.text)]){
        [self printAlert:@"请输入手机号码"];
        return false;
    }
    //校验密码长度
    if(GGTRIM(_mobel.text).length !=11){
        [self printAlert:@"请输入11位手机号码"];
        return false;
    }
    
    NSString * regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:GGTRIM(_mobel.text)]){
        [self printAlert:@"请输入正确手机号码"];
        return false;
    }
    return 1;
}

-(void)printAlert:(NSString *) message{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
