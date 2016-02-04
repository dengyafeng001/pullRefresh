//
//  RefreshControl.m
//  SMCP
//
//  Created by dyf on 16/2/1.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import "RefreshControl.h"
#import "PullRefreshView.h"
#import "LoadMoreView.h"

@interface RefreshControl ()
{
    __weak UIScrollView *listenScrollView;
    PullRefreshView *viewPullDown;
    LoadMoreView *loadMore;
}
@end

@implementation RefreshControl

- (void)dealloc
{
    NSLog(@"RefreshControl dealloc");
}
- (id)init
{
    self = [super init];
    return self;
}
- (void)listenScrollView:(UIScrollView *)scrollView
{
    listenScrollView = scrollView;
    [listenScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [listenScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)stopListenScrollView:(UIScrollView *)scrollView
{
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [scrollView removeObserver:self forKeyPath:@"contentSize"];
    
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollViewDidScroll:listenScrollView];
    }
    else if([keyPath isEqualToString:@"contentSize"])
    {
        [self refreshLoadMore];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offy = scrollView.contentOffset.y;
    if (_pullDownEnabled && offy < 0 - scrollView.contentInset.top)
    {
        if (scrollView.isDragging)
        {
            if (viewPullDown.state != PullRefreshLoading)
            {
                if (offy < -65 - scrollView.contentInset.top)
                {
                    [viewPullDown setState:PullRefreshPulling];
                }
                else
                {
                    [viewPullDown setState:PullRefreshNormal];
                }
            }
        }
        else
        {
            if (viewPullDown.state == PullRefreshPulling)
            {
                [self startPullRefresh];
            }
        }
    }
    else if(_loadMoreEnabled && offy > 0)
    {
        CGFloat contentSizeH = listenScrollView.contentSize.height;
        contentSizeH = MAX(contentSizeH, listenScrollView.frame.size.height);
        CGFloat arrowY = listenScrollView.contentOffset.y - (contentSizeH - listenScrollView.frame.size.height);
        if (arrowY < 30)
        {
            if (loadMore.state != LoadMoreNormal)
            {
                [loadMore setState:LoadMoreNormal];
                //取消获取更多
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(willStartLoadMore) object:nil];
            }
        }
        else
        {
            if (loadMore.state != LoadMoreLoading)
            {
                [loadMore setState:LoadMoreLoading];
                //开始获取更多，延时执行让用户可以取消
                [self performSelector:@selector(willStartLoadMore) withObject:nil afterDelay:0.7];
            }
        }
    }
}

- (void)setPullDownEnabled:(BOOL)pullDownEnabled
{
    _pullDownEnabled = pullDownEnabled;
    if (pullDownEnabled)
    {
        if (!viewPullDown)
        {
            CGRect rviewpulldown = CGRectMake(0, -60, listenScrollView.frame.size.width, 60);
            viewPullDown = [[PullRefreshView alloc] initWithFrame:rviewpulldown];
            viewPullDown.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [listenScrollView addSubview:viewPullDown];
        }
    }
    else
    {
        [viewPullDown removeFromSuperview];
        viewPullDown = nil;
    }
}
- (void)setLoadMoreEnabled:(BOOL)loadMoreEnabled
{
    _loadMoreEnabled = loadMoreEnabled;
    if (loadMoreEnabled)
    {
        CGFloat contentSizeH = listenScrollView.contentSize.height;
        contentSizeH = MAX(contentSizeH, listenScrollView.frame.size.height);
        CGRect rect = CGRectMake(0, contentSizeH, listenScrollView.frame.size.width, 40);
        if (!loadMore)
        {
            loadMore = [[LoadMoreView alloc] initWithFrame:rect];
            loadMore.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [listenScrollView addSubview:loadMore];
        }
        UIEdgeInsets edge = listenScrollView.contentInset;
        edge.bottom = 40;
        listenScrollView.contentInset = edge;
        
        [loadMore setFrame:rect];
    }
    else
    {
        [loadMore removeFromSuperview];
        loadMore = nil;
        
        UIEdgeInsets edge = listenScrollView.contentInset;
        edge.bottom = 0;
        listenScrollView.contentInset = edge;
    }
}
- (void)startPullRefresh
{
    if (viewPullDown.state == PullRefreshLoading)
    {
        return;
    }
    //开始刷新
    [viewPullDown setState:PullRefreshLoading];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIEdgeInsets edge = listenScrollView.contentInset;
    edge.top += 60;
    listenScrollView.contentInset = edge;
    [UIView commitAnimations];
    
    if (_startLoading)
    {
        _startLoading(YES);
    }
}
- (void)stopPullRefresh
{
    if (viewPullDown.state == PullRefreshLoading)
    {
        [viewPullDown setState:PullRefreshLoadFinish];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            UIEdgeInsets edge = listenScrollView.contentInset;
            edge.top -= 60;
            listenScrollView.contentInset = edge;
            [UIView commitAnimations];
        });
    }
}

- (void)refreshLoadMore
{
    if (_loadMoreEnabled)
    {
        //确保能滚动
        CGFloat contentSizeH = listenScrollView.contentSize.height;
        if (contentSizeH <= listenScrollView.frame.size.height)
        {
            listenScrollView.contentSize = CGSizeMake(listenScrollView.frame.size.width, listenScrollView.frame.size.height + 1);
        }
        
        UIEdgeInsets edge = listenScrollView.contentInset;
        edge.bottom = 40;
        listenScrollView.contentInset = edge;
        
        contentSizeH = MAX(contentSizeH, listenScrollView.frame.size.height);
        if (loadMore.frame.origin.y != contentSizeH)
        {
            CGRect rect = CGRectMake(0, contentSizeH, listenScrollView.frame.size.width, 40);
            [loadMore setFrame:rect];
            
            [loadMore setState:LoadMoreNormal];
        }
    }
}
- (void)willStartLoadMore
{
    if (_startLoading)
    {
        _startLoading(NO);
    }
}

@end
