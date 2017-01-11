//
//  signupController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/26.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "SignupController.h"
#import "TaskDetailTipView.h"
#import "SignUpSuccessController.h"

@interface SignupController()<UITextViewDelegate>

{
    //输入誓言文本框
    UITextView *wordTextField;
    //提示文本框
    UILabel *tipLabel;
    //字数提示框
    UILabel *wordNumberL;
}

@end

@implementation SignupController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //启动友盟页面统计
    [MobClick beginLogPageView:@"填写誓言模块"];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"填写誓言模块"];
}

-(void)setupUI{
    
    self.title = @"职业报名";
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:nil];

    
    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    WK(weakSelf);
    //设置上方的提示图片
    UIImageView *topTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign-up-first-tip"]];
    [self.view addSubview:topTip];
    topTip.contentMode = UIViewContentModeCenter;
    [topTip mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(260*HEIGHT_SCALE, 100*HEIGHT_SCALE));
    }];
    
    //设置背景色
    self.view.backgroundColor = color_ffffff;
    
    //设置输入框
    wordTextField = [[UITextView alloc] init];
    wordTextField.backgroundColor = color_eff1f5;
    wordTextField.layer.masksToBounds = YES;
    wordTextField.layer.cornerRadius = 10;
    wordTextField.layer.borderWidth = 1;
    wordTextField.layer.borderColor = color_c1cfeb.CGColor;
    wordTextField.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    wordTextField.delegate = self;
    [self.view addSubview:wordTextField];
    [wordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(topTip.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth - 20, kWindowWidth/2 - 40));
    }];
    
    //添加输入框字数提示框
    wordNumberL = [[UILabel alloc] init];
    wordNumberL.text = @"0/50";
    wordNumberL.textColor = color_7892a5;
    wordNumberL.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
    [self.view addSubview:wordNumberL];
    [wordNumberL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(wordTextField.mas_right);
        make.bottom.mas_equalTo(wordTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    
    //添加 提示标题
    TaskDetailTipView *seriousTip = [[TaskDetailTipView alloc] initWithFrame:CGRectMake(5, 0, kWindowWidth, 40)];
    seriousTip.hideLine = YES;
    seriousTip.title = @"严肃说明";
    [self.view addSubview:seriousTip];
    [seriousTip mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(wordTextField.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 40));
    }];
    
    //创建提示内容
    NSArray *descripArray = @[@"你确定已经下定决心开始踏上IT修真之路了吗？",@"加入班级开始学习后，需要每天坚持写日报，汇报学习进度，你确定要这样做吗？",@"如果一切你都想好了，那么正式闭关修炼之前，在上方输入框写下你的入学誓言吧！"];
    UILabel *lastLabel;
    for (int i= 0; i < descripArray.count; i ++){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*WIDTH_SCALE, 0, kWindowWidth - 20*WIDTH_SCALE, 40*HEIGHT_SCALE)];
        label.textColor = color_7892a5;
        label.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"%d.%@",i + 1,descripArray[i]];
        [self.view addSubview:label];
        if (!lastLabel) {
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.mas_equalTo(seriousTip.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(kWindowWidth - 20*WIDTH_SCALE, 50*HEIGHT_SCALE));
                make.left.mas_equalTo(self.view.mas_left).offset(20);
            }];
            lastLabel = label;
        }else{
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(lastLabel.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(kWindowWidth - 20*WIDTH_SCALE, 50*HEIGHT_SCALE));
                make.left.mas_equalTo(self.view.mas_left).offset(20);
            }];
            lastLabel = label;
        }
    }

    //添加下一步button
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextStepBtn.backgroundColor = color_24c9a7;
    nextStepBtn.layer.masksToBounds = YES;
    nextStepBtn.layer.cornerRadius = 6;
    [nextStepBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepBtn];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth - 20, 55*HEIGHT_SCALE));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-25*HEIGHT_SCALE);
    }];
    
    //tipLabel
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kWindowWidth, 30)];
    tipLabel.text = @"请输入你的誓言";
    tipLabel.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    tipLabel.textColor = color_7892a5;
    [wordTextField addSubview:tipLabel];
    
    
}

#pragma mark 按钮触发方法
//返回上个页面
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//进入下一步  进入下个页面的时候发送加入班级的请求,如果加入成功则推出加入成功页面,加入失败则给用户提示并取消推出下个页面的操作
-(void)nextStep{
    
    if (!wordTextField.text || wordTextField.text.length == 0) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:@"请输入誓言" spacingWithTop:kWindowHeight/2 stayTime:2];
        return;
    }

    if (wordTextField.text.length > 50) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:@"誓言长度不可以超过50个字" spacingWithTop:kWindowHeight/2 - 30 stayTime:2];
        return;
    }
    
    if (self.model) {
        
        //拼接网络请求字符串 及参数
        NSString *strOuUrl = [NSString stringWithFormat:@"%@%lu",API_JoinClass,(NSUInteger)self.model.classId];
        NSDictionary *paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:wordTextField.text,@"swear",KUserToken,@"token", nil];
        
        [HttpService sendPostHttpRequestWithUrl:strOuUrl paraments:paramentsDic successBlock:^(NSDictionary *paraments) {
            
            if (paraments && [paraments isKindOfClass:[NSDictionary class]]) {
                
                if ([[paraments objectForKey:@"message"] isEqualToString:@"success"]) {
                    
                    NSArray *dataArray = [paraments objectForKey:@"data"];
                    
                    if (dataArray && dataArray.count != 0) {
                        
                        NSDictionary *dicOfNumber = [dataArray firstObject];
                        
                        if (dicOfNumber) {
                            
                            NSInteger studyNumber = [[dicOfNumber objectForKey:@"num"] integerValue];
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                //保存并更新个人信息
                                [UserTool updateUserOidAndCidWithBlcok:nil];
                                
                                //推出加入成功页面
                                SignUpSuccessController *signupSuccessVC = [[SignUpSuccessController alloc] init];
                                
                                signupSuccessVC.studyNumber = studyNumber;
                                signupSuccessVC.model = self.model;
                                signupSuccessVC.jobName = self.jobName;
                                
                                [self.navigationController pushViewController:signupSuccessVC animated:YES];
                            });
                        }
                    }
                    
                }else{
                    
                    [PTTShowAlertView showAlertViewWithTitle:@"提示" message:[paraments objectForKey:@"message"] cancleBtnTitle:nil cancelAction:nil sureBtnTitle:@"确定" sureAction:nil];
                }
            }
        }];
    }
}

#pragma mark textField代理
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    //开始输入的时候移除 提示文本框
    if (tipLabel && tipLabel.superview) {
        
        [tipLabel removeFromSuperview];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    wordNumberL.text = [NSString stringWithFormat:@"%lu/50",wordTextField.text.length];
}

#pragma mark 控制器代理方法

//触摸外围视图的时候,释放焦点,如果当前文本为空,则将提示Label加上
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (wordTextField.text.length == 0 && !tipLabel.superview) {
        
        [wordTextField addSubview:tipLabel];
    }
    [wordTextField resignFirstResponder];
}


@end
