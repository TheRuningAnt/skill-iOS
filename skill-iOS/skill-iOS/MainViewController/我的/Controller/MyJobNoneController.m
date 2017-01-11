//
//  MyJobNoneController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/4.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "MyJobNoneController.h"
#import "JobsListController.h"

@interface MyJobNoneController ()

@end

@implementation MyJobNoneController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏标题
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"我的职业";
    
    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    //设置背景图片
    UIImageView *backImageV = [[UIImageView alloc] init];
    backImageV.frame = CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height - 20*HEIGHT_SCALE);
    backImageV.image = [UIImage imageNamed:@"my-back-img"];
    backImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backImageV];
    
    WK(weakSelf);
    
    //设置去报名按钮
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinBtn setTitle:@"去报名" forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinBtn setBackgroundColor:color_51d4b9];
    joinBtn.layer.masksToBounds = YES;
    joinBtn.layer.cornerRadius = 8;
    [self.view addSubview:joinBtn];
    [joinBtn addTarget:self action:@selector(joinClass) forControlEvents:UIControlEventTouchUpInside];
    
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-10*HEIGHT_SCALE);
        make.height.mas_equalTo(40*HEIGHT_SCALE);
        make.width.mas_equalTo(kWindowWidth - 20*WIDTH_SCALE);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
}

#pragma mark 按钮触发方法

//推出职业列表选择职业
-(void)joinClass{
    
    
    JobsListController *jobListVC = [[JobsListController alloc] init];
    [self.navigationController pushViewController:jobListVC animated:YES];
}

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
