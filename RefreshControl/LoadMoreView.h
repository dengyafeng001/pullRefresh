//
//  LoadMoreView.h
//  SMCP
//
//  Created by dyf on 16/1/30.
//  Copyright © 2016年 wisorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LoadMoreNormal = 0,
    LoadMoreLoading
}LoadMoreState;

@interface LoadMoreView : UIView
@property (nonatomic, assign) LoadMoreState state;
@end
