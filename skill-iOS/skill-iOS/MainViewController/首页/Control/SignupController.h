//
//  signupController.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/26.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassDetailModel.h"
/**
 *  报名Controller
 */
@interface SignupController : UIViewController

//职业名称
@property (nonatomic,strong) NSString *jobName;

//班级model
@property (nonatomic,strong) ClassDetailModel *model;

@end
