//
//  ClassListModel.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/27.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  班级列表使用的Model
 */
@interface ClassListModel : NSObject

/**
 *  班级 cid
 */
@property (nonatomic,assign) NSInteger classId;
/**
 *  班号
 */
@property (nonatomic,assign) NSInteger name;
/**
 *  期数 第几期
 */
@property (nonatomic,assign) NSInteger grade;
/**
 *  当前班级人数
 */
@property (nonatomic,assign) NSInteger total;
/**
 *  班级的截图链接  现在还没有 暂时为空
 */
@property (nonatomic,strong) NSString *classImg;
/**
 *  职业名称  从接口里获取不到,需要页面赋值
 */
@property (nonatomic,strong) NSString *jobName;

@end
