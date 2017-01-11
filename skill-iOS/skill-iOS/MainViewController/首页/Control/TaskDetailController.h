//
//  TaskDetailController.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/25.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailModel.h"
/**
 *  任务详情Controller
 */

@interface TaskDetailController : UIViewController

/**
   任务详情的model,该值可有可无,有的话将不再进行网络请求,没有的话将会根据taskId去请求新的数据
 */
@property (nonatomic,strong) TaskDetailModel *model;
/**
  必传  任务id
 */
@property (nonatomic,assign) NSInteger taskId;
/**
  是否模态返回   web页面需要展示任务,会调用该页面,但是web页面不可以有导航栏,所以必须要模态回去
 */
@property (nonatomic,assign) BOOL weatherPresent;
@end
