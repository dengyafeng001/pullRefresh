//
//  RefreshControl.h
//  SMCP
//
//  Created by dyf on 16/2/1.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableView+PullRefresh.h"

@interface RefreshControl : NSObject
@property (nonatomic, assign) BOOL pullDownEnabled;
@property (nonatomic, assign) BOOL loadMoreEnabled;
@property (nonatomic, copy) StartLoading startLoading;

- (void)listenScrollView:(UIScrollView *)scrollView;
- (void)stopListenScrollView:(UIScrollView *)scrollView;
- (void)startPullRefresh;
- (void)stopPullRefresh;
@end
