//
//  MessageModel.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/4.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
/**
  信息id
 */
@property (nonatomic,assign) NSInteger messaegId;
/**
 消息内容
 */
@property (nonatomic,strong) NSString *content;
/**
 创建时间戳
 */
@property (nonatomic,assign) NSInteger updateAt;
/**
 *  是否读取
 */
@property (nonatomic,assign) NSInteger unread;


@end
