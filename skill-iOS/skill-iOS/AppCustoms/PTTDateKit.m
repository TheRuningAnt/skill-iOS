//
//  PTTDateKit.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/31.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTDateKit.h"

@implementation PTTDateKit

//精确到毫秒时间格式 YYYY-MM-dd hh:mm:ss:SSS

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点)  以毫秒为单位
 返回一个yyyy年MM月dd日 格式的字符串
 
 @param interval 时间戳
 @return yyyy年MM月dd日 格式的字符串
 */
+(NSString*)dateFrom1970WithTimeInterval:(NSInteger)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSString *str = [formatter stringFromDate:date];
    
    NSArray *dateArray = [str componentsSeparatedByString:@"-"];
    return  [NSString stringWithFormat:@"%@年%@月%@号",dateArray[0],dateArray[1],dateArray[2]];
}

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd HH:mm 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd HH:mm 格式的字符串
 */
+(NSString*)dateTimeFrom1970WithTimeInterval:(NSInteger)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}

/**
 给定一个时间戳 (距离时间纪元 1970年1月1日0点) 以毫秒为单位
 返回一个yyyy-MM-dd 格式的字符串
 
 @param interval 时间戳
 @return yyyy-MM-dd 格式的字符串
 */
+(NSString*)dateLineFormatFrom1970WithTimeInterval:(NSInteger)interval{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}

/**
 给定一个yyyy-MM-dd 格式的时间字符串  返回一个标准的时间戳
 
 @param timeString yyyy-MM-dd 格式的时间字符串
 @return 时间戳  以毫秒为单位
 */
+(NSInteger)timestampWithYearMonthDayStyle1String:(NSString*)timeString{
    
    if (!timeString) {
        
        return 0;
    }
    
    NSInteger interval = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateOfGet = [formatter dateFromString:timeString];
    if (dateOfGet) {
        
        interval = [dateOfGet timeIntervalSince1970];
    }
    
    return interval*1000;
}

/**
 给定一个yyyy年MM月dd日 格式的时间字符串  返回一个标准的时间戳
 
 @param timeString yyyy-MM-dd 格式的时间字符串
 @return 时间戳 以毫秒为单位
 */
+(NSInteger)timestampWithYearMonthDayStyle2String:(NSString*)timeString{
    
    if (!timeString) {
        
        return 0;
    }
    
    NSInteger interval = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSDate *dateOfGet = [formatter dateFromString:timeString];
    
    //补上8个小时的时差
    NSDate *dateOfSure = [dateOfGet dateByAddingTimeInterval:8*60*60];
    
    if (dateOfSure) {
        
        interval = [dateOfSure timeIntervalSince1970];
    }
    
    return interval*1000;
}

/**
 返回当前的时间,精确到毫秒  格式为 YYYY-MM-dd hh:mm:ss:SSS
 
 @return YYYY-MM-dd hh:mm:ss:SSS  格式的时间字符串
 
 */
+(NSString*)currentDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    
    NSDate *currentDate = [NSDate date];
    return [formatter stringFromDate:currentDate];
}

/**
 给定一个时间戳,返回和当前时间戳对应的年龄 (毫秒级的时间戳)
 
 @param timeStamp 时间戳
 @return 和当前时间对比的年龄
 */
+(NSInteger)getAgeOfTimeStamp:(int64_t)timeStamp{
    

    //判断是否是错误数据
    if (timeStamp < 0) {
        return 0;
    }
    
    NSInteger currentTimeStamp = [[[NSDate alloc] init] timeIntervalSince1970]*1000;
    
    if (currentTimeStamp < timeStamp) {
        
        return 0;
    }

    
    //获取用户的出生年月日格式字符串
    NSString *userAgeStr = [PTTDateKit dateFrom1970WithTimeInterval:timeStamp];
    NSInteger userYear = [[userAgeStr substringToIndex:4] integerValue];
    NSInteger userMonth = [[userAgeStr substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSUInteger userDay = [[userAgeStr substringWithRange:NSMakeRange(8, 2)] integerValue];
    
    //获取当前年月日格式字符串
    NSString *currentDateStr = [PTTDateKit currentDate];
    NSInteger currentYear = [[currentDateStr substringToIndex:4] integerValue];
    NSInteger currentMonth = [[currentDateStr substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSUInteger currentDay = [[currentDateStr substringWithRange:NSMakeRange(8, 2)] integerValue];
    
    //计算用户年龄
    int32_t age = (int32_t)(currentYear - userYear);
    if(userMonth >= currentMonth){
        
        if(userMonth > currentMonth){
            
            age --;
        }else{
            
            if(userDay > currentDay){
                
                age--;
            }
        }
    }
    
    if (age < 0) {
        
        return 0;
    }


    
    return age;
}

@end
