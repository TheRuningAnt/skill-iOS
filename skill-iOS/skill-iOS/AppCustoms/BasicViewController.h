//
//  BasicViewController.h
//  MakeLearn-iOS
//
//  Created by 王晨飞 on 16/7/4.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "NavigationViewController.h"

@interface BasicViewController : UIViewController

/**
 创建指定属性的Controller

 @param backImageStr 返回按钮的图片名
 @return 一般返回子类实例对象
 */
-(id)initWithBackBtnImageStr:(NSString*)backImageStr;

@end
