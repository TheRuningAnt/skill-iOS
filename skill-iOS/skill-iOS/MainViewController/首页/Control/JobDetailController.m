//
//  JobDetailController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2014/10/24.
//  Copyright © 2014年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "JobDetailController.h"
#import "JobModel.h"
#import "TaskCell.h"
#import "TaskListModel.h"
#import "TaskView.h"
#import "TaskDetailModel.h"
#import "TaskDetailController.h"
#import "SignupController.h"
#import "ClassListController.h"
#import "JobDailyController.h"
#import "ClassListController.h"
#import "JobIntroduceController.h"
#import "JobSkillController.h"
#import "ResourceController.h"


@interface JobDetailController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  存放上方控件的容器视图
 */
@property (nonatomic,strong) UIView *topContentView;
/**
 *  职业头像
 */
@property (nonatomic,strong) UIImageView *headImageV;
/**
 *  职业名
 */
@property (nonatomic,strong) UILabel *jobTitleL;
/**
 *  职业门槛难度View
 */
@property (nonatomic,strong) UIView *thresholdView;
/**
 *  难易程度View
 */
@property (nonatomic,strong) UIView *difficultView;
/**
 *  求贤企业Res Label
 */
@property (nonatomic,strong) UILabel *companyResL;
/**
 *  成长周期Res L
 */
@property (nonatomic,strong) UILabel *cycleResL;
/**
 *  保存职业信息的Model
 */
@property (nonatomic,strong) JobModel *jobModel;
/**
 *  任务tableView
 */
@property (nonatomic,strong) UITableView *taskTableView;
/**
 *  保存任务列表Model数组
 */
@property (nonatomic,strong) NSMutableArray *taskModesArray;
/**
 *  保存任务详情的Model
 */
@property (nonatomic,strong) NSMutableDictionary *taskDetailModeDic;

/**
 *  创建和班级列表数据传递的model
 */
@property (nonatomic,strong) JobModel *tmpModel;
/**
  报名按钮btn  未加入班级的时候显示
 */
@property (nonnull,strong) UIButton *signUpBtn;

@end

@implementation JobDetailController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    //设置导航栏背景透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //判断是否要显示页面下方的报名按钮
    /**
     *  1.首先检测该用户是否登录
     2.根据该账户是否有职业 来决定是否创建 报名按钮
     */
    if ([UserTool userClassId] < 0) {
        
        //添加下方的报名按钮
        _signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signUpBtn setBackgroundColor:color_51d4b9];
        [_signUpBtn setTitle:@"报名" forState:UIControlStateNormal];
        [_signUpBtn addTarget:self action:@selector(clickSignUpBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_signUpBtn];
        [_signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(50*HEIGHT_SCALE);
            make.left.mas_equalTo(self.view.mas_left);
        }];
        
        //更新taskTableView的高度约束
        [self.taskTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50*HEIGHT_SCALE);
        }];
    }else{
        
        if (_signUpBtn && _signUpBtn.superview) {
            
            [_signUpBtn removeFromSuperview];
            //更新taskTableView的高度约束
            [self.taskTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
            }];
        }
    }

    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"职业详情模块"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    [self loadDataOfHeadView];
    [self loadDataOfTaskList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"职业详情模块"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark 添加设置子控件
-(void)setupUI{
    
    self.view.backgroundColor = color_e8efed;
    
    /**
     *  设置上方显示头像区域的视图
     */
    WK(weakSelf);
    
    self.topContentView = [[UIView alloc] init];
    self.topContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topContentView];
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 310*HEIGHT_SCALE));
        make.left.mas_equalTo(weakSelf.view.mas_left);
    }];
    
    //设置背景图
    UIImageView *bacImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job-background"]];
    [self.topContentView addSubview:bacImageView];
    [bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 230*HEIGHT_SCALE));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWindowWidth - 200*WIDTH_SCALE)/2, 22, 200*WIDTH_SCALE, 40)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20*WIDTH_SCALE];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"职业详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bacImageView addSubview:titleLabel];
    
    //设置职业头像
    [self.topContentView addSubview:self.headImageV];
    self.headImageV.image = [UIImage imageNamed:@"men-image"];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(bacImageView.mas_top).offset(80);
        make.left.mas_equalTo(@(8*HEIGHT_SCALE));
        make.size.mas_equalTo(CGSizeMake(115*HEIGHT_SCALE, 115*HEIGHT_SCALE));
    }];
    
    //设置职业名字
    [self.topContentView addSubview:self.jobTitleL];
    self.jobTitleL.textColor = [UIColor whiteColor];
    self.jobTitleL.text = @"--";
    self.jobTitleL.font = [UIFont systemFontOfSize:17];
    [self.jobTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(bacImageView.mas_top).offset(80);
        make.left.mas_equalTo(self.headImageV.mas_right).offset(7);
        make.right.mas_equalTo(self.topContentView.mas_right);
        make.height.mas_equalTo(30*HEIGHT_SCALE);
    }];
    
    //设置职业门槛
    UILabel *thresholdL = [[UILabel alloc] init];
    [self.topContentView addSubview:thresholdL];
    thresholdL.textColor = [UIColor whiteColor];
    thresholdL.text = @"职业门槛";
    thresholdL.font = [UIFont systemFontOfSize:12];
    [thresholdL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.jobTitleL.mas_bottom).offset(3);
        make.left.mas_equalTo(self.headImageV.mas_right).offset(7);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.width.mas_equalTo(60*WIDTH_SCALE);
    }];
    
    //设置职业门槛难易程度 UIView
    [self.topContentView addSubview:self.thresholdView];
    [self.thresholdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.jobTitleL.mas_bottom).offset(3);
        make.left.mas_equalTo(thresholdL.mas_right).offset(5);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.right.mas_equalTo(self.topContentView.mas_right);

    }];
    
    //设置"难易程度Label"
    UILabel *difficultL = [[UILabel alloc] init];
    [self.topContentView addSubview:difficultL];
    difficultL.font = [UIFont systemFontOfSize:12];
    difficultL.textColor = [UIColor whiteColor];
    difficultL.text = @"难易程度";
    [difficultL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(thresholdL.mas_bottom).offset(3);
        make.left.mas_equalTo(self.headImageV.mas_right).offset(7);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.width.mas_equalTo(60*WIDTH_SCALE);
    }];
    
    //设置难易程度 UIView
    [self.topContentView addSubview:self.difficultView];
    [self.difficultView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.thresholdView.mas_bottom).offset(3);
        make.left.mas_equalTo(difficultL.mas_right).offset(5);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.right.mas_equalTo(self.topContentView.mas_right);
        
    }];
    
    //设置 求贤企业L
    UILabel *companyL = [[UILabel alloc] init];
    [self.topContentView addSubview:companyL];
    companyL.font = [UIFont systemFontOfSize:12];
    companyL.textColor = [UIColor whiteColor];
    companyL.text = @"求贤企业";
    [companyL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(difficultL.mas_bottom).offset(3);
        make.left.mas_equalTo(self.headImageV.mas_right).offset(7);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.width.mas_equalTo(60*WIDTH_SCALE);
    }];
    
    //设置求贤企业数量Lable
    [self.topContentView addSubview:self.companyResL];
    self.companyResL.textColor = color_ffc651;
    self.companyResL.font = [UIFont systemFontOfSize:12];
    self.companyResL.text = @"--";
    self.companyResL.textAlignment = NSTextAlignmentCenter;
    [self.companyResL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(difficultL.mas_bottom).offset(3);
        make.left.mas_equalTo(companyL.mas_right).offset(0);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.width.mas_equalTo(45*WIDTH_SCALE);
    }];
    
    //家
    UILabel *companyResSubL = [[UILabel alloc] init];
    [self.topContentView addSubview:companyResSubL];
    companyResSubL.textColor = [UIColor whiteColor];
    companyResSubL.font = [UIFont systemFontOfSize:12];
    companyResSubL.text = @"家";
    [companyResSubL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(difficultL.mas_bottom).offset(3);
        make.left.mas_equalTo(self.companyResL.mas_right).offset(0);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.width.mas_equalTo(15*WIDTH_SCALE);
    }];

    //设置成长周期label
    UILabel *cycleL = [[UILabel alloc] init];
    [self.topContentView addSubview:cycleL];
    cycleL.font = [UIFont systemFontOfSize:12];
    cycleL.textColor = [UIColor whiteColor];
    cycleL.text = @"成长周期";
    [cycleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(difficultL.mas_bottom).offset(3);
        make.left.mas_equalTo(companyResSubL.mas_right).offset(5);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.width.mas_equalTo(60*WIDTH_SCALE);
    }];
    
    //设置成长周期数值
    [self.topContentView addSubview:self.cycleResL];
    self.cycleResL.textColor = color_ffc651;
    self.cycleResL.font = [UIFont systemFontOfSize:12];
    self.cycleResL.text = @"--";
    self.cycleResL.textAlignment = NSTextAlignmentCenter;
    [self.cycleResL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.difficultView.mas_bottom).offset(3);
        make.left.mas_equalTo(cycleL.mas_right).offset(2);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.width.mas_equalTo(10*WIDTH_SCALE);
    }];

    //年
    UILabel *cycleResSubL = [[UILabel alloc] init];
    [self.topContentView addSubview:cycleResSubL];
    cycleResSubL.textColor = [UIColor whiteColor];
    cycleResSubL.font = [UIFont systemFontOfSize:12];
    cycleResSubL.text = @"年";
    [cycleResSubL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(difficultL.mas_bottom).offset(3);
        make.left.mas_equalTo(self.cycleResL.mas_right).offset(0);
        make.height.mas_equalTo(25*HEIGHT_SCALE);
        make.width.mas_equalTo(15*WIDTH_SCALE);
    }];
    
    /**
     *  添加下方的可点击按钮
     *
     */
    //简介按钮
    UIImageView *introduceImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth/5, kWindowWidth/5) localImage:@"job-introduce"  imageFrame:CGRectMake((kWindowWidth/5 - 25)/2, 15, 25, 25) contendMode:PTT_ImageView_Image_Contend_Mode_Aspect title:@"简介" fontSize:14*HEIGHT_SCALE titleColor:color_7892a5 distantWithImageAndTitle:0 withAction:^(id sender) {
        
        JobIntroduceController *jobIntroduceVC = [[JobIntroduceController alloc] init];
        jobIntroduceVC.jobId = weakSelf.jobId;
        [self.navigationController pushViewController:jobIntroduceVC animated:YES];
    }];
    [self.topContentView addSubview:introduceImageV];
    [introduceImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(bacImageView.mas_bottom);
        make.left.mas_equalTo(self.topContentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth/5, kWindowWidth/5));
    }];
    
    //日报按钮
    UIImageView *paperImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/5, 0, kWindowWidth/5, kWindowWidth/5) localImage:@"job-detail-paper"  imageFrame:CGRectMake((kWindowWidth/5 - 25)/2, 15, 25, 25) contendMode:PTT_ImageView_Image_Contend_Mode_Aspect title:@"日报" fontSize:14*HEIGHT_SCALE titleColor:color_7892a5 distantWithImageAndTitle:0 withAction:^(id sender) {
        
        //推出职业日报
        JobDailyController *jobDailyVC = [[JobDailyController alloc] init];
        jobDailyVC.oid = (int)weakSelf.jobId;
        [weakSelf.navigationController pushViewController:jobDailyVC animated:YES];
    }];
    [self.topContentView addSubview:paperImageV];
    [paperImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(bacImageView.mas_bottom);
        make.left.mas_equalTo(self.topContentView.mas_left).offset(kWindowWidth/5);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth/5, kWindowWidth/5));
    }];

    //技能按钮
    UIImageView *skillImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/5, 0, kWindowWidth/5, kWindowWidth/5) localImage:@"job-skill"  imageFrame:CGRectMake((kWindowWidth/5 - 25)/2, 15, 25, 25) contendMode:PTT_ImageView_Image_Contend_Mode_Aspect title:@"技能" fontSize:14*HEIGHT_SCALE titleColor:color_7892a5 distantWithImageAndTitle:0 withAction:^(id sender) {

        if (weakSelf.jobModel.name) {
            
            JobSkillController *jobSillVC = [[JobSkillController alloc] init];
            
            if ([weakSelf.jobModel.name isEqualToString:@"ui"]) {
                
                jobSillVC.jobName = @"ui-skill";
            }else if ([weakSelf.jobModel.name isEqualToString:@"CSS"]){
                
                jobSillVC.jobName = @"css";
            }else{
                
                jobSillVC.jobName = weakSelf.jobModel.name;
            }
            
            [self.navigationController pushViewController:jobSillVC animated:YES];
        }
    }];
    [self.topContentView addSubview:skillImageV];
    [skillImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(bacImageView.mas_bottom);
        make.left.mas_equalTo(self.topContentView.mas_left).offset(2*kWindowWidth/5);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth/5, kWindowWidth/5));
    }];

    //班级按钮
    UIImageView *classImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/5, 0, kWindowWidth/5, kWindowWidth/5) localImage:@"job-class"  imageFrame:CGRectMake((kWindowWidth/5 - 25)/2, 15, 25, 25) contendMode:PTT_ImageView_Image_Contend_Mode_Aspect title:@"班级" fontSize:14*HEIGHT_SCALE titleColor:color_7892a5 distantWithImageAndTitle:0 withAction:^(id sender) {
        
        /**
         *  判断推出classListController的tmpModel是否赋值成功,若未赋值成功禁止弹出页面
         */
        if(!weakSelf.tmpModel.name){
            
            return ;
        }
        
        ClassListController *classListController = [[ClassListController alloc] init];
        
        /**创建一个JobModel  传递给classListController
         *  只需要其中的职业id 和职业名字 字段
         */
        classListController.jobModel = weakSelf.tmpModel;
        
        [weakSelf.navigationController pushViewController:classListController animated:YES];
    }];
    [self.topContentView addSubview:classImageV];
    [classImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(bacImageView.mas_bottom);
        make.left.mas_equalTo(self.topContentView.mas_left).offset(3*kWindowWidth/5);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth/5, kWindowWidth/5));
    }];

    //资源按钮
    UIImageView *libraryImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/5, 0, kWindowWidth/5, kWindowWidth/5) localImage:@"job-resource"  imageFrame:CGRectMake((kWindowWidth/5 - 25)/2, 15, 25, 25) contendMode:PTT_ImageView_Image_Contend_Mode_Aspect title:@"资源" fontSize:14*HEIGHT_SCALE titleColor:color_7892a5 distantWithImageAndTitle:0 withAction:^(id sender) {
        
        if (!weakSelf.jobModel) {
            
            return ;
        }

        ResourceController *resourceVC = [[ResourceController alloc] init];
        resourceVC.oid = (int32_t)weakSelf.jobModel.jobId;
        [weakSelf.navigationController pushViewController:resourceVC animated:YES];
    }];
    [self.topContentView addSubview:libraryImageV];
    [libraryImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(bacImageView.mas_bottom);
        make.left.mas_equalTo(self.topContentView.mas_left).offset(4*kWindowWidth/5);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth/5, kWindowWidth/5));
    }];

    //设置导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"job-detail-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(10,22, 40*HEIGHT_SCALE, 40*HEIGHT_SCALE) ;
    //[button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //添加任务列表TableView
    [self.view addSubview:self.taskTableView];
    [self.taskTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.topContentView.mas_bottom).offset(0);
        make.width.mas_equalTo(kWindowWidth);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(weakSelf.view.mas_left);
    }];
    
}

#pragma mark 获取网络数据
//获取头视图控件网络
-(void)loadDataOfHeadView{
    
    //每次请求网络数据前检测网络状态
    KCheckNetWorkAndRetuen(^(){})

    WK(weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@%lu",API_JobDetail,self.jobId];
    
   [HttpService sendGetHttpRequestWithUrl:url paraments:nil successBlock:^(NSDictionary *jsonDic) {
       
        [weakSelf.jobModel setValuesForKeysWithDictionary:jsonDic];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshJobInfo];
        });
    }];
}

//获取任务列表数据
-(void)loadDataOfTaskList{
    
    //每次请求网络数据前检测网络状态
    //KCheckNetWorkAndRetuen(^(){})
    
    NSString *url = [NSString stringWithFormat:@"%@",API_TaskList];
    
    [HttpService sendGetHttpRequestWithUrl:url paraments:@{@"oid":@(self.jobId)} successBlock:^(NSDictionary *jsonDic) {
        
        if ([jsonDic isKindOfClass:[NSArray class]]) {
            [(NSArray*)jsonDic enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                TaskListModel *model = [TaskListModel new];
                [model setValuesForKeysWithDictionary:obj];
                model.tag = 1;
                [self.taskModesArray addObject:model];
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.taskTableView reloadData];
        });
    }];
}

//获取单个任务详情数据
-(void)loadDataOfTaskDetailOfIndex:(NSInteger)index withAction:(void (^)())block{
    
    //每次请求网络数据前检测网络状态
    KCheckNetWorkAndRetuen(^(){})
    
    NSString *url = [NSString stringWithFormat:@"%@%lu",API_TaskDetail,index];
    [HttpService sendGetHttpRequestWithUrl:url paraments:nil successBlock:^(NSDictionary *jsonDic) {
        
        //初始化数据
        TaskDetailModel *model = [TaskDetailModel new];
        
        //设置标题数据
        NSDictionary *detailDic = [jsonDic objectForKey:@"detail"];
        if (detailDic) {
            [model setValuesForKeysWithDictionary:detailDic];
        }
        
        //设置具体步骤  和  相关要求  数据
        NSDictionary *extendDic = [PTT_Data_Kit dicionaryWihJSON:[jsonDic objectForKey:@"extend"]];
        if (extend) {
            
            //添加具体步骤数据
            NSArray *arrayOfSetup = [extendDic objectForKey:@"step"];
            if (arrayOfSetup && arrayOfSetup.count != 0) {
                
                model.stepArray = @[].mutableCopy;
                [arrayOfSetup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSString *setupName = [(NSDictionary*)obj objectForKey:@"name"];
                        if (setupName) {
                            [model.stepArray addObject:setupName];
                        }
                    }
                }];
            }
            
            //添加相关要求数据
            NSArray *arrayOfRequire = [extendDic objectForKey:@"require"];
            if (arrayOfRequire && arrayOfRequire.count != 0) {
                
                model.requireArray = @[].mutableCopy;
                [arrayOfRequire enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSString *requireName = [(NSDictionary*)obj objectForKey:@"name"];
                        if (requireName) {
                            [model.requireArray addObject:requireName];
                        }
                    }
                }];
            }
            
            //添加目标效果展示数据
            NSArray *arrayOfImg = [extendDic objectForKey:@"img"];
            if (arrayOfImg && arrayOfImg.count != 0) {
                
                model.imgArray = @[].mutableCopy;
                [arrayOfImg enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *link = [obj objectForKey:@"link"];
                        if (link) {
                            [model.imgArray addObject:link];
                        }
                    }
                }];
            }
            
            //获取资源下载数据
            NSArray *resourseArray = [extendDic objectForKey:@"resources"];
            if (resourseArray && resourseArray.count != 0) {
                
                model.resourseArray = @[].mutableCopy;
                [resourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *link = [obj objectForKey:@"link"];
                        if (link) {
                            [model.resourseArray addObject:link];
                        }
                    }
                }];
            }

        }
        
        //获取相关技能等数据外层字典
        NSDictionary *relationDic = [jsonDic objectForKey:@"relation"];
        if (relationDic) {
            
            //添加相关技能数据
            NSArray *skillArray = [relationDic objectForKey:@"skill"];
            if (skillArray && skillArray.count != 0) {
                
                model.skillArray = @[].mutableCopy;
                [skillArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *skillName = [obj objectForKey:@"name"];
                        if (skillName) {
                            
                            [model.skillArray addObject:skillName];
                        }
                    }
                }];
            }
        }
        
        //将model保存到全局字典里去,方便下次调用
        [self.taskDetailModeDic setObject:model forKey:[NSString stringWithFormat:@"%lu",index]];
        if(block){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //刷新主线程页面
                block();
            });
        }
    }];
}


#pragma mark 刷新页面
-(void)refreshJobInfo{
    
    self.jobTitleL.text = self.jobModel.name;
    self.companyResL.text =[NSString stringWithFormat:@"%lu",self.jobModel.company];
    self.cycleResL.text = [self.jobModel.cycle substringToIndex:1];
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:self.jobModel.img] placeholderImage:[UIImage imageNamed:@"men-image"]];
    
    //更新和班级列表数据传递的tmpModel
    self.tmpModel.jobId = self.jobModel.jobId;
    self.tmpModel.name = self.jobModel.name;
    
    //设置门槛难度 UIView
    for (int i = 0; i < 5 ; i ++) {
        
        UIImageView *imageView;
        if (i < [self.jobModel.threshold integerValue]) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select-star"]];
        }else{
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nonselect-star"]];
        }
        imageView.frame = CGRectMake(25*HEIGHT_SCALE*i + 5, 0, 20*HEIGHT_SCALE, 20*HEIGHT_SCALE);
        [self.thresholdView addSubview:imageView];
    }
    
    //设置难易程度 UIView
    for (int i = 0; i < 5 ; i ++) {
        
        UIImageView *imageView;
        if (i < [self.jobModel.difficult integerValue]) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select-star"]];
        }else{
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nonselect-star"]];
        }
        imageView.frame = CGRectMake(25*HEIGHT_SCALE*i + 5, 0, 20*HEIGHT_SCALE, 20*HEIGHT_SCALE);
        [self.difficultView addSubview:imageView];
    }
}

#pragma mark 按钮点击触发事件

//导航栏返回按钮触发事件
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger invalidateSessionCancelingTasks:YES];
}

//报名按钮点击触发
-(void)clickSignUpBtn{
    
    ClassListController *classListController = [[ClassListController alloc] init];
    classListController.jobModel = self.jobModel;
    [self.navigationController pushViewController:classListController animated:YES];
}

#pragma mark taskTableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.taskModesArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WK(weakSelf);
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bitCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (!cell) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tmpCell"];
    }
    
    //防止循环引用  禁止cell复用
   __weak TaskCell *weakCell = cell;
    
    TaskListModel *model = self.taskModesArray[indexPath.row];
    weakCell.taskTitle = [NSString stringWithFormat:@"任务%lu:%@",indexPath.row + 1,model.title];
    weakCell.indexPath = indexPath;
    weakCell.cellTag = model.tag;
    weakCell.block = ^(NSIndexPath *index){
        
        //修改按钮提示图标
    if (model.tag == 1){
        model.tag = 2;
        weakCell.cellTag = 2;
            
        //获取该cell对应的任务详情数据
        TaskDetailModel *taskDetailModel ;
        taskDetailModel = [self.taskDetailModeDic objectForKey:[NSString stringWithFormat:@"%lu",model.taskId]];
            
            if (!taskDetailModel) {
                //获取该任务的详细数据,并回到主线程推出任务简介下拉视图
                [weakSelf loadDataOfTaskDetailOfIndex:model.taskId withAction:^{
                    
                    [weakSelf.taskTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                    
                    //刷新完数据之后将该次点击的视图滚动到最上方
                    [weakSelf.taskTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }];
            }
            else{
                
                [weakSelf.taskTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                //刷新完数据之后将该次点击的视图滚动到最上方
                [weakSelf.taskTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        else{
            model.tag = 1;
            weakCell.cellTag = 1;
            [weakSelf.taskTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
        }
    };
    
    if (model.tag == 2) {
        //当cellTag = 2的时候,需要展示任务详情
        
        /**
         *  先检测该任务详情model是否已经保存,若保存过则直接获取,若没有保存则去网络请求 返回高度为 数组里保存的步骤数 + 1 (下面需要显示耗时多长时间)
         */
        TaskDetailModel *taskDetailModel ;
        taskDetailModel = [self.taskDetailModeDic objectForKey:[NSString stringWithFormat:@"%lu",model.taskId]];
        
        //检查是否获取成功
        if (taskDetailModel) {
            
            //为cell添加子视图
            NSMutableArray *arrayOfContent = [NSMutableArray arrayWithArray:taskDetailModel.stepArray];
            [arrayOfContent addObject:taskDetailModel.time];
            weakCell.contentArray = arrayOfContent;
        }
    }
    
    return weakCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskListModel *model = self.taskModesArray[indexPath.row];
    if (model.tag == 2) {
        
        TaskDetailModel *taskDetailModel ;
        //返回高度为 数组里保存的步骤数 + 1 (下面需要显示耗时多长时间)
        taskDetailModel = [self.taskDetailModeDic objectForKey:[NSString stringWithFormat:@"%lu",model.taskId]];
       
            return (taskDetailModel.stepArray.count + 1)*50*HEIGHT_SCALE + 80 * HEIGHT_SCALE;
    }
    return 80*HEIGHT_SCALE;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel *lineOfDown = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
    lineOfDown.backgroundColor = color_dfeaff;

    return lineOfDown;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //推出技能详情页面
    TaskListModel *model = self.taskModesArray[indexPath.row];
    TaskDetailModel *taskDetailModel = [self.taskDetailModeDic objectForKey:[NSString stringWithFormat:@"%lu",model.taskId]];
    
    TaskDetailController *taskDetailcController = [[TaskDetailController alloc] init];
    taskDetailcController.model = taskDetailModel;
    taskDetailcController.taskId = model.taskId;
    
    [self.navigationController pushViewController:taskDetailcController animated:YES];
}

#pragma mark 懒加载
-(UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] init];
    }
    return _headImageV;
}

-(UILabel *)jobTitleL{
    if (!_jobTitleL) {
        _jobTitleL = [[UILabel alloc] init];
    }
    return _jobTitleL;
}

-(UIView *)thresholdView{
    if (!_thresholdView) {
        _thresholdView = [[UIView alloc] init];
    }
    return _thresholdView;
}

-(UIView *)difficultView{
    if (!_difficultView) {
        _difficultView = [[UIView alloc] init];
    }
    return _difficultView;
}

-(UILabel *)companyResL{
    if (!_companyResL) {
        _companyResL = [[UILabel alloc] init];
    }
    return _companyResL;
}

-(UILabel *)cycleResL{
    if (!_cycleResL) {
        _cycleResL = [[UILabel alloc] init];
    }
    return _cycleResL;
}

-(JobModel *)jobModel{
    if (!_jobModel) {
        _jobModel = [JobModel new];
    }
    return _jobModel;
}

-(JobModel *)tmpModel{
    if (!_tmpModel) {
        _tmpModel = [JobModel new];
    }
    return _tmpModel;
}

-(NSMutableArray *)taskModesArray{
    if (!_taskModesArray) {
        _taskModesArray = @[].mutableCopy;
    }
    return _taskModesArray;
}

-(UITableView *)taskTableView{
    
    if (!_taskTableView) {
        
        _taskTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _taskTableView.delegate = self;
        _taskTableView.dataSource = self;
        _taskTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _taskTableView.showsVerticalScrollIndicator = NO;
        _taskTableView.backgroundColor = color_e8efed;
        
        UIView *taskTableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 10*HEIGHT_SCALE)];
        taskTableHeadView.backgroundColor = color_e8efed;
        _taskTableView.tableHeaderView = taskTableHeadView;
        
        [_taskTableView registerClass:[TaskCell class] forCellReuseIdentifier:@"cell"];
    }
    return _taskTableView;
}

-(NSMutableDictionary *)taskDetailModeDic{
    if (!_taskDetailModeDic) {
        _taskDetailModeDic = [NSMutableDictionary dictionary];
    }
    return _taskDetailModeDic;
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
