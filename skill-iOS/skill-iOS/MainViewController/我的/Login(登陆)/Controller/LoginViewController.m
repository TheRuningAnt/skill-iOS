//
//  LoginViewController.m
//  MakeLearn-iOS
//
//  Created by 花见花开你帅妹 on 16/7/14.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "LoginViewController.h"
#import "RootController.h"
#import "RegisterViewController.h"
#import "ForgetPosswordViewController.h"
#import "MineController.h"

/**
 输入框tag值:
 手机号输入框 1001
 验证码输入框 1002
 密码输入框   1003
 */
@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView * iphoneBgView;

@property (strong, nonatomic) UIView * passWordBgView;

@property (strong, nonatomic) UIImageView * iphoneImgView;

@property (strong, nonatomic) UIImageView * passWordImgView;

@property (strong, nonatomic) UILabel * line1;

@property (strong, nonatomic) UILabel * line2;

@property (strong, nonatomic) UITextField* iphoneText;

@property (strong, nonatomic) UITextField * passWordText;

@property (strong, nonatomic) UIButton * loginBtn;

@property (strong, nonatomic) UIButton * forgetBtn;

@property (strong, nonatomic) UILabel * otherLable;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    if (self.showLeftItem) {
        
        //导航栏返回按钮
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItems = @[item1];
    }
    
    //导航栏标题
    self.title = @"登录";
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:font,
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //如果是从子页面推出来的,则添加返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        //导航栏返回按钮
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItems = @[item1];
    }

    //导航栏注册按钮
    UIButton *button2 = [[UIButton alloc]init];
    [button2 setTitle:@"注册" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setTitleColor:color_24c9a7 forState:UIControlStateNormal];
    button2.frame = CGRectMake(0,0, 30, 40) ;
    [button2 addTarget:self action:@selector(liJiZhuCeBtnselectorBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"登录模块"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    //退出友盟页面统计
    [MobClick endLogPageView:@"登录模块"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;

    [self CustomNavigation];
    
    [self initSubViews];
    
    [self layoutSubviews];
}

#pragma mark- 自定义导航条

- (void)CustomNavigation
{
    self.view.backgroundColor=[UIColor colorWithHexString:@"f0f4f7"];
    
    //显示导航条
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //导航条图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationbar_background"]forBarMetrics:UIBarMetricsDefault];
    
    //修改导航条字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

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


#pragma mark- 初始化视图

-(void)initSubViews{
    
    self.iphoneBgView.frame=[FrameAutoScaleLFL CGLFLMakeX:0 Y:74 width:320 height:50];
    
    self.passWordBgView.frame=[FrameAutoScaleLFL CGLFLMakeX:0 Y:125 width:320 height:50];
    
    self.iphoneImgView.frame=[FrameAutoScaleLFL CGLFLMakeX:(58-12)/2 Y:(50-18)/2 width:12 height:18];
    
    self.passWordImgView.frame=[FrameAutoScaleLFL CGLFLMakeX:(58-14)/2 Y:(50-16)/2 width:14 height:16];
    
    self.line1.frame=[FrameAutoScaleLFL CGLFLMakeX:58 Y:(50-26)/2 width:1 height:26];
    
    self.line2.frame=[FrameAutoScaleLFL CGLFLMakeX:58 Y:(50-26)/2 width:1 height:26];
    
    self.iphoneText.frame=[FrameAutoScaleLFL CGLFLMakeX:78 Y:(45-26)/2 width:320-78 height:35];

    self.passWordText.frame=[FrameAutoScaleLFL CGLFLMakeX:78 Y:(45-26)/2 width:320-78 height:35];
   
    self.loginBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:8 Y:194 width:304 height:44];
    
    self.forgetBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:320-76 Y:238 width:68 height:30];
    
    self.otherLable.frame=[FrameAutoScaleLFL CGLFLMakeX:(320-100)/2 Y:568-221 width:100 height:30];
}

#pragma mark- text代理

- (void)infoAction
{
    
    if (self.iphoneText.text.length!=11||self.passWordText.text.length<6) {
        
        [self.loginBtn setTitleColor:color_999999 forState:UIControlStateNormal];
        
        self.loginBtn.backgroundColor=color_e1e1e1;

    }
    else
    {
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
        self.loginBtn.backgroundColor=color_51d4b9;
    }
    
}

#pragma mark- 登录按钮触发方法

-(void)loginselectorBtn
{
    
    WK(weakSelf);
    
    if (self.iphoneText.text.length == 0) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:@"手机号不能为空"];
        return;
    }
    
    if (self.passWordText.text.length == 0) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:@"密码不能为空"];
        return;
    }
    
    if ([RegisterHttp checkPassword:self.passWordText.text]) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:[RegisterHttp checkPassword:self.passWordText.text] spacingWithTop:kWindowHeight/2 stayTime:2];
        return;
    }

    NSString  *validMess1 = [RegisterHttp checkMobile:self.iphoneText.text];
    
    if(validMess1.length > 0){
        
        [ShowMessageTipUtil showTipLabelWithMessage:validMess1];
        return;
    }
    
    self.loginBtn.enabled = NO;
    [RegisterHttp loginWithPhoneNumber:self.iphoneText.text password:self.passWordText.text successJson:^(id json){
        if ([[json objectForKey:@"code"] intValue]==0) {
            
            [ShowMessageTipUtil showTipLabelWithMessage:@"登录成功" spacingWithTop:kWindowHeight/4*3.0 stayTime:2];
            // 存储帐号信息  并返回之前页面
            UserModel *user  = [[UserModel alloc] init];
            user.uid = [[json objectForKey:@"uid"] intValue];
            user.userNumber = self.iphoneText.text;
            user.token = [json objectForKey:@"token"];
            user.firstLogin = NO;
            [UserTool save:user];
            [UserTool updateUserOidAndCidWithBlcok:nil];
            
            //登录友盟分析
            [MobClick profileSignInWithPUID:[UserTool userModel].userNumber];
            [MobClick startWithConfigure:UMConfigInstance];
            
            //登录环信
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
    
            RootController *rootController = [[RootController alloc] init];
            rootController.view.backgroundColor = [UIColor whiteColor];
            
            [self.navigationController pushViewController:rootController animated:YES];
        }
        else
        {
            if ([[json objectForKey:@"message"] isEqualToString:@"无此用户"]) {
                
                [ShowMessageTipUtil showTipLabelWithMessage:@"该手机号未注册"];
                return ;
            }else if ([[json objectForKey:@"message"] isEqualToString:@"密码错误"]){
                
                [ShowMessageTipUtil showTipLabelWithMessage:@"密码错误，请重新输入"];
                return ;

            }else{
                
                [ShowMessageTipUtil showTipLabelWithMessage:[json objectForKey:@"message"]];
            }
            self.loginBtn.enabled = YES;

        }
        
        weakSelf.loginBtn.enabled = YES;
    }];
    weakSelf.loginBtn.enabled = YES;

}

#pragma mark- 注册触发方法

-(void)liJiZhuCeBtnselectorBtn
{
    
    RegisterViewController *registr=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registr animated:YES];
    
}

#pragma mark- 忘记密码触发方法

-(void)wangJiMiMaBtnselectorBtn
{
    
    ForgetPosswordViewController *forg=[[ForgetPosswordViewController alloc] init];

    [self.navigationController pushViewController:forg animated:YES];
    
}

#pragma mark- 添加视图到主页面

-(void)layoutSubviews{
    
    [self.view addSubview:self.iphoneBgView];
    
    [self.view addSubview:self.passWordBgView];
    
    [self.iphoneBgView addSubview:self.iphoneImgView];
    
    [self.passWordBgView addSubview:self.passWordImgView];
    
    [self.iphoneBgView addSubview:self.line1];
    
    [self.passWordBgView addSubview:self.line2];

    [self.iphoneBgView addSubview:self.iphoneText];
    
    [self.passWordBgView addSubview:self.passWordText];
    
    [self.view addSubview:self.loginBtn];

    [self.view addSubview:self.forgetBtn];

    [self.view addSubview:self.otherLable];
    
}

#pragma mark- 懒加载

-(UIView *)iphoneBgView{
    if (!_iphoneBgView) {
        
        _iphoneBgView = [[UIView alloc] init];
        _iphoneBgView.backgroundColor=[UIColor whiteColor];

    }
    return _iphoneBgView;
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

-(UITextField *)iphoneText{
    if (!_iphoneText) {
        
        _iphoneText = [[UITextField alloc] init];
        _iphoneText.placeholder=@"请输入手机号";
        _iphoneText.keyboardType = UIKeyboardTypeNumberPad;
        _iphoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _iphoneText.delegate=self;
        _iphoneText.font=[UIFont systemFontOfSize:14*HEIGHT_SCALE];
        _iphoneText.text = [UserTool userModel].userNumber;
        _iphoneText.tag = 1001;
        //添加监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:_iphoneText];
        


    }
    return _iphoneText;
}

-(UITextField *)passWordText{
    if (!_passWordText) {
        
        _passWordText = [[UITextField alloc] init];
        _passWordText.placeholder=@"请输入登录密码";
        [_passWordText setSecureTextEntry:YES];
        _passWordText.delegate=self;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoAction)name:UITextFieldTextDidChangeNotification object:nil];
        _passWordText.font=[UIFont systemFontOfSize:14*HEIGHT_SCALE];
        _passWordText.tag = 1003;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:_passWordText];
    }
    return _passWordText;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font=[UIFont systemFontOfSize:16*HEIGHT_SCALE];
        [_loginBtn.layer setMasksToBounds:YES];
        [_loginBtn.layer setCornerRadius:5*HEIGHT_SCALE];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor=color_24c9a7;
        [_loginBtn addTarget:self action:@selector(loginselectorBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton *)forgetBtn{
    if (!_forgetBtn) {
        
        _forgetBtn = [[UIButton alloc] init];
        [_forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font=[UIFont systemFontOfSize:14*HEIGHT_SCALE];
        [_forgetBtn.layer setMasksToBounds:YES];
        [_forgetBtn.layer setCornerRadius:8];
        [_forgetBtn setTitleColor:color_0f4068 forState:UIControlStateNormal];
        _forgetBtn.backgroundColor=[UIColor clearColor];
        [_forgetBtn addTarget:self action:@selector(wangJiMiMaBtnselectorBtn) forControlEvents:UIControlEventTouchUpInside];

    }
    return _forgetBtn;
}

#pragma mark 监听代理
-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    if (!textField) {
        return;
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
