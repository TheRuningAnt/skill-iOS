//
//  LibraryModel.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/1.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "LibraryModel.h"

@implementation LibraryModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        _libraryId = [value integerValue];
    }
    
}

@end
