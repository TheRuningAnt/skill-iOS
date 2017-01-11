//
//  ClClassDetailController.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/27.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassListModel.h"

/**
 *  班级详情Controller
 */
@interface ClassDetailController : UIViewController

@property (nonatomic,assign) NSInteger cid;
@property (nonatomic,strong) NSString *jobName;


/**
   是否需要默认选中班级同门列表
 */
@property (nonatomic,assign) BOOL selectMatesV;
@end

