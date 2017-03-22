//
//  PullRefreshView.m
//  SMCP
//
//  Created by dyf on 16/1/28.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import "PullRefreshView.h"

@interface PullRefreshView ()
{
    CALayer *_arrowImage;
    UILabel *_statusLab;
    UIActivityIndicatorView *_activityView;
}
@end

@implementation PullRefreshView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _arrowImage = [CALayer layer];
        _arrowImage.frame = CGRectMake(35.0f, (frame.size.height - 40) / 2.0, 16.0f, 40.0f);
        _arrowImage.contentsGravity = kCAGravityResizeAspect;
        _arrowImage.contents = (id)[UIImage imageNamed:@"blueArrow"].CGImage;
        _arrowImage.contentsScale = [[UIScreen mainScreen] scale];
        [[self layer] addSublayer:_arrowImage];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, (frame.size.height - 20) / 2.0, self.frame.size.width, 20.0f)];
        _statusLab.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLab.textColor = [UIColor colorWithRed:141/255.0 green:161/255.0 blue:175/255.0 alpha:1.0];
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLab.text = @"下拉刷新";
        [self addSubview:_statusLab];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(25.0f, (frame.size.height - 20) / 2.0, 20.0f, 20.0f);
        [self addSubview:_activityView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = _arrowImage.frame;
    rect.origin.x = self.frame.size.width / 2.0 - 70;
    _arrowImage.frame = rect;
    
    rect = _activityView.frame;
    rect.origin.x = self.frame.size.width / 2.0 - 75;
    _activityView.frame = rect;
}
- (void)setState:(PullRefreshState)state
{
    _state = state;
    if (state == PullRefreshNormal)
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.18];
        _arrowImage.transform = CATransform3DIdentity;
        [CATransaction commit];
        _statusLab.text = @"下拉刷新";
        _arrowImage.hidden = NO;
        [_activityView stopAnimating];
    }
    else if(state == PullRefreshPulling)
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.18];
        _arrowImage.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
        _statusLab.text = @"释放开始刷新";
        _arrowImage.hidden = NO;
        [_activityView stopAnimating];
    }
    else if(state == PullRefreshLoading)
    {
        _statusLab.text = @"加载中...";        
        [_activityView startAnimating];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _arrowImage.hidden = YES;
        [CATransaction commit];
    }
    else if(state == PullRefreshLoadFinish)
    {
        _statusLab.text = @"刷新成功！";
        [_activityView stopAnimating];
        _arrowImage.hidden = YES;
    }
}

@end
