
//  ClassListCell.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/27.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "ClassListCell.h"
#import "PTTNumberTransform.h"

@interface ClassListCell()

{
    /**
     *  班级头像
     */
    UIImageView *classImageV;
    /**
     *  班级标题
     */
    UILabel *titleLabel;
    /**
     *  期数label
     */
    UILabel *itemAndPeopleNumberLabel;
    /*
     *  底部分割线
     */
    UILabel *line;
}

@end

@implementation ClassListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    WK(weakSelf);
    
    //创建班级头像
    classImageV = [[UIImageView alloc] init];
    classImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:classImageV];
    [classImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(weakSelf.mas_left).offset(8*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(100*HEIGHT_SCALE, 100*WIDTH_SCALE));
        
    }];
    
    //创建班级标题
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = color_0f4068;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(classImageV.mas_right).offset(5*WIDTH_SCALE);
        make.top.mas_equalTo(classImageV.mas_top);
        make.height.mas_equalTo(40*HEIGHT_SCALE);
        make.right.mas_equalTo(weakSelf.mas_right);
    }];
    
    //创建期数装饰tip
    UIImageView *itemTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"class-list-item"]];
    [self addSubview:itemTip];
    [itemTip mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(classImageV.mas_right).offset(5*WIDTH_SCALE);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(3*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(20*HEIGHT_SCALE, 20*HEIGHT_SCALE));
    }];
    
    //创建人期数和人数Label
    itemAndPeopleNumberLabel = [[UILabel alloc] init];
    itemAndPeopleNumberLabel.textColor = color_7892a5;
    itemAndPeopleNumberLabel.font = [UIFont systemFontOfSize:14];
    itemAndPeopleNumberLabel.backgroundColor = [UIColor whiteColor];
    itemAndPeopleNumberLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:itemAndPeopleNumberLabel];
    [itemAndPeopleNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(itemTip.mas_right).offset(5*WIDTH_SCALE);
        make.centerY.mas_equalTo(itemTip.mas_centerY);
        make.height.mas_equalTo(40*HEIGHT_SCALE);
        make.right.mas_equalTo(weakSelf.mas_right);
    }];
    
    //创建底部分割线
    line = [[UILabel alloc] init];
    line.backgroundColor = color_dfeaff;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.left.mas_equalTo(classImageV.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(1);
    }];
}

//设置cell字体内容
-(void)setModel:(ClassListModel *)model{
    
    /**
     *  使用model给cell上的控件赋值
     */
    
    [classImageV sd_setImageWithURL:[NSURL URLWithString:model.classImg] placeholderImage:[UIImage imageNamed:@"men-image"]];
    titleLabel.text = [NSString stringWithFormat:@"%@ %lu班",model.jobName,model.name];
    itemAndPeopleNumberLabel.text = [NSString stringWithFormat:@"第%@期   %lu / 20",[PTTNumberTransform pttGetWordFromNumber:model.grade],model.total];
    
    //设置字体高亮属性
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:itemAndPeopleNumberLabel.text];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:color_51d4b9 range:[itemAndPeopleNumberLabel.text rangeOfString:[NSString stringWithFormat:@"%lu",model.total]]];
    itemAndPeopleNumberLabel.attributedText = AttributedStr;
}

@end
