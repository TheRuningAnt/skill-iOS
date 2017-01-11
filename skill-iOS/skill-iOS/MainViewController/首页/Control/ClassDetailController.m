//
//  ClClassDetailController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/27.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "ClassDetailController.h"
#import "ClassDetailModel.h"
#import "SwitchoverTwoTableView.h"
#import "DailyCell.h"
#import "DailyModel.h"
#import "ClassmateCell.h"
#import "PersonModel.h"
#import "SignupController.h"
#import "MineController.h"
#import "WebDailyDetailController.h"
#import "PTTWebViewController.h"

@interface ClassDetailController()<UITableViewDelegate,UITableViewDataSource>
/**
 *  存放上方控件的容器视图
 */
@property (nonatomic,strong) UIView *topContentView;
/**
 *  班级头像
 */
@property (nonatomic,strong) UIImageView *headImageV;
/**
 *  班级名
 */
@property (nonatomic,strong) UILabel *className;
/**
 *  QQ群
 */
@property (nonatomic,strong) UILabel *qqLabel;
/**
 *  时间
 */
@property (nonatomic,strong) UILabel *timeLabel;
/**
 *  班级宣言
 */
@property (nonatomic,strong) UILabel *classWord;
/**
 *  班级详情Model
 */
@property (nonatomic,strong) ClassDetailModel *classDetailModel;
/**
 *  设置默认的加载页面数据长度
 */
@property (nonatomic,assign) NSInteger pageSize;
/**
 *  创建两个tableView的容器
 */
@property (nonatomic,strong) SwitchoverTwoTableView *switchTwoTabelView;

/**
 *  班级日报tableView
 */
@property (nonatomic,strong) UITableView *classDailyTableView;
/**
 *  存放班级日报model数组
 */
@property (nonatomic,strong) NSMutableArray *classDailyModels;
/**
 *  日报页面当前加载的页面下标
 */
@property (nonatomic,assign) NSInteger currentClassDailyPage;

/**
 *  班级同门tableView
 */
@property (nonatomic,strong) UITableView *classMateTableView;
/**
 *  班级同门model数组
 */
@property (nonatomic,strong) NSMutableArray *classMateModels;
/**
 *  加入班级按钮
 */
@property (nonatomic,strong) UIButton *joinBtn;
/**
 创建班级同门无数据占位图
 */
@property (nonatomic,strong) UIImageView *nonClassmaetImageV;
/**
 创建班级日报无数据占位图
 */
@property (nonatomic,strong) UIImageView *nonDailyImageV;

//是否将要从线下报名页面返回的标志值
@property (nonatomic,assign) BOOL returenFromWeb;
@end

@implementation ClassDetailController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //设置导航栏背景透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //从不同页面返回需要设置不同的navigationBar.translucent属性
    if (_returenFromWeb) {
        self.navigationController.navigationBar.translucent = NO;
    }else{
        self.navigationController.navigationBar.translucent = YES;
    }
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"班级详情模块"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _returenFromWeb = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化数据
    [self initializeData];
    
    //布局界面
    [self setupUI];
    
    //请求上方头视图数据并更新界面
    [self loadHeadAndClassMateData];
    
    //请求班级日报数据
    [self loadClassDailyData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"班级详情模块"];
    
    [PttLoadingTip stopLoading];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initializeData{
    
    self.currentClassDailyPage = 1;
    self.pageSize = 10;
}

#pragma mark 添加设置子控件
-(void)setupUI{
    
    //当点击班级同门的时候,界面会偏移出视图外围,导致点击返回按钮的时候界面动画异常,所以设置本页面超出视图外的部分不显示
    self.view.layer.masksToBounds = YES;
    self.view.clipsToBounds = YES;
    
    /**
     *  设置上方显示头像区域的视图
     */
    WK(weakSelf);
    
    self.topContentView = [[UIView alloc] init];
    self.topContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topContentView];
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 220*HEIGHT_SCALE));
        make.left.mas_equalTo(weakSelf.view.mas_left);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWindowWidth - 200*WIDTH_SCALE)/2, 22, 200*WIDTH_SCALE, 40)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20*WIDTH_SCALE];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"班级详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    //设置导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"job-detail-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(10,22, 40*HEIGHT_SCALE, 40*HEIGHT_SCALE) ;
    //[button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //设置背景图
    UIImageView *bacImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job-background"]];
    [self.topContentView addSubview:bacImageView];
    [bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 220*HEIGHT_SCALE));
    }];
    
    //设置班级头像
    [self.topContentView addSubview:self.headImageV];
    self.headImageV.image = [UIImage imageNamed:@"men-image"];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(bacImageView.mas_top).offset(80);
        make.left.mas_equalTo(@(8*HEIGHT_SCALE));
        make.size.mas_equalTo(CGSizeMake(115*HEIGHT_SCALE, 115*HEIGHT_SCALE));
    }];
    
    //设置班级名字
    [self.topContentView addSubview:self.className];
    self.className.textColor = [UIColor whiteColor];
    self.className.text = @"班级:--";
    self.className.font = [UIFont systemFontOfSize:15*HEIGHT_SCALE];
    [self.className mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(bacImageView.mas_top).offset(80);
        make.left.mas_equalTo(weakSelf.headImageV.mas_right).offset(7);
        make.right.mas_equalTo(weakSelf.topContentView.mas_right);
        make.height.mas_equalTo(30*HEIGHT_SCALE);
    }];
    
    //创建QQ群
    [self.topContentView addSubview:self.qqLabel];
    self.qqLabel.textColor = [UIColor whiteColor];
    self.qqLabel.text = @"qq:--";
    self.qqLabel.font = [UIFont systemFontOfSize:15*HEIGHT_SCALE];
    self.qqLabel.adjustsFontSizeToFitWidth = YES;
    [self.qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.className.mas_bottom).offset(0);
        make.left.mas_equalTo(weakSelf.headImageV.mas_right).offset(7);
        make.right.mas_equalTo(weakSelf.topContentView.mas_right);
        make.height.mas_equalTo(30*HEIGHT_SCALE);
    }];
    
    //创建时间
    [self.topContentView addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.text = @"time:--";
    self.timeLabel.font = [UIFont systemFontOfSize:15*HEIGHT_SCALE];
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.qqLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(weakSelf.headImageV.mas_right).offset(7);
        make.right.mas_equalTo(weakSelf.topContentView.mas_right);
        make.height.mas_equalTo(30*HEIGHT_SCALE);
    }];
    
    //创建宣言Label
    [self.topContentView addSubview:self.classWord];
    self.classWord.textColor = [UIColor whiteColor];
    self.classWord.text = @"word:--";
    self.classWord.font = [UIFont systemFontOfSize:15*HEIGHT_SCALE];
    self.classWord.numberOfLines = 0;
    self.classWord.adjustsFontSizeToFitWidth = YES;
    [self.classWord mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.timeLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(weakSelf.headImageV.mas_right).offset(7);
        make.right.mas_equalTo(weakSelf.topContentView.mas_right);
        make.height.mas_equalTo(35*HEIGHT_SCALE);
    }];
    
    /**
     * 逻辑: 因为有班级的情况多于没有班级的情况,为了保证体验,默认不留出 加入 按钮的空间.创建控件的时候判断是否有班级,有班级不创建加入按钮,没有班级创建加入按钮并添加到页面上,但是按钮隐藏掉.班级详情数据下来后根据班级状态以及当前用户的班级状态,决定按钮是否显示并调整子视图的高度
     *
     */
    //添加下方的内容子视图  默认是已经有班级 注册过的 所以不需要显示下方的 加入 按钮
    self.switchTwoTabelView = [[SwitchoverTwoTableView alloc] initWithFrame:CGRectMake(0,220*HEIGHT_SCALE, kWindowHeight, kWindowHeight - 220*HEIGHT_SCALE) FirstBtnTitle:@"班级日报" firstView:self.classDailyTableView firstAction:nil sectionBtnTitle:@"班级同门" secondView:self.classMateTableView secondAction:nil tabBaeHidden:1];
    
    //如果需要默认显示班级同门列表,则将switchTwoTabelView滑动到班级同门列表处
    if (self.selectMatesV) {
        
        [self.switchTwoTabelView selectSecontView];
    }
    
    [self.view addSubview:self.switchTwoTabelView];
    
    if([UserTool userClassId] < 0){
        
        self.joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.joinBtn setTitle:@"报名" forState:UIControlStateNormal];
        [self.joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.joinBtn setBackgroundColor:color_51d4b9];
        self.joinBtn.hidden = YES;
        [self.view addSubview:self.joinBtn];
        [self.joinBtn addTarget:self action:@selector(joinClass) forControlEvents:UIControlEventTouchUpInside];
        
        [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
            make.height.mas_equalTo(50*HEIGHT_SCALE);
            make.width.mas_equalTo(kWindowWidth);
        }];
    }
}

#pragma mark 网络请求

//获取上方班级信息数据
-(void)loadHeadAndClassMateData{
    
    WK(weakSelf);
    
    //检测网络链接
    KCheckNetWorkAndRetuen(^(){
        [weakSelf.classMateModels removeAllObjects];
        [weakSelf.classMateTableView reloadData];
        [weakSelf.classMateTableView.mj_header endRefreshing];
    })
    
    NSString *urlOfStr = [NSString stringWithFormat:@"%@/a/classes/detail?cid=%lu",API_General ,self.cid];

    [HttpService sendGetHttpRequestWithUrl:urlOfStr paraments:nil successBlock:^(NSDictionary *jsonDic) {

        if ([jsonDic isKindOfClass:[NSDictionary class]]) {
            
            NSArray *arrayOfRoot = [jsonDic objectForKey:@"classes"];
            NSDictionary *dicOfData = [arrayOfRoot firstObject];
            if (dicOfData) {
                
                [self.classDetailModel setValuesForKeysWithDictionary:dicOfData];
            }
            
            /**
             *  如果后台数据库测试数据 班号不存在的话  则置为*
             */
            NSString *classTotalName = nil;
            NSString *className = nil;
            className = weakSelf.classDetailModel.name ? weakSelf.classDetailModel.name : @"*";
            
            if ([self.classDetailModel.type isEqualToString:@"online"]) {
                
                classTotalName = [NSString stringWithFormat:@"线上%@  【%@】班",self.jobName,className];
            }else if([self.classDetailModel.type isEqualToString:@"offline"]) {
                
                classTotalName = [NSString stringWithFormat:@"线下%@  【%@】班",self.jobName,className];
            }else{
                
                classTotalName = [NSString stringWithFormat:@"%@  【%@】班",self.jobName,className];
            }
            
            //获取用户列表数据
            NSDictionary *usersDic= [jsonDic objectForKey:@"users"];
            NSArray *usersKeys = [usersDic allKeys];
            
            if (usersKeys && usersKeys.count != 0) {
                
                [usersKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (obj) {
                        
                        NSDictionary *dicOfUser = [usersDic objectForKey:obj];
                        
                        __block PersonModel *model = [PersonModel new];
                        [model setValuesForKeysWithDictionary:dicOfUser];
                        [self.classMateModels addObject:model];
                    }
                }];
            }
            
            //解析relation字段  获取每个人的誓言
            NSMutableDictionary *dicOfNumAndSwear = [NSMutableDictionary dictionary];
            NSDictionary *dicOfRelation = [jsonDic objectForKey:@"relations"];
            NSArray *arrayOfRelation = [dicOfRelation objectForKey:[NSString stringWithFormat:@"%lu",weakSelf.cid]];
            if (arrayOfRelation && arrayOfRelation.count != 0) {
                
                [arrayOfRelation enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                        
                        NSInteger num = [[obj objectForKey:@"num"] integerValue];
                        NSString *swear = [obj objectForKey:@"swear"];
                        [dicOfNumAndSwear setValue:swear forKey:[NSString stringWithFormat:@"%lu",num]];
                    }
                }];
            }
            
            //使用dicOfNumAndSwear来对Model的swear 赋值
            [weakSelf.classMateModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj && [obj isKindOfClass:[PersonModel class]]) {
                    
                    PersonModel *model = (PersonModel*)obj;
                    model.swear = [dicOfNumAndSwear objectForKey:[NSString stringWithFormat:@"%lu",model.studyNumber]];
                }
            }];
            
            //更新班级信息界面  和 下方同门列表信息
            dispatch_async(dispatch_get_main_queue(), ^{
                
                /**
                 *  更新班级信息
                 */
                weakSelf.className.text = classTotalName;
                weakSelf.qqLabel.text = [NSString stringWithFormat:@"qq群：%lu",(long)weakSelf.classDetailModel.qq];
                weakSelf.timeLabel.text = [PTTDateKit dateLineFormatFrom1970WithTimeInterval:weakSelf.classDetailModel.createAt];
                if (weakSelf.classDetailModel.content.length != 0) {
                    weakSelf.classWord.text =[NSString stringWithFormat:@"班级宣言：%@",weakSelf.classDetailModel.content];
                }else{
                    weakSelf.classWord.text = @"班级宣言：无";
                }
                [weakSelf.headImageV sd_setImageWithURL:[NSURL URLWithString:weakSelf.classDetailModel.img] placeholderImage:[UIImage imageNamed:@"men-image"]];
                
                //如果同门列表没数据的话  则加上无数据占位图
                if (weakSelf.classMateModels.count == 0) {
                    
                    [weakSelf.classMateTableView addSubview:weakSelf.nonClassmaetImageV];
                }
                
                /**
                 *  更新同门列表信息
                 */
                [weakSelf.classMateTableView reloadData];
                [weakSelf.classMateTableView.mj_header endRefreshing];
                
                //判断是否添加 显示 加入  按钮
                if ([UserTool userClassId] < 0 && self.classMateModels.count < 20 && self.joinBtn) {
                    
                    weakSelf.joinBtn.hidden = NO;
                    [weakSelf.switchTwoTabelView changHeight:-50*HEIGHT_SCALE];
                }
            });
        }
    }];
}

//获取班级日报数据
-(void)loadClassDailyData{
    
    [self.classDailyModels removeAllObjects];
    [self.classDailyTableView reloadData];
    
    WK(weakSelf);
    KCheckNetWorkAndRetuen(^(){
        [weakSelf.classDailyTableView.mj_header endRefreshing];
        [weakSelf.classDailyTableView.mj_footer endRefreshing];
    })
    
    self.currentClassDailyPage = 1;
    
    //拼接字符串参数
    NSMutableDictionary *paramensDic = [NSMutableDictionary dictionary];
    [paramensDic setValue:[NSString stringWithFormat:@"%lu",self.cid] forKey:@"cid"];
    [paramensDic setValue:[NSString stringWithFormat:@"%lu",self.currentClassDailyPage] forKey:@"page"];
    [paramensDic setValue:[NSString stringWithFormat:@"%lu",self.pageSize] forKey:@"size"];
    
    [self loadClassDailyDataParaments:paramensDic];
}

//获取更多班级日报数据

-(void)loadMoreClassDailyOnlineData{
    
    WK(weakSelf);
    KCheckNetWorkAndRetuen(^(){
        [weakSelf.classDailyTableView.mj_header endRefreshing];
        [weakSelf.classDailyTableView.mj_footer endRefreshing];
    })
    
    self.currentClassDailyPage ++;
    
    //拼接字符串参数
    NSMutableDictionary *paramensDic = [NSMutableDictionary dictionary];
    [paramensDic setValue:[NSString stringWithFormat:@"%lu",self.cid] forKey:@"cid"];
    [paramensDic setValue:[NSString stringWithFormat:@"%lu",self.currentClassDailyPage] forKey:@"page"];
    [paramensDic setValue:[NSString stringWithFormat:@"%lu",self.pageSize] forKey:@"size"];
    
    [self loadClassDailyDataParaments:paramensDic];
    
}

//加载班级日报数据和请求更多日日报数据调用方法
-(void)loadClassDailyDataParaments:(NSDictionary*)paraments{
    
    WK(weakSelf);
    
    [PttLoadingTip startLoading];
    
    [HttpService sendGetHttpRequestWithUrl:API_ClassDaily paraments:paraments successBlock:^(NSDictionary *jsonDic) {
        
        NSInteger numberBeforeLoad = self.classDailyModels.count;
        
        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
            //解析班级日报数据
            NSArray *rootArray = [jsonDic valueForKey:@"dailies"];
            
            if (rootArray && rootArray.count != 0) {
                
                [rootArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ( obj && [obj isKindOfClass:[NSDictionary class]]) {
                        
                        DailyModel *model = [DailyModel new];
                        
                        //设置日报属性数据 这里可以获取到用户的uid
                        [model setValuesForKeysWithDictionary:obj];
                        
                        //获取班级编号
                        NSDictionary *classDic = [jsonDic objectForKey:@"classes"];
                        if (classDic && [classDic isKindOfClass:[NSDictionary class]] && classDic.count > 0) {
                            
                            NSDictionary *calssValueDic = [[classDic allValues] firstObject];
                            if (calssValueDic) {
                                
                                model.name = [[calssValueDic objectForKey:@"name"] integerValue];
                            }
                        }
                        
                        //获取当前用户的任务列表  将json字符串编码解码获取数据
                        NSString *tidsStr =  [obj objectForKey:@"tids"];
                        NSData *data = [tidsStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray* tids = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        
                        //获取用户头像 使用uid去匹配
                        NSDictionary *dicOfUsers = [jsonDic objectForKey:@"users"];
                        if (dicOfUsers && dicOfUsers.count != 0) {
                            
                            NSDictionary *currentUserInfo = [dicOfUsers objectForKey:[NSString stringWithFormat:@"%lu",model.uid]];
                            if (currentUserInfo) {
                                
                                model.thumb = [currentUserInfo objectForKey:@"thumb"];
                                model.nick = [currentUserInfo objectForKey:@"nick"];
                            }
                        }
                        
                        //获取用户任务编号
                        NSDictionary *taskDic = [jsonDic objectForKey:@"tasks"];
                        if (taskDic && taskDic.count != 0) {
                            
                            model.taskNumbers = [NSMutableArray array];
                            //遍历数组获取用户的任务编号
                            if (tids && [tids isKindOfClass:[NSArray class]]) {
                                [tids enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    
                                    NSDictionary *subTasksDic = [taskDic objectForKey: [NSString stringWithFormat:@"%lu",[obj integerValue]]];
                                    if (subTasksDic) {
                                        
                                        NSInteger num = [[subTasksDic objectForKey:@"num"] integerValue];
                                        [model.taskNumbers addObject:@(num)];
                                    }
                                }];
                            }
                        }
                        
                        [self.classDailyModels addObject:model];
                    }
                }];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [PttLoadingTip stopLoading];
            
            //如果班级日报无数据的话 则加上无数据的提示图片
            if ([[paraments objectForKey:@"page"] integerValue] == 1 && weakSelf.classDailyModels.count == 0 && !weakSelf.nonDailyImageV.superview) {
                
                [weakSelf.classDailyTableView addSubview:weakSelf.nonDailyImageV];
            }
            
            //如果班级日报没有新数据的话 则给用户提示
            if (numberBeforeLoad == weakSelf.classDailyModels.count && [[paraments objectForKey:@"page"] integerValue] != 1) {
                
                [ShowMessageTipUtil showTipLabelWithMessage:@"没有更多数据了" spacingWithTop:kWindowHeight/2 stayTime:2];
            }
            
            [weakSelf.classDailyTableView.mj_header endRefreshing];
            [weakSelf.classDailyTableView.mj_footer endRefreshing];
            [weakSelf.classDailyTableView reloadData];
        });
    }];
}


#pragma mark tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1001) {
        
        return self.classDailyModels.count;
    }
    
    if (tableView.tag == 1002) {
        
        return self.classMateModels.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120*HEIGHT_SCALE;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果是班级日报列表
    if (tableView.tag == 1001) {
        
        DailyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dailyCell"];
        cell.model = self.classDailyModels[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        
        ClassmateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCell"];
        cell.model = self.classMateModels[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //MineController
    //班级日报列表(1001) 和班级同门进行不同的处理
    if (tableView.tag == 1001) {
        
        //点击推出日报详情页面
        WebDailyDetailController *webDailyDetailVC = [[WebDailyDetailController alloc] init];
        DailyModel *dailyModel = self.classDailyModels[indexPath.row];
        webDailyDetailVC.did = dailyModel.dailyId;
        [self presentViewController:webDailyDetailVC animated:YES completion:nil];
        
    }
    else{
        
        //推出查看他人信息页面
        MineController *mineVC = [[MineController alloc] init];
        PersonModel *model = self.classMateModels[indexPath.row];
        mineVC.visitor = YES;
        mineVC.visitorId = model.userId;
        [self.navigationController pushViewController:mineVC animated:YES];
    }
}

#pragma mark 按钮点击触发事件

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//加入按钮触发方法
-(void)joinClass{
    
    if([self.classDetailModel.type isEqualToString:@"offline"]){
        
        //如果当前班级为线下班级  则推出线下报名帖
        PTTWebViewController *webViewVC = [[PTTWebViewController alloc] init];
        webViewVC.pttTitle = @"线下报名";
        webViewVC.pttUrl = [NSString stringWithFormat:@"http://www.jnshu.com/#/daily/9183"];
        _returenFromWeb = YES;
        
        [self.navigationController pushViewController:webViewVC animated:YES];
    }else{
        
        //推出报名引导页
        SignupController *signupController = [[SignupController alloc] init];
        
        signupController.model = self.classDetailModel;
        signupController.jobName = self.jobName;
        
        [self.navigationController pushViewController:signupController animated:YES];
    }
}

#pragma mark 懒加载

-(UILabel *)className{
    if (!_className) {
        _className = [[UILabel alloc] init];
    }
    return _className;
}

-(UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] init];
    }
    return _headImageV;
}

-(UILabel *)qqLabel{
    if (!_qqLabel) {
        _qqLabel = [[UILabel alloc] init];
    }
    return _qqLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
    }
    return _timeLabel;
}

-(UILabel *)classWord{
    if (!_classWord) {
        _classWord = [[UILabel alloc] init];
    }
    return _classWord;
}

-(ClassDetailModel *)classDetailModel{
    if (!_classDetailModel) {
        _classDetailModel = [ClassDetailModel new];
    }
    return _classDetailModel;
}

-(NSMutableArray*)classDailyModels{
    if (!_classDailyModels) {
        _classDailyModels = @[].mutableCopy;
    }
    return _classDailyModels;
}

-(NSMutableArray *)classMateModels{
    
    if (!_classMateModels) {
        _classMateModels = @[].mutableCopy;
    }
    return _classMateModels;
}

-(UITableView *)classDailyTableView{
    
    if (!_classDailyTableView) {
        
        _classDailyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_classDailyTableView registerClass:[DailyCell class] forCellReuseIdentifier:@"dailyCell"];
        _classDailyTableView.tag = 1001;
        _classDailyTableView.delegate =self;
        _classDailyTableView.dataSource = self;
        _classDailyTableView.showsVerticalScrollIndicator = NO;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 6*HEIGHT_SCALE)];
        headView.backgroundColor = color_e8efed;
        _classDailyTableView.tableHeaderView = headView;
        _classDailyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        //添加下拉刷新  上拉加载功能
        WK(weakSelf);
        _classDailyTableView.mj_header = [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
            [weakSelf loadClassDailyData];
        }];
        _classDailyTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadMoreClassDailyOnlineData];
        }];
        
        //隐藏多余分割线
        _classDailyTableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _classDailyTableView;
}

-(UITableView *)classMateTableView{
    
    if (!_classMateTableView) {
        
        _classMateTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_classMateTableView registerClass:[ClassmateCell class] forCellReuseIdentifier:@"classCell"];
        _classMateTableView.tag = 1002;
        _classMateTableView.delegate =self;
        _classMateTableView.dataSource = self;
        _classMateTableView.showsVerticalScrollIndicator = NO;
        _classMateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 6*HEIGHT_SCALE)];
        headView.backgroundColor = color_e8efed;
        _classMateTableView.tableHeaderView = headView;
        
        //添加下拉刷新  上拉加载功能
        WK(weakSelf);
        _classMateTableView.mj_header = [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
            [weakSelf.classMateModels removeAllObjects];
            [weakSelf.classMateTableView reloadData];
            
            [weakSelf loadHeadAndClassMateData];
        }];
        
        //隐藏多余分割线
        _classMateTableView.tableFooterView = [[UIView alloc] init];
    }
    return _classMateTableView;
}

//创建班级同门模块没数据的占位图
-(UIImageView *)nonClassmaetImageV{
    
    if (!_nonClassmaetImageV) {
        
        _nonClassmaetImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"non-classmate"]];
        _nonClassmaetImageV.contentMode = UIViewContentModeCenter;
        _nonClassmaetImageV.frame = CGRectMake(0, 30, kWindowWidth, 200);
    }
    return _nonClassmaetImageV;
}

//创建班级日报模块没数据的占位图
-(UIImageView *)nonDailyImageV{
    
    if (!_nonDailyImageV) {
        
        _nonDailyImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"non-class-daily"]];
        _nonDailyImageV.contentMode = UIViewContentModeCenter;
        _nonDailyImageV.frame = CGRectMake(0, 30, kWindowWidth, 200);
    }
    return _nonDailyImageV;
}


@end
