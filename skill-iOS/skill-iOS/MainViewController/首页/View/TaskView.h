//
//  TaskView.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/25.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  点击任务上的指示按钮 弹出来的任务详情View
 */
@interface TaskView : UIView

typedef enum{
    
    K_JOB_DETAIL_VIEW = 0,
    K_TASK_DETAIL_VIEW
}Current_View;

/**
 *  传入一个任务详情Model 初始化自身界面
    步骤描述 + 时间
 */
@property (nonatomic,strong)NSArray *contentArray;
//为特殊界面设置的设置背景颜色 需要在给contextArray赋值之前赋值
@property (nonatomic,strong) UIColor *titleBackgroundColor;
//当前使用自身的View
@property (nonatomic,assign) Current_View currentView;

@end
