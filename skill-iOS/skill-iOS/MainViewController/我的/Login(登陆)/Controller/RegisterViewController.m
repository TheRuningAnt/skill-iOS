//
//  RegisterViewController.m
//  MakeLearn-iOS
//
//  Created by 花见花开你帅妹 on 16/7/15.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "MineController.h"
#import "JobIntroduceView.h"
#import "RootController.h"

/**
   输入框tag值:
   手机号输入框 1001
   验证码输入框 1002
   密码输入框   1003
 */
@interface RegisterViewController ()

@property (strong, nonatomic) UIView * iphoneBgView;

@property (strong, nonatomic) UIView * passWordBgView;

@property (strong, nonatomic) UIView * messageBgView;

@property (strong, nonatomic) UIImageView * iphoneImgView;

@property (strong, nonatomic) UIImageView * messageImgView;

@property (strong, nonatomic) UIImageView * passWordImgView;

@property (strong, nonatomic) UILabel * line1;

@property (strong, nonatomic) UILabel * line2;

@property (strong, nonatomic) UILabel * line3;

@property (strong, nonatomic) UILabel * line4;

@property (strong, nonatomic) UILabel * line5;

@property (strong, nonatomic) UITextField* iphoneText;

@property (strong, nonatomic) UITextField* messageText;

@property (strong, nonatomic) UITextField * passWordText;

@property (strong, nonatomic) UIButton * sendmessageBtn;

@property (strong, nonatomic) UIButton * otherTextBtn;

@property (strong, nonatomic) UIButton * registerBtn;

@property (strong, nonatomic) UIButton *speakButton;

@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"注册模块"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"f0f4f7"];
    self.title = @"注册";

    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    //添加登录按钮
    UIButton *buttonOfLogin = [[UIButton alloc]init];
    [buttonOfLogin setTitle:@"登录" forState:UIControlStateNormal];
    [buttonOfLogin setTitleColor:color_24c9a7 forState:UIControlStateNormal];
    buttonOfLogin.titleLabel.font = [UIFont systemFontOfSize:14];
    buttonOfLogin.frame = CGRectMake(0,0, 60*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [buttonOfLogin setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [buttonOfLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:buttonOfLogin];
    self.navigationItem.rightBarButtonItems = @[item2];

    
    //导航栏标题
    self.title = @"注册";
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:font,
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;

    [self CustomNavigation];
    
    [self initSubViews];
    
    [self layoutSubviews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    //退出友盟页面统计
    [MobClick endLogPageView:@"注册模块"];
}

#pragma mark- 自定义导航条

- (void)CustomNavigation
{
    self.view.backgroundColor=[UIColor colorWithHexString:@"f0f4f7"];
    
    //显示导航条
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}


#pragma mark - 导航栏按钮触发方法

//返回上个界面
- (void)back{
    NSArray *chiledVC = self.navigationController.childViewControllers;
    for (int i = 0; i<chiledVC.count; i++) {
        if ([chiledVC[i]isKindOfClass:[MineController class]]) {
            [self.navigationController popToViewController:[chiledVC objectAtIndex:i] animated:YES];
            break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//登录按钮
-(void)login{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark- 初始化视图

-(void)initSubViews{
    
    self.iphoneBgView.frame=[FrameAutoScaleLFL CGLFLMakeX:0 Y:74 width:320 height:50];
    
    self.messageBgView.frame=[FrameAutoScaleLFL CGLFLMakeX:0 Y:125 width:320 height:50];
    
    self.passWordBgView.frame=[FrameAutoScaleLFL CGLFLMakeX:0 Y:176 width:320 height:50];
    
    self.iphoneImgView.frame=[FrameAutoScaleLFL CGLFLMakeX:(58-12)/2 Y:(50-18)/2 width:12 height:18];
    
    self.messageImgView.frame=[FrameAutoScaleLFL CGLFLMakeX:(58-16)/2 Y:(50-18)/2 width:16 height:18];
    
    self.passWordImgView.frame=[FrameAutoScaleLFL CGLFLMakeX:(58-14)/2 Y:(50-16)/2 width:14 height:16];
    
    self.line1.frame=[FrameAutoScaleLFL CGLFLMakeX:58 Y:(50-26)/2 width:1 height:26];
    
    self.line2.frame=[FrameAutoScaleLFL CGLFLMakeX:58 Y:(50-26)/2 width:1 height:26];
    
    self.line3.frame=[FrameAutoScaleLFL CGLFLMakeX:58 Y:(50-26)/2 width:1 height:26];
    
    self.line4.frame=[FrameAutoScaleLFL CGLFLMakeX:320-100 Y:(50-26)/2 width:1 height:26];
    
    self.iphoneText.frame=[FrameAutoScaleLFL CGLFLMakeX:78 Y:(45-26)/2 width:320-78 height:32];
    
    self.messageText.frame=[FrameAutoScaleLFL CGLFLMakeX:78 Y:(45-26)/2 width:320-78 height:32];
    
    self.passWordText.frame=[FrameAutoScaleLFL CGLFLMakeX:78 Y:(45-26)/2 width:320-78 height:32];
    
    self.sendmessageBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:320 - 80 Y:(50-26)/2 width:60 height:26];
    
    self.registerBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:8 Y:244 width:304 height:44];
    
    self.otherTextBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:320-108 Y:294 width:100 height:30];
    
    self.line4.frame=[FrameAutoScaleLFL CGLFLMakeX:320 - 87 Y:(50-26)/2 width:1 height:26];
}

#pragma mark- 添加到主界面

-(void)layoutSubviews{
    
    [self.view addSubview:self.iphoneBgView];
    
    [self.view addSubview:self.messageBgView];
    
    [self.view addSubview:self.passWordBgView];
    
    [self.iphoneBgView addSubview:self.iphoneImgView];
    
    [self.messageBgView addSubview:self.messageImgView];
    
    [self.passWordBgView addSubview:self.passWordImgView];
    
    [self.iphoneBgView addSubview:self.line1];
    
    [self.messageBgView addSubview:self.line2];
    
    [self.passWordBgView addSubview:self.line3];
    
    [self.iphoneBgView addSubview:self.iphoneText];
    
    [self.messageBgView addSubview:self.messageText];
    
    [self.passWordBgView addSubview:self.passWordText];
    
    [self.messageBgView addSubview:self.sendmessageBtn];
    //[self.messageBgView addSubview:self.speakButton];
    [self.messageBgView addSubview:self.line4];
    //[self.messageBgView addSubview:self.line5];
    [self.view addSubview:self.registerBtn];
    
    [self.view addSubview:self.otherTextBtn];
}

#pragma mark- 懒加载
-(UILabel *)line4{
    if (!_line4) {
        
        _line4 = [[UILabel alloc] init];
        _line4.backgroundColor=color_e4e4e4;
        
    }
    return _line4;
}
-(UILabel *)line5{
    if (!_line5) {
        
        _line5 = [[UILabel alloc] init];
        _line5.backgroundColor=color_e4e4e4;
        
    }
    return _line5;
}
-(UIButton *)speakButton{
    if (!_speakButton) {
        _speakButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speakButton setTitle:@"语音验证" forState:UIControlStateNormal];
        _speakButton.titleLabel.font=[UIFont systemFontOfSize:14*HEIGHT_SCALE];
        [_speakButton setTitleColor:color_24c9a7 forState:UIControlStateNormal];
        [_speakButton addTarget:self action:@selector(sendSpeakBtnselector) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speakButton;
}

-(UIView *)iphoneBgView{
    if (!_iphoneBgView) {
        
        _iphoneBgView = [[UIView alloc] init];
        _iphoneBgView.backgroundColor=[UIColor whiteColor];
        
    }
    return _iphoneBgView;
}

-(UIView *)messageBgView{
    if (!_messageBgView) {
        
        _messageBgView = [[UIView alloc] init];
        _messageBgView.backgroundColor=[UIColor whiteColor];
        
    }
    return _messageBgView;
}


-(UIView *)passWordBgView{
    if (!_passWordBgView) {
        
        _passWordBgView = [[UIView alloc] init];
        _passWordBgView.backgroundColor=[UIColor whiteColor];
        
    }
    return _passWordBgView;
}

-(UIImageView *)iphoneImgView{
    if (!_iphoneImgView) {
        
        _iphoneImgView = [[UIImageView alloc] init];
        _iphoneImgView.image=[UIImage imageNamed:@"login-number"];
        
    }
    return _iphoneImgView;
}

-(UIImageView *)messageImgView{
    if (!_messageImgView) {
        
        _messageImgView = [[UIImageView alloc] init];
        _messageImgView.image=[UIImage imageNamed:@"regist-code"];
        
    }
    return _messageImgView;
}

-(UIImageView *)passWordImgView{
    if (!_passWordImgView) {
        
        _passWordImgView = [[UIImageView alloc] init];
        _passWordImgView.image=[UIImage imageNamed:@"login-password"];
        
    }
    return _passWordImgView;
}

-(UILabel *)line1{
    if (!_line1) {
        
        _line1 = [[UILabel alloc] init];
        _line1.backgroundColor=color_e4e4e4;
        
    }
    return _line1;
}

-(UILabel *)line2{
    if (!_line2) {
        
        _line2 = [[UILabel alloc] init];
        _line2.backgroundColor=color_e4e4e4;
        
    }
    return _line2;
}

-(UILabel *)line3{
    if (!_line3) {
        
        _line3 = [[UILabel alloc] init];
        _line3.backgroundColor=color_e4e4e4;
        
    }
    return _line3;
}

-(UITextField *)iphoneText{
    if (!_iphoneText) {
        
        _iphoneText = [[UITextField alloc] init];
        _iphoneText.placeholder=@"请输入手机号";
        _iphoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _iphoneText.font=[UIFont systemFontOfSize:14*HEIGHT_SCALE];
        _iphoneText.keyboardType = UIKeyboardTypeNumberPad;
        _iphoneText.tag = 1001;
        //添加监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:_iphoneText];
        
    }
    return _iphoneText;
}

-(UITextField *)messageText{
    if (!_messageText) {
        
        _messageText = [[UITextField alloc] init];
        _messageText.placeholder=@"输入验证码";
        _messageText.keyboardType = UIKeyboardTypeNumberPad;
        _messageText.font=[UIFont systemFontOfSize:14*HEIGHT_SCALE];
        _messageText.tag = 1002;
        //添加监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:_messageText];
    }
    return _messageText;
}

-(UITextField *)passWordText{
    if (!_passWordText) {
        
        _passWordText = [[UITextField alloc] init];
        _passWordText.placeholder=@"请输入由字母或数字组成6-16位密码";
        _passWordText.font=[UIFont systemFontOfSize:14*HEIGHT_SCALE];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoAction)name:UITextFieldTextDidChangeNotification object:nil];
        [_passWordText setSecureTextEntry:YES];
        _passWordText.tag = 1003;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:_passWordText];
    }
    return _passWordText;
}

-(UIButton *)sendmessageBtn{
    if (!_sendmessageBtn) {
        
        _sendmessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendmessageBtn setTitle:@"短信验证" forState:UIControlStateNormal];
        _sendmessageBtn.titleLabel.font=[UIFont systemFontOfSize:14*HEIGHT_SCALE];
        [_sendmessageBtn setTitleColor:color_24c9a7 forState:UIControlStateNormal];
        [_sendmessageBtn addTarget:self action:@selector(sendmessageBtnselector) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendmessageBtn;
}

-(UIButton *)registerBtn{
    if (!_registerBtn) {
        
        _registerBtn = [[UIButton alloc] init];
        [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font=[UIFont systemFontOfSize:16*HEIGHT_SCALE];
        [_registerBtn.layer setMasksToBounds:YES];
        [_registerBtn.layer setCornerRadius:8*HEIGHT_SCALE];
        [_registerBtn setTitleColor:color_999999 forState:UIControlStateNormal];
        _registerBtn.backgroundColor=color_e1e1e1;
        [_registerBtn addTarget:self action:@selector(registerBtnselectorBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registerBtn;
}

-(UIButton *)otherTextBtn{
    if (!_otherTextBtn) {
        
        _otherTextBtn = [[UIButton alloc] init];
        _otherTextBtn.titleLabel.font=[UIFont systemFontOfSize:12*HEIGHT_SCALE];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已有账号? 去登录"]];
        NSRange range1=[[hintString string]rangeOfString:@"登录"];
        NSRange range2=[[hintString string]rangeOfString:@"已有账号? 去"];
         [hintString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range1];
        [hintString addAttribute:NSForegroundColorAttributeName value:color_24c9a7 range:range1];
        [hintString addAttribute:NSForegroundColorAttributeName value:color_0f4068 range:range2];
        [_otherTextBtn setAttributedTitle:hintString forState:UIControlStateNormal];
        [_otherTextBtn addTarget:self action:@selector(_otherTextBtnselectorBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _otherTextBtn;
}

#pragma mark- text代理

- (void)infoAction
{
    
    if (self.iphoneText.text.length!=11||self.passWordText.text.length<6||self.messageText.text.length!=6) {
        
        [self.registerBtn setTitleColor:color_999999 forState:UIControlStateNormal];
        
        self.registerBtn.backgroundColor=color_e1e1e1;
        
    }
    else
    {
        [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.registerBtn.backgroundColor=color_51d4b9;
    }
    
}


#pragma mark- 触发验证码方法

//发送短信验证码
-(void)sendmessageBtnselector
{
    KCheckNetWorkAndRetuen(^(){
        return ;
    })
    
    NSString  *validMess = [RegisterHttp checkMobile:self.iphoneText.text];
    
    if(validMess.length > 0){
        
        [ShowMessageTipUtil showTipLabelWithMessage:validMess];
        
        return;
    }
    
    [RegisterHttp registerSendPhoneNumber:self.iphoneText.text verify:@"register" successJson:^(id json) {
        if ([[json objectForKey:@"code"] intValue]==0) {
            
            [ShowMessageTipUtil showTipLabelWithMessage:@"验证码获取成功"];
            [self startTime];
        }
        else
        {
            [ShowMessageTipUtil showTipLabelWithMessage:[json objectForKey:@"message"]];
        }
        
    }];
}

/**
 * 发送语音验证码
 */
-(void)sendSpeakBtnselector{
    
    KCheckNetWorkAndRetuen(^(){
        return ;
    })
    
    NSString  *validMess1 = [RegisterHttp checkMobile:self.iphoneText.text];
    if(validMess1.length > 0){
        [ShowMessageTipUtil showTipLabelWithMessage:validMess1];
        return;
    }
    [self sendVoiceStartTime];
    [RegisterHttp voiceSendPhoneNumber:self.iphoneText.text Type:@"register" successBlock:^(id json) {
        if ([[json objectForKey:@"code"] intValue]==0) {
            [ShowMessageTipUtil showTipLabelWithMessage:@"语音验证码获取成功"];
        }
        else
        {
           [ShowMessageTipUtil showTipLabelWithMessage:[json objectForKey:@"message"]];
        }
    }];
}

#pragma mark- 验证码倒计时

-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
            });
        }
        else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 90;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [_sendmessageBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                _sendmessageBtn.userInteractionEnabled = NO;
                
                if ([_sendmessageBtn.titleLabel.text isEqualToString:@"01s"]) {
                    [_sendmessageBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    _sendmessageBtn.userInteractionEnabled = YES;
                }
                
            });
            timeout--;
            
        }
    });
    
    dispatch_resume(_timer);
    
}
-(void)sendVoiceStartTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
            });
        }
        else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 90;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [_speakButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                _speakButton.userInteractionEnabled = NO;
                
                if ([_speakButton.titleLabel.text isEqualToString:@"01s"]) {
                    [_speakButton setTitle:@"重新获取" forState:UIControlStateNormal];
                    _speakButton.userInteractionEnabled = YES;
                }
                
            });
            timeout--;
            
        }
    });
    
    dispatch_resume(_timer);
    
}


#pragma mark- 点击注册方法

-(void)registerBtnselectorBtn
{
    NSString  *validMess1 = [RegisterHttp checkMobile:self.iphoneText.text];
    NSString  *validMess2 = [RegisterHttp checkPassword:self.passWordText.text];
    
    if(validMess1.length > 0){
        
        [ShowMessageTipUtil showTipLabelWithMessage:validMess1 spacingWithTop:kWindowHeight/2 - 110  stayTime:3];
        
        return;
    }
    if(validMess2.length > 0){
        
        [ShowMessageTipUtil showTipLabelWithMessage:validMess2 spacingWithTop:kWindowHeight/2 - 110 stayTime:3];
        
        return;
    }
    
    if ([RegisterHttp checkPassword:self.passWordText.text]) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:[RegisterHttp checkPassword:self.passWordText.text] spacingWithTop:kWindowHeight/2 - 110 stayTime:2];
        return;
    }
    
    if (self.messageText.text.length != 6) {
        [ShowMessageTipUtil showTipLabelWithMessage:@"请填写正确验证码" spacingWithTop:kWindowHeight/2 - 110 stayTime:3];
        return;
    }
    
    [RegisterHttp registerWithPhoneNumber:self.iphoneText.text verify:self.messageText.text Password:self.passWordText.text successJson:^(id json) {
                        
        // 存储帐号信息  并返回之前页面
        UserModel *user  = [[UserModel alloc] init];
        user.uid = [[json objectForKey:@"uid"] intValue];
        user.userNumber = self.iphoneText.text;
        user.token = [json objectForKey:@"token"];
        user.firstLogin = YES;
        [UserTool save:user];
        [UserTool updateUserOidAndCidWithBlcok:nil];
        
        //登录友盟分析
        [MobClick profileSignInWithPUID:[UserTool userModel].userNumber];
        [MobClick startWithConfigure:UMConfigInstance];
        
        //注册成功之后,需要注册环信账户
        EMError *error = [[EMClient sharedClient] registerWithUsername:self.iphoneText.text password:@"123456"];
        if (error==nil) {
            NSLog(@"环信注册成功");
        }
        
        //登录
        [[EMClient sharedClient] loginWithUsername:user.userNumber
                                          password:@"123456"
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                NSLog(@"登陆成功");
                                                EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
                                                emoptions.displayStyle = EMPushDisplayStyleSimpleBanner;
                                                [[EMClient sharedClient] updatePushOptionsToServer];
                                                
                                            } else {
                                                NSLog(@"登陆失败");
                                            }
                                        }];
        
        //给该用户一个默认的昵称,并更新个人信息
        NSArray *nicks = @[@"呼保义",@"玉麒麟",@"智多星",@"入云龙",@"双抢将",@"豹子头",@"霹雳火",@"双 鞭",@"小李广",@"小旋风",@"双抢将",@"美髯公",@"花和尚",@"双抢将",@"没羽箭",@"青面兽",@"金抢手",@"急先锋",@"神行太保",@"赤发鬼",@"黑旋风",@"九纹龙",@"没遮拦",@"插翅虎",@"混江龙",@"立地太岁",@"船火儿",@"浪里白条",@"活阎罗",@"病关索",@"拼命三郎",@"两头蛇",@"双尾蝎",@"神机军师",@"镇三山",@"病尉迟",@"丑郡马"];
        
        NSInteger nickIndex = arc4random() % (nicks.count);
        NSDictionary *paramentsDic = @{@"token":[UserTool userModel].token,@"nick":nicks[nickIndex]};
        
        [HttpService sendPutHttpRequestWithUrl:API_ChangePersonInfo paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
            
            NSLog(@"update nick jsonDic = %@",jsonDic);
        }];
        
        
        RootController *rootController = [[RootController alloc] init];
        rootController.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController pushViewController:rootController animated:YES];
    }];
}

#pragma mark- 点击返回登陆

-(void)_otherTextBtnselectorBtn
{
    LoginViewController *l=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:l animated:YES];
}

#pragma mark 监听代理
-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    if (!textField) {
        return;
    }
    
    if (textField.tag == 1002) {
        NSString *toBeString = textField.text;
        if (toBeString.length > 6) {
            textField.text = [toBeString substringToIndex:6];
        }
    }
    if (textField.tag == 1001) {
        NSString *toBeString = textField.text;
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
        }
    }
    if (textField.tag == 1003) {
        NSString *toBeString = textField.text;
        if (toBeString.length > 16) {
            textField.text = [toBeString substringToIndex:16];
        }
    }
}

@end
