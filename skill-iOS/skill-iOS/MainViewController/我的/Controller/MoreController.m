//
//  MoreController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/5.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "MoreController.h"
#import "PTTWebViewController.h"

@interface MoreController ()<UITableViewDelegate,UITableViewDataSource>

/**
 tableView cell 的标题数组
 */
@property (nonatomic,strong) NSArray *titles;

/**
 dailyIds 数组
 */
@property (nonatomic,strong) NSArray *dailyIds;
/**
   tableView cell 的图片数组
 */
@property (nonatomic,strong) NSArray *cellImages;

@end

@implementation MoreController

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
    [MobClick beginLogPageView:@"更多模块"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //退出友盟页面统计
    [MobClick endLogPageView:@"更多模块"];
}

-(void)setUpUI{
    
    self.view.backgroundColor = color_e8efed;
    
    //设置导航栏标题
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"更多";
    
    //导航栏返回按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    //创建下方的tableView
    UITableView *moreTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kWindowWidth, 60*self.titles.count*HEIGHT_SCALE) style:UITableViewStylePlain];
    moreTableV.delegate = self;
    moreTableV.dataSource = self;
    [moreTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    moreTableV.tableFooterView = [[UIView alloc] init];
    moreTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    moreTableV.scrollEnabled = 0;
    [self.view addSubview:moreTableV];
}

#pragma mark tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = color_0f4068;
    cell.imageView.image = [UIImage imageNamed:self.cellImages[indexPath.row]];
    
    if (indexPath.row != self.titles.count - 1) {
        
        UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59.5 * HEIGHT_SCALE, kWindowWidth, 0.5)];
        lineLabel.backgroundColor = color_dfeaff;
        [cell addSubview:lineLabel];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60*HEIGHT_SCALE;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    PTTWebViewController *webViewVC = [[PTTWebViewController alloc] init];
    webViewVC.pttTitle = self.titles[indexPath.row];
    webViewVC.pttUrl = [NSString stringWithFormat:@"http://www.jnshu.com/#/daily/%@",self.dailyIds[indexPath.row]];
    
    [self.navigationController pushViewController:webViewVC animated:YES];
}

#pragma mark 按钮触发方法

//返回上个页面
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 懒加载

-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"线下报名",@"学费减免",@"任务闯关",@"换班申请"];
    }
    return _titles;
}

-(NSArray*)cellImages{
    if (!_cellImages) {
        _cellImages = @[@"signup-icon",@"free-icon",@"task-icon",@"change-icon"];
    }
    return _cellImages;
}

-(NSArray *)dailyIds{
    if (!_dailyIds) {
        _dailyIds = @[@"11199",@"9147",@"3210",@"3217"];
    }
    return _dailyIds;
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
