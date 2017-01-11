//
//  UserTool.h
//  MakeLearn-iOS
//
//  Created by 花见花开你帅妹 on 16/7/18.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface UserTool : NSObject

//存储用户
+ (void)save:(UserModel *)userModel;

//读取
+ (UserModel *)userModel;

//获取UID
+(NSInteger)userId;

//获取班级id
+(int32_t)userClassId;

//获取职业id
+(int32_t)userJobId;

//清除个人信息
+(void)clearUserInfo;

/**
   更新完用户信息之后,需要进行特殊操作调用该方法

 @param block 执行的Blokc块
 */
+(void)updateUserOidAndCidWithBlcok:(void (^)())block;

/**
 根据指定的Uid构建对应用户信息的model

 @param uid uid
 @param action 更新完成在该block块里可以获取到当前对应用户信息的model
 */
+(void)getInfoWithUid:(NSInteger)uid action:(void (^)(UserModel *model))action;

@end
