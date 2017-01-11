//
//  PTTWebViewController.m
//  TestWebView_1102
//
//  Created by 赵广亮 on 2016/11/2.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTWebViewController.h"
#import <WebKit/WebKit.h>

@interface PTTWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong)WKWebView *wkWebView;

@end

@implementation PTTWebViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_24c9a7,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.pttTitle;
    
    //导航栏返回按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    //创建wkwebView
    //如果是带导航栏的话 wkWebView的高度应该是屏幕的高度减去导航栏的高度减去状态栏的高度  kWindowHeight -20 -44
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 64)];
    self.wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.wkWebView.navigationDelegate = self;
    
    //设置网址链接
    if (self.pttUrl) {
        
        NSURL *url = [NSURL URLWithString:self.pttUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [self.wkWebView loadRequest:request];
    }
    
    //添加到页面上去
    [self.view addSubview:self.wkWebView];
}

#pragma wkwebView代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    [PttLoadingTip startLoading];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [PttLoadingTip stopLoading];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    [PttLoadingTip stopLoading];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [PttLoadingTip stopLoading];
}

#pragma mark 按钮触发方法
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
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
