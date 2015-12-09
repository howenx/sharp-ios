//
//  AppendAddrViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/22.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AppendAddrViewController.h"
#import "UIView+frame.h"
#import "HSGlobal.h"
#import "NSString+GG.h"
@interface AppendAddrViewController ()<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

{
    NSString * province;
    NSString * city;
    NSString * town;
}

@property (weak, nonatomic) IBOutlet UITextField * nameLab;
@property ( nonatomic) IBOutlet UITextField * phoneLab;
@property ( nonatomic) IBOutlet UITextField * areaAddrLab;
@property (weak, nonatomic) IBOutlet UITextField *  detailAddrLab;
@property (weak, nonatomic) IBOutlet UITextField * idNumber;
@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;



@property ( nonatomic) IBOutlet UIPickerView *myPicker;
@property ( nonatomic) IBOutlet UIView *pickerBgView;
@property ( nonatomic) UIView *maskView;
//data
@property ( nonatomic) NSDictionary *pickerDic;
@property ( nonatomic) NSArray *provinceArray;
@property ( nonatomic) NSArray *cityArray;
@property ( nonatomic) NSArray *townArray;
@property ( nonatomic) NSArray *selectedArray;
@end

@implementation AppendAddrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _myPicker.delegate = self;
//    _myPicker.dataSource = self;
    self.navigationItem.title=@"添加收货地址";
    _areaAddrLab.tag = 20001;
    _nameLab.delegate = self;
    _phoneLab.delegate = self;
    _areaAddrLab.delegate = self;
    _idNumber.delegate = self;
    _detailAddrLab.delegate = self;
    [self getPickerData];
    [self initView];
    [self registerForKeyboardNotifications];
    [self setPageData:_data];
    
}

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

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag ==20001){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
        });
        [self.view addSubview:self.maskView];
        [self.view addSubview:self.pickerBgView];
        self.maskView.alpha = 0;
        self.pickerBgView.y = GGUISCREENHEIGHT;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0.3;
            self.pickerBgView.frame = CGRectMake(0, 100, self.pickerBgView.width, self.pickerBgView.height);
            self.pickerBgView.bottom = GGUISCREENHEIGHT - 49;
        }];

    }
}
#pragma mark - init view
- (void)initView {
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,GGUISCREENWIDTH,GGUISCREENHEIGHT)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView.width = GGUISCREENWIDTH;
}
#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

//每行显示的文字样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 107, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    if (component == 0) {
        titleLabel.text = [self.provinceArray objectAtIndex:row];
    }
    else if (component == 1) {
        titleLabel.text = [self.cityArray objectAtIndex:row];
    }
    else {
        titleLabel.text = [self.townArray objectAtIndex:row];
    }
    return titleLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

#pragma mark - private method

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.y = GGUISCREENHEIGHT;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

#pragma mark - xib click

- (IBAction)cancel:(id)sender {
    [self hideMyPicker];
}

- (IBAction)ensure:(id)sender {
    province = [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    city = [self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
    town = [self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
    _areaAddrLab.text = [NSString stringWithFormat:@"%@ %@ %@", province, city,town];
    [self hideMyPicker];
}



- (IBAction)saveAddress:(UIButton *)sender {
   
    
    BOOL validIdNumber = [self validateIDCardNumber:_idNumber.text];
    if([NSString isBlankString:GGTRIM(_nameLab.text)]){
        [HSGlobal printAlert:@"请输入姓名"];
        return;
    }
    if(![self isPhone]){
        return;
    }
    if(!validIdNumber){
        [HSGlobal printAlert:@"身份证不正确"];
        return;
    }
    if([NSString isBlankString:GGTRIM(_areaAddrLab.text)]){
        [HSGlobal printAlert:@"请输入所在区域"];
        return;
    }
    if([NSString isBlankString:GGTRIM(_detailAddrLab.text)]){
        [HSGlobal printAlert:@"请输入详细地址"];
        return;
    }
     NSDictionary * addrDict = [NSDictionary dictionaryWithObjectsAndKeys:@"BJ",@"北京市",@"TJ",@"天津市",@"HE",@"河北省",@"SX",@"山西省",@"NM",@"内蒙古",@"LN",@"辽宁省",@"JL",@"吉林省",@"HL",@"黑龙江省",@"SH",@"上海市",@"JS",@"江苏省",@"ZJ",@"浙江省",@"AH",@"安徽省",@"FJ",@"福建省",@"JX",@"江西省",@"SD",@"山东省",@"HA",@"河南省",@"HB",@"湖北省",@"HN",@"湖南省",@"GD",@"广东省",@"GX",@"广西省",@"HI",@"海南省",@"CQ",@"重庆市",@"SC",@"四川省",@"GZ",@"贵州省",@"YN",@"云南省",@"XZ",@"西藏",@"SN",@"陕西省",@"GS",@"甘肃省",@"QH",@"青海省",@"NX",@"宁夏",@"XJ",@"新疆",@"HK",@"香港",@"MO",@"澳门",@"TW",@"台湾省", nil];
    
    NSMutableDictionary * deliveryCityDict = [NSMutableDictionary dictionary];
    [deliveryCityDict setObject:town forKey:@"area"];
    [deliveryCityDict setObject:city forKey:@"city"];
    [deliveryCityDict setObject:province forKey:@"province"];
    [deliveryCityDict setObject:@"" forKey:@"area_code"];
    [deliveryCityDict setObject:@"" forKey:@"city_code"];
    [deliveryCityDict setObject:[addrDict objectForKey:province] forKey:@"province_code"];
    NSString * strDict = [self dictionaryToJson:deliveryCityDict];
    NSString * url;
    NSMutableDictionary * myDict = [NSMutableDictionary dictionary];
    if (_data == nil) {
//        [myDict setObject:@"" forKey:@"addId"];
        url = [HSGlobal AddAddressInfo];
    }else{
        [myDict setObject:_data.addId forKey:@"addId"];
        url = [HSGlobal updateAddressInfo];
    }
    [myDict setObject:_phoneLab.text forKey:@"tel"];
    [myDict setObject:_nameLab.text forKey:@"name"];
    [myDict setObject:strDict forKey:@"deliveryCity"];
    [myDict setObject:_detailAddrLab.text forKey:@"deliveryDetail"];
    if(_defaultSwitch.isOn){
//        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        [myDict setObject:@(true) forKey:@"orDefault"];
    }else{
        [myDict setObject:@(false) forKey:@"orDefault"];
    }
    
    [myDict setObject:_idNumber.text forKey:@"idCardNum"];
    
    AFHTTPRequestOperationManager * manager = [HSGlobal shareRequestManager];
    
    [manager POST:url parameters:myDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"message = %@",message);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        //    hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        if(200 == code){
            hud.labelText = @"保存成功";
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            hud.labelText = @"保存失败";
            [hud hide:YES afterDelay:1];
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HSGlobal printAlert:@"数据加载失败"];
        
    }];
 
    
}
-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
//验证手机号
- (BOOL)isPhone
{
    //校验空
    if([NSString isBlankString:GGTRIM(_phoneLab.text)]){
        [HSGlobal printAlert:@"请输入手机号码"];
        return false;
    }
    //校验密码长度
    if(GGTRIM(_phoneLab.text).length !=11){
        [HSGlobal printAlert:@"请输入11位手机号码"];
        return false;
    }
    
    NSString * regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:GGTRIM(_phoneLab.text)]){
        [HSGlobal printAlert:@"请输入正确手机号码"];
        return false;
    }
    return 1;
}

- (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
 
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value  substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

- (void)setPageData:(AddressData *)data{
    
    _nameLab.text = data.name;
    _phoneLab.text = data.tel;
    _areaAddrLab.text = data.deliveryCity;
     NSArray * strArr = [ _areaAddrLab.text componentsSeparatedByString:@" "];// 以空格分割成数组，依次读取数组中的元素
    if(strArr.count == 3){
        province = strArr[0];
        city = strArr[1];
        town = strArr[2];
    }
    _detailAddrLab.text = data.deliveryDetail;
    _idNumber.text = data.idCardNum;
    [_defaultSwitch setOn: data.orDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
