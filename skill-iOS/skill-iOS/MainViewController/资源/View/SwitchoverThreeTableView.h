//
//  SwitchoverThreeTableView.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/1.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchoverThreeTableView : UIView

/**
 *  使用两个按钮的标题、两个视图、两个点击事件创建点击之后切换下方视图的控件
 *
 *  @param frame        整个视图frame
 *  @param firstTitle   第一个按钮标题
 *  @param firstView    第一个视图
 *  @param firstAction  第一个按钮点击触发事件
 *  @param secondTitle  第二个按钮标题
 *  @param secondView   第二个视图
 *  @param secondAction 第二个按钮点击触发事件
 *  @param thirdTitle   第三个按钮标题
 *  @param thirdView   第三个视图
 *  @param thirdAction 第三个按钮点击触发事件
 *  @param tabBarHide   导航栏是否隐藏了 没有隐藏的话 子视图的高度会减去20 默认是不隐藏的
 */
-(instancetype)initWithFrame:(CGRect)frame FirstBtnTitle:(NSString*)firstTitle  firstView:(UIView*)firstView firstAction:(void (^)())firstAction sectionBtnTitle:(NSString*)secondTitle secondView:(UIView*)secondView secondAction:(void (^)())secondAction thirdBtnTitle:(NSString*)thirdTitle thirdView:(UIView*)thirdView thirdAction:(void (^)())thirdAction tabBaeHidden:(BOOL)tabBarHidden;

/**
 *  在特殊情况时需要动态调整自身高度以迎合需求,传入一个数值,动态改变自身高度
 *
 *  @param value 高度改变参数
 */
-(void)changHeight:(CGFloat)value;

@end
