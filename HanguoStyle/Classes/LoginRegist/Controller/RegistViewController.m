//
//  RegistViewController.m
//  GiftGuide
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import "RegistViewController.h"
#import "ReturnResult.h"

@interface RegistViewController ()<UITextFieldDelegate>
{
    int secondsCountDown; //倒计时总时长
    NSTimer * countDownTimer;
    FMDatabase * database;
}
- (IBAction)backButton:(UIButton *)sender;
- (IBAction)registButton:(UIButton *)sender;
- (IBAction)testingCodeButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;

@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *identCode;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *againPwd;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden=YES;
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.navigationItem.title = @"账号注册";

    _pwd.returnKeyType = UIReturnKeyDone;
    _identCode.returnKeyType = UIReturnKeyDone;
    _againPwd.returnKeyType = UIReturnKeyDone;
    _pwd.delegate = self;
    _identCode.delegate = self;
    _againPwd.delegate = self;
    _pwd.tag = 12012;
    _identCode.tag = 12013;
    _againPwd.tag = 12014;
    [self getTestCode];
    _phoneLab.text = [NSString stringWithFormat:@"已经发送验证码至 %@****%@",[_phone substringToIndex:3],[_phone substringFromIndex:8]];
}
-(void)viewDidDisappear:(BOOL)animated
{
    if(countDownTimer != nil){
        //关闭定时器
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL canChange = YES;
    
    if(textField.tag == 12012){
        if([@"" isEqualToString:string]){
            canChange = YES;
        }else{
            canChange = [NSString isNumAndLetter:string];
            if(!canChange){
                [self showHud:@"密码只能包含字母和数字"];
            }
            
            if(_pwd.text.length+string.length>12){
                [self showHud:@"密码为6-12位"];
                
                canChange = NO;
            }
            
        }
        
        return canChange;
    }else if(textField.tag == 12014){
        if([@"" isEqualToString:string]){
            canChange = YES;
        }else{
            canChange = [NSString isNumAndLetter:string];
            
            if(!canChange){
                [self showHud:@"确认密码只能包含字母和数字"];
            }
            
            if(_pwd.text.length+string.length>12){
                [self showHud:@"确认密码为6-12位"];
                
                canChange = NO;
            }
            
        }
        
        return canChange;
    }else if(textField.tag == 12013){
        if([@"" isEqualToString:string]){
            canChange = YES;
        }else{
            canChange = [NSString isNum:string];
            
            if(!canChange){
                [self showHud:@"手机验证码为数字"];
            }
            if(GGTRIM(_identCode.text).length+string.length > 6){
                [self showHud:@"验证码为6位"];
                canChange = NO;
            }
        }
        
        return canChange;
        
    }
    return canChange;
    
}
#pragma mark - 按钮事件
- (IBAction)backButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registButton:(UIButton *)sender {
    if(![self check]){
        return;
    }
    [self getData];
}
//获取验证码
- (IBAction)testingCodeButton:(UIButton *)sender {
    [self getTestCode];
    
}
-(void)getTestCode{
    //设置倒计时总时长
    secondsCountDown = 60;//60秒倒计时
    NSString * urlString =[HSGlobal testingCodeUrl];
    NSString * msg = [NSString md5:[_phone stringByAppendingString:@"hmm"]] ;
    AFHTTPRequestOperationManager *manager = [PublicMethod shareNoHeadRequestManager];
    
    [manager POST:urlString  parameters:@{@"phone":_phone,@"msg":msg} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        if(returnResult.code == 200){
            //开始倒计时
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
        }else{
            [self showHud:returnResult.message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
        NSLog(@"Error: %@", error);
        [self showHud:@"请求出错"];
    }];


}
-(void)timeFireMethod{
    _testBtn.enabled = NO;
    //倒计时-1
    secondsCountDown--;
    //修改倒计时标签现实内容
    [_testBtn setTitle:[NSString stringWithFormat:@"%d s",secondsCountDown] forState:UIControlStateNormal];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        countDownTimer = nil;
        [_testBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _testBtn.enabled = YES;
    }
}
//发送注册数据
-(void)getData{
    NSString * urlString =[HSGlobal registUrl];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareNoHeadRequestManager];
    
    [manager POST:urlString  parameters:@{@"phone":_phone,@"code":GGTRIM(_identCode.text),@"password":GGTRIM(_pwd.text)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        
        if(returnResult.code == 200){
            [self toLogin];
        }else{
            [self showHud:returnResult.message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showHud:@"请求出错"];
    }];

}

-(void)toLogin{
    NSString * urlString =[HSGlobal loginUrl];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareNoHeadRequestManager];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_phone,@"name",_pwd.text,@"password",@"-1",@"code",nil];
    [manager POST:urlString  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        
        if(returnResult.code == 200){
            [self showHud:@"注册成功，自动登录"];
            //把用户账号存到内存中
            [[NSUserDefaults standardUserDefaults]setObject:returnResult.token forKey:@"userToken"];
            NSDate * lastDate = [[NSDate alloc] initWithTimeInterval:returnResult.expired sinceDate:[NSDate date]];
            [[NSUserDefaults standardUserDefaults]setObject:lastDate forKey:@"expired"];
            [self sendCart];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
            
            
        }else if(returnResult.code == 4001){//如果让输入图文验证码就跳到登陆界面
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
        }else{
            [self showHud:returnResult.message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showHud:@"登陆失败"];
    }];
    
}

-(BOOL)check{

    if([NSString isBlankString:GGTRIM(_pwd.text)]){
        [self showHud:@"请输入密码"];
        return false;
    }
    
    if([NSString isBlankString:GGTRIM(_identCode.text)]){
        [self showHud:@"请输入验证码"];
        return false;
    }
    
    //校验密码长度
    if(_pwd.text.length<6 || _pwd.text.length>12){
        [self showHud:@"请输入6-12位的密码"];
        return false;
    }
    //校验密码长度
    if(_identCode.text.length !=6){
        [self showHud:@"请输入六位短信密码"];
        return false;
    }
    if(![_pwd.text isEqualToString:_againPwd.text]){
        [self showHud:@"确认密码和密码不一致"];
        return false;
    }
    //校验密码是由数字和字母组成，不可是单一一种
    
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,12}";//"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    bool result = [pred evaluateWithObject:_pwd.text];
    if(!result){
        [self showHud:@"密码是由数字和字母组成"];
        return false;
    }
    
    return true;
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
-(void)sendCart{
    database = [PublicMethod shareDatabase];
    
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
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            //            [HSGlobal printAlert:@"发送购物车数据失败"];
            [self showHud:@"发送购物车数据失败"];
        }];
        
    }
}
@end
