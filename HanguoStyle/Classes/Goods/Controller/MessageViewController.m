//
//  MessageViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/4/6.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MessageViewController
@synthesize tableView = tableView_;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = GGColor(240, 240, 240);
    [self createSettingView];
}
-(void)createSettingView{
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT) style:UITableViewStylePlain];
    //    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.bounces = YES;
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.showsHorizontalScrollIndicator = NO;
    tableView_.showsVerticalScrollIndicator = NO;
    tableView_.bounces = NO;
    [self.view addSubview:tableView_];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"messageCell";
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell setData:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138/2;
}
@end
