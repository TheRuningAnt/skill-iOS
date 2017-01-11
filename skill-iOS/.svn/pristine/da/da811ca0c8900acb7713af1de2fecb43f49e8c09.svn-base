//
//  JobIntroduceView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/22.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "JobIntroduceView.h"

@interface JobIntroduceView()

@property (nonatomic,strong) UIImageView *introduceImageV;
@property (nonatomic,strong) UIImageView *shadowImageV;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIButton *jobListBtn;

@end

@implementation JobIntroduceView

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    WK(weakSelf);
    
    //添加控件
    [self addSubview:self.shadowImageV];
    [self addSubview:self.introduceImageV];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.jobListBtn];

    //标题
    self.titleLabel.text = @"清楚自己学什么";;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = color_0f4068;
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf.introduceImageV.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(150, 40));
        make.top.mas_equalTo(weakSelf.introduceImageV.mas_top).offset(200*HEIGHT_SCALE);
    }];
    
    //背景阴影图
    self.shadowImageV.backgroundColor = [UIColor clearColor];
    self.introduceImageV.backgroundColor = [UIColor clearColor];

    //详细介绍
    self.detailLabel.text = @"知道自己适合学什么，那就直接选择职业，拿出你全部的热情开始修真之路吧！";
    self.detailLabel.textColor = color_7892a5;
    [self.detailLabel setFont:[UIFont systemFontOfSize:13]];
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(0);
        make.width.equalTo(@(kWindowWidth*3/4));
        make.height.equalTo(@40);
    }];
    
    
    //添加职业列表按钮
    [self.jobListBtn setTitle:@"职业列表" forState:UIControlStateNormal];
    [self.jobListBtn setTintColor:[UIColor whiteColor]];
    self.jobListBtn.backgroundColor = color_24c9a7;
    [self.jobListBtn addTarget:self action:@selector(showIntroduce) forControlEvents:UIControlEventTouchUpInside];
    self.jobListBtn.layer.masksToBounds = YES;
    self.jobListBtn.layer.cornerRadius = 10;
    [self.jobListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
        make.top.equalTo(weakSelf.detailLabel.mas_bottom).offset(20);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    
    
}

//推出职业列表
-(void)showIntroduce{
    
    _bthBlock();
}

#pragma mark 触摸视图事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}


#pragma mark 懒加载

//标题Label
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    };
    return _titleLabel;
}

//介绍Label
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
    }
    return _detailLabel;
}

//职业列表按钮
-(UIButton *)jobListBtn{
    if (!_jobListBtn) {
        _jobListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _jobListBtn;
}

//背景图
-(UIImageView *)introduceImageV{
    if (!_introduceImageV) {
        _introduceImageV = [[UIImageView alloc] initWithframe:CGRectMake(0, 80*HEIGHT_SCALE, kWindowWidth, kWindowHeight - 150) andImage:@"reusterSuccess" contendMode:1 withAction:^(id sender) {

        }];
    }
    return _introduceImageV;
}

//背景虚化
-(UIImageView *)shadowImageV{
    if (!_shadowImageV) {
        
        _shadowImageV = [[UIImageView alloc] initWithframe:[UIScreen mainScreen].bounds andImage:@"shdow-image" contendMode:0 withAction:^(id sender) {
            [self removeFromSuperview];
        }];
    }
    return _shadowImageV;
}

@end
