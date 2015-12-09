//
//  UpdateUserInfoViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/2.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "UpdateUserInfoViewController.h"
#import "HSGlobal.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+GG.h"
@interface UpdateUserInfoViewController ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    //下拉菜单
    UIActionSheet * myActionSheet;
    UIActionSheet * genderActionSheet;
    NSString * encodeImage;
}
@property (nonatomic) UIImage * localImage;
@property (nonatomic) UITextField * textField;
@property (nonatomic) UILabel * gLabel;//性别label

@end

@implementation UpdateUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本信息";
    [self createView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) createView{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 64, 100, 40);
    [button setTitle:@"请选择本地照片" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, GGUISCREENWIDTH, 8)];
    lineView.backgroundColor =  GGColor(240, 240, 240);
    [self.view addSubview:lineView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 112,  100, 40)];
    label.text = @"用户名:";
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(60, 117, GGUISCREENWIDTH-60-10, 30)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.placeholder = self.userName;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.textAlignment = UITextAlignmentRight;
    _textField.delegate = self;
    
    [self.view addSubview:_textField];
    
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 152, GGUISCREENWIDTH, 8)];
    lineView1.backgroundColor =  GGColor(240, 240, 240);
    [self.view addSubview:lineView1];
    
    
    
    
    
    UIButton *gButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gButton.frame = CGRectMake(10, 152, GGUISCREENWIDTH - 40, 50);
    gButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [gButton setTitle:@"性别：" forState:UIControlStateNormal];
    gButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [gButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gButton addTarget:self action:@selector(chooseGenderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gButton];
    
    UIImageView * jianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-30, 170, 25, 25)];
    jianImageView.image = [UIImage imageNamed:@"icon_more_hui"];
    [self.view addSubview:jianImageView];
    _gLabel = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-50, 170, 20, 20)];
    _gLabel.text = self.gender;
    [self.view addSubview:_gLabel];

    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 202, GGUISCREENWIDTH, 8)];
    lineView2.backgroundColor =  GGColor(240, 240, 240);
    [self.view addSubview:lineView2];

    
    
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.backgroundColor = GGColor(254, 99, 108);
    saveButton.frame = CGRectMake(10, 248, GGUISCREENWIDTH-20, 30);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}
-(void)chooseGenderAction{
    //在这里呼出下方菜单按钮项
    genderActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:  @"男",@"女",nil];
    genderActionSheet.tag = 2;
    [genderActionSheet showInView:self.view];

}
-(void)saveButtonClick{
    if ([NSString isBlankString:_textField.text]) {
        _textField.text = self.userName;
    }
    NSString * urlString =[HSGlobal updateUserInfo];
    AFHTTPRequestOperationManager * manager = [HSGlobal shareRequestManager];

    NSString * genderFlag ;
    if([@"男" isEqualToString :_gLabel.text]){
        genderFlag = @"M";
    }else if([@"女" isEqualToString :_gLabel.text]){
        genderFlag = @"F";
    }
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_textField.text,@"nickname",genderFlag,@"gender",encodeImage,@"photoUrl",nil];
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
        //    hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        if(200 == code){
            hud.labelText = @"修改成功";
            [self.delegate backIcon:_localImage];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            hud.labelText = @"修改失败";
            [hud hide:YES afterDelay:1];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [HSGlobal printAlert:@"数据加载失败"];
        
    }];

}
-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:  @"从手机相册获取",nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1){
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == myActionSheet.cancelButtonIndex)
        {
            NSLog(@"取消");
        }
        
        switch (buttonIndex)
        {
            case 0:  //打开本地相册
                [self LocalPhoto];
                break;
        }

    }else if(actionSheet.tag == 2){
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == genderActionSheet.cancelButtonIndex)
        {
            NSLog(@"取消");
        }
        
        switch (buttonIndex)
        {
            case 0:  //男
                 _gLabel.text = @"男";
                break;
            case 1:  //女
                _gLabel.text = @"女";
                break;
        }

    }
}


//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        _localImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(_localImage) == nil)
        {
            data = UIImageJPEGRepresentation(_localImage, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(_localImage);
        }
        //base64 的转码
        encodeImage = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [picker dismissViewControllerAnimated:YES completion:nil];
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
                                   CGRectMake(GGUISCREENWIDTH-10-40, 64+5, 30, 30)] ;
        
        smallimage.image = _localImage;
        //加在视图中
        [self.view addSubview:smallimage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
