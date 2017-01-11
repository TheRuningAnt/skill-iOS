//
//  AboutViewController.m
//  skill-iOS
//
//  Created by ptteng on 16/11/4.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) UIImageView       *logImgView;

@property (nonatomic, strong) UILabel        *aboutL;

@end

@implementation AboutViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"关于我们模块"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNavigationUI];
    [self addSubViews];
    [self initViewLayout];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //退出友盟页面统计
    [MobClick endLogPageView:@"关于我们模块"];
}

//自定义导航栏
-(void)setupNavigationUI{
    
    self.view.backgroundColor = color_ffffff;
    //设置导航栏标题
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"关于我们";
    
    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[item1];    
}
#pragma - -- - -- --- -- 页面布局部分 - - - -  - -
-(void)addSubViews{
    _logImgView = [[UIImageView alloc] init];
    _logImgView.image = [UIImage imageNamed:@"about_logo"];
    [self.view addSubview:_logImgView];
    
    _aboutL = [[UILabel alloc] init];
    _aboutL.userInteractionEnabled = NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    _aboutL.attributedText = [[NSAttributedString alloc] initWithString:@"        修真院是北京葡萄藤信息技术有限公司旗下的互动式教学平台，相比于传统的文档预览，文字分享、在线视频等被动教育模式，修真院联合数十位业界大咖，亲临实战，保证课程体系独家研发，融入真实项目，紧跟最新技术，化繁为简，只教有用的，只教实践的。无论你是初涉程序的小白，将入职场的菜鸟，还是已有建树的行家，我们都希望与你并肩阔步，见证你的成长，分享你成功的喜悦。" attributes:attributes];    
    _aboutL.textColor = color_0f4068;
    _aboutL.numberOfLines = 0;
    _aboutL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_aboutL];
}
-(void)initViewLayout{
    WK(weakself);
    [self.logImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        make.top.mas_equalTo(weakself.view.mas_top).offset(30);
        make.size.mas_equalTo(weakself.logImgView.image.size);
    }];
 
    [self.aboutL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.logImgView.mas_bottom).offset(20);
        make.left.mas_equalTo(weakself.view.mas_left).offset(34);
        make.right.mas_equalTo(weakself.view.mas_right).offset(-34);
        make.height.mas_equalTo(250);
    }];
}
#pragma  - - -  - -点击方法  - -  - - - -
//返回上个页面
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
