//
//  WirteDailyController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/8.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "WebDailyDetailController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "TaskDetailController.h"
#define TRUSTED_HOST @"192.168.1.2"

/**
    定义webView协议
 */

@protocol WebDailyProtocol <JSExport>

-(void)getTaskId:(id)taskId;
-(void)getTask:(id)taskId;
-(int)mine;

@end

/**
   创建web日报详情页面
 */
@interface WebDailyDetailController()<UIWebViewDelegate,WebDailyProtocol>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) NSURLConnection *urlConnection;

@property (nonatomic,assign) BOOL authenticated;

@property (nonatomic,strong) NSURLRequest *request;

@end

@implementation WebDailyDetailController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.translucent = YES;
    
    //设置导航栏背景透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"日报详情模块"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadHtml];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"日报详情模块"];
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

//加载html页面
-(void)loadHtml{
    
    NSString *baseUrl = nil;
    
    //测试环境
    if ([API_General isEqualToString:@"http://test.skill.ptteng.com"]) {
        baseUrl = [NSString stringWithFormat:@"http://test.mobile.skill.ptteng.com/index2.html?"];
    }
    //开发环境
    if ([API_General isEqualToString:@"http://dev.home.skill.ptteng.com"]) {
        baseUrl = [NSString stringWithFormat:@"http://dev.mobile.skill.ptteng.com/index2.html?"];
    }
    
    //线上环境
    if ([API_General isEqualToString:@"https://www.jnshu.com"]) {
        baseUrl = [NSString stringWithFormat:@"https://www.jnshu.com/webview/index2.html?"];
    }
    
    NSString* encodedToken = [[UserTool userModel].token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *subString = [NSString stringWithFormat:@"%@did=%lu&&token=%@",baseUrl,self.did,encodedToken];

    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:subString]];
    [self.webView loadRequest:_request];
    
}

#pragma mark webView代理
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    WK(weakSelf);
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"back"] = ^{
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    //js调用oc传值
    context[@"iOS"] = self;
    
//    //获取本地Html tag值
//    UserModel *model = [UserTool userModel];
//    NSString *htmlExecute = [NSString stringWithFormat:@"mine('%lu')",model.htmlTag];
//    [context evaluateScript:htmlExecute];

}

//获取任务id 并推出任务详情
-(void)getTaskId:(id)taskId{
    
    if (!taskId || [taskId integerValue] == 0) {
        
        return;
    }
    
    TaskDetailController *taskVC = [[TaskDetailController alloc] init];
    taskVC.weatherPresent = YES;
    taskVC.taskId = [taskId integerValue];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:taskVC];

    dispatch_async(dispatch_get_main_queue(), ^{
      
       [self presentViewController:nav animated:YES completion:nil];
   });
}

//改变本地tag值
-(void)getTask:(id)taskId{
    
    UserModel *model = [UserTool userModel];
    model.htmlTag = 1;
    [UserTool save:model];
}

//返回参数
-(int)mine{
    
    UserModel *model = [UserTool userModel];
    return  (int)model.htmlTag;
}

#pragma mark 懒加载
-(UIWebView *)webView{
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, kWindowWidth, self.view.frame.size.height- 20)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        UISwipeGestureRecognizer *swipeToLeft= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(webViewBack)];
        swipeToLeft.direction = UISwipeGestureRecognizerDirectionRight;
        
        [_webView addGestureRecognizer:swipeToLeft];
    }
    return _webView;
}

-(void)webViewBack{
    
    [self.webView goBack];
}

#pragma mark test code 修改https之后增加验证证书代码=======================================

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authenticated);
    
    if (!_authenticated) {
        
        _authenticated = NO;
        
        _urlConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
        
        [_urlConnection start];
        
        return NO;
    }
    return YES;
}

#pragma mark - NURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [self.webView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
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
