//
//  RefundViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/4/14.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "RefundViewController.h"
#import "PlaceholderTextView.h"
@interface RefundViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UIView * bg1View;
    PlaceholderTextView * detailTextView;
    UILabel * detailLabel3;
    UITextField * nameTextfield;
    UITextField * telTextfield;
    UILabel * moneyLabel;
}
@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"申请退款";
    self.view.backgroundColor = GGBgColor;
    [self createSettingView];
}
-(void)createSettingView{
    
    bg1View = [[UIView alloc]initWithFrame:CGRectMake(0, 25/2, SCREEN_WIDTH, 230/2)];
    bg1View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg1View];
    
    //说明
    UIImageView * startImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 10, 10)];
    startImageView.image = [UIImage imageNamed:@"xing"];
    [bg1View addSubview:startImageView];
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(startImageView, 5), 15, 100, 16)];
    detailLabel.text = @"退款说明:";
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.textColor  = [UIColor blackColor];
    [bg1View addSubview:detailLabel];
    
    //文本
    detailTextView=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(15, PosYFromView(startImageView, 15), GGUISCREENWIDTH-30, 114/2)];
    detailTextView.placeholder=@"最多200个字";
    detailTextView.font=[UIFont boldSystemFontOfSize:14];
    detailTextView.placeholderFont=[UIFont boldSystemFontOfSize:13];
    detailTextView.keyboardType = UIKeyboardTypeDefault;
    detailTextView.layer.borderWidth=0.5;
    detailTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [bg1View addSubview:detailTextView];
    
    
    UIView * bg2View = [[UIView alloc]initWithFrame:CGRectMake(0, PosYFromView(bg1View, 15), SCREEN_WIDTH, 86/2)];
    bg2View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg2View];
    
    UIImageView * startImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 10, 10)];
    startImageView2.image = [UIImage imageNamed:@"xing"];
    [bg2View addSubview:startImageView2];
    
    UILabel * detailLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(startImageView, 5), 15, 95, 16)];
    detailLabel2.text = @"退款金额:  ￥";
    detailLabel2.font = [UIFont systemFontOfSize:15];
    detailLabel2.textColor  = [UIColor blackColor];
    [bg2View addSubview:detailLabel2];
    
    //金额
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(detailLabel2, 0), 15, 200, 16)];
    moneyLabel.text = self.orderData.orderInfo.payTotal;
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textColor  = UIColorFromRGB(0xff5359);
    [bg2View addSubview:moneyLabel];
    
    UIView * bg3View = [[UIView alloc]initWithFrame:CGRectMake(0, PosYFromView(bg2View, 15), SCREEN_WIDTH, 290/2)];
    bg3View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg3View];
    
    
    
    detailLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 45, 15)];
    detailLabel3.text = @"非必填";
    detailLabel3.font = [UIFont systemFontOfSize:15];
    detailLabel3.textColor  = [UIColor blackColor];
    [bg3View addSubview:detailLabel3];
    
    
    UIView * bg4View = [[UIView alloc]initWithFrame:CGRectMake(15, PosYFromView(detailLabel3, 15), SCREEN_WIDTH-30, 176/2)];
    bg4View.backgroundColor = GGBgColor;
    [bg3View addSubview:bg4View];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 75, 176/4)];
    nameLabel.text = @"  联系人:";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor  = UIColorFromRGB(0x999999);
    [bg4View addSubview:nameLabel];
    
    nameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(PosXFromView(nameLabel, 14), 0, SCREEN_WIDTH-30-75-30-14, 176/4)];
    nameTextfield.textColor = UIColorFromRGB(0x666666);
    [bg4View addSubview:nameTextfield];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, PosYFromView(nameTextfield, 0), SCREEN_WIDTH-30, 0.5)];
    lineView.backgroundColor = GGBgColor;
    [bg4View addSubview:lineView];
    
    UILabel * telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, PosYFromView(nameTextfield, 0), 90, 176/4)];
    telLabel.text = @"  联系电话:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.textColor  = UIColorFromRGB(0x999999);
    [bg4View addSubview:telLabel];
    
    telTextfield = [[UITextField alloc]initWithFrame:CGRectMake(PosXFromView(telLabel, 0), PosYFromView(nameTextfield, 0), SCREEN_WIDTH-30-90-30, 176/4)];
    telTextfield.textColor = UIColorFromRGB(0x666666);
    [bg4View addSubview:telTextfield];
    
    
    
    
    
    UIButton * commitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-41-21-64, SCREEN_WIDTH-30, 41)];
    [commitButton setBackgroundColor:UIColorFromRGB(0xff5359)];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];

}
-(void)commitClick:(UIButton *)btn
{
#pragma mark -POST请求
    
    //            [lastDict setObject: [NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderId] forKey:@"orderId"];
    //            [lastDict setObject: [NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderSplitId] forKey:@"splitOrderId"];
    //            [lastDict setObject: detailTextView.text forKey:@"reason"];
    //            [lastDict setObject: moneyLabel.text forKey:@"payBackFee"];
    //            [lastDict setObject: nameTextfield.text forKey:@"contactName"];
    //            [lastDict setObject: telTextfield.text forKey:@"contactTel"];
    //            [lastDict setObject: @"deliver" forKey:@"refundType"];
    
    
    /********** POST请求  ***********/
//    NSString * urlString =[HSGlobal refundUrl];
//    
//    
////    NSString * newUrlString = [NSString stringWithFormat:@"%@?name=%@",urlString,@"wunan"];
//    //username=test
//    //password=123456
//    
//    //默认GET请求
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    //请求类型(默认GET请求)
//    request.HTTPMethod = @"POST";
//    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
//    [request setValue:userToken forHTTPHeaderField:@"id-token"];
//    
//        // 4> 设置Content-Type
//    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"sds1213"];
//    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
//    //把参数放到请求体里面
////    NSString * str = [NSString stringWithFormat:@"orderId=%@&splitOrderId=%@&reason=%@&payBackFee=%@&contactName=%@&contactTel=%@&refundType=%@",[NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderId],[NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderSplitId],detailTextView.text,moneyLabel.text,nameTextfield.text,telTextfield.text,@"deliver"];
//    
////    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
//    //发送异步请求
//    
//    request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//         NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",result);
//    }];
//    
//    
#pragma mark -AFNetWorking的POST请求
//    NSDictionary *parameters = @{@"username":@"test",@"password":@"123456"};
//    
//    //AFNetWorking POST请求
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"image/png", nil];
//    
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        NSLog(@"￥￥￥￥￥￥￥：%@",responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    
    
    
//    NSMutableData * dataM = [NSMutableData data];
    // 1> 数据体
//    NSString *topStr = [self topStringWithMimeType:@"image/png" uploadFile:@"头像1.png"];
//    NSString *bottomStr = [self bottomString];
//
//    NSMutableDictionary * lastDict = [NSMutableDictionary new];
//            [lastDict setObject: [NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderId] forKey:@"orderId"];
//            [lastDict setObject: [NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderSplitId] forKey:@"splitOrderId"];
//            [lastDict setObject: detailTextView.text forKey:@"reason"];
//            [lastDict setObject: moneyLabel.text forKey:@"payBackFee"];
//            [lastDict setObject: nameTextfield.text forKey:@"contactName"];
//            [lastDict setObject: telTextfield.text forKey:@"contactTel"];
//            [lastDict setObject: @"deliver" forKey:@"refundType"];
//    NSString * urlString =[HSGlobal refundUrl];
//    
//    NSMutableData *dataM = [NSMutableData data];
//    [dataM appendData:[[NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderId] dataUsingEncoding:NSUTF8StringEncoding]];
//    [dataM appendData:[[NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderSplitId] dataUsingEncoding:NSUTF8StringEncoding]];
//    [dataM appendData:[detailTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
//    [dataM appendData:[moneyLabel.text dataUsingEncoding:NSUTF8StringEncoding]];
//    [dataM appendData:[nameTextfield.text dataUsingEncoding:NSUTF8StringEncoding]];
//    [dataM appendData:[telTextfield.text dataUsingEncoding:NSUTF8StringEncoding]];
//    [dataM appendData:[@"deliver" dataUsingEncoding:NSUTF8StringEncoding]];
    
//    [dataM appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
//    [dataM appendData:data];
//    [dataM appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 1. Request
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:2.0f];
//    
//    // dataM出了作用域就会被释放,因此不用copy
//    request.HTTPBody = dataM;
//    
//    // 2> 设置Request的头属性
//    request.HTTPMethod = @"POST";
//    
//    // 3> 设置Content-Length
//    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
//    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
//    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
//    [request setValue:userToken forHTTPHeaderField:@"id-token"];
//    
//    // 4> 设置Content-Type
//    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"sds1213"];
//    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
//    
//    // 3> 连接服务器发送请求
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", result);
//    }];
//    if (!STR_IS_EMPTY(detailTextView.text)) {
//        
//        if (detailTextView.text.length > 200) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = [NSString stringWithFormat:@"文本过长,当前长度为:%ld",
//                             detailTextView.text.length];
//            hud.labelFont = [UIFont systemFontOfSize:11];
//            hud.margin = 10.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:1];
//            return;
//        }
    
        
        
//        NSMutableDictionary * lastDict = [NSMutableDictionary new];
//
//        
//        [lastDict setObject: [NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderId] forKey:@"orderId"];
//        [lastDict setObject: [NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderSplitId] forKey:@"splitOrderId"];
//        [lastDict setObject: detailTextView.text forKey:@"reason"];
//        [lastDict setObject: moneyLabel.text forKey:@"payBackFee"];
//        [lastDict setObject: nameTextfield.text forKey:@"contactName"];
//        [lastDict setObject: telTextfield.text forKey:@"contactTel"];
//        [lastDict setObject: @"deliver" forKey:@"refundType"];
//        
//        NSString * urlString =[HSGlobal refundUrl];
//        
//        [NetRequestClass NetRequestPOSTWithRequestURL:urlString WithParameter:lastDict WithReturnValeuBlock:^(id returnValue) {
//            
//            if ([returnValue isKindOfClass:[NSDictionary class]]) {
//             NSDictionary * message =   [returnValue objectForKey:@"message"];
//                NSLog(@"%@",[message objectForKey:@"message"]);
//            }
//        } WithErrorCodeBlock:^(id errorCode) {
//            NSLog(@"%@",errorCode);
//        } WithFailureBlock:^{
//            NSLog(@"失败!");
//        }];
//        
    
        
//
    
    
//        AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
//        [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",[[NSUUID UUID] UUIDString]] forHTTPHeaderField:@"Content-Type"];
////        [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data;] forHTTPHeaderField:@"Content-Type"];
//        if (manager ==nil) {
//            return;
//        }
//    
//        [GiFHUD setGifWithImageName:@"hmm.gif"];
//        [GiFHUD show];
//        [manager POST:[HSGlobal refundUrl]  parameters:lastDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//            
//            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
//            NSInteger code =[[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
//            NSLog(@"message= %@",message);
//            if(code == 200){
//                [self back];
//            }else{
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = message;
//                hud.labelFont = [UIFont systemFontOfSize:11];
//                hud.margin = 10.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:1];
//            }
//            [GiFHUD dismiss];
//            [self performSelector:@selector(back) withObject:nil afterDelay:1];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [GiFHUD dismiss];
//            NSLog(@"Error: %@", error);
//            [PublicMethod printAlert:@"退款失败"];
//            [self performSelector:@selector(back) withObject:nil afterDelay:1];
//            
//        }];
//
//
//    }else
//    {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"退款原因不能为空!~";
//                hud.labelFont = [UIFont systemFontOfSize:11];
//                hud.margin = 10.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:1];
//    }
//    NSMutableURLRequest * requset = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:[HSGlobal refundUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
//    } error:nil];
    
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //    //请求类型(默认GET请求)
    //    request.HTTPMethod = @"POST";
    //        NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    //        [request setValue:userToken forHTTPHeaderField:@"id-token"];
    //
    //        // 4> 设置Content-Type
    //        NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"sds1213"];
    //        [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    //    //把参数放到请求体里面
    //    NSString * str = [NSString stringWithFormat:@"orderId=%@&splitOrderId=%@&reason=%@&payBackFee=%@&contactName=%@&contactTel=%@&refundType=%@",[NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderId],[NSString stringWithFormat:@"%ld",self.orderData.orderInfo.orderSplitId],detailTextView.text,moneyLabel.text,nameTextfield.text,telTextfield.text,@"deliver"];
    //    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:<#(NSURLRequest *)#> writingStreamContentsToFile:<#(NSURL *)#> completionHandler:<#^(NSError *error)handler#>

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
    
    
    NSDictionary *parameters =@{@"name":@"value1",@"age":@"value2"};
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"hmm_kaituan_success"], 1.0);
    
    [manager POST:[HSGlobal refundUrl] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData :imageData name:@"1" fileName:@"1.png" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSLog(@"Success: %@", [[responseObject objectForKey:@"message"] objectForKey:@"message"]);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
    self.selectButtonBlock(nil);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
