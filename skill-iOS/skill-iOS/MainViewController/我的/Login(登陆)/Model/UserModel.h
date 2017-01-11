//
//  UserModel.h
//  MakeLearn-iOS
//
//  Created by 花见花开你帅妹 on 16/7/18.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

/**
 *  UId  没有用户登录的时候置为 -1  以此来判断是否有用户登录
 */
@property (nonatomic, assign) int32_t uid;
/**
 *  手机号   没有用户登录的时候置为 nil
 */
@property (nonatomic, strong) NSString *userNumber;
/**
 *  token 没有用户登录的时候置为 nil
 */
@property (nonatomic, strong) NSString *token;
/**
 *  cid 班级Id  没有用户登录的时候置为-1
 */
@property (nonatomic,assign) int32_t cid;
/**
 *  oid 职业id  没有用户登录的时候置为 -1
 */
@property (nonatomic,assign) int32_t oid;
/**
 * 班号
 */
@property (nonatomic,assign) NSInteger name;
/**
 * none 无班级 online 线上散修班 outside 线上外门班offline线下内门班
 */
@property (nonatomic,strong) NSString *type;
/**
 *  昵称
 */
@property (nonatomic,strong) NSString *nick;
/**
 *  誓言
 */
@property (nonatomic,strong) NSString *swear;
/**
 * 职位名称 自定义字段
 */
@property (nonatomic,strong) NSString *jobName;
/**
 *  用户头像
 */
@property (nonatomic,strong) NSString *thumb;
/**
   用户个人签名
 */
@property (nonatomic,strong) NSString *sign;
/**
  是否第一次登录
 */
@property (nonatomic,assign) BOOL firstLogin;

/**
   省份代码
 */
@property (nonatomic,assign) NSInteger province;
/**
   城市代码
 */
@property (nonatomic,assign) NSInteger city;
/**
   和html互调特殊字段
 */
@property (nonatomic,assign) NSInteger htmlTag;


@end
