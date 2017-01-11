//
//  InputController.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/5.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonInfoModel;

/**
   文本输入页面
 */
@interface InputController : UIViewController

/**
   自身title
 */
@property (nonatomic,strong) NSString *controlTitle;
/**
   提示文本
 */
@property (nonatomic,strong) NSString *tipString;
/**
    文本长度最大值
 */
@property (nonatomic,assign) NSInteger maxLength;
/**
    文本长度最小值
 */
@property (nonatomic,assign) NSInteger minLength;
/**
    本次提交的数据对应字段
 */
@property (nonatomic,strong) NSString *type;

/**
   接受上个页面传过来的当前个人信息数据,方便提交数据用
 */
@property (nonatomic,strong) PersonInfoModel *model;

/**
   修改信息的时候,需要显示原来的值,该参数用来接受原值,若为空则显示默认的tipString
 */
@property (nonatomic,strong) NSString *userTipString;

@end
