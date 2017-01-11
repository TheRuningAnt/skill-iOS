//
//  MessageModel.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/4.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        _messaegId = [value integerValue];
    }
}

@end
