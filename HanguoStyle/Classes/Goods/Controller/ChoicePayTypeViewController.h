//
//  ChoicePayTypeViewController.h
//  NewZhuaMa
//
//  Created by 王小帅 on 15/10/28.
//  Copyright © 2015年 xll. All rights reserved.
//

#import "MyBaseViewController.h"

@interface ChoicePayTypeViewController : MyBaseViewController
@property (nonatomic,assign)float payMoney;
@property (nonatomic,assign)int isPass;
@property (nonatomic,copy)NSString *onePsw;
@property (nonatomic,copy)NSString *twoPsw;
@property (nonatomic,copy)NSString *threePsw;
-(void)loadDataOneWithPsw:(NSString *)str;
-(void)loadDataTwo;
-(void)loadDataThree;
@end
