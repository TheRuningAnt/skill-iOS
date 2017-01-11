//
//  PTTDateKit.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/31.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
   时间戳和时间字符串转换工具
 */
@interface PTTDateKit : NSObject


/**
  给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
  返回一个yyyy年MM月dd日 格式的字符串

 @param interval 时间戳
 @return yyyy年MM月dd日 格式的字符串
 */
+(NSString*)dateFrom1970WithTimeInterval:(NSInteger)interval;

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd 格式的字符串
 */
+(NSString*)dateLineFormatFrom1970WithTimeInterval:(NSInteger)interval;


/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd HH:mm 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd HH:mm 格式的字符串
 */
+(NSString*)dateTimeFrom1970WithTimeInterval:(NSInteger)interval;



/**
 给定一个yyyy-MM-dd 格式的时间字符串  返回一个标准的时间戳

 @param timeString yyyy-MM-dd 格式的时间字符串
 @return 时间戳 以毫秒为单位
 */
+(NSInteger)timestampWithYearMonthDayStyle1String:(NSString*)timeString;

/**
 给定一个yyyy年MM月dd日 格式的时间字符串  返回一个标准的时间戳
 
 @param timeString yyyy-MM-dd 格式的时间字符串
 @return 时间戳 以毫秒为单位
 */
+(NSInteger)timestampWithYearMonthDayStyle2String:(NSString*)timeString;


/**
 返回当前的时间,精确到毫秒  格式为 YYYY-MM-dd hh:mm:ss:SSS

 @return YYYY-MM-dd hh:mm:ss:SSS  格式的时间字符串

 */
+(NSString*)currentDate;


/**
  给定一个时间戳,返回和当前时间戳对应的年龄 (毫秒级的时间戳)

 @param timeStamp 时间戳
 @return 和当前时间对比的年龄
 */
+(NSInteger)getAgeOfTimeStamp:(int64_t)timeStamp;

@end
