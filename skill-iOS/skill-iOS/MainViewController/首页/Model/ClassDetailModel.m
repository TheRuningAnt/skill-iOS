//
//  ClassDetailModel.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/27.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "ClassDetailModel.h"

@implementation ClassDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        _classId = [value intValue];
    }
}

@end
