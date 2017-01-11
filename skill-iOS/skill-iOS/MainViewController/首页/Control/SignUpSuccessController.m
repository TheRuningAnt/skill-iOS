//
//  SignUpSuccessController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/26.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "SignUpSuccessController.h"
#import "JobDetailController.h"

@interface SignUpSuccessController()

{
    //输入誓言文本框
    UILabel *describLabel;
}

@end

@implementation SignUpSuccessController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"报名成功模块"];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setupUI];
}


- (void)viewWillDisappear:(BOOL)animated
{
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"报名成功模块"];
}

-(void)setupUI{
    
    self.title = @"职业报名";
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:nil];
    
    //隐藏返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;

    WK(weakSelf);
    /**
    *  创建上方提示图模块
    */
    //设置上方的提示进度条
    UIImageView *topTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign-up-second-tip"]];
    [self.view addSubview:topTip];
    topTip.contentMode = UIViewContentModeCenter;
    [topTip mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(260*HEIGHT_SCALE, 80*HEIGHT_SCALE));
    }];
    
    //设置上方的头像
    UIImageView *topIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign-up-second-icon"]];
    [self.view addSubview:topIcon];
    topIcon.contentMode = UIViewContentModeCenter;
    [topIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(topTip.mas_bottom);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(260*HEIGHT_SCALE, 150*HEIGHT_SCALE));
    }];

    
    
    //设置背景色
    self.view.backgroundColor = color_ffffff;
    
    /**
     * 创建文本描述及提示模块
    */
    UILabel *congratulationsL = [[UILabel alloc] init];
    congratulationsL.textColor = color_0f4068;
    congratulationsL.font = [UIFont systemFontOfSize:19*WIDTH_SCALE];
    congratulationsL.text = @"恭喜！";
    congratulationsL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:congratulationsL];
    [congratulationsL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(topIcon.mas_bottom).offset(13*HEIGHT_SCALE);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX).offset(9);
        make.size.mas_equalTo(CGSizeMake(90, 20*WIDTH_SCALE));
    }];
    
    //添加描述label
    describLabel = [[UILabel alloc] init];
    describLabel.backgroundColor = color_ffffff;
    describLabel.text = @"--";
    describLabel.textColor = color_7892a5;
    describLabel.numberOfLines = 0;
    describLabel.font = [UIFont systemFontOfSize:17*WIDTH_SCALE];
    [self.view addSubview:describLabel];
    [describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(congratulationsL.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth - 30, 130*HEIGHT_SCALE));
    }];
    
    /**
    *  创建结果提示UIImageView模块
    */
    UIImageView *signupResultV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup-result-border"]];
    [self.view addSubview:signupResultV];
    [signupResultV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(describLabel.mas_bottom).offset(20*HEIGHT_SCALE);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth - 40, 80*HEIGHT_SCALE));
    }];
    
    //创建结果描述label
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.backgroundColor = color_ffffff;
    resultLabel.text = @"班号:--[--]\n学号:线上--[--]";
    resultLabel.textColor = color_9eafbd;
    resultLabel.numberOfLines = 0;
    resultLabel.font = [UIFont systemFontOfSize:15*WIDTH_SCALE];
    [signupResultV addSubview:resultLabel];
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(signupResultV.mas_left).offset((kWindowWidth - 40)/4);
        make.centerY.mas_equalTo(signupResultV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((kWindowWidth - 40)/4*3 - 5, 60*HEIGHT_SCALE));
    }];
    
    //添加完成button
    UIButton *complateStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [complateStepBtn setTitle:@"完成" forState:UIControlStateNormal];
    complateStepBtn.backgroundColor = color_24c9a7;
    complateStepBtn.layer.masksToBounds = YES;
    complateStepBtn.layer.cornerRadius = 6;
    [complateStepBtn addTarget:self action:@selector(complate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:complateStepBtn];
    [complateStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth - 20, 55*HEIGHT_SCALE));
        make.top.mas_equalTo(signupResultV.mas_bottom).offset(10*HEIGHT_SCALE);
    }];
    
    /*
     根据前面页面传过来的数据更新展示内容
     */
    //详细介绍模块
    NSString *describStr = [NSString stringWithFormat:@"      你已经成功加入IT修真院【%@】第【%lu】期第【%@】班，在未来的时间里，你将会与无数的师兄一起成长，打怪升级，从菜鸟变大神！你的师兄将是你IT修真路上坚实的后盾，加油吧，少年！",self.jobName,self.model.grade,self.model.name];
    NSRange jobRange = [describStr rangeOfString:[NSString stringWithFormat:@"【%@】",self.jobName]];
    NSRange itemRange = [describStr rangeOfString:[NSString stringWithFormat:@"【%lu】",self.model.grade]];
    NSRange classRange = [describStr rangeOfString:[NSString stringWithFormat:@"【%@】",self.model.name]];
    
    //设置关键字体高亮
    NSMutableAttributedString *describAttrStr = [[NSMutableAttributedString alloc] initWithString:describStr];
    [describAttrStr addAttribute:NSForegroundColorAttributeName value:color_ffc651 range:jobRange];
    [describAttrStr addAttribute:NSForegroundColorAttributeName value:color_ffc651 range:itemRange];
    [describAttrStr addAttribute:NSForegroundColorAttributeName value:color_ffc651 range:classRange];
    
    //调整描述文本间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];//调整行间距
    [describAttrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, describAttrStr.length)];
    
    describLabel.attributedText = describAttrStr;
    
    //班级和学号显示模块
    NSString *classAndStudyNumber;

    if ([self.model.type isEqualToString:@"online"]) {
        
        classAndStudyNumber = [NSString stringWithFormat:@"班号:线上%@[%@]\n学号:线上%@[%lu]",self.jobName,self.model.name,self.jobName,self.studyNumber];
    }else if ([self.model.type isEqualToString:@"online"]) {
        
        NSString *classAndStudyNumberStr = [NSString stringWithFormat:@"班号:线下%@[%@]\n学号:线下%@[%lu]",self.jobName,self.model.name,self.jobName,self.studyNumber];
        resultLabel.text = classAndStudyNumberStr;
    }
    
    if (classAndStudyNumber) {
        
        NSRange classNumRange = [classAndStudyNumber rangeOfString:[NSString stringWithFormat:@"线上%@[%@]",self.jobName,self.model.name]];
        NSRange studyNumRange = [classAndStudyNumber rangeOfString:[NSString stringWithFormat:@"线上%@[%lu]",self.jobName,self.studyNumber]];
        if (classNumRange.length && studyNumRange.length) {
            
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:classAndStudyNumber];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:color_ffc651 range:classNumRange];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:color_ffc651 range:studyNumRange];
            
            resultLabel.attributedText = attributeStr;
        }
    }else{
        
        resultLabel.text = @"班号:线上--\n学号:线上--";
    }
}

//点击完成  返回职业详情页面
-(void)complate{
    
    __block UIViewController *classVC;
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isMemberOfClass:[JobDetailController class]]) {
            
            classVC = obj;
        }
    }];
    
    if (classVC) {
        
        [self.navigationController popToViewController:classVC animated:YES];
    }
}



@end
