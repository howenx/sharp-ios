//
//  AssessViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/26.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "AssessViewController.h"
#import "TQStarRatingView.h"
#import "PlaceholderTextView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCImagePickerHeader.h"

#define photoW (GGUISCREENWIDTH-60)/5
@interface AssessViewController ()<StarRatingViewDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    //下拉菜单
    UIActionSheet * myActionSheet;
    PlaceholderTextView * detailTextfield;
    int maySelect;//本次可选的图片数量
    UIButton * uploadPhotoBtn;
    NSMutableArray *images;
    
}
//上传图片
@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;
//五星
@property (nonatomic, strong) TQStarRatingView *starRatingView;
@property (nonatomic, assign) int grade;//分数
@end

@implementation AssessViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden=YES;
    maySelect = 5;
    _grade = 5;
    images = [NSMutableArray array];
    self.navigationItem.title = @"评价";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createView];
}
- (void)createView{
    
    UIImageView * goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,70,70)];
    goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    CALayer *layer = [goodsImageView layer];
    layer.borderColor = GGBgColor.CGColor;
    layer.borderWidth = 1.0f;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:_assessListData.orderLine.invImg]];
    [self.view addSubview:goodsImageView];
    
    
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 55, 20)];
    titleLab.numberOfLines = 1;
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.text = @"描述相符";
    [self.view addSubview:titleLab];
    
    _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(150, 39, 160, 22)
                                                 numberOfStar:kNUMBER_OF_STAR];
    _starRatingView.delegate = self;
    [self.view addSubview:_starRatingView];
    
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 89, GGUISCREENWIDTH, 1)];
    line1.backgroundColor = GGBgColor;
    [self.view addSubview:line1];
    
    
    
    detailTextfield=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(10, 100, GGUISCREENWIDTH-20, 70)];
    detailTextfield.placeholder=@"快来评价，让小伙伴们做个参考吧~";
    detailTextfield.font=[UIFont boldSystemFontOfSize:14];
    detailTextfield.keyboardType = UIKeyboardTypeDefault;
    detailTextfield.textColor = UIColorFromRGB(0xa9a9a9);

    [self.view addSubview:detailTextfield];
    
    [self showImageView];
    UIView * lastView = [[UIView alloc]initWithFrame:CGRectMake(0, 180+photoW+15, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
    lastView.backgroundColor = GGBgColor;
    [self.view addSubview:lastView];
    
    UIButton * commitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT-64-40, GGUISCREENWIDTH, 40)];
    [commitButton setTitle:@"提交评价" forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    commitButton.backgroundColor = GGMainColor;
    [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];

}
//星星代理方法返回值
-(void)starRatingView:(TQStarRatingView *)view score:(float)score{
     _grade = [[NSString stringWithFormat:@"%f",score*5] intValue];
    NSLog(@"-------%d",_grade);
}
-(void)uploadPhotoBtnClick:(UIButton *)btn{
    

    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:  @"相册",@"拍照",nil];
    [myActionSheet showInView:self.view];
    
   }


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开本地相册
            [self localPhoto];
            break;
        case 1:
            [self takePhoto];
            break;
    }
    
}
//选择本地相册
-(void)localPhoto{
    ELCImagePickerController * elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = maySelect; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];

}
//选择完相册照片点击完成回调方法
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                UIImage * smallImage =[self scaleFromImage:image toSize:CGSizeMake(photoW*5, photoW*5)];
                NSData *imageData = UIImagePNGRepresentation(smallImage);

                if([imageData length]/1024/1024>1){
                    smallImage =[self scaleFromImage:image toSize:CGSizeMake(photoW, photoW)];
                }
                NSLog(@"PNG+++_______+++%lu",(unsigned long)[imageData length]);
                [images addObject:smallImage];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
    }
    [self showImageView];

}
//拍照功能
-(void)takePhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//当选择一张拍照的图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    //当选择的类型是图片
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage])
    {

        UIImage * _localImage = [info objectForKey:UIImagePickerControllerEditedImage];;
        UIImage * smallImage =[self scaleFromImage:_localImage toSize:CGSizeMake(photoW*5, photoW*5)];
        NSData *imageData = UIImagePNGRepresentation(smallImage);
        if([imageData length]/1024/1024>1){
            smallImage =[self scaleFromImage:smallImage toSize:CGSizeMake(photoW, photoW)];
        }
        NSLog(@"PNG+++_______+++%lu",(unsigned long)[imageData length]);
        [images addObject:smallImage];
        [self showImageView];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}
//显示图片到页面上
- (void)showImageView {
    [[self.view viewWithTag:16000]removeFromSuperview];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 180, GGUISCREENWIDTH, photoW)];
    view.tag = 16000;
    [self.view addSubview:view];
    CGRect workingFrame = CGRectMake(10, 0, photoW, photoW);
    CGRect delFrame = CGRectMake(5, -5, 20, 20);
    for(int i = 0;i<images.count;i++){
        UIImage * image = images[i];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.frame = workingFrame;
        
        [view addSubview:imageview];
        
        UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.tag = 10000+i;
        delBtn.frame = delFrame;
        [delBtn setImage:[UIImage imageNamed:@"iconfont_shanchu"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:delBtn];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width + 10;
        delFrame.origin.x = delFrame.origin.x + photoW + 10;
    }
    uploadPhotoBtn = [[UIButton alloc]init];
    [uploadPhotoBtn setImage:[UIImage imageNamed:@"uploadPhoto"] forState:UIControlStateNormal];
    [uploadPhotoBtn addTarget:self action:@selector(uploadPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:uploadPhotoBtn];
    uploadPhotoBtn.frame = workingFrame;
    maySelect = 5 - images.count;
}
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//照相机点完成回调方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//删除图片
- (void)delBtnClick :(UIButton *)button{
    [images removeObjectAtIndex:button.tag-10000];
    [self showImageView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//相册点取消回调
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)commitButtonClick{
    NSLog(@"%lu",(unsigned long)detailTextfield.text.length);
    if(detailTextfield.text.length<10 || detailTextfield.text.length>500){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"评价在10到500字之间"];
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return;
    }
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"7777"] forHTTPHeaderField:@"Content-Type"];
    
    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
    
    
    
    NSMutableDictionary * lastDict = [NSMutableDictionary new];
    
    
    [lastDict setObject: [NSString stringWithFormat:@"%ld",_assessListData.orderLine.orderId] forKey:@"orderId"];
    [lastDict setObject: [NSString stringWithFormat:@"%ld",_assessListData.orderLine.skuTypeId] forKey:@"skuTypeId"];
    [lastDict setObject: _assessListData.orderLine.skuType forKey:@"skuType"];
    [lastDict setObject: [NSNumber numberWithInt:_grade] forKey:@"grade"];
    [lastDict setObject: detailTextfield.text forKey:@"content"];
    
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager POST:[HSGlobal assessUrl] parameters:lastDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i = 0;i<images.count;i++){
            UIImage * image = images[i];
            NSData *imageData = UIImagePNGRepresentation(image);
            
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"img%d",i]
                                    fileName:[NSString stringWithFormat:@"img%d.png",i] mimeType:@"image/png"];
            
            //            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"img%d",i] fileName:[NSString stringWithFormat:@"img%d.png",i] mimeType:@"image/jpg/png/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSLog(@"Success: %@", [[responseObject objectForKey:@"message"] objectForKey:@"message"]);
        NSInteger code = [[[responseObject objectForKey:@"message"] objectForKey:@"code"]integerValue];
        
        if (code == 200) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"评价成功"];
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"评价失败"];
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
        }
        [GiFHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [GiFHUD dismiss];
        NSLog(@"Error: %@", error);
    }];

}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    CGFloat viewY = firstResponder.frame.origin.y + firstResponder.frame.size.height + 10 +64;
    //键盘上端的frame的y值
    CGFloat keyY = GGUISCREENHEIGHT - keyboardSize.height;
    NSLog(@"viewY=%f",viewY);
    NSLog(@"keyY=%f",keyY);
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
    self.view.frame = CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT);
    [UIView commitAnimations];
    
}

@end
