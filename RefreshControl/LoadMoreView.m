//
//  LoadMoreView.m
//  SMCP
//
//  Created by dyf on 16/1/30.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import "LoadMoreView.h"

@interface LoadMoreView ()
{
    UILabel *_statusLab;
    UIActivityIndicatorView *_activityView;
}
@end
@implementation LoadMoreView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, (frame.size.height - 20) / 2.0, self.frame.size.width, 20.0f)];
        _statusLab.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLab.textColor = [UIColor colorWithRed:141/255.0 green:161/255.0 blue:175/255.0 alpha:1.0];
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLab.text = @"下拉刷新";
        [self addSubview:_statusLab];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(frame.size.width / 2.0 - 60, (frame.size.height - 20) / 2.0, 20.0f, 20.0f);
        [self addSubview:_activityView];
    }
    return self;
}
- (void)setState:(LoadMoreState)state
{
    _state = state;
    if (state == LoadMoreNormal)
    {
        _statusLab.text = @"加载更多";
        [_activityView stopAnimating];
    }
    else if(state == LoadMoreLoading)
    {
        _statusLab.text = @"加载中...";
        [_activityView startAnimating];
    }
}

@end
