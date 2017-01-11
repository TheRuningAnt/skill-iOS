//
//  DailyModel.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/28.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "DailyModel.h"

@implementation DailyModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        _dailyId = [value integerValue];
    }
}

@end
