# 功能介绍
扩展UITableView使其具体下拉刷新和上拉获取更多的功能，属性在程序运行过程中可根据情况动态改变
# 支持Cocoapods
pod 'pullRefresh', '~> 1.0.4'
# 如何使用
    //1.在开启下拉或者上拉前调用
    [self.tableView setup];
    
    //2.开启下拉或者上拉
    [self.tableView setPullDownEnable:YES];
    [self.tableView setLoadMoreEnable:YES];
    
    //3.设置回调函数
    __weak typeof(self)weakSelf = self;
    [self.tableView setLoadingBlock:^(BOOL pullDown) {
        //请求数据  
        [weakSelf requestData:!pullDown];
    }];
    //4.在请求结束后结束动画
    [self.tableView reloadData];
