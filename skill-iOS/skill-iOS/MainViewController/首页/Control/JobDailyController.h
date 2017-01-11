//
//  JobDailyController.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/29.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  职业日报列表 该controller也可用于展示个人日报模块  也可用于展示班级日报模块
   根据下面两个参数的值来判断应该显示哪个方面内容的日报,同时也要修改请求的参数
 */
@interface JobDailyController : UIViewController

//职业Id
@property (nonatomic,assign) int32_t oid;

//个人uid
@property (nonatomic,assign) int32_t uid;

//班级id
@property (nonatomic,assign) int32_t cid;

//是否访客模式
@property (nonatomic,assign) BOOL visitor;

@end
