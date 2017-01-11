//
//  DownloadTipView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/26.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "DownloadTipView.h"

@implementation DownloadTipView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    //添加阴影背景
    UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:self.frame];
    shadowImageView.image = [UIImage imageNamed:@"Shadow-image"];
    [self addSubview:shadowImageView];
    
    /**
     创建提示模块
    */
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth - 40, kWindowWidth / 2)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.center = self.center;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 8;
    [self addSubview:contentView];
    
    //内容描述label
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = color_0f4068;
    detailLabel.font = [UIFont systemFontOfSize:11*WIDTH_SCALE];
    detailLabel.text = @"你正在使用流量下载资源\n是否继续?";
    detailLabel.backgroundColor = [UIColor whiteColor];
    detailLabel.numberOfLines = 2;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(contentView.mas_centerX);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.top.mas_equalTo(contentView.mas_top).offset(30*HEIGHT_SCALE);
        make.height.mas_equalTo(80*HEIGHT_SCALE);
    }];
    
    //创建修饰线 -- 水平
    UILabel *lineOfHorizontal = [[UILabel alloc] init];
    lineOfHorizontal.backgroundColor = color_dfeaff;
    [contentView addSubview:lineOfHorizontal];
    [lineOfHorizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView.mas_bottom).offset(-60*HEIGHT_SCALE);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    //创建修饰线 -- 垂直
    UILabel *lineOfVertical = [[UILabel alloc] init];
    lineOfVertical.backgroundColor = color_dfeaff;
    [contentView addSubview:lineOfVertical];
    [lineOfVertical mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineOfHorizontal.mas_bottom);
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(1, 60*HEIGHT_SCALE));
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:color_7892a5 forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:11*WIDTH_SCALE];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(lineOfHorizontal.mas_bottom);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(lineOfVertical.mas_left);
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitleColor:color_0f4068 forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:11*WIDTH_SCALE];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(lineOfHorizontal.mas_bottom);
        make.left.mas_equalTo(lineOfVertical.mas_right);
        make.right.mas_equalTo(contentView.mas_right);
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
}

//取消按钮触发事件
-(void)cancelBtnClick{
    [self removeFromSuperview];
}

//确定按钮触发事件
-(void)sureBtnClick{
    [self removeFromSuperview];
    self.sureBlock();
}


@end
