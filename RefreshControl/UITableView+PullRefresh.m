//
//  UITableView+PullRefresh.m
//  SMCP
//
//  Created by dyf on 16/1/28.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import "UITableView+PullRefresh.h"
#import <objc/runtime.h>
#import "RefreshControl.h"


static char scrollListenKey;

void df_swizzling_method(Class class,const char *orignSelName,  const char *newSelName)
{
    SEL orignSelector = sel_registerName(orignSelName);
    SEL newSelector = sel_registerName(newSelName);
    Method originM = class_getInstanceMethod(class, orignSelector);
    Method newM = class_getInstanceMethod(class, newSelector);
    if (class_addMethod(class, orignSelector, method_getImplementation(newM), method_getTypeEncoding(newM)))
    {
        class_replaceMethod(class, newSelector, method_getImplementation(originM), method_getTypeEncoding(originM));
    }
    else
    {
        method_exchangeImplementations(originM, newM);
    }
}

@implementation UITableView (PullRefresh)
+ (void)load
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        //交换reloadData方法，方便结束下拉刷新动画
        df_swizzling_method(self.class,"reloadData", "df_reloadData");
        
        //交换dealloc方法，方便取消kvo监听
        df_swizzling_method(self.class, "dealloc", "df_dealloc");
    });
}

- (void)df_reloadData
{
    //调用tableview的reloadData
    [self df_reloadData];
    
    //结束下拉刷新
    [[self scrollViewListen] stopPullRefresh];
}
- (void)df_dealloc
{
    //结束kvo监听
    [[self scrollViewListen] stopListenScrollView:self];
    //调用dealloc
    [self df_dealloc];
}

- (RefreshControl *)scrollViewListen
{
    RefreshControl *ret = objc_getAssociatedObject(self, &scrollListenKey);
    return ret;
}

- (void)setup
{
    RefreshControl *ret = objc_getAssociatedObject(self, &scrollListenKey);
    if (!ret)
    {
        ret = [[RefreshControl alloc] init];
        [ret listenScrollView:self];
        objc_setAssociatedObject(self, &scrollListenKey, ret, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setPullDownEnable:(BOOL)enable
{
    [self scrollViewListen].pullDownEnabled = enable;
}
- (void)setLoadMoreEnable:(BOOL)enable
{
    [self scrollViewListen].loadMoreEnabled = enable;
}

- (void)setLoadingBlock:(StartLoading)block
{
    [self scrollViewListen].startLoading = block;
}
- (void)startPullDownAnimate
{
    [[self scrollViewListen] startPullRefresh];
}
@end



