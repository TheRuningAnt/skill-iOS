//
//  PTTDataKit.m
//  Test_1019
//
//  Created by 赵广亮 on 2016/10/19.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTT_Data_Kit.h"

@implementation PTT_Data_Kit

/**
 *  给定一个Json格式数据,返回一个初始化好的字典
 *
 *  @param json 数据 (字典/数据块/字符串类型)
 *
 *  @return NSDictionary
 */
+(NSDictionary*)dicionaryWihJSON:(id)json{
    
    if (json == nil || json == (id)kCFNull)return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    }else if([json isKindOfClass:[NSData class]]){
        jsonData = json;
    }else if([json isKindOfClass:[NSString class]]){
        jsonData = [(NSString*)json dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        if (![dic isKindOfClass:[NSDictionary class]])dic = nil;
    }
    return dic;
}

@end
