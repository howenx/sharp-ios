//
//  UpdateUserInfoViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/2.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "UpdateUserInfoViewController.h"
#import "UserNameViewController.h"

@interface UpdateUserInfoViewController ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UserNameDelegate>
{
    //下拉菜单
    UIActionSheet * myActionSheet;
    UIActionSheet * genderActionSheet;
    NSString * encodeImage;
}
@property (nonatomic) UIImage * localImage;
@property (nonatomic) UILabel * nameLab;
@property (nonatomic) UILabel * gLabel;//性别label
@property (nonatomic) UIImageView * smallimage;

@end

@implementation UpdateUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"修改信息";
    [self createView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) createView{
    
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    

    
    UILabel * photoLabelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-70, 40)];
    photoLabelTitle.text = @"修改头像";
    photoLabelTitle.tag = 10001;
    photoLabelTitle.font = [UIFont systemFontOfSize:14];
    photoLabelTitle.userInteractionEnabled = YES;
    [photoLabelTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapAction)]];
    [bgView addSubview:photoLabelTitle];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(10, 64, 100, 40);
//    [button setTitle:@"请选择本地照片" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    
    _smallimage = [[UIImageView alloc] initWithFrame: CGRectMake(GGUISCREENWIDTH-70, 5, 30, 30)] ;
    _smallimage.image = _comeImage;
    _smallimage.tag = 10002;
    _smallimage.layer.cornerRadius = 15;
    _smallimage.userInteractionEnabled = YES;
    [_smallimage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapAction)]];
    [bgView addSubview:_smallimage];
    
    UIImageView * jianImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-30, 10, 20, 20)];
    jianImageView1.contentMode = UIViewContentModeScaleAspectFit;
    jianImageView1.image = [UIImage imageNamed:@"icon_more_hui"];
    jianImageView1.tag = 10003;
    jianImageView1.userInteractionEnabled = YES;
    [jianImageView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapAction)]];
    [bgView addSubview:jianImageView1];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, GGUISCREENWIDTH, 0.5)];
    lineView.backgroundColor =  [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.3];
    [bgView addSubview:lineView];
    
    UILabel * nameLabelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 40.5,  90, 40)];
    nameLabelTitle.text = @"昵称";
    nameLabelTitle.tag = 10005;
    nameLabelTitle.font = [UIFont systemFontOfSize:14];
    nameLabelTitle.userInteractionEnabled = YES;
    [nameLabelTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTapAction)]];
    [bgView addSubview:nameLabelTitle];
    
    
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 40.5, GGUISCREENWIDTH-130, 40)];
    _nameLab.tag = 10006;
    _nameLab.textAlignment = NSTextAlignmentRight;
    _nameLab.text = self.userName;
    _nameLab.font = [UIFont systemFontOfSize:15];
    _nameLab.userInteractionEnabled = YES;
    [_nameLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTapAction)]];

    [bgView addSubview:_nameLab];
    UIImageView * jianImageView0 = [[UIImageView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-30, PosYFromView(lineView, 10), 20, 20)];
    jianImageView0.contentMode = UIViewContentModeScaleAspectFit;
    jianImageView0.tag = 10004;
    jianImageView0.image = [UIImage imageNamed:@"icon_more_hui"];
    jianImageView0.userInteractionEnabled = YES;
    [jianImageView0 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTapAction)]];
    [bgView addSubview:jianImageView0];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 80.5, GGUISCREENWIDTH, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.3];
    [bgView addSubview:lineView1];
    
    
    UILabel * sexLabelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 80.5, GGUISCREENWIDTH - 40, 40)];
    sexLabelTitle.text = @"性别";
    sexLabelTitle.tag = 10007;
    sexLabelTitle.font = [UIFont systemFontOfSize:14];
    sexLabelTitle.userInteractionEnabled = YES;
    [sexLabelTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sexTapAction)]];
    [bgView addSubview:sexLabelTitle];
    

    _gLabel = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-60, 80.5, 20, 40)];
    [_gLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sexTapAction)]];
    _gLabel.font = [UIFont systemFontOfSize:15];
    _gLabel.tag = 10008;
    _gLabel.text = self.gender;
    _gLabel.userInteractionEnabled = YES;
    [self.view addSubview:_gLabel];

    
    UIImageView * jianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-30, PosYFromView(lineView1, 10), 20, 20)];
    jianImageView.contentMode = UIViewContentModeScaleAspectFit;
    jianImageView.image = [UIImage imageNamed:@"icon_more_hui"];
    jianImageView.tag = 10009;
    jianImageView.userInteractionEnabled = YES;
    [jianImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sexTapAction)]];
    [bgView addSubview:jianImageView];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 121, GGUISCREENWIDTH, 0.5)];
    lineView2.backgroundColor =  [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.3];
    [bgView addSubview:lineView2];

    UILabel * telLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 121, 40, 40)];
    telLabel.text = @"电话";
    telLabel.tag = 10010;
    telLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:telLabel];
    
    UILabel * telLabelNum = [[UILabel alloc]initWithFrame:CGRectMake(50, 121, GGUISCREENWIDTH-50-20, 40)];
    telLabelNum.text = [self.tel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    telLabelNum.textColor = [UIColor lightGrayColor];
    telLabelNum.textAlignment = NSTextAlignmentRight;
    telLabelNum.tag = 10011;
    telLabelNum.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:telLabelNum];
    
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 121+40.5, GGUISCREENWIDTH, 0.5)];
    lineView3.backgroundColor =  [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.3];
    [bgView addSubview:lineView3];
    
    
    bgView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, PosYFromView(lineView3, 0));
    
//    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    saveButton.backgroundColor = GGMainColor;
//    saveButton.frame = CGRectMake(10, 248, GGUISCREENWIDTH-20, 30);
//    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:saveButton];
}
-(void)photoTapAction{
    [self openMenu];
}
-(void)nameTapAction{
    UserNameViewController * user = [[UserNameViewController alloc]init];
    user.delegate = self;
    user.comeName = _nameLab.text;
    [self.navigationController pushViewController:user animated:YES];
    
}
-(void)sexTapAction{
    [self chooseGenderAction];
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
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    
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
    NSString * genderFlag ;
    if([@"男" isEqualToString :_gLabel.text]){
        genderFlag = @"M";
    }else if([@"女" isEqualToString :_gLabel.text]){
        genderFlag = @"F";
    }
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:genderFlag,@"gender",encodeImage,@"photoUrl",nil];
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
            [self.delegate backIcon:_smallimage.image andName:_nameLab.text andSex:_gLabel.text];
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
-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:  @"相册",@"拍照",nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1){
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == myActionSheet.cancelButtonIndex)
        {
            return;
        }
        
        switch (buttonIndex)
        {
            case 0:  //打开本地相册
                [self LocalPhoto];
                break;
            case 1:
                [self takePhoto];
                break;
        }

    }else if(actionSheet.tag == 2){
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == genderActionSheet.cancelButtonIndex)
        {
            return;
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
        [self saveButtonClick];

    }
}

-(void)takePhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
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
    //当选择的类型是图片
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage])
    {
        //先把图片转成NSData
//        _localImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        _localImage = [info objectForKey:UIImagePickerControllerEditedImage];;
        
        UIImage *smallImage =[self scaleFromImage:_localImage toSize:CGSizeMake(160.0f, 160.0f)];
        
        NSData *data;
        if (UIImagePNGRepresentation(smallImage) == nil)
        {
            data = UIImageJPEGRepresentation(smallImage, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(smallImage);
        }
        //base64 的转码
        encodeImage = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [picker dismissViewControllerAnimated:YES completion:nil];
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        
        
        _smallimage.image = smallImage;
        [self saveButtonClick];
        
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
/**
 *  代理方法
 */
-(void)backName:(NSString *)name{
    _nameLab.text = name;
    [self.delegate backIcon:_smallimage.image andName:_nameLab.text andSex:_gLabel.text];
}

- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
