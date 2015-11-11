//
//  LosePwdViewController.m
//  GiftGuide
//
//  Created by qianfeng on 15-8-18.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "LosePwdViewController.h"
#import "ReturnResult.h"
#import "HSGlobal.h"
#import "NSString+GG.h"
@interface LosePwdViewController ()

- (IBAction)commitButton:(UIButton *)sender;
- (IBAction)testingCodeButton:(UIButton *)sender;

- (IBAction)backButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *identCode;
@end

@implementation LosePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    _phoneNum.returnKeyType = UIReturnKeyDone;
    _pwd.returnKeyType = UIReturnKeyDone;
    _identCode.returnKeyType = UIReturnKeyDone;
    _phoneNum.delegate = self;
    _pwd.delegate = self;
    _identCode.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  下面俩个方法一个是点击done键撤销键盘，一个是点击空白处撤销键盘
 *
 */

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




#pragma mark - 按钮事件
- (IBAction)backButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)commitButton:(UIButton *)sender {
    if(![self check]){
        return;
    }
    [self getData];
}

- (IBAction)testingCodeButton:(UIButton *)sender {
    
    if(![self isUrl]){
        return;
    }
    
    NSString * urlString =[HSGlobal testingCodeUrl];
    NSString * msg = [NSString md5:[GGTRIM(_phoneNum.text) stringByAppendingString:@"hmm"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //此处设置后返回的默认是NSData的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString  parameters:@{@"phone":GGTRIM(_phoneNum.text),@"msg":msg} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"---dict %@",dict);
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        [self printAlert:returnResult.message];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self printAlert:@"请求出错"];
    }];
}

//发送注册数据
-(void)getData{
    NSString * urlString =[HSGlobal resetPwdUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //此处设置后返回的默认是NSData的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString  parameters:@{@"phone":GGTRIM(_phoneNum.text),@"code":GGTRIM(_identCode.text),@"password":GGTRIM(_pwd.text)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"---dict %@",dict);
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        [self printAlert:returnResult.message];
        if(returnResult.result){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self printAlert:@"请求出错"];
    }];
    
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
    
    if([@"" isEqualToString:GGTRIM(_identCode.text)]){
        [self printAlert:@"请输入验证码"];
        return false;
    }
    
    //校验密码长度
    if(_pwd.text.length<6 || _pwd.text.length>20){
        [self printAlert:@"请输入6-12位的密码"];
        return false;
    }
    //校验密码长度
    if(_identCode.text.length !=6){
        [self printAlert:@"请输入六位短信密码"];
        return false;
    }
    return true;
}

//验证手机号
- (BOOL)isUrl
{
    //校验空
    if([@"" isEqualToString:GGTRIM(_phoneNum.text)]){
        [self printAlert:@"请输入手机号码"];
        return false;
    }
    //校验密码长度
    if(GGTRIM(_phoneNum.text).length !=11){
        [self printAlert:@"请输入11位手机号码"];
        return false;
    }
    
    NSString * regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:GGTRIM(_phoneNum.text)]){
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
