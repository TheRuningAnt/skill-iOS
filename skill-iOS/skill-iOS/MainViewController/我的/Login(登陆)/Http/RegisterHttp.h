//
//  RegisterHttp.h
//  MakeLearn-iOS
//
//  Created by 花见花开你帅妹 on 16/7/15.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterHttp : NSObject

//发送验证码
+(void)registerSendPhoneNumber:(NSString *)phone verify:(NSString *)verify successJson:(void (^)(id json))successBlock;

//验证验证码
//+(void)registerSendPhoneNumber:(NSString *)phone successJson:(void (^)(id json))successBlock;

//注册
+(void)registerWithPhoneNumber:(NSString *)phone verify:(NSString *)verify Password:(NSString *)password successJson:(void (^)(id json))successBlock;

//登陆
+(void)loginWithPhoneNumber:(NSString *)phone password:(NSString *)password successJson:(void (^)(id json))successBlock;

//忘记密码
+(void)forgetWithPhoneNumber:(NSString *)phone password:(NSString *)password  verify:(NSString *)verify successJson:(void (^)(id json))successBlock;

//设置用户信息
+(void)ChangeWithUserNick:(NSString *)nick grade:(NSString *)grade mail:(NSString *)mail img:(NSString *)img successJson:(void (^)(id json))successBlock;

//上传图片
+(void)loginHeadImg:(NSString *)headImgStr andUrl:(NSString *)url successJson:(void (^)(id json))successBlock;

//手机号正则判断
+ (NSString *)checkMobile:(NSString *)aMobile;

//密码正则判断
+ (NSString *)checkPassword:(NSString *)aPassword;

//验证码正则判断
+(NSString *)checkVerifyCode:(NSString *)verifyCode;

//邮箱正则判断
+ (BOOL)validateEmail:(NSString *)email;

//第三方登录
+ (void)postOpenNumberWithOpenId:(NSString *)openid andWithType:(NSString *)type successBlock:(void(^)(id json))block;

//绑定手机号
+(void)registerWithBindPhoneNumber:(NSString *)phone verify:(NSString *)verify openid:(NSString *)openid Type:(NSString *)type successJson:(void (^)(id json))successBlock;

//查询是否手机或openid注册
+ (void)getMobileNumberIsRegister:(NSString *)openid Type:(NSString *)type successBlock:(void(^)(id json))block;

//QQ正则判断 [1-9][0-9]{4,}
+(NSString*)checkQQ:(NSString*)qqStr;

/**
 * 获取语音验证码
 */
+ (void)voiceSendPhoneNumber:(NSString *)mobile Type:(NSString *)type successBlock:(void(^)(id json))block;
//@property (nonatomic , strong) NSDictionary *loginDic;
//
//@property (nonatomic , strong) NSDictionary *userMessageDic;

@end
