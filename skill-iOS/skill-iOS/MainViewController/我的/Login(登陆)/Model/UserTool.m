//
//  UserTool.m
//  MakeLearn-iOS
//
//  Created by 花见花开你帅妹 on 16/7/18.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "UserTool.h"
#import "UserModel.h"

@implementation UserTool
/**
 *  作为单例来进行处理
   如果不做为单例处理的话,在某个界面进行保存的时候,如果该界面退出,那么数据保存肯定会保存不完完整  测试
 *
 */
static UserTool *userTool = nil;

+ (void)save:(UserModel *)userModel{
    
    if (!userTool) {
        userTool = [[UserTool alloc] init];
    }
    
    // 归档
    [NSKeyedArchiver archiveRootObject:userModel toFile:KAccountFilePath];
}

+ (UserModel *)userModel{
    
    if (!userTool) {
        userTool = [[UserTool alloc] init];
    }
    // 读取帐号
    UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:KAccountFilePath];

    return account;
}

//获取UID
+(NSInteger)userId{
    
    if (!userTool) {
        userTool = [[UserTool alloc] init];
    }

    UserModel *model = [self userModel];
    if (model) {
        return model.uid;
    }
    return 0;
}

//获取职业id
+(int32_t)userJobId{
    
    if (!userTool) {
        userTool = [[UserTool alloc] init];
    }
    
    UserModel *model = [self userModel];
    if (model) {
        return model.oid;
    }
    return -1;
}

//获取班级id
+(int32_t)userClassId{
    
    if (!userTool) {
        userTool = [[UserTool alloc] init];
    }
    
    UserModel *model = [self userModel];
    if (model) {
        return model.cid;
    }
    return -1;
}

/**
 *   保存并更新个人班级id 和职业id信息
 *
     更新完用户信息之后,需要进行特殊操作调用该方法
 
     @param block 执行的Blokc块
*/
+(void)updateUserOidAndCidWithBlcok:(void (^)())block{
    
    NSString *strOfUrl = [NSString stringWithFormat:@"%@/a/user/detail/full?uids=%lu",API_General,[UserTool userId]];
    
    NSDictionary * jobNameAndIdDic = [NSDictionary dictionaryWithObjectsAndKeys:@"CSS",@"1",@"JS",@"2",@"android",@"3",@"iOS",@"4",@"JAVA",@"5",@"OP",@"6",@"PM",@"7",@"UI",@"8",nil];
    
    [HttpService sendGetHttpRequestWithUrl:strOfUrl paraments:nil successBlock:^(NSDictionary *jsonDic) {
        
        UserModel *model = [UserTool userModel];
        
        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
            //获取用户cid和Uid
            NSDictionary *dataDic = [jsonDic objectForKey:@"relations"];
            if (dataDic) {
                
                NSDictionary *saveDataDic = (NSDictionary*)[[dataDic allValues] firstObject];
                if (saveDataDic) {
                    
                    int32_t cid = [[saveDataDic valueForKey:@"cid"] intValue];
                    if (cid > 0) {
                        model.cid = cid;
                    }else{
                        model.cid = -1;
                    }
                    
                    int32_t oid = [[saveDataDic valueForKey:@"oid"] intValue];
                    if (oid > 0) {
                        model.oid = oid;
                    }else{
                        model.oid = -1;
                    }
                    
                    //获取誓言 和签名
                    [model setValuesForKeysWithDictionary:saveDataDic];
                }else{
                    model.cid = -1;
                    model.oid = -1;
                }
            }

            //获取用户其他个人信息
            NSArray *users = [jsonDic objectForKey:@"users"];
            if (users && users.count != 0) {
                
                NSDictionary *userDic = users[0];
                if (userDic && [userDic isKindOfClass:[NSDictionary class]]) {
                    
                    [model setValuesForKeysWithDictionary:userDic];
                }
            }
            
            //获取职业名称
            if (model.oid) {
                
                model.jobName = [jobNameAndIdDic objectForKey:[NSString stringWithFormat:@"%d",model.oid]];
            }

            //获取班号
            NSDictionary *classDic = [jsonDic objectForKey:@"classes"];
            if (classDic && classDic.count != 0) {
                
                NSDictionary *classValuedIC = [classDic objectForKey:[NSString stringWithFormat:@"%d",model.cid]];
                if (classValuedIC) {
                    
                    model.name = [[classValuedIC objectForKey:@"name"] integerValue];
                }
            }
            
            [UserTool save:model];
            
            if (block) {
                
                block();
            }
        }else{
            [ShowMessageTipUtil showTipLabelWithMessage:@"更新本地用户信息失败" spacingWithTop:kWindowHeight/2 stayTime:2];
        }
    }];
}

/**
 根据指定的Uid构建对用户信息的model
 
 @param uid uid
 @return UserModel
 */
+(void)getInfoWithUid:(NSInteger)uid action:(void (^)(UserModel *model))action{

    if (uid <= 0) {
        return ;
    }
    
    UserModel *model = [UserModel new];
    
    NSString *strOfUrl = [NSString stringWithFormat:@"%@/a/user/detail/full?uids=%lu",API_General,uid];
    
    NSDictionary * jobNameAndIdDic = [NSDictionary dictionaryWithObjectsAndKeys:@"CSS",@"1",@"JS",@"2",@"android",@"3",@"iOS",@"4",@"JAVA",@"5",@"OP",@"6",@"PM",@"7",@"UI",@"8",nil];
    
    [HttpService sendGetHttpRequestWithUrl:strOfUrl paraments:nil successBlock:^(NSDictionary *jsonDic) {
        
        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
            //获取用户cid和Uid
            NSDictionary *dataDic = [jsonDic objectForKey:@"relations"];
            if (dataDic) {
                
                NSDictionary *saveDataDic = (NSDictionary*)[[dataDic allValues] firstObject];
                if (saveDataDic) {
                    
                    int32_t cid = [[saveDataDic valueForKey:@"cid"] intValue];
                    if (cid > 0) {
                        model.cid = cid;
                    }else{
                        model.cid = -1;
                    }
                    
                    int32_t oid = [[saveDataDic valueForKey:@"oid"] intValue];
                    if (oid > 0) {
                        model.oid = oid;
                    }else{
                        model.oid = -1;
                    }
                    
                    //获取誓言 和签名
                    [model setValuesForKeysWithDictionary:saveDataDic];
                }else{
                    model.cid = -1;
                    model.oid = -1;
                }
            }
            
            //获取用户其他个人信息
            NSArray *users = [jsonDic objectForKey:@"users"];
            if (users && users.count != 0) {
                
                NSDictionary *userDic = users[0];
                if (userDic && [userDic isKindOfClass:[NSDictionary class]]) {
                    
                    [model setValuesForKeysWithDictionary:userDic];
                }
            }
            
            //获取职业名称
            if (model.oid) {
                
                model.jobName = [jobNameAndIdDic objectForKey:[NSString stringWithFormat:@"%d",model.oid]];
            }
            
            //获取班号
            NSDictionary *classDic = [jsonDic objectForKey:@"classes"];
            if (classDic && classDic.count != 0) {
                
                NSDictionary *classValuedIC = [classDic objectForKey:[NSString stringWithFormat:@"%d",model.cid]];
                if (classValuedIC) {
                    
                    model.name = [[classValuedIC objectForKey:@"name"] integerValue];
                }
            }
                    
            if (action) {
                
                action(model);
            }
        }else{
            [ShowMessageTipUtil showTipLabelWithMessage:@"更新本地用户信息失败" spacingWithTop:kWindowHeight/2 stayTime:2];
        }
    }];
}


//清除个人信息
+(void)clearUserInfo{
    
    UserModel *model = [UserTool userModel];
    
    model.uid = -1;
//不要清除本次登录的用户手机号
//    model.userNumber = nil;
    model.token = nil;
    model.cid = -1;
    model.oid = -1;
    model.name = -1;
    model.type = nil;
    model.nick = nil;
    model.swear = nil;
    model.jobName = nil;
    model.thumb = nil;
    
    [UserTool save:model];
}

@end
