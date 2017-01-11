//
//  ResourceController.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/21.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "BasicViewController.h"


/**
    资源模块Controller
 */
@interface ResourceController : BasicViewController

/**
 *  逻辑:
 *   该页面有五个地方可以推出:根tabBar,职业详情页面,"我的"模块,查看他人信息模块  学习窍门模块
     需要根据不同的模块来显示不同的内容
      分辨依据: oid  uid visitor pushFromSkill(仅仅对返回按钮做特殊处理就可以)
     1.uid大于0  识别为从 "我的"  模块推出该页面
     2.uid 小于0
       (1).oid > 0  识别为从职业详情页面推出来的  显示需要显示的职业资源
       (2)oid == 0 pushFromSkill == no 识别为从根tabBar显示出来的  显示默认的内容
     3.oid == 0 pushFromSkill == no 识别为从根tabBar显示出来的  显示默认的内容
 
 */

@property (nonatomic,assign) int32_t oid;
/**
 用户id
 */
@property (nonatomic,assign) int32_t uid;

//是否访客模式
@property (nonatomic,assign) BOOL visitor;


//是否从学习窍门模块推出
@property (nonatomic,assign) BOOL pushFromSkill;

@end
