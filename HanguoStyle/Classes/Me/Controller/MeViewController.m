//
//  MeViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "MeViewController.h"
#import "MeCell.h"
#import "MeData.h"
#import "AddressViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.data = [NSMutableArray array];
    
    MeData * meData = [[MeData alloc]init];
    meData.title = @"收货地址管理";
    [_data addObject:meData];
    
    MeData * meData1 = [[MeData alloc]init];
    meData1.title = @"关于我们";
    [_data addObject:meData1];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeCell *cell  = [MeCell subjectCell];
    cell.data = self.data[indexPath.section];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor =  GGColor(240, 240, 240);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到商品展示页面
    [self pushGoodShowView:indexPath.section];
}
-(void)pushGoodShowView :(NSInteger)index{
    if(index == 0){
        AddressViewController * adViewController = [[AddressViewController alloc]init];
        [self.navigationController pushViewController:adViewController animated:YES];
    }
   
}


@end
