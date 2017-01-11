//
//  DailyModel.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/28.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  日报model
 */
@interface DailyModel : NSObject
/**
 *  日报 (id字段)
 */
@property (nonatomic,assign) NSInteger dailyId;
/**
 *  班级id  cid
 */
@property (nonatomic,assign) NSInteger cid;
/**
   班级编号
 */
@property (nonatomic,assign) NSInteger name;
/**
 *  职业id
 */
@property (nonatomic,assign) NSInteger oid;
/**
 *  用户id
 */
@property (nonatomic,assign) NSInteger uid;
/**
 *  任务id数组
 */
//@property (nonatomic,strong) NSArray *tids;
/**
 *  日报标题
 */
@property (nonatomic,strong) NSString *title;
/**
 *  内容
 */
@property (nonatomic,strong) NSString *content;
/**
 *  更新时间
 */
@property (nonatomic,assign) NSInteger updateTime;
/**
 *  dailyTime
 */
@property (nonatomic,assign) NSInteger dailyTime;
/**
 *  创建时间
 */
@property (nonatomic,assign) NSInteger createAt;
/**
 *  更新时间
 */
@property (nonatomic,assign) NSInteger updateAt;
/**
 *  成果链接
 */
@property (nonatomic,strong) NSString *resultsUrl;
/**
 *  代码链接
 */
@property (nonatomic,strong) NSString *codeUrl;
/**
 *  回复数量
 */
@property (nonatomic,assign) NSInteger reply;
/**
 *  浏览数量
 */
@property (nonatomic,assign) NSInteger readCount;
/**
 *  最后一次回复时间
 */
@property (nonatomic,assign) NSInteger lastReply;

/**
 * 用户头像  在另一层解析
 */
@property (nonatomic,strong) NSString *thumb;
/**
 *  任务编号组成的数组  自定义 [NSString]
 */
@property (nonatomic,strong) NSMutableArray *taskNumbers;
/**
 * none 无班级 online 线上散修班 outside 线上外门班offline线下内门班
 */
@property (nonatomic,strong) NSString *type;
/**
   昵称
 */
@property (nonatomic,strong) NSString *nick;
@end
