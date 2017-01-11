//
//  SetViewController.m
//  skill-iOS
//
//  Created by ptteng on 16/11/4.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "SetViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "LoginViewController.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView       *setTableView;//设置table

@property (nonatomic, strong) NSMutableArray    *imgArray;//图片array

@property (nonatomic, strong) NSMutableArray    *titleaArray;//标题array

@property (nonatomic, strong) UIButton          *logoutButton;//退出登录按钮

@end

@implementation SetViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setShadowImage:nil];

    _imgArray = [NSMutableArray arrayWithObjects:@"set_about",@"set_version", nil];
    _titleaArray = [NSMutableArray arrayWithObjects:@"关于我们",@"当前版本", nil];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"设置模块"];
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
    [MobClick endLogPageView:@"设置模块"];
}

//自定义导航栏
-(void)setupNavigationUI{

    self.view.backgroundColor = color_e8efed;
    
    //设置导航栏标题
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"设置";
    
    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[item1];
}
#pragma - - - - - - -  - - - - - 页面布局部分 - - - -  - - - - -
-(void)addSubViews{
    
    _setTableView = [[UITableView alloc] init];
    _setTableView.backgroundColor = color_ffffff;
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    _setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _setTableView.scrollEnabled = NO;
    [self.view addSubview:_setTableView];
    
    //退出登录按钮
    _logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutButton setTitleColor:color_24c9a8 forState:UIControlStateNormal];
    _logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_logoutButton addTarget:self action:@selector(onClickLogoutButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    _logoutButton.backgroundColor = color_ffffff;
    [self.view addSubview:_logoutButton];
    
    
}
-(void)initViewLayout{
    WK(weakself);
    [self.setTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.view.mas_left);
        make.top.mas_equalTo(weakself.view.mas_top).offset(10*HEIGHT_SCALE);
        make.right.mas_equalTo(weakself.view.mas_right);
        make.height.equalTo(@120);
    }];
    //退出登录按钮
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.setTableView.mas_bottom).offset(20*HEIGHT_SCALE);
        make.height.equalTo(@60);
        make.left.mas_equalTo(weakself.view.mas_left);
        make.right.mas_equalTo(weakself.view.mas_right);
    }];
}
#pragma - - - - - - -  - - - - - 点击方法部分 - - - -  - - - - -

//返回上个页面
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//点击退出登录按钮
-(void)onClickLogoutButtonMethod{
    
    [PTTShowAlertView showAlertViewWithTitle:@"提示" message:@"确定要注销登录吗?" cancleBtnTitle:@"取消" cancelAction:nil sureBtnTitle:@"确定" sureAction:^{
        
                    //清除用户信息
                    [UserTool clearUserInfo];
                    
                    //退出友盟统计信息
                    [MobClick profileSignOff];
                    
                    //退出环信推送
                    EMError *error = [[EMClient sharedClient] logout:YES];
                    if (!error) {
                        NSLog(@"退出环信成功");
                    }
                
                    //返回登录页面
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    
                    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    }];
}

#pragma - - - - - - UITableViewDelegate,UITableViewDataSource - - - - -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellString = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellString];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    UIImage *image = [UIImage imageNamed:self.imgArray[indexPath.section]];
    CGSize size = image.size;
    cell.imageView.image = image;

    //调整image的大小
    UIGraphicsBeginImageContextWithOptions(size, NO,0.0);
    CGRect imageRect=CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    cell.imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = self.titleaArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = color_0f4068;

    if (indexPath.row == 0) {
        
        UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59.5, kWindowWidth, 0.5)];
        lineLabel.backgroundColor = color_dfeaff;
        [cell addSubview:lineLabel];
    }else{
    
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = app_Version;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = color_7892a5;
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    
    return cell;
    
}
//点击列表项
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //点击关于我们
            AboutViewController * about = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];

        }
            break;
        case 1:
        {
            //点击当前版本

        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
