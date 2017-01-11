//
//  WirteDailyController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/8.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "WirteDailyController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WirteDailyController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) NSURLConnection *urlConnection;

@property (nonatomic,assign) BOOL authenticated;

@property (nonatomic,strong) NSURLRequest *request;

@end

@implementation WirteDailyController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"写日报模块"];
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
    [MobClick endLogPageView:@"写日报模块"];
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}

//加载html页面
-(void)loadHtml{
    
    NSString* encodedToken = [[UserTool userModel].token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *baseUrl = nil;
    
    //测试环境
    if ([API_General isEqualToString:@"http://test.skill.ptteng.com"]) {
        baseUrl = [NSString stringWithFormat:@"http://test.mobile.skill.ptteng.com/index.html?"];
    }
    //开发环境
    if ([API_General isEqualToString:@"http://dev.home.skill.ptteng.com"]) {
        baseUrl = [NSString stringWithFormat:@"http://dev.mobile.skill.ptteng.com/index.html?"];
    }
    //线上环境
    if ([API_General isEqualToString:@"https://www.jnshu.com"]) {
        baseUrl = [NSString stringWithFormat:@"https://www.jnshu.com/webview/index.html?"];
    }

    
    
    NSString *strOfUrl = [NSString stringWithFormat:@"%@token=%@&cid=%d&oid=%d",baseUrl,encodedToken,[UserTool userModel].cid,[UserTool userModel].oid];
    
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strOfUrl]];
    
    [self.webView loadRequest:_request];
}

#pragma mark webView代理
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    WK(weakSelf);
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"rBack"] = ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    };
}

#pragma mark 懒加载
-(UIWebView *)webView{
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, kWindowWidth, self.view.frame.size.height - 20)];
        _webView.delegate = self;
    }
    return _webView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark test code=======================================

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
