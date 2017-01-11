//
//  RegisterSuccessView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/14.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "RegisterSuccessView.h"
#import "HomePageController.h"
#import "JobsListController.h"

@implementation RegisterSuccessView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    //添加背面蒙版
    UIImageView *backShadowv = [[UIImageView alloc] initWithFrame:self.frame];
    backShadowv.image = [UIImage imageNamed:@"Shadow-image"];
    backShadowv.alpha = .9f;
    [self addSubview:backShadowv];
    
    //添加提示图片
    UIImageView *contentImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,300*WIDTH_SCALE, 400*HEIGHT_SCALE)];
    contentImageV.image = [UIImage imageNamed:@"regist-success-bg"];
    contentImageV.center = self.center;
    contentImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:contentImageV];
    
    WK(weakSelf);
    //添加提示title
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:23*WIDTH_SCALE];
    titleL.text = @"注册成功";
    titleL.textAlignment = NSTextAlignmentCenter;
    [contentImageV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(contentImageV.mas_top).offset(20*HEIGHT_SCALE);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100*WIDTH_SCALE, 40*HEIGHT_SCALE));
    }];
    
    //创建subTipLabel
    UILabel *subTipL = [[UILabel alloc] initWithFrame:CGRectZero];
    subTipL.backgroundColor = [UIColor clearColor];
    subTipL.textColor = [UIColor whiteColor];
    subTipL.font = [UIFont systemFontOfSize:13*WIDTH_SCALE];
    subTipL.text = @"恭喜，您已成功注册IT修真院";
    subTipL.textAlignment = NSTextAlignmentCenter;
    [contentImageV addSubview:subTipL];
    [subTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(titleL.mas_bottom).offset(5*HEIGHT_SCALE);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];
    
    //创建按钮上方提示title
    UILabel *buttonTioL = [[UILabel alloc] initWithFrame:CGRectZero];
    buttonTioL.backgroundColor = [UIColor clearColor];
    buttonTioL.textColor = color_7892a5;
    buttonTioL.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
    buttonTioL.text = @"选择喜欢的职业，开启新的征途";
    buttonTioL.textAlignment = NSTextAlignmentCenter;
    [contentImageV addSubview:buttonTioL];
    [buttonTioL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(subTipL.mas_bottom).offset(80*HEIGHT_SCALE);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];
    
    //创建职业列表btn
    UIButton *jobListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jobListBtn addTarget:self action:@selector(pushJobslist) forControlEvents:UIControlEventTouchUpInside];
    [jobListBtn setBackgroundColor:color_24c9a7];
    jobListBtn.layer.masksToBounds = YES;
    jobListBtn.layer.cornerRadius = 8;
    jobListBtn.titleLabel.font = [UIFont systemFontOfSize:17*WIDTH_SCALE];
    [jobListBtn setTitle:@"职业列表" forState:UIControlStateNormal];
    [jobListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:jobListBtn];
    [jobListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(buttonTioL.mas_bottom).offset(20*HEIGHT_SCALE);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(260*WIDTH_SCALE, 50*HEIGHT_SCALE));
    }];
    
    //创建关闭btn
    UIButton *clossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clossBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [clossBtn setBackgroundColor:color_24c9a7];
    clossBtn.layer.masksToBounds = YES;
    clossBtn.layer.cornerRadius = 8;
    clossBtn.titleLabel.font = [UIFont systemFontOfSize:17*WIDTH_SCALE];
    [clossBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [clossBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:clossBtn];
    [clossBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(jobListBtn.mas_bottom).offset(20*HEIGHT_SCALE);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(260*WIDTH_SCALE, 50*HEIGHT_SCALE));
    }];
}

//推出职业详情
-(void)pushJobslist{
    
    [self remove];
    if (self.responder && [self.responder isKindOfClass:[HomePageController class]]) {
        
        HomePageController *tmpHomeVC = (HomePageController*)self.responder;
        JobsListController *jobsVC = [[JobsListController alloc] init];
        [tmpHomeVC.navigationController pushViewController:jobsVC animated:YES];
    }
}

//关闭当前页面
-(void)remove{
    
    if (self && self.superview) {
        
        [self removeFromSuperview];
    }
}

@end
