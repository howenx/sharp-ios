//
//  UserNameViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/19.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import "UserNameViewController.h"
@interface UserNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField * nameTextField;

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改昵称";
    _nameTextField.delegate = self;
    _nameTextField.placeholder = _comeName;
    self.tabBarController.tabBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveBtn:(UIButton *)sender {
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    [self saveButtonClick];
    
}
-(void)saveButtonClick{
    
    NSString * urlString =[HSGlobal updateUserInfo];
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    if(_nameTextField.text == nil ||[@"" isEqualToString:_nameTextField.text]){
        _nameTextField.text =_comeName;
    }
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_nameTextField.text,@"nickname",nil];
    [manager POST:urlString  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"code= %ld",(long)code);
        NSLog(@"message= %@",message);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        if(200 == code){
            hud.labelText = @"修改成功";
            [self.delegate backName:_nameTextField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            hud.labelText = @"修改失败";
            [hud hide:YES afterDelay:1];
        }
        
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
        
    }];
    
}
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
    
    if([@"" isEqualToString:string]){
        canChange = YES;
    }else{
        canChange = [NSString isNumAndLetterAndChinese:string];
        if(!canChange){
            [self showHud:@"昵称为数字、字母、汉字组合"];
        }
        
        if(_nameTextField.text.length+string.length+string.length >12){
            canChange = NO;
            [self showHud:@"昵称最多12位"];
        }
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
