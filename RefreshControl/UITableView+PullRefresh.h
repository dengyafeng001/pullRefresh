//
//  UITableView+PullRefresh.h
//  SMCP
//
//  Created by dyf on 16/1/28.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollViewListen;

typedef void(^StartLoading)(BOOL pullDown);

@interface UITableView (PullRefresh)
/*初始化方法，必须调用*/
- (void)setup;

/*是否开启下拉刷新*/
- (void)setPullDownEnable:(BOOL)enable;

/*是否开启获取更多*/
- (void)setLoadMoreEnable:(BOOL)enable;

/*下拉或上拉执行的block*/
- (void)setLoadingBlock:(StartLoading)block;

/*主动开始下拉刷新的动画*/
- (void)startPullDownAnimate;

/*调用tableView的reloadData方法会结束下拉和上拉动画*/
@end
