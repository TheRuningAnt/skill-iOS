//
//  PTTDataKit.h
//  Test_1019
//
//  Created by 赵广亮 on 2016/10/19.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTT_Data_Kit : NSObject

/**
 *  给定一个Json格式数据,返回一个初始化好的字典
 *
 *  @param json 数据 (字典/数据块/字符串类型)
 *
 *  @return NSDictionary
 */
+(NSDictionary*)dicionaryWihJSON:(id)json;


@end
