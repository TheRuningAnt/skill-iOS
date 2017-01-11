//
//  JobModel.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/24.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  职业详情model
 */
@interface JobModel : NSObject
/**
 *  职业ID id = jobId
 */
@property (nonatomic,assign) NSInteger jobId;

/**
 *  职业名称
 */
@property (nonatomic,strong) NSString *name;

/**
 *  职业图片
 */
@property (nonatomic,strong) NSString *img;

/**
 *  简介
 */
@property (nonatomic,strong) NSString *brief;

/**
 *  职业描述 description = jobDescription
 */
@property (nonatomic,strong) NSString *jobDescription;

/**
 *  薪水范围
 */
@property (nonatomic,strong) NSString *salary;

/**
 *  职业难度
 */
@property (nonatomic,strong) NSString *difficult;

/**
 *  职业门槛
 */
@property (nonatomic,strong) NSString *threshold;

/**
 *  公司需求
 */
@property (nonatomic,assign) NSInteger company;

/**
 *  入门基础
 */
@property (nonatomic,strong) NSString *basis;

/**
 *  职业所属类型
 */
@property (nonatomic,strong) NSString *type;

/**
 *  职业成长周期
 */
@property (nonatomic,strong) NSString *cycle;

/**
 *  线上职业期数
 */
@property (nonatomic,strong) NSString *onlineGradeCount;

/**
 *  线下职业期数
 */
@property (nonatomic,strong) NSString *offlineGradeCount;

/**
 *  班级数量
 */
@property (nonatomic,strong) NSString *classCount;

/**
 *  线上班级数
 */
@property (nonatomic,strong) NSString *onlineClassCount;

/**
 *  线下班级数
 */
@property (nonatomic,strong) NSString *offlineClassCount;

/**
 *  外门弟子人数
 */
@property (nonatomic,strong) NSString *onlineUserCount;

/**
 *  内门弟子人数
 */
@property (nonatomic,strong) NSString *offlineUserCount;

/**
 *  首席弟子人数
 */
@property (nonatomic,strong) NSString *coreUserCount;

/**
 *  模块详情
 */
@property (nonatomic,strong) NSString *modules;

@end
