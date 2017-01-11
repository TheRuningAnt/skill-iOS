//
//  ChangeBirthdayAndCityController.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/7.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonInfoModel;

@interface PickViewController : UIViewController

/**
 自身title
 */
@property (nonatomic,strong) NSString *controlTitle;
/**
 接受上个页面传过来的当前个人信息数据,方便提交数据用
 */
@property (nonatomic,strong) PersonInfoModel *model;
/**
 本次提交的数据对应字段
 */
@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSString *tipString;
@end
