

//
//  ClassmateCell.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/28.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "ClassmateCell.h"

@interface ClassmateCell()

{
    /**
     *  用户头像
     */
    UIImageView *headImageV;
    /**
     *  标题Label
     */
    UILabel *titleL;
    /**
     *  描述Label
     */
    UILabel *describL;
    /*
     *  底部分割线
     */
    UILabel *line;
}

@end

@implementation ClassmateCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    WK(weakSelf);
    
    /**
     创建用户头像
     */
    headImageV = [[UIImageView alloc] init];
    [self addSubview:headImageV];
    [headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(weakSelf.mas_left).offset(8*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(100*WIDTH_SCALE, 100*HEIGHT_SCALE));
        
    }];
    
    //创建标题Label
    titleL = [[UILabel alloc] init];
    titleL.textColor = color_0f4068;
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.adjustsFontSizeToFitWidth = YES;
    titleL.numberOfLines = 0;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(headImageV.mas_right).offset(5*WIDTH_SCALE);
        make.top.mas_equalTo(headImageV.mas_top);
        make.height.mas_equalTo(30*HEIGHT_SCALE);
        make.right.mas_equalTo(weakSelf.mas_right);
    }];
    
    //创建描述Label
    describL = [[UILabel alloc] init];
    describL.textColor = color_7892a5;
    describL.font = [UIFont systemFontOfSize:12];
    describL.backgroundColor = [UIColor whiteColor];
    describL.adjustsFontSizeToFitWidth = YES;
    describL.numberOfLines = 0;
    [self addSubview:describL];
    [describL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(headImageV.mas_right).offset(5*WIDTH_SCALE);
        make.top.mas_equalTo(titleL.mas_bottom).offset(2);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-6*HEIGHT_SCALE);
    }];
    
    //创建底部分割线
    line = [[UILabel alloc] init];
    line.backgroundColor = color_dfeaff;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.left.mas_equalTo(headImageV.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(1);
    }];
}

-(void)setModel:(PersonModel *)model{
    
    [headImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"class-list-placeholder"]];
    titleL.text = [NSString stringWithFormat:@"学号：%lu",model.studyNumber];
    describL.text = model.sign;
}

@end
