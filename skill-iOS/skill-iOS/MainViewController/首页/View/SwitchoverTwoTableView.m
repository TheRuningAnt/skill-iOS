//
//  SwitchoverTwoTableView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/27.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "SwitchoverTwoTableView.h"

@interface SwitchoverTwoTableView()<UIScrollViewDelegate>
{
    UIButton *firstButton;  //第一个按钮
    UIButton *secondButton;  //第二个按钮
    
    UIView *changeTipView;   //下方的点击提示图
    __block UIView *contentView; //创建两个子视图容器
    
    UIView *_firstView;         //指向第一个控件
    UIView *_secondView;         //指向第二个控件
    
    void (^firstBlock)() ;  //第一个按钮触发Block
    void (^secondBlock)() ;  //第二个按钮出发Block
    
}

@end

@implementation SwitchoverTwoTableView

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
 *  @param tabBarHide   导航栏是否隐藏了 没有隐藏的话 子视图的高度会减去20 默认是不隐藏的
 */
-(instancetype)initWithFrame:(CGRect)frame FirstBtnTitle:(NSString*)firstTitle  firstView:(UIView*)firstView firstAction:(void (^)())firstAction sectionBtnTitle:(NSString*)secondTitle secondView:(UIView*)secondView secondAction:(void (^)())secondAction tabBaeHidden:(BOOL)tabBarHidden{
    
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    self.backgroundColor = color_e8efed;
    
    //初始化Block
    firstBlock = firstAction;
    secondBlock = secondAction;
    
    //创建第一个Btn tag值为1的时候为选中状态 2为非选择状态
    firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, kWindowWidth/2.f - 0.5, 45*HEIGHT_SCALE);
    firstButton.backgroundColor = [UIColor whiteColor];
    [firstButton setTitle:firstTitle forState:UIControlStateNormal];
    [firstButton setTitleColor:color_7892a5 forState:UIControlStateNormal];
    [firstButton setTitleColor:color_51d4b9 forState:UIControlStateSelected];
    firstButton.selected = YES;
    firstButton.titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    [firstButton addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:firstButton];
    
    //创建第二个Btn tag值为1的时候为选中状态 2为非选择状态
    secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(kWindowWidth/2.f - 0.5, 0, kWindowWidth/2.f - 0.5, 45*HEIGHT_SCALE);
    [secondButton setTitle:secondTitle forState:UIControlStateNormal];
    [secondButton setTitleColor:color_7892a5 forState:UIControlStateNormal];
    [secondButton setTitleColor:color_51d4b9 forState:UIControlStateSelected];
    secondButton.backgroundColor = [UIColor whiteColor];
    secondButton.titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    [secondButton addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:secondButton];
    
    //创建中间的修饰条
    UIImageView *tip = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2.f, 0, 1, 45*HEIGHT_SCALE)];
    tip.image = [UIImage imageNamed:@"Switch-two-view-tip"];
    [self addSubview:tip];
    
    //创建下方点击指示图
    changeTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 45*HEIGHT_SCALE - 2, kWindowWidth/2.f, 2)];
    changeTipView.backgroundColor = color_51d4b9;
    [self addSubview:changeTipView];

    /**
     *  创建下方滚动视图模块
     */
    
    //获取参数引用
    _firstView = firstView;
    _secondView = secondView;
    
    //创建子视图容器
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 45*HEIGHT_SCALE, kWindowWidth*2, self.height - 45*HEIGHT_SCALE)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:contentView];
    
    //设置第一个视图的属性,并添加到页面上去
    if(firstView){
        
        if(tabBarHidden){
            
            //状态栏隐藏
            firstView.frame = CGRectMake(0, 0, kWindowWidth, contentView.height);
        }else{
            //状态栏未隐藏
            firstView.frame = CGRectMake(0, 0, kWindowWidth, contentView.height - 20);
        }
        [contentView addSubview:firstView];
    }
    
    //设置第二个视图的属性,并添加到页面上去
    if(secondView){
        
        if(tabBarHidden){
            
            //状态栏隐藏
            secondView.frame = CGRectMake(kWindowWidth, 0, kWindowWidth, contentView.height);
        }else{
            //不隐藏
            secondView.frame = CGRectMake(kWindowWidth, 0, kWindowWidth, contentView.height - 20);
        }

        [contentView addSubview:secondView];
    }

    return self;
}

/**
 *  在特殊情况时需要动态调整自身高度以迎合需求,传入一个数值,动态改变自身高度
 *
 *  @param value 高度改变参数
 */
-(void)changHeight:(CGFloat)value{
    
    self.frame = [self changeFrame:self.frame withHeight:value];
    contentView.frame = [self changeFrame:contentView.frame withHeight:value];
    _firstView.frame = [self changeFrame:_firstView.frame withHeight:value];
    _secondView.frame = [self changeFrame:_secondView.frame withHeight:value];
    
}

#pragma mark 内部调用方法

//第一个按钮点击触发事件
-(void)firstBtnClick:(id)sender{
    
    firstButton.selected = YES;
    secondButton.selected = NO;
    
    //改变指示视图的位置
    if (changeTipView.origin.x != 0) {
        [UIView animateWithDuration:0.2 animations:^{
            changeTipView.frame = CGRectMake(0, 45*HEIGHT_SCALE - 2, kWindowWidth/2.f, 2);
        }];
    }
    
    //更改下方子视图位置
    if (contentView.frame.origin.x != 0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            contentView.frame = CGRectMake(0, 45*HEIGHT_SCALE, contentView.frame.size.width, contentView.frame.size.height);
        }];
    }
    
    //触发block
    if(firstBlock){
        firstBlock();
    }
}

/**
 *  第二个按钮点击触发事件
 */
-(void)secondBtnClick:(id)sender{
    
    firstButton.selected = NO;
    secondButton.selected = YES;
    
    //改变指示视图的位置
    if (changeTipView.origin.x != kWindowWidth) {
        [UIView animateWithDuration:0.2 animations:^{
            changeTipView.frame = CGRectMake(kWindowWidth/2.f, 45*HEIGHT_SCALE - 2, kWindowWidth/2.f, 2);
        }];
    }
    
    //更改下方子视图位置
    if (contentView.frame.origin.x != kWindowWidth) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            contentView.frame = CGRectMake(-kWindowWidth, 45*HEIGHT_SCALE, contentView.frame.size.width, contentView.frame.size.height);
        }];
    }
    
    //触发block
    if (secondBlock) {
        secondBlock();
    }
}

/**
 *  根据给定的frame 和 高度变化量 返回一个根据该变化量创建的新frame
 *
 *  @param frame  需要改变的frame
 *  @param height 高度变化量
 *
 *  @return 新frame
 */
-(CGRect)changeFrame:(CGRect)frame withHeight:(CGFloat)height{
    
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + height);
}

/**
 选中第二个View.将当前显示的视图滚动到第二个View处
 */
-(void)selectSecontView{
    
    if (secondButton && [self respondsToSelector:@selector(secondBtnClick:)]) {
        
        [self secondBtnClick:secondButton];
    }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == 0 && !firstButton.selected) {
        [self firstBtnClick:nil];
    }
    
    if (scrollView.contentOffset.x == kWindowWidth && !secondButton.selected) {
        [self secondBtnClick:nil];
    }
}

@end
