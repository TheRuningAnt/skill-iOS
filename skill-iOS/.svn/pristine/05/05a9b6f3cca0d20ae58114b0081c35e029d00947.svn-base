
//
//  ClassListModel.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/27.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "ClassListModel.h"

@implementation ClassListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        _classId = [value integerValue];
    }
}

-(NSString *)description{
    
    return [NSString stringWithFormat:@"\n职业名:%@\n班级cid :%lu\n期数:%lu\n当前班级人数:%lu",self.jobName,self.classId,self.grade,self.total];
}

@end
