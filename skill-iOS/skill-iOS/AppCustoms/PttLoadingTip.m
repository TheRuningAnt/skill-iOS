//
//  PttLoadingTip.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/28.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PttLoadingTip.h"

@implementation PttLoadingTip

static UIActivityIndicatorView *indectView = nil;

/**
 开始加载动画
 */
+(void)startLoading{
    
    if (!indectView) {
        indectView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kWindowWidth/2, kWindowHeight/2, 100, 100)];
        indectView.center =  [UIApplication sharedApplication].keyWindow.center;
        indectView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indectView.color = [UIColor grayColor];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:indectView];
    [indectView startAnimating];
}

/**
 停止并移除动画
 */
+(void)stopLoading{
    
    [indectView stopAnimating];
    if (indectView.superview) {
        [indectView removeFromSuperview];
    }
}

/**
 *  设置圆圈的中心
 *
 */
+(void)setCenter:(CGPoint)center{
    
    if (!indectView) {
        indectView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kWindowWidth/2, kWindowHeight/2, 100, 100)];
        indectView.center =  [UIApplication sharedApplication].keyWindow.center;
        indectView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indectView.color = [UIColor grayColor];
    }
    
    indectView.frame = CGRectMake(center.x, center.y, 100, 100);
}

@end
