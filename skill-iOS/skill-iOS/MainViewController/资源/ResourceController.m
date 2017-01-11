//
//  ResourceController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/21.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "ResourceController.h"
#import "PTTFlowBtnView.h"
#import "SwitchoverThreeTableView.h"
#import "LibraryCell.h"
#import "PTTWebViewController.h"
#import "LibrayBookCellTableViewCell.h"

@interface ResourceController ()<UITableViewDelegate,UITableViewDataSource>

/**
    导航栏顶部工程师提示按钮
 */
@property (nonatomic,strong) UIButton *topNavBtn;

/**
    创建保存工程师名和对应oid的键值对
 */
@property (nonatomic,strong) NSDictionary *jobNameAndIdDic;
/**
 * 创建按钮列表的pttFlowBtnView
 */
@property (nonatomic,strong) PTTFlowBtnView *pttFlowBtnView;
/**
  文档tableView
 */
@property (nonatomic,strong) UITableView *wordTableView;
/**
 视频tableView
 */
@property (nonatomic,strong) UITableView *videoTableView;
/**
 书籍tableView
 */
@property (nonatomic,strong) UITableView *booksTableView;
/**
   没有内容时,文档 模块的占位图
 */
@property (nonatomic,strong) UIImageView *wordNonDageImageV;
/**
 没有内容时,视频 模块的占位图
 */
@property (nonatomic,strong) UIImageView *videoNonDageImageV;
/**
 没有内容时,书籍 模块的占位图
 */
@property (nonatomic,strong) UIImageView *booksNonDageImageV;


/**
 当前的Job id
 */
@property (nonatomic,assign) NSInteger currentOid;
/**
 保存文档模型数组
 */
@property (nonatomic,strong) __block NSMutableArray *wordModels;
/**
 当前的文档页面下标
 */
@property (nonatomic,assign) NSInteger currentWordPage;
/**
 保存视频模型数组
 */
@property (nonatomic,strong) __block NSMutableArray *videoModels;
/**
 当前的视频页面下标
 */
@property (nonatomic,assign) NSInteger currentWVideoPage;
/**
 保存书籍模型数组
 */
@property (nonatomic,strong) __block NSMutableArray *bookModels;
/**
 当前的书籍页面下标
 */
@property (nonatomic,assign) NSInteger currentBookPage;

@end

@implementation ResourceController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
        
        NSDictionary *dict = @{NSForegroundColorAttributeName:color_24c9a7,
                               NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                               };
        self.navigationController.navigationBar.titleTextAttributes = dict;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.hidden = NO;
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"资源模块"];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializData];
    
    [self setupUI];
    
    WK(weakSelf);
    //加载三个UITableView的数据
    [self loadDataWithTibleView:weakSelf.wordTableView CurrentPage:1 type:1 mutableArray:weakSelf.wordModels];
    [self loadDataWithTibleView:weakSelf.videoTableView CurrentPage:1 type:2 mutableArray:weakSelf.videoModels];
    [self loadDataWithTibleView:weakSelf.booksTableView CurrentPage:1 type:3 mutableArray:weakSelf.bookModels];
}


- (void)viewWillDisappear:(BOOL)animated
{
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"资源模块"];
    [PttLoadingTip stopLoading];
}

-(void)initializData{
    
    //根据是不是由职业详情页面推出来的进行不同的处理
    if (self.oid > 0) {
        
        self.currentOid = self.oid;
    }else{
        
        self.currentOid = 1;
    }
    self.currentWordPage = 1;
    self.currentWVideoPage = 1;
    self.currentBookPage = 1;
}

//设置子控件布局
-(void)setupUI{
    
    self.view.backgroundColor = color_e8efed;
    self.view.clipsToBounds = YES;
    self.view.layer.masksToBounds = YES;
    
    if (self.uid <= 0) {
        
        //设置导航栏按钮
        self.navigationItem.titleView = self.topNavBtn;
    }
    
    //根据是否是职业详情页面推出来的来判断是否添加返回按钮
    if (self.oid > 0 || self.uid > 0 || self.pushFromSkill) {
        
        //导航栏返回按钮
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItems = @[item1];
    }
    
    //根据是不是由职业详情页面推出来的进行不同的处理
    
    if (self.uid > 0) {
        
        self.title = @"我的收藏";
    }else if (self.oid > 0) {
        
        NSString *key = [NSString stringWithFormat:@"%d",self.oid];
        NSString *name = [self.jobNameAndIdDic objectForKey:key];
        [self.topNavBtn setTitle:name forState:UIControlStateNormal];
    }else {
        
        [self.topNavBtn setTitle:@"CSS工程师" forState:UIControlStateNormal];
    }
    
    //如果是从查看他人信息页面推出的 显示"TA的收藏"
    if(self.visitor){
        
        self.title = @"TA的收藏";
    }
    
    //添加SwitchoverThreeTableView
    SwitchoverThreeTableView *switchThreeTableView = [[SwitchoverThreeTableView alloc]
                                                      initWithFrame:CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height)
                                                      FirstBtnTitle:@"文档"
                                                      firstView:self.wordTableView
                                                      firstAction:nil
                                                      sectionBtnTitle:@"视频"
                                                      secondView:self.videoTableView
                                                      secondAction:nil
                                                      thirdBtnTitle:@"书籍"
                                                      thirdView:self.booksTableView
                                                      thirdAction:nil
                                                      tabBaeHidden:NO];
    if (self.oid == 0 && self.uid <= 0) {
        
        [switchThreeTableView changHeight:-48];
    }
    [self.view addSubview:switchThreeTableView];
    
    //添加按钮选择控件  该控件需要放到最后去添加,因为其展示出来的子视图是隐藏着的
    [self.view addSubview:self.pttFlowBtnView];
}

#pragma mark 加载网络数据

-(void)loadDataWithTibleView:(UITableView*)tableView CurrentPage:(NSInteger)currentPage type:(NSInteger)type mutableArray:(NSMutableArray*)mutArray{
    
    KCheckNetWorkAndRetuen(^(){
      
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
    })
    
    WK(weakSelf);
    NSString *strOfUrl;
    //根据从不同的页面推出来的  设置不同的网络请求
    
    if(self.uid > 0){
        
        strOfUrl = [NSString stringWithFormat:@"%@%d?",API_MyCollect,self.uid];
    }else {
        
        strOfUrl = [NSString stringWithFormat:@"%@%lu?",API_JobLibrary,self.currentOid];
    }
    
    
    NSDictionary *paramentsDic = nil;
    //如果是访客模式 则不添加token请求数据
    if (self.visitor) {
        
        paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",currentPage],@"page",@"10",@"size",[NSString stringWithFormat:@"%lu",type] ,@"type",nil];

    }else{
        
        paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",currentPage],@"page",@"10",@"size",[NSString stringWithFormat:@"%lu",type] ,@"type",nil];
    }
    
    [PttLoadingTip startLoading];
    
    [HttpService sendGetHttpRequestWithUrl:strOfUrl paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {

        //创建记录值,记录该次加载开始前数组的元素个数是多少,当加载结束后再次判断数组内model数量和该值的比较,一致则判定无新数据了
        NSInteger numberBeforeLoad = mutArray.count;

        if (jsonDic && [jsonDic isKindOfClass:[NSArray class]]) {
            
            NSArray *arrayOfModels = (NSArray*)jsonDic;
            if (arrayOfModels && arrayOfModels.count != 0) {
                
                [arrayOfModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                        
                        LibraryModel *model = [LibraryModel new];
                        [model setValuesForKeysWithDictionary:obj];
                        [mutArray addObject:model];
                    }
                }];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [PttLoadingTip stopLoading];
            
            [tableView reloadData];
            
            //判断数据是否为空来决定是否添加对应的无资源图片
            if ([[paramentsDic objectForKey:@"page"] integerValue] == 1 && mutArray.count == 0) {
                
                if (tableView.tag == 1001 && !weakSelf.wordNonDageImageV.superview) {
                    
                    [tableView addSubview:weakSelf.wordNonDageImageV];
                }
                if (tableView.tag == 1002 && !weakSelf.videoNonDageImageV.superview) {
                    
                    [tableView addSubview:weakSelf.videoNonDageImageV];
                }
                if (tableView.tag == 1003 && !weakSelf.booksNonDageImageV.superview) {
                    
                    [tableView addSubview:weakSelf.booksNonDageImageV];
                }
            }
            if (mutArray.count > 0) {
                
                if (tableView.tag == 1001 && weakSelf.wordNonDageImageV.superview) {
                    
                    [weakSelf.wordNonDageImageV removeFromSuperview];
                }
                if (tableView.tag == 1002 && weakSelf.videoNonDageImageV.superview) {
                    
                    [weakSelf.videoNonDageImageV removeFromSuperview];
                }
                if (tableView.tag == 1003 && weakSelf.booksNonDageImageV.superview) {
                    
                    [weakSelf.booksNonDageImageV removeFromSuperview];
                }
            }
            
            //判断是否已经没有新数据了 给用户提示
            if(numberBeforeLoad == mutArray.count && [[paramentsDic objectForKey:@"page"] integerValue] != 1){
                
                //如果当前展示的我的收藏内容  则提示没有更多收藏了
                if (self.uid > 0) {
                    
                    [ShowMessageTipUtil showTipLabelWithMessage:@"暂无更多收藏内容" spacingWithTop:kWindowHeight/2 stayTime:2];
                }else{
                 
                    [ShowMessageTipUtil showTipLabelWithMessage:@"没有更多资源了" spacingWithTop:kWindowHeight/2 stayTime:2];
                }
            }
            
            [tableView.mj_header endRefreshing];
            [tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark tableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1001) {
        
        return self.wordModels.count;
    }else if (tableView.tag == 1002) {
        
        return self.videoModels.count;
    }else if (tableView.tag == 1003) {
        
        return self.bookModels.count;
    }else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1003) {
        
        return 120*HEIGHT_SCALE;
    }else{
        
        return 110*HEIGHT_SCALE;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1001) {
        
        LibraryModel *model = self.wordModels[indexPath.row];
        if (model && model.url) {
            
            [self createAndPushWebViewWithUrl:model.url];
        }
    }
    if (tableView.tag == 1002) {
        
        LibraryModel *model = self.videoModels[indexPath.row];
        if (model && model.url) {
            
            [self createAndPushWebViewWithUrl:model.url];
        }
    }
    if (tableView.tag == 1003) {
        
        LibraryModel *model = self.bookModels[indexPath.row];
        if (model && model.url) {
            
            [self createAndPushWebViewWithUrl:model.url];
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1001) {

        LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wordCell"];
        LibraryModel *model = self.wordModels[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.model = model;
        return cell;
    }
    if (tableView.tag == 1002) {
        
        LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        LibraryModel *model = self.videoModels[indexPath.row];
        cell.model = model;
        return cell;
    }
    if (tableView.tag == 1003) {
        
        LibrayBookCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        LibraryModel *model = self.bookModels[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
};

#pragma mark 创建webView并添加到视图上
-(void)createAndPushWebViewWithUrl:(NSString*)url{
    
    PTTWebViewController *wkWebView = [[PTTWebViewController alloc] init];
    wkWebView.pttTitle = @"资源详情";
    wkWebView.pttUrl = url;

    [self.navigationController pushViewController:wkWebView animated:YES];
}

#pragma mark 按钮触发事件
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clikcTopNavBtn{
    
    if (self.topNavBtn.selected) {
        
        self.topNavBtn.selected = NO;
        self.pttFlowBtnView.hidden = YES;
    }else{
        
        self.topNavBtn.selected = YES;
        self.pttFlowBtnView.hidden = NO;
    }
}

#pragma mark 懒加载

-(UIButton *)topNavBtn{
    
    if (!_topNavBtn) {
        
        _topNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topNavBtn.frame = CGRectMake(0, 0, 150*WIDTH_SCALE, 40*HEIGHT_SCALE);
        _topNavBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_topNavBtn setTitle:@"CSS工程师" forState:UIControlStateNormal];
        [_topNavBtn addTarget:self action:@selector(clikcTopNavBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [_topNavBtn setTitleColor:color_0f4068 forState:UIControlStateNormal];
        [_topNavBtn setImage:[UIImage imageNamed:@"top-button-tip-down"] forState:UIControlStateNormal];
        
        [_topNavBtn setTitleColor:color_51d4b9 forState:UIControlStateSelected];
        [_topNavBtn setImage:[UIImage imageNamed:@"top-button-tip-up"] forState:UIControlStateSelected];
        
        //设置图片和文本的位置
        [_topNavBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_topNavBtn.imageView.frame.size.width, 0, _topNavBtn.imageView.frame.size.width)];
        [_topNavBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _topNavBtn.titleLabel.frame.size.width + 14, 0, -_topNavBtn.titleLabel.bounds.size.width)];
    }
    return _topNavBtn;
}

-(NSDictionary *)jobNameAndIdDic{
    if (!_jobNameAndIdDic) {
        _jobNameAndIdDic = [NSDictionary dictionaryWithObjectsAndKeys:@"CSS工程师",@"1",@"JS工程师",@"2",@"安卓工程师",@"3",@"iOS工程师",@"4",@"JAVA工程师",@"5",@"运维工程师",@"6",@"产品经理",@"7",@"UI工程师",@"8",nil];
    }
    return _jobNameAndIdDic;
}

-(PTTFlowBtnView *)pttFlowBtnView{
    WK(weakSelf);
    if (!_pttFlowBtnView) {
        
        NSMutableArray *jobNamesArray = [NSMutableArray array];
        for (int i = 0; i < self.jobNameAndIdDic.count; i ++) {
            
            [jobNamesArray addObject:[self.jobNameAndIdDic objectForKey:[NSString stringWithFormat:@"%d",i + 1]]];
        }
        
        _pttFlowBtnView = [[PTTFlowBtnView alloc] initPttFolwBtnViewWithFrame:CGRectMake(0, 0, kWindowWidth, self.view.height) titles:jobNamesArray btnWith:81*WIDTH_SCALE btnHeight:32.5*HEIGHT_SCALE numberOfHorizontal:4 block:^(NSInteger tagValue) {
            
            NSString *jobName = [weakSelf.jobNameAndIdDic objectForKey:[NSString stringWithFormat:@"%lu",tagValue]];
            [weakSelf.topNavBtn setTitle:jobName forState:UIControlStateNormal];
            weakSelf.pttFlowBtnView.hidden = YES;
            weakSelf.topNavBtn.selected = NO;
            
            //点击之后更新下方的tableView
            
            [weakSelf.wordModels removeAllObjects];
            [weakSelf.videoModels removeAllObjects];
            [weakSelf.bookModels removeAllObjects];
            
            weakSelf.currentWordPage = 1;
            weakSelf.currentWVideoPage = 1;
            weakSelf.currentBookPage =  1;
            
            weakSelf.currentOid = tagValue;
            
            [weakSelf loadDataWithTibleView:weakSelf.wordTableView CurrentPage:1 type:1 mutableArray:weakSelf.wordModels];
            [weakSelf loadDataWithTibleView:weakSelf.videoTableView CurrentPage:1 type:2 mutableArray:weakSelf.videoModels];
            [weakSelf loadDataWithTibleView:weakSelf.booksTableView CurrentPage:1 type:3 mutableArray:weakSelf.bookModels];
        }];
        
        _pttFlowBtnView.hidden = YES;
    }
    return _pttFlowBtnView;
}

-(NSMutableArray *)wordModels{
    if (!_wordModels) {
        _wordModels = @[].mutableCopy;
    }
    return _wordModels;
}

-(NSMutableArray *)videoModels{
    if (!_videoModels) {
        _videoModels = @[].mutableCopy;
    }
    return _videoModels;
}

-(NSMutableArray *)bookModels{
    if (!_bookModels) {
        _bookModels = @[].mutableCopy;
    }
    return _bookModels;
}

//创建文档tableView
-(UITableView *)wordTableView{
    
    if (!_wordTableView) {
        
        _wordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height - 20) style:UITableViewStylePlain];
        [_wordTableView registerClass:[LibraryCell class] forCellReuseIdentifier:@"wordCell"];
        _wordTableView.tag = 1001;
        _wordTableView.delegate =self;
        _wordTableView.dataSource = self;
        _wordTableView.showsVerticalScrollIndicator = NO;
        _wordTableView.backgroundColor = color_e8efed;
        
        //设置头视图
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 10*HEIGHT_SCALE)];
        headView.backgroundColor = color_e8efed;
        _wordTableView.tableHeaderView = headView;
        
        //添加下拉刷新  上拉加载功能
        WK(weakSelf);
        _wordTableView.mj_header = [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
            
            weakSelf.currentWordPage = 1;
            [weakSelf.wordModels removeAllObjects];
           [weakSelf loadDataWithTibleView:weakSelf.wordTableView CurrentPage:weakSelf.currentWordPage type:1 mutableArray:weakSelf.wordModels];
        }];
        _wordTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            weakSelf.currentWordPage ++;
            [weakSelf loadDataWithTibleView:weakSelf.wordTableView CurrentPage:weakSelf.currentWordPage type:1 mutableArray:weakSelf.wordModels];
        }];
        
        //隐藏多余分割线
        _wordTableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _wordTableView;
}

//创建视频tableView
-(UITableView *)videoTableView{
    
    if (!_videoTableView) {
        
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height - 20) style:UITableViewStylePlain];
        [_videoTableView registerClass:[LibraryCell class] forCellReuseIdentifier:@"videoCell"];
        _videoTableView.tag = 1002;
        _videoTableView.delegate =self;
        _videoTableView.dataSource = self;
        _videoTableView.showsVerticalScrollIndicator = NO;
        _videoTableView.backgroundColor = color_e8efed;
        
        //设置头视图
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 10*HEIGHT_SCALE)];
        headView.backgroundColor = color_e8efed;
        _videoTableView.tableHeaderView = headView;
        
        //添加下拉刷新  上拉加载功能
        WK(weakSelf);
        _videoTableView.mj_header = [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
            
            weakSelf.currentWVideoPage = 1;
            [weakSelf.videoModels removeAllObjects];
            [weakSelf loadDataWithTibleView:weakSelf.videoTableView CurrentPage:weakSelf.currentWordPage type:2 mutableArray:weakSelf.videoModels];
        }];
        _videoTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            weakSelf.currentWVideoPage ++;
            [weakSelf loadDataWithTibleView:weakSelf.videoTableView CurrentPage:weakSelf.currentWVideoPage type:2 mutableArray:weakSelf.videoModels];
        }];
        
        //隐藏多余分割线
        _videoTableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _videoTableView;
}

//创建书籍tableView
-(UITableView *)booksTableView{
    
    if (!_booksTableView) {
        
        _booksTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height - 20) style:UITableViewStylePlain];
        [_booksTableView registerClass:[LibrayBookCellTableViewCell class] forCellReuseIdentifier:@"bookCell"];
        _booksTableView.tag = 1003;
        _booksTableView.delegate =self;
        _booksTableView.dataSource = self;
        _booksTableView.showsVerticalScrollIndicator = NO;
        _booksTableView.backgroundColor = color_e8efed;
        
        //设置头视图
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 10*HEIGHT_SCALE)];
        headView.backgroundColor = color_e8efed;
        _booksTableView.tableHeaderView = headView;
        
        //添加下拉刷新  上拉加载功能
        WK(weakSelf);
        _booksTableView.mj_header = [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
            
            weakSelf.currentBookPage = 1;
            [weakSelf.bookModels removeAllObjects];
            [weakSelf loadDataWithTibleView:weakSelf.booksTableView CurrentPage:weakSelf.currentBookPage type:3 mutableArray:weakSelf.bookModels];
        }];
        _booksTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            weakSelf.currentBookPage ++;
            [weakSelf loadDataWithTibleView:weakSelf.booksTableView CurrentPage:weakSelf.currentBookPage type:3 mutableArray:weakSelf.bookModels];
        }];
        
        //隐藏多余分割线
        _booksTableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _booksTableView;
}

//创建文档模块没数据的占位图
-(UIImageView *)wordNonDageImageV{
    
    if (!_wordNonDageImageV) {
        
        _wordNonDageImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"non-collection"]];
        _wordNonDageImageV.contentMode = UIViewContentModeCenter;
        _wordNonDageImageV.frame = CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height - 20);
    }
    return _wordNonDageImageV;
}

//创建视频模块没数据的占位图
-(UIImageView *)videoNonDageImageV{
    
    if (!_videoNonDageImageV) {
        
        _videoNonDageImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"non-collection"]];
        _videoNonDageImageV.contentMode = UIViewContentModeCenter;
        _videoNonDageImageV.frame = CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height - 20);
    }
    return _videoNonDageImageV;
}

//创建文档模块没数据的占位图
-(UIImageView *)booksNonDageImageV{
    
    if (!_booksNonDageImageV) {
        
        _booksNonDageImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"non-collection"]];
        _booksNonDageImageV.contentMode = UIViewContentModeCenter;
        _booksNonDageImageV.frame = CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height - 20);
    }
    return _booksNonDageImageV;
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
