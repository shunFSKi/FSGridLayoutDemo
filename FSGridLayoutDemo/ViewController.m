//
//  ViewController.m
//  FSGridLayoutDemo
//
//  Created by 冯顺 on 2017/6/10.
//  Copyright © 2017年 冯顺. All rights reserved.
//

#import "ViewController.h"
#import "FSGridLayoutView.h"
#import <Masonry.h>
#import "FSTableViewCell.h"
#import <SVPullToRefresh.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *jsonStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertWithTop];
    }];
    [self insertWithTop];
    
}

- (void)insertWithTop
{
    [self.tableView.pullToRefreshView setTitle:@"下拉更改数据" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"更换数据中..." forState:SVPullToRefreshStateLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.pullToRefreshView stopAnimating];
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%d",arc4random()%4] ofType:@"txt"];
        self.jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self.tableView reloadData];
    });
    
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FSGridLayoutView GridViewHeightWithJsonStr:self.jsonStr];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.jsonStr = self.jsonStr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


@end
