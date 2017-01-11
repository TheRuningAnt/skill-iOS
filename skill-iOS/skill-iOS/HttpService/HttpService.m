//
//  HttpService.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/23.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "HttpService.h"

@implementation HttpService

/**
 *  发送Get请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];

#pragma <#arguments#>
    
    [manger GET:requestUrl parameters:paramentsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                successBlock([dict objectForKey:@"data"]);
            }
        }else{
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求异常  %@",error);
    }];
}

/**
 *  发送基本Get请求 将返回数据解析后直接返回
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendBaseGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger GET:requestUrl parameters:paramentsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
                successBlock(dict);
            
        }else{
            
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求异常  %@",error);
    }];
}


/**
 *  发送Post请求
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 */
+(void)sendPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manger POST:requestUrl parameters:paramentsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]] && dict.count != 0) {
            
            successBlock(dict);
        }else{
            
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常"];
    }];
}

/**
 *  发送Post请求 带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  #param failBlock
 */
+(void)sendPostHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger POST:requestUrl parameters:paramentsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]] && dict.count != 0) {
            successBlock(dict);
        }else{
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
        }
        
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock();
        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常"];
    }];
}

/**
 *  发送Get请求  带失败回调
 *
 *  @param requestUrl   请求链接
 *  @param paramentsDic 请求参数
 *  @param successBlock 请求成功处理Block块
 *  @param failBlock    失败回调
 */
+(void)sendGetHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger GET:requestUrl parameters:paramentsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                
                successBlock([dict objectForKey:@"data"]);
            }else{
                
                failBlock();
            }
        }else{
        
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
            failBlock();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求异常  %@",error);
        failBlock();
    }];
}


/**
 发送Delete请求

 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger DELETE:requestUrl parameters:paramentsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]] && dict.count != 0) {
            successBlock(dict);
        }else{
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
        }
        
        successBlock(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常"];
    }];
}

/**
 发送Delete请求 带失败block回调
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 @param failblock   请求失败回调
 */
+(void)sendDeleteHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock failBlock:(void (^)())failBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger DELETE:requestUrl parameters:paramentsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]] && dict.count != 0) {
            successBlock(dict);
        }else{
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
        }
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock();
        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常"];
    }];
}


/**
 发送put请求
 
 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param successBlock 请求成功的回调
 */
+(void)sendPutHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger PUT:requestUrl parameters:paramentsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]] && dict.count != 0) {
            successBlock(dict);
        }else{
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
        }
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常"];
    }];
}

/**
  发送上传图片请求

 @param requestUrl 请求地址
 @param paramentsDic 请求参数
 @param image 需要上传的图片
 @param successBlock 请求成功的回调
 */
+(void)sendPostImageHttpRequestWithUrl:(NSString*)requestUrl paraments:(NSDictionary*)paramentsDic image:(UIImage*)image successBlock:(void(^)(NSDictionary* jsonDic))successBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:requestUrl parameters:paramentsDic constructingBodyWithBlock:^(id  _Nonnull formData) {
        
        NSData *data = UIImageJPEGRepresentation(image,0.1);

        [formData appendPartWithFileData:data name:@"file" fileName:@"imaaaa.png" mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dict isKindOfClass:[NSDictionary class]] && dict.count != 0) {
            
            successBlock(dict);
        }else{
            [ShowMessageTipUtil showTipLabelWithMessage:@"请求返回数据错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:@"请求异常"];
    }];
}


@end
