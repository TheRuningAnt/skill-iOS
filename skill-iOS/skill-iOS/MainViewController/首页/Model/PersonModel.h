//
//  PersonModel.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/28.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  个人信息model
 */
@interface PersonModel : NSObject
/**
*  用户ID (id)
*/
@property (nonatomic,assign) NSInteger userId;
/**
 *  昵称
 */
@property (nonatomic,strong) NSString *nick;
/**
 *  qq
 */
@property (nonatomic,strong) NSString *qq;
/**
 *  头像
 */
@property (nonatomic,strong) NSString *thumb;
/**
 *  个人签名
 */
@property (nonatomic,strong) NSString *sign;
/**
 *  日报数
 */
@property (nonatomic,assign) NSInteger dailyCount;
/**
 *  类型	none 无班级 online 线上散修班 outside 线上外门班offline线下内门班
 */
@property (nonatomic,strong) NSString *type;
/**
 *  班级id  cid
 */
@property (nonatomic,assign) NSInteger cid;
/**
 *  未读消息数
 */
@property (nonatomic,assign) NSInteger isLook;

//接口文档未定义但是接口返回的内容
/**
 *  手机号
 */
@property (nonatomic,strong) NSString *mobile;
/**
 *  誓言
 */
@property (nonatomic,strong) NSString *swear;
/**
 *  学号
 */
@property (nonatomic,assign) NSInteger studyNumber;
@end
