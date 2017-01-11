//
//  TaskDetailController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/25.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "TaskDetailController.h"
#import "TaskDetailTipView.h"
#import "TaskView.h"
#import "DownloadTipView.h"
#import "PTTWebViewController.h"

@interface TaskDetailController ()

@property (nonatomic,strong) UIImageView *currentShowImageView;

@end
@implementation TaskDetailController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = color_e8efed;
    
    //设置导航栏控件
    self.title = @"任务详情";
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"任务详情模块"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    WK(weakSelf);
    
    [self setNavView];
    /**
     *   如果前面传进来的model有值的话则直接拿来使用,否则的话重新发起网络请求
     */
    if(self.model){
        
        [self setupUI];
    }else{
        
        [self loadDataOfTaskDetailOfIndex:self.taskId withAction:^{
        
        [weakSelf setupUI];
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [PttLoadingTip stopLoading];
    
    if (self.currentShowImageView && self.currentShowImageView.superview) {
        
        [self.currentShowImageView removeFromSuperview];
    }
    
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"任务详情模块"];
}

#pragma mark 设置页面

//设置导航控制器属性以及背景颜色
-(void)setNavView{
    
    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[item1];
}

-(void)setupUI{
    
    /**
     * 计算scrollView的内容高度
     */
    //标题视图模块高度
    CGFloat topViewHeight = 40.f*HEIGHT_SCALE + KTextHeight(self.model.taskDescription) + 47*HEIGHT_SCALE + 10*HEIGHT_SCALE;
    //具体步骤模块高度
    CGFloat stepViewHeight = 40.f*HEIGHT_SCALE + 50 * HEIGHT_SCALE * self.model.stepArray.count;
    //相关要求模块高度
    CGFloat requireViewHeight = 40.f*HEIGHT_SCALE + self.model.requireArray.count*40.f*HEIGHT_SCALE;
    //相关技能模块高度
    CGFloat skillViewHeigth = 40.f*HEIGHT_SCALE + self.model.skillArray.count*40.f*HEIGHT_SCALE;
    //效果展示模块高度
    CGFloat heightOfImagView = ((kWindowWidth - 40)/3 + 20) + 40*HEIGHT_SCALE;
    CGFloat resultViewHeight = 40.f*HEIGHT_SCALE + heightOfImagView;
    //资源下载模块高度
    CGFloat resourceHeight = 40.f*HEIGHT_SCALE * 2;
    
    //计算scrollView总高度
    CGFloat scrollViewHeight = (10 + topViewHeight + 10 + stepViewHeight + 10 + requireViewHeight + 10 +skillViewHeigth  + 10 + resultViewHeight + 10 + resourceHeight + 20 - 44);
    
    /**
     *  创建整体ScrollView
     *
     */
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height)];
    //遇到特殊情况时
    if (self.view.frame.size.height == kWindowHeight) {
        contentScrollView.frame = CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height - 64);
    }
    contentScrollView.backgroundColor = color_e8efed;
    contentScrollView.contentSize = CGSizeMake(kWindowWidth, scrollViewHeight);
    contentScrollView.showsVerticalScrollIndicator = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:contentScrollView];
    
    /**
     创建上方标题视图及子控件
    */
    UIView *topView = [[UIView alloc] init];
    [contentScrollView addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(contentScrollView.mas_top).offset(10);
        make.width.mas_equalTo(kWindowWidth);
        make.height.mas_equalTo(topViewHeight);
        make.left.mas_equalTo(contentScrollView.mas_left);
    }];
    
    //创建标题Label
    UILabel *topTitleLabel = [[UILabel alloc] init];
    topTitleLabel.adjustsFontSizeToFitWidth =YES;
    topTitleLabel.textColor = color_0f4068;
    topTitleLabel.backgroundColor = [UIColor whiteColor];
    topTitleLabel.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    topTitleLabel.text = self.model.title;
    topTitleLabel.numberOfLines = 0;
    [topView addSubview:topTitleLabel];
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_top).offset(10);
        make.left.mas_equalTo(topView.mas_left).offset(10);
        make.height.mas_equalTo(40*HEIGHT_SCALE);
        make.right.mas_equalTo(topView.mas_right);
    }];
    
    //创建描述label
    UILabel *topDescripLabel = [[UILabel alloc] init];
    topDescripLabel.textColor = color_7892a5;
    topDescripLabel.backgroundColor = [UIColor whiteColor];
    topDescripLabel.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
    topDescripLabel.numberOfLines = 0;
    topDescripLabel.text = self.model.taskDescription;
    topDescripLabel.adjustsFontSizeToFitWidth =YES;
    [topView addSubview:topDescripLabel];
    [topDescripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topTitleLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(topView.mas_left).offset(10);
        make.height.mas_equalTo(KTextHeight(self.model.taskDescription));
        make.right.mas_equalTo(topView.mas_right);
    }];
    
    //创建时间修饰tip
    UIImageView *topTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"job-detail-time"]];
    [topView addSubview:topTip];
    [topTip mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(topDescripLabel.mas_bottom).offset(10*HEIGHT_SCALE);
        make.left.mas_equalTo(topView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(17*HEIGHT_SCALE, 17*HEIGHT_SCALE));
    }];
    
    //任务时间字段
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = color_fdb92c;
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
    timeLabel.numberOfLines = 0;
    timeLabel.text = self.model.time;
    [topView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(topTip.mas_right).offset(10);
        make.height.mas_equalTo(30*HEIGHT_SCALE);
        make.right.mas_equalTo(topView.mas_right);
        make.centerY.mas_equalTo(topTip.mas_centerY);
    }];

    
    /**
     *  创建具体步骤模块  内容模块根据高度需要自适应
     */
    UIView *stepContentView = [[UIView alloc] init];
    stepContentView.backgroundColor = [UIColor whiteColor];
    [contentScrollView addSubview:stepContentView];
    [stepContentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(topView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 40.f*HEIGHT_SCALE + 50 * HEIGHT_SCALE * self.model.stepArray.count));
        make.left.mas_equalTo(contentScrollView.mas_left);
    }];
    
    //创建具体步骤提示View
    TaskDetailTipView *stepTipView = [[TaskDetailTipView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40*HEIGHT_SCALE)];
    stepTipView.title = @"具体步骤";
    [stepContentView addSubview:stepTipView];
    
    //具体步骤内容View
    TaskView *taskView = [[TaskView alloc] initWithFrame:CGRectMake(0, 40*HEIGHT_SCALE, kWindowWidth, 50 * HEIGHT_SCALE * self.model.stepArray.count)];
    taskView.currentView = K_TASK_DETAIL_VIEW;
    taskView.titleBackgroundColor = [UIColor whiteColor];
    taskView.contentArray = self.model.stepArray ;
    [stepContentView addSubview:taskView];
    
    /**
     *  相关要求模块
     */
    UIView *requireContentView = [[UIView alloc] init];
    requireContentView.backgroundColor = [UIColor whiteColor];
    [contentScrollView addSubview:requireContentView];
    [requireContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(stepContentView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, self.model.requireArray.count*40*HEIGHT_SCALE + 40*HEIGHT_SCALE));
        make.left.mas_equalTo(contentScrollView.mas_left);
    }];
    
    //创建相关要求提示View
    TaskDetailTipView *requireTipView = [[TaskDetailTipView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40*HEIGHT_SCALE)];
    requireTipView.title = @"相关要求";
    [requireContentView addSubview:requireTipView];
    
    //添加相关要求内容视图
    for (int i= 0; i < self.model.requireArray.count; i ++){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*WIDTH_SCALE, 40*HEIGHT_SCALE + 40*HEIGHT_SCALE*i, kWindowWidth - 30, 40*HEIGHT_SCALE)];
        label.textColor = color_7892a5;
        label.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"%d.%@",i + 1,self.model.requireArray[i]];
        [requireContentView addSubview:label];
    }
    
    
    /**
     *  相关技能模块
     */
    UIView *skillContentView = [[UIView alloc] init];
    skillContentView.backgroundColor = [UIColor whiteColor];
    [contentScrollView addSubview:skillContentView];
    [skillContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(requireContentView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, self.model.skillArray.count*40*HEIGHT_SCALE + 40*HEIGHT_SCALE));
        make.left.mas_equalTo(contentScrollView.mas_left);
    }];
    
    //创建技能要求提示View
    TaskDetailTipView *skillTipView = [[TaskDetailTipView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40*HEIGHT_SCALE)];
    skillTipView.title = @"相关技能";
    [skillContentView addSubview:skillTipView];
    
    //创建相关要求展示内容
    for (int i= 0; i < self.model.skillArray.count; i ++){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*WIDTH_SCALE, 40*HEIGHT_SCALE + 40*HEIGHT_SCALE*i, kWindowWidth - 30, 40*HEIGHT_SCALE)];
        label.textColor = color_7892a5;
        label.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
        label.backgroundColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%d.%@",i + 1,self.model.skillArray[i]];
        label.adjustsFontSizeToFitWidth = YES;
        [skillContentView addSubview:label];
    }

    
    /**
     *  效果展示模块
     */
    UIView *resultContentView = [[UIView alloc] init];
    resultContentView.backgroundColor = [UIColor whiteColor];
    [contentScrollView addSubview:resultContentView];
    [resultContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(skillContentView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, heightOfImagView));
        make.left.mas_equalTo(contentScrollView.mas_left);
    }];
    
    //创建效果展示提示View
    TaskDetailTipView *resultTipView = [[TaskDetailTipView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40*HEIGHT_SCALE)];
    resultTipView.title = @"效果展示";
    [resultContentView addSubview:resultTipView];
    
    //添加 "单击放大图片" 字段
    UILabel *tipViewAssocitL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40*HEIGHT_SCALE)];
    tipViewAssocitL.textColor = color_7892a5;
    tipViewAssocitL.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    tipViewAssocitL.text = @"（单击查看大图）";
    [resultTipView addSubview:tipViewAssocitL];
    [tipViewAssocitL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(resultTipView.mas_top);
        make.left.mas_equalTo(resultTipView.mas_left).offset(95*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(200, 40*HEIGHT_SCALE));
    }];
    
    CGFloat showImageWidth = (kWindowWidth - 40)/3;
    CGFloat showImageHeight = showImageWidth;
    //创建效果展示内容scrollView
    UIScrollView *showScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40*HEIGHT_SCALE, kWindowWidth, showImageHeight + 20)];
    showScrollV.contentSize = CGSizeMake((showImageWidth + 10) * self.model.imgArray.count, showImageHeight + 20);
    showScrollV.backgroundColor = [UIColor whiteColor];
    showScrollV.showsVerticalScrollIndicator = NO;
    showScrollV.showsHorizontalScrollIndicator = NO;
    [resultContentView addSubview:showScrollV];
    
    //添加效果图片
    for (int i= 0; i < self.model.imgArray.count; i ++){
        
        //创建点击放大的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
    
        //创建内容展示图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (showImageWidth +10) * i, 10 , showImageWidth, showImageHeight)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgArray[i]] placeholderImage:[UIImage imageNamed:@"men-image"]];
            imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
            
        [showScrollV addSubview:imageView];
    }

    /**
     *  资源下载模块
     */
    UIView *resourceContentView = [[UIView alloc] init];
    resourceContentView.backgroundColor = [UIColor whiteColor];
    [contentScrollView addSubview:resourceContentView];
    [resourceContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(resultContentView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 40*HEIGHT_SCALE*2));
        make.left.mas_equalTo(contentScrollView.mas_left);
    }];
    
    //创建效果展示提示View  只考虑有最多两行图片的情况
    TaskDetailTipView *resourceTipView = [[TaskDetailTipView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40*HEIGHT_SCALE)];
    resourceTipView.title = @"资源下载";
    [resourceContentView addSubview:resourceTipView];
    
    //创建下载提示Label
    UILabel *downloadTip = [[UILabel alloc] init];
    downloadTip.textColor = color_7892a5;
    downloadTip.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
    downloadTip.backgroundColor = [UIColor whiteColor];
    downloadTip.text = @"源文件下载";
    [resourceContentView addSubview:downloadTip];
    [downloadTip mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(resourceTipView.mas_bottom).offset(10*HEIGHT_SCALE);
        make.left.mas_equalTo(resourceContentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(100*WIDTH_SCALE, 20*HEIGHT_SCALE));
    }];
    
    //创建下载按钮
    UIButton *downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downLoadButton setTitle:@"下载" forState:UIControlStateNormal];
    [downLoadButton setTitleColor:color_24c9a7 forState:UIControlStateNormal];
    downLoadButton.titleLabel.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
    [downLoadButton addTarget:self action:@selector(downloadResource) forControlEvents:UIControlEventTouchUpInside];
    [resourceContentView addSubview:downLoadButton];
    [downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(resourceTipView.mas_bottom).offset(10*HEIGHT_SCALE);
        make.size.mas_equalTo(CGSizeMake(40*WIDTH_SCALE, 20*HEIGHT_SCALE));
        make.right.mas_equalTo(resourceContentView.mas_right).offset(-15);

    }];
    
    //创建下载提示图标
    UIImageView *downloadTipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"download-tip"]];
    [resourceContentView addSubview:downloadTipIcon];
    [downloadTipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(downLoadButton.mas_left).offset(-2*WIDTH_SCALE);
        make.centerY.mas_equalTo(downLoadButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15*WIDTH_SCALE, 15*HEIGHT_SCALE));

    }];
}

-(void)downloadResource{

    WK(weakSelf);
    //下载前检测网络状态
    [PTTReachability PTTReachabilityWithSuccessBlock:^(NSString *status) {
        NSLog(@"网络 status = %@",status);
        if ([status isEqualToString:@"无连接"]) {
            
            [ShowMessageTipUtil showTipLabelWithMessage:@"当前无网络链接,请检查网络状态"];
        }else if ([status isEqualToString:@"3G/4G网络"]) {
            
            DownloadTipView *downloadTipView = [[DownloadTipView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
            downloadTipView.sureBlock = ^(){
                
                //在这里处理点击确定之后的操作
            };
            [weakSelf.view addSubview:downloadTipView];
        }
    }];
    
    //如果资源数组里没有数据 则提示用户无数据,否则进入下载页面
    if (self.model.resourseArray.count == 0) {
        [ShowMessageTipUtil showTipLabelWithMessage:@"暂无下载资源" spacingWithTop:kWindowHeight/2 stayTime:2];
    }else{
        
        [self createAndPushWebViewWithUrl:self.model.resourseArray[0]];
    }
}

#pragma mark 获取源数据

//获取单个任务详情数据
-(void)loadDataOfTaskDetailOfIndex:(NSInteger)index withAction:(void (^)())block{
    
    //每次请求网络数据前检测网络状态
    KCheckNetWorkAndRetuen(^(){})
    
    WK(weakSelf);
    
    NSString *url = [NSString stringWithFormat:@"%@%lu",API_TaskDetail,index];

    [PttLoadingTip startLoading];
    [HttpService sendGetHttpRequestWithUrl:url paraments:nil successBlock:^(NSDictionary *jsonDic) {
        
        //初始化数据
        self.model = [TaskDetailModel new];
        
        //设置标题数据
        NSDictionary *detailDic = [jsonDic objectForKey:@"detail"];
        if (detailDic) {
            [self.model setValuesForKeysWithDictionary:detailDic];
        }
        
        //设置具体步骤模块和相关要求模块数据
        NSDictionary *extendDic = [PTT_Data_Kit dicionaryWihJSON:[jsonDic objectForKey:@"extend"]];
        if (extend) {
            
            //添加具体步骤数据
            NSArray *arrayOfSetup = [extendDic objectForKey:@"step"];
            if (arrayOfSetup && arrayOfSetup.count != 0) {
                
                self.model.stepArray = @[].mutableCopy;
                [arrayOfSetup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSString *setupName = [(NSDictionary*)obj objectForKey:@"name"];
                        if (setupName) {
                            [self.model.stepArray addObject:setupName];
                        }
                    }
                }];
            }
            
            //添加相关要求数据
            NSArray *arrayOfRequire = [extendDic objectForKey:@"require"];
            if (arrayOfRequire && arrayOfRequire.count != 0) {
                
                self.model.requireArray = @[].mutableCopy;
                [arrayOfRequire enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSString *requireName = [(NSDictionary*)obj objectForKey:@"name"];
                        if (requireName) {
                            [self.model.requireArray addObject:requireName];
                        }
                    }
                }];
            }
            
            //添加目标效果展示数据
            NSArray *arrayOfImg = [extendDic objectForKey:@"img"];
            if (arrayOfImg && arrayOfImg.count != 0) {
                
                self.model.imgArray = @[].mutableCopy;
                [arrayOfImg enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *link = [obj objectForKey:@"link"];
                        if (link) {
                            [self.model.imgArray addObject:link];
                        }
                    }
                }];
            }
            
            //获取资源下载数据
            NSArray *resourseArray = [extendDic objectForKey:@"resources"];
            if (resourseArray && resourseArray.count != 0) {
                
                self.model.resourseArray = @[].mutableCopy;
                [resourseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *resourseDic = (NSDictionary*)obj;
                        [self.model.resourseArray addObject:[resourseDic objectForKey:@"link"]];
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
                
                self.model.skillArray = @[].mutableCopy;
                [skillArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *skillName = [obj objectForKey:@"name"];
                        if (skillName) {
                            
                            [weakSelf.model.skillArray addObject:skillName];
                        }
                    }
                }];
            }
        }
        
        if(block){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [PttLoadingTip stopLoading];
                //刷新主线程页面
                block();
            });
        }
    } failBlock:^{
       
        weakSelf.model = [TaskDetailModel new];
        weakSelf.model.title = @"暂无数据";
        [weakSelf setupUI];
    }];
}

#pragma mark 按钮触发方法

//回到上个页面
-(void)back{
    
    //如果是模态进来的,则模态出去,否则正常返回
    if(self.weatherPresent){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//点击图片获取复制品放大
-(void)clickImageView:(id)sender{
    
    if([sender isKindOfClass:[UITapGestureRecognizer class]]){
        
        if (self.currentShowImageView) {
            
            [self.currentShowImageView removeFromSuperview];
            self.currentShowImageView = nil;
        }else{
            
            //获取当前的点击UIImageView 并复制一份添加到视图上  
            UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
            self.currentShowImageView = tap.view.mutableCopy;
            
            self.currentShowImageView.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
            self.currentShowImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.currentShowImageView.userInteractionEnabled = YES;
            
            //为该复制品添加点击手势从屏幕中移除
            UITapGestureRecognizer *tapCopy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cliclShowView:)];
            tapCopy.numberOfTapsRequired = 1;
            tapCopy.numberOfTouchesRequired = 1;
            [self.currentShowImageView addGestureRecognizer:tapCopy];
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.currentShowImageView];
        }
    }
}

#pragma mark 创建webView并添加到视图上
-(void)createAndPushWebViewWithUrl:(NSString*)url{
    
    PTTWebViewController *wkWebView = [[PTTWebViewController alloc] init];
    wkWebView.pttTitle = @"资源下载";
    wkWebView.pttUrl = url;
    
    [self.navigationController pushViewController:wkWebView animated:YES];
}

//移除当前正在展示的View
-(void)cliclShowView:(id)sender{
    
    if (self.currentShowImageView && [self.currentShowImageView superview]) {
        
        [self.currentShowImageView removeFromSuperview];
        self.currentShowImageView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//为UIView添加copying协议
@interface UIImageView(PTTImageView)<NSCopying>

@end

@implementation UIImageView(PTTImageView)

-(id)copyWithZone:(NSZone *)zone{
    
    UIImageView *imageView = [UIImageView allocWithZone:zone];
    return imageView;

}

-(id)mutableCopy{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.image = self.image;
    return imageView;
}

@end
