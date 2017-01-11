//
//  HttpService.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/23.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpService : NSObject

/**
 *  发送Get请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;


/**
 *  发送基本Get请求 将返回数据解析后直接返回
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendBaseGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;
/**
 *  发送Get请求  带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  @param failBlock    失败回调
 */
+(void)sendGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock;

/**
 *  发送Post请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 *  发送Post请求 带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  @param failBlock    失败回调
 */
+(void)sendPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock;

/**
 发送Delete请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

/**
 发送Delete请求 带失败block回调
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 @param failblock   请求失败回调
 */
+(void)sendDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock;

/**
 发送put请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendPutHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock;


/**
 发送上传图片请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param image 需要上传的图片
 @param successBlock 请求成功的回调
 */
+(void)sendPostImageHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic image:(UIImage*)image successBlock:(void(^)(NSDictionary* jsonDic))successBlock;

@end
