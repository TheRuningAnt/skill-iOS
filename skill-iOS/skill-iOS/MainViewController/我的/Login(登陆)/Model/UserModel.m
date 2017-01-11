//
//  UserModel.m
//  MakeLearn-iOS
//
//  Created by 花见花开你帅妹 on 16/7/18.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

MJCodingImplementation

static UserModel *userModelManager = nil;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(NSString *)description{
    
    return  [NSString stringWithFormat:@"uid = %d  number = %@   token = %@ cid = %d oid = %d",_uid,_userNumber,_token,_cid,_oid];
}

@end
