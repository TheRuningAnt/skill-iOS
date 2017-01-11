

//
//  InputController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/5.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "InputController.h"
#import "PersonController.h"

@interface InputController ()<UITextViewDelegate>

/**
   创建文本输入框
 */
@property (nonatomic,strong) UITextView *textView;
/**
   提示输入字数的Label
 */
@property (nonatomic,strong) UILabel *tipLabel;
/**
   占位符label
 */
@property (nonatomic,strong) UILabel *placeLabel;
@end

@implementation InputController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:nil];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"输入修改个人信息模块"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //退出友盟页面统计
    [MobClick endLogPageView:@"输入修改个人信息模块"];
}

-(void)setUpUI{
    
    self.view.backgroundColor = color_e8efed;
    
    //设置导航栏标题
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = self.controlTitle;
    
    //导航栏返回按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    //导航栏右边的按钮
    UIButton *rigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rigthBtn.frame = CGRectMake(0,0, 50*HEIGHT_SCALE, 50*HEIGHT_SCALE) ;
    [rigthBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rigthBtn setTitleColor:color_24c8a8 forState:UIControlStateNormal];
    [rigthBtn setTitleColor:color_ffffff forState:UIControlStateHighlighted];
    rigthBtn.titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    [rigthBtn addTarget:self action:@selector(clikcSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rigthBtn];
    self.navigationItem.rightBarButtonItems = @[rightBarItem];
    
    //添加输入框
    [self.view addSubview:self.textView];
    
    //添加输入框提示label
    [self.view addSubview:self.tipLabel];
    
    //如果有需要默认显示编辑的文字,则显示出来 并且不需要将提示label添加到页面上
    if (self.userTipString.length != 0) {
        
        self.textView.text = self.userTipString;
    }else{
        
        //添加输入框提示文本label
        [self.view addSubview:self.placeLabel];
    }
}

#pragma mark 发起网络请求
/**
 点击保存按钮的时候发起更新个人信息的网络请求
 如果修改成功则返回上个页面,如果修改失败则停留在本页面
 */
-(void)clikcSaveBtn{
    
    if ([self.type isEqualToString:@"qq"]) {
        
        NSString *checkRes = [RegisterHttp checkQQ:self.textView.text];
        if (checkRes) {
            
            [ShowMessageTipUtil showTipLabelWithMessage:checkRes spacingWithTop:kWindowHeight/2 - 40 stayTime:2];
            return;
        }
    }
    
    if (self.textView.text.length < self.minLength) {
        
        [ShowMessageTipUtil showTipLabelWithMessage:[NSString stringWithFormat:@"文字长度应大于%lu个字符",(long)self.minLength] spacingWithTop:kWindowHeight/2.0 stayTime:2];
        return;
    }else if(self.textView.text.length > self.maxLength){
        
        [ShowMessageTipUtil showTipLabelWithMessage:[NSString stringWithFormat:@"文字长度应小于%lu个字符",(long)self.maxLength] spacingWithTop:kWindowHeight/2 stayTime:2];
        return;
    }
    
    //提取数组model 里的数据添加到修改个人信息的参数Dic里
    
    NSMutableDictionary *paramentsDic = [NSMutableDictionary dictionary];
    [paramentsDic setObject:self.model.thumb forKey:@"thumb"];
    [paramentsDic setObject:self.model.nick forKey:@"nick"];
    [paramentsDic setObject:[NSString stringWithFormat:@"%lu",(long)self.model.birthday] forKey:@"birthday"];
    [paramentsDic setObject:self.model.qq forKey:@"qq"];
    [paramentsDic setObject:self.model.school forKey:@"school"];
    [paramentsDic setObject:[NSString stringWithFormat:@"%lu",(long)self.model.city] forKey:@"city"];
    [paramentsDic setObject:[NSString stringWithFormat:@"%lu",(long)self.model.province] forKey:@"province"];
    [paramentsDic setObject:self.model.sign forKey:@"sign"];
    [paramentsDic setObject:[UserTool userModel].token forKey:@"token"];
    
    //更新请求参数里该次修改的数据
    [paramentsDic setObject:self.textView.text forKey:self.type];
    
    //发送网络请求
    WK(weakSelf);
    [HttpService sendPutHttpRequestWithUrl:API_ChangePersonInfo paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
        
        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
            if ([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]) {
                
                [ShowMessageTipUtil showTipLabelWithMessage:@"修改成功" spacingWithTop:kWindowHeight/2 stayTime:2];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                
                [ShowMessageTipUtil showTipLabelWithMessage:[jsonDic objectForKey:@"message"]spacingWithTop:kWindowHeight/2 stayTime:2];
            }
        }
    }];
}

#pragma mark textField 代理

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (self.placeLabel.superview) {
        
        [self.placeLabel removeFromSuperview];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    self.tipLabel.text = [NSString stringWithFormat:@"%lu/%lu",textView.text.length,self.maxLength];
}

#pragma mark 按钮触发方法

//返回上个页面
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITextView *)textView{
    
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, kWindowWidth, 80*HEIGHT_SCALE)];
        _textView.font = [UIFont systemFontOfSize:17*WIDTH_SCALE];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
    }
    return _textView;
}

-(UILabel *)tipLabel{
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth - 60*WIDTH_SCALE, 60*HEIGHT_SCALE, 60*WIDTH_SCALE, 30)];
        _tipLabel.textColor = color_8ea9bc;
        _tipLabel.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
        if (self.userTipString) {
            
            _tipLabel.text = [NSString stringWithFormat:@"%lu/%lu",self.userTipString.length,self.maxLength];
        }else{
            
            _tipLabel.text = [NSString stringWithFormat:@"0/%lu",self.maxLength];
        }
    }
    return _tipLabel;
}

-(UILabel *)placeLabel{
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 30, 240, 30)];
        if (self.userTipString.length != 0) {
            
            self.textView.text = self.userTipString;
        }else{
            
            _placeLabel.text = self.tipString;
        }
        _placeLabel.textColor = color_7892a5;
        _placeLabel.font = [UIFont systemFontOfSize:15*WIDTH_SCALE];
        _placeLabel.backgroundColor = [UIColor whiteColor];
    }
    return _placeLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
