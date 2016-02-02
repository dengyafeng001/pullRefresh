//
//  ViewController.m
//  PullRefresh
//
//  Created by dyf on 16/2/1.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+PullRefresh.h"

@interface ViewController ()
{
    NSMutableArray *dataList;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.在开启下拉或者上拉前调用
    [self.tableView setup];
    
    //2.开启下拉刷新
    [self.tableView setPullDownEnable:YES];
    
    //3.开启上拉获取更多
    [self.tableView setLoadMoreEnable:YES];
    
    //4.设置回调函数
    __weak typeof(self)weakSelf = self;
    [self.tableView setLoadingBlock:^(BOOL pullDown) {
        
        [weakSelf requestData:!pullDown];
    }];
    
    dataList = [NSMutableArray array];
    [self.tableView performSelector:@selector(startPullDownAnimate) withObject:nil afterDelay:0.1];
}
- (void)requestData:(BOOL)isLoadMore
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!isLoadMore)
        {
            [dataList removeAllObjects];
        }
        for (int i = 0 ; i < 10; i++)
        {
            [dataList addObject:[NSString stringWithFormat:@"第%d行",i+ 1]];
        }
        
        if (dataList.count >= 40) {
            [self.tableView setLoadMoreEnable:NO];
        }
        else{
            [self.tableView setLoadMoreEnable:YES];
        }
        //5.结束动画
        [self.tableView reloadData];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = dataList[indexPath.row];
    return cell;
}
@end
