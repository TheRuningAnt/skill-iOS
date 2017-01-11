
//
//  DailyCell.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/28.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "DailyCell.h"

@interface DailyCell()

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
     * 发布时间Label
     */
    UILabel *timeL;
    /**
     *  回复数Label
     */
    UILabel *replayL;
    /**
     *  浏览量Label
     */
    UILabel *browseL;
    /*
     *  底部分割线
     */
    UILabel *line;
}

/*
 * 保界面上使用的taskLabel
 */

@property (nonatomic,strong) NSMutableArray *taskLabelsArray;

@property (nonatomic,strong) NSDictionary *jobNameAndIdDic;
@end

@implementation DailyCell

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
        make.size.mas_equalTo(CGSizeMake(100*WIDTH_SCALE, 100*WIDTH_SCALE));
    }];
    
    //创建标题Label
    titleL = [[UILabel alloc] init];
    titleL.textColor = color_0f4068;
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.numberOfLines = 2;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(headImageV.mas_right).offset(8);
        make.top.mas_equalTo(headImageV.mas_top);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-4);
    }];
    
    //创建发表时间
    timeL = [[UILabel alloc] init];
    timeL.textColor = color_7892a5;
    timeL.font = [UIFont systemFontOfSize:10];
    timeL.backgroundColor = [UIColor whiteColor];
    timeL.numberOfLines = 0;
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(headImageV.mas_right).offset(5*WIDTH_SCALE);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-6);
        make.size.mas_equalTo(CGSizeMake(140*WIDTH_SCALE, 20*HEIGHT_SCALE));
    }];
    
    //创建浏览数Lbael
    browseL = [[UILabel alloc] init];
    browseL.textColor = color_7892a5;
    browseL.font = [UIFont systemFontOfSize:10];
    browseL.backgroundColor = [UIColor whiteColor];
    browseL.adjustsFontSizeToFitWidth = YES;
    [self addSubview:browseL];
    [browseL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(timeL.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-8*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(20*WIDTH_SCALE, 20*HEIGHT_SCALE));
    }];
    
    //创建浏览数tip
    UIImageView *browselTip = [[UIImageView alloc] init];
    browselTip.image = [UIImage imageNamed:@"class-paper-library"];
    [self addSubview:browselTip];
    [browselTip mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(timeL.mas_centerY);
        make.right.mas_equalTo(browseL.mas_left).offset(-1*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(14*WIDTH_SCALE, 12*HEIGHT_SCALE));
    }];
    
    //创建回复Label
    replayL = [[UILabel alloc] init];
    replayL.textColor = color_7892a5;
    replayL.font = [UIFont systemFontOfSize:10];
    replayL.backgroundColor = [UIColor whiteColor];
    replayL.adjustsFontSizeToFitWidth = YES;
    replayL.numberOfLines = 0;
    [self addSubview:replayL];
    [replayL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(browselTip.mas_left).offset(-3*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(10*WIDTH_SCALE, 20*HEIGHT_SCALE));
        make.centerY.mas_equalTo(timeL.mas_centerY);
    }];
    
    //创建回复提示tip
    UIImageView *tipOfReplay = [[UIImageView alloc] init];
    tipOfReplay.image = [UIImage imageNamed:@"class-paper-message"];
    [self addSubview:tipOfReplay];
    [tipOfReplay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(timeL.mas_centerY);
        make.right.mas_equalTo(replayL.mas_left).offset(-1*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(14*WIDTH_SCALE, 12*HEIGHT_SCALE));
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

/*
 优化逻辑:
 该页面控件过多 而且需要添加复杂的逻辑运算,每次滑动该页面都会导致创建多个label并且切圆角而导致离屏渲染,解决方法:依靠tableView的复用机制,在第一次创建cell的时候创建出来最多5个任务添加到界面上,保存在数组里给cell持有,每次给cell赋值的时候,仅需给给这些创建好的cell赋值即可,不需要在次创建控件和切圆角,可以缓解快速滑动页面时的卡顿问题.
 */
-(void)setModel:(DailyModel *)model{
    
    [headImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"class-list-placeholder"]];
    
    /**
     *  设置列表标题
     */
    
    //获取状态
    NSString *statue = nil;
    if ([self.model.type isEqualToString:@"none"]) {
        
        statue = @"无班级";
    }else if([self.model.type isEqualToString:@"offline"]) {
        
        statue = @"线下";
    }else {
        
        statue = @"线上";
    }

    //获取职业名字
    NSString *jobName = [self.jobNameAndIdDic objectForKey:[NSString stringWithFormat:@"%lu",(long)model.oid]];
    
    titleL.text = [NSString stringWithFormat:@"%@%@【%ld】班|修真院弟子【%@】 | %@的日报",statue,jobName,(long)model.name,model.nick,[PTTDateKit dateFrom1970WithTimeInterval:model.createAt]];
    timeL.text = [NSString stringWithFormat:@"发表于%@",[PTTDateKit dateTimeFrom1970WithTimeInterval:model.createAt]];
    replayL.text = [NSString stringWithFormat:@"%ld", (long)model.reply];
    browseL.text = [NSString stringWithFormat:@"%ld",(long)model.readCount];
    
    WK(weakSelf);
    //设置需要显示的任务标签隐藏状态和值
    if (model.taskNumbers.count <= 4) {
        
        //显示label
        [model.taskNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UILabel *label = weakSelf.taskLabelsArray[idx];
            label.text = [NSString stringWithFormat:@"任务%ld",(long)[obj integerValue]];
            label.hidden = NO;
        }];
        
        //隐藏不需要显示的Label
        NSInteger i = model.taskNumbers.count;
        while (i < 4) {
            
            UILabel *label = weakSelf.taskLabelsArray[i];
            label.hidden = YES;
            i ++;
        }
    }else{
        
        for (int i = 0 ; i < 4 ; i ++){
            
            UILabel *label = weakSelf.taskLabelsArray[i];
            label.text = [NSString stringWithFormat:@"任务%lu",[model.taskNumbers[i] integerValue]];
            label.hidden = NO;
        }
    }
}

-(NSMutableArray *)taskLabelsArray{
    
    if (!_taskLabelsArray) {
        
        _taskLabelsArray = @[].mutableCopy;
        
        UILabel *lastLabel = nil;
        //创建四个labels并保存起来
        for (int i = 0; i < 4; i ++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.textColor = color_0bcaa7;
            label.layer.borderWidth = 1;
            label.layer.borderColor = color_0bcaa7.CGColor;
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 3;
            label.font = [UIFont systemFontOfSize:12];
            label.backgroundColor = [UIColor whiteColor];
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.hidden = YES;
            [self addSubview:label];
            
            if (!lastLabel) {
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(titleL.mas_bottom).offset(10*HEIGHT_SCALE);
                    make.left.mas_equalTo(headImageV.mas_right).offset(5*WIDTH_SCALE);
                    make.size.mas_equalTo(CGSizeMake(50*WIDTH_SCALE, 22*HEIGHT_SCALE));
                }];
            }else{
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(titleL.mas_bottom).offset(10*HEIGHT_SCALE);
                    make.left.mas_equalTo(lastLabel.mas_right).offset(5*WIDTH_SCALE);
                    make.size.mas_equalTo(CGSizeMake(45*WIDTH_SCALE, 22*HEIGHT_SCALE));
                }];
            }
            lastLabel = label;
            
            [self addSubview:lastLabel];
            //将创建好的label添加到数组里
            [_taskLabelsArray addObject:lastLabel];
        }
    }
    
    return _taskLabelsArray;
}


-(NSDictionary *)jobNameAndIdDic{
    if (!_jobNameAndIdDic) {
        _jobNameAndIdDic = [NSDictionary dictionaryWithObjectsAndKeys:@"CSS",@"1",@"JS",@"2",@"Android",@"3",@"iOS",@"4",@"JAVA",@"5",@"OP",@"6",@"PM",@"7",@"UI",@"8",nil];
    }
    return _jobNameAndIdDic;
}

@end
