//
//  PullRefreshView.h
//  SMCP
//
//  Created by dyf on 16/1/28.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PullRefreshNormal = 0,
    PullRefreshPulling,
    PullRefreshLoading,
    PullRefreshLoadFinish
}PullRefreshState;

@interface PullRefreshView : UIView

@property (nonatomic, assign) PullRefreshState state;

@end
