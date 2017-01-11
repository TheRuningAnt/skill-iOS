//
//  JobsListItem.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/24.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "JobsListItem.h"

@interface JobsListItem()

@property (nonatomic,strong) UIImageView *jobImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *introduceLabel;

@end

@implementation JobsListItem

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    //创建职业视图
    [self addSubview:self.jobImageView];
    self.jobImageView.layer.borderWidth = 1;
    self.jobImageView.layer.borderColor = color_c1cfeb.CGColor;
    [self.jobImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo((self.width - 20)*3/4 + 20);
    }];

    //创建标题Lable
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:18*HEIGHT_SCALE];
    self.titleLabel.textColor = color_0f4068;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.jobImageView.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.left.mas_equalTo(self.mas_left).offset(5);
    }];
    
    //创建描述label
    [self addSubview:self.introduceLabel];
    self.introduceLabel.font = [UIFont systemFontOfSize:13*HEIGHT_SCALE];
    self.introduceLabel.numberOfLines = 0;
    self.introduceLabel.textColor = color_7892a5;
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left).offset(5);
    }];
}

-(void)setJobModel:(JobModel *)jobModel{
    
    [self.jobImageView sd_setImageWithURL:[NSURL URLWithString:jobModel.img] placeholderImage:[UIImage imageNamed:@"job-list-placeHolder"]];
    self.titleLabel.text = jobModel.name;
    self.introduceLabel.text = jobModel.jobDescription;
}

#pragma mark 懒加载

-(UIImageView *)jobImageView{
    
    if (!_jobImageView) {
        _jobImageView = [[UIImageView alloc] init];
    }
    return _jobImageView;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

-(UILabel *)introduceLabel{
    
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] init];
    }
    return _introduceLabel;
}

@end
