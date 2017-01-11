
//
//  MyClassController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/7.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "MyClassController.h"
#import "TaskDetailTipView.h"
#import "JobDailyController.h"
#import "ResourceController.h"
#import "WirteDailyController.h"
#import "JobsListController.h"
#import "ClassDetailController.h"
#import <Accelerate/Accelerate.h>

/**
  创建一个私有的UILabel category
 */
@interface UILabel(pttExtend)
/**
快速创建文本提示框
*/
-(instancetype)initOfTipLael;
/**
 快速创建文本显示框
 */
-(instancetype)initOfSubLabel;

@end

@implementation UILabel(pttExtend)

-(instancetype)initOfSubLabel{
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = color_7892a5;
        self.font = [UIFont systemFontOfSize:15*WIDTH_SCALE];
        self.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

-(instancetype)initOfTipLael{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = color_0f4068;
        self.font = [UIFont systemFontOfSize:15*WIDTH_SCALE];
    }
    return self;
}

@end


/**
   创建该界面使用的model
 */
@interface SubUserModel : NSObject

/**
   用户头像
 */
@property (nonatomic,strong) NSString *thumb;
/**
 * none 无班级 online 线上散修班 outside 线上外门班offline线下内门班
 */
@property (nonatomic,assign) NSString *type;
/**
  班号
 */
@property (nonatomic,strong) NSString *name;
/**
 职业id
 */
@property (nonatomic,assign) NSInteger oid;
/**
 班级成立时间 对应字段 createAt
 */
@property (nonatomic,assign) NSInteger classCreateAt;
/**
   班级QQ群
 */
@property (nonatomic,assign) NSInteger qq;
/**
 班级人数
 */
@property (nonatomic,assign) NSInteger total;
/**
 入学时间 对应字段 createAt
 */
@property (nonatomic,assign) NSInteger personCreateAt;
/**
   学号
 */
@property (nonatomic,assign) NSInteger studyNumber;

/**
  用户id
 */
@property (nonatomic,assign) NSInteger uid;
/**
   班级id
 */
@property (nonatomic,assign) NSInteger cid;
@end

@implementation SubUserModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

/**
   MyClassController
 */
@interface MyClassController ()
/**
 头像背景图
 */
@property (nonatomic,strong) UIImageView *headBackImageV;
/**
  头像
 */
@property (nonatomic,strong) UIImageView *headImageV;
/**
 我的班级label
 */
@property (nonatomic,strong) UILabel * classNmaeL;
/**
 班级成立时间label
 */
@property (nonatomic,strong) UILabel * creatTimeL;
/**
 qq label
 */
@property (nonatomic,strong) UILabel * qqL;
/**
 班级人数Label
 */
@property (nonatomic,strong) UILabel * peopleNumberL;
/**
 入学时间label
 */
@property (nonatomic,strong) UILabel * joinTimeL;
/**
 学号label
 */
@property (nonatomic,strong) UILabel * myNumberL;
/**
  保存当前页面信息的Model
 */
@property (nonatomic,strong) SubUserModel *infoModel;
/**
   导航栏跳转特殊属性字段
 */
@property (nonatomic,assign) NSInteger tapOfShow;
/**
   创建上方控件的承载视图
 */
@property (nonatomic,strong) UIView *topContentView;

@end

@implementation MyClassController

-(void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    if (_tapOfShow == 0) {
        
        self.navigationController.navigationBar.translucent = YES;
    }else{
        
        self.navigationController.navigationBar.translucent = NO;
    }

    
    if (!self.visitor) {
        
        //启动友盟页面统计
        [MobClick beginLogPageView:@"我的班级模块"];
    }else{
        
        //启动友盟页面统计
        [MobClick beginLogPageView:@"TA的班级模块"];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
    //检测当前头像是否有图片,如果有图片的话,则直接拿来做渲染背景图,没有图片的话则给头像视图添加观察者
    if (self.headImageV.image) {
        
        UIImage *blureImage = [self coreBlurImage:self.headImageV.image withBlurNumber:0.9];

        //如果是用ipod直接拍照上传的则需要旋转角度
        if (blureImage.size.width == 3264 && blureImage.size.height == 2448) {
            
            blureImage = [UIImage imageWithCGImage:blureImage.CGImage scale:1.0f orientation:UIImageOrientationRight];
        }

        self.headBackImageV.image = blureImage;
    }else{
        
        NSLog(@"暂无图片");

        //给用户头像添加观察者,当获取到用户的头像的时候,更新背景图片
        [self.headImageV addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    [self loadUserInfo];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    if (!self.visitor) {
        
        //退出友盟页面统计
        [MobClick endLogPageView:@"我的班级模块"];
    }else{
        
        //退出友盟页面统计
        [MobClick endLogPageView:@"TA的班级模块"];
    }
    
    //用户的头像视图添加有观察者,当头像视图有图片的时候观察者会移除,但是如果用户一直获取不到头像数据,那么需要在界面消失的时候移除观察者
    
    if (self.headImageV.observationInfo) {
        
        [self.headImageV removeObserver:self forKeyPath:@"image"];
    }
}

-(void)setUpUI{

    self.view.backgroundColor = color_e8efed;
    self.view.layer.masksToBounds = YES;
    self.view.clipsToBounds = YES;
    
    WK(weakSelf);
    
    //添加承载控件的根scrollView
    UIScrollView *contentScrollV = [[UIScrollView alloc] init];
    contentScrollV.backgroundColor = color_e8efed;
    contentScrollV.showsVerticalScrollIndicator = NO;
    //如果是访客模式  则承载下方子控件的scrollView的conentSize则不需要添加学习窍门模块的高度
    if(self.visitor){
        
        contentScrollV.contentSize = CGSizeMake(kWindowWidth, 10 + 60*HEIGHT_SCALE * 3 + 10 + 380*HEIGHT_SCALE);
    }else{
        
        contentScrollV.contentSize = CGSizeMake(kWindowWidth, 10 + 60*HEIGHT_SCALE * 3 + 10 + 4 * 50 *HEIGHT_SCALE + 380*HEIGHT_SCALE);
    }

    [self.view addSubview:contentScrollV];
    [contentScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(-20);
        make.width.mas_equalTo(kWindowWidth);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.left.mas_equalTo(weakSelf.view.mas_left);
    }];
    
    //添加头部控件载体
    self.topContentView = [[UIView alloc] init];
    self.topContentView.backgroundColor = [UIColor whiteColor];
    self.topContentView.clipsToBounds = YES;
    self.topContentView.layer.masksToBounds = YES;
    [contentScrollV addSubview:self.topContentView];
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(contentScrollV.mas_top);
        make.centerX.mas_equalTo(contentScrollV.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 380*HEIGHT_SCALE));
    }];
    
    //添加头像背景图片
    [self.topContentView addSubview:self.headBackImageV];
    self.headBackImageV.backgroundColor = [UIColor grayColor];
    self.headBackImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.headBackImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.topContentView.mas_top);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth + 80, 380*HEIGHT_SCALE));
    }];
    
    //给头像背景图片再加一层蒙版
    UIImageView *shadowImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth + 80, 380*HEIGHT_SCALE)];
    shadowImageV.image = [UIImage imageNamed:@"Shadow-image"];
    shadowImageV.alpha = 0.5;
    [self.headBackImageV addSubview:shadowImageV];
    
    //添加上方子控件承载容器 承载班级创建时间等控件
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.topContentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(weakSelf.headBackImageV.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth,180*HEIGHT_SCALE));
        make.centerX.mas_equalTo(weakSelf.headBackImageV.mas_centerX);
    }];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWindowWidth - 200*WIDTH_SCALE)/2, 22, 200*WIDTH_SCALE, 40)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20*WIDTH_SCALE];
    titleLabel.textColor = [UIColor whiteColor];
    if (self.visitor) {
        
        titleLabel.text = @"TA的班级";
    }else{
        
        titleLabel.text = @"我的班级";
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentScrollV addSubview:titleLabel];

    //设置导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(10,22, 40*HEIGHT_SCALE, 40*HEIGHT_SCALE) ;
    //[button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollV addSubview:button];
    
    //添加我的班级提示label
    UILabel *myClassTipL = [[UILabel alloc] initOfTipLael];
    myClassTipL.text = @"我的班级:";
    if(self.visitor){
        
        myClassTipL.text = @"TA的班级:";
    }
    [contentView addSubview:myClassTipL];
    [myClassTipL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(contentView.mas_top).offset(50*HEIGHT_SCALE);
        make.left.mas_equalTo(contentView.mas_left).offset(15*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(70*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];

    //添加我的班级Label
    [self.view addSubview:self.classNmaeL];
    self.classNmaeL.text = @"--";
    [contentView addSubview:self.classNmaeL];
    [self.classNmaeL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(myClassTipL.mas_top);
        make.left.mas_equalTo(myClassTipL.mas_right).offset(2*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(107*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];
    
    //创建成立时间提示Label
    UILabel *createTimeTipL = [[UILabel alloc] initOfTipLael];
    createTimeTipL.text = @"成立时间:";
    [contentView addSubview:createTimeTipL];
    [createTimeTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(contentView.mas_top).offset(50*HEIGHT_SCALE);
        make.left.mas_equalTo(contentView.mas_centerX).offset(10*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(70*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];
    
    //添加成立时间Label
    [contentView addSubview:self.creatTimeL];
    self.creatTimeL.text = @"--";
    [self.creatTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(createTimeTipL.mas_top);
        make.left.mas_equalTo(createTimeTipL.mas_right).offset(2*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(107*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];

    //创建QQ群 tip label
    UILabel *qqTipL = [[UILabel alloc] initOfTipLael];
    qqTipL.text = @"QQ      群:";
    [contentView addSubview:qqTipL];
    [qqTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(myClassTipL.mas_bottom).offset(10*HEIGHT_SCALE);
        make.left.mas_equalTo(contentView.mas_left).offset(15*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(70*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];
    
    //添加QQ群Lable
    [contentView addSubview:self.qqL];
    self.qqL.text = @"--";
    [self.qqL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(qqTipL.mas_top);
        make.left.mas_equalTo(qqTipL.mas_right).offset(2*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(107*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];

    //创建班级人数tip label
    UILabel *classNumberTipL = [[UILabel alloc] initOfTipLael];
    classNumberTipL.text = @"班级人数:";
    [contentView addSubview:classNumberTipL];
    [classNumberTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(createTimeTipL.mas_bottom).offset(10*HEIGHT_SCALE);
        make.left.mas_equalTo(contentView.mas_centerX).offset(10*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(70*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];

    //添加班级人数Label
    [contentView addSubview:self.peopleNumberL];
    self.peopleNumberL.text = @"--";
    [self.peopleNumberL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(classNumberTipL.mas_top);
        make.left.mas_equalTo(classNumberTipL.mas_right).offset(2*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(107*WIDTH_SCALE, 30*HEIGHT_SCALE));

    }];

    //创建入学时间tip L
    UILabel *joinTimeTipL = [[UILabel alloc] initOfTipLael];
    joinTimeTipL.text = @"入学时间:";
    [contentView addSubview:joinTimeTipL];
    [joinTimeTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(qqTipL.mas_bottom).offset(10*HEIGHT_SCALE);
        make.left.mas_equalTo(contentView.mas_left).offset(15*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(70*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];

    //添加入学时间label
    [contentView addSubview:self.joinTimeL];
    self.joinTimeL.text = @"--";
    [self.joinTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(joinTimeTipL.mas_top);
        make.left.mas_equalTo(joinTimeTipL.mas_right).offset(2*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(107*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];

    //创建我的学号Tip label
    UILabel *myNumberTipL = [[UILabel alloc] initOfTipLael];
    myNumberTipL.text = @"我的学号:";
    if(self.visitor){
        
        myNumberTipL.text = @"TA的学号:";
    }
    [contentView addSubview:myNumberTipL];
    [myNumberTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(classNumberTipL.mas_bottom).offset(10*HEIGHT_SCALE);
        make.left.mas_equalTo(contentView.mas_centerX).offset(10*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(70*WIDTH_SCALE, 30*HEIGHT_SCALE));
    }];
    
    //添加我的学号label
    [contentView addSubview:self.myNumberL];
    self.myNumberL.text = @"--";
    [self.myNumberL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(myNumberTipL.mas_top);
        make.left.mas_equalTo(myNumberTipL.mas_right).offset(2*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(107*WIDTH_SCALE, 30*HEIGHT_SCALE));
        
    }];

    //添加用户头像
    [contentView addSubview:self.headImageV];
    
/**
     添加标题及按钮模块
 */
    //创建承载标题和按钮的视图
    UIView *titlesAndBtnsView = [[UIView alloc] init];
    titlesAndBtnsView.backgroundColor = [UIColor whiteColor];
    titlesAndBtnsView.frame = CGRectMake(0, 10*HEIGHT_SCALE + 380*HEIGHT_SCALE, kWindowWidth, 180*HEIGHT_SCALE);
    [contentScrollV addSubview:titlesAndBtnsView];
    
    //循环添加标题和按钮控件
    NSArray *subTitles = @[@"坚持写日报，记录学况，提出疑难，会有大神点评，指点迷津。",@"查看师兄弟的日报，反观自己的盲点、疑难答疑解惑，巩固学习。",@"大神日报堪比修真秘诀，易读易懂，有实战性，迅速储备知识点。"];
    NSArray *btnTitles = @[@"我的日报",@"班级日报",@"职业日报"];
    
    //如果是访客模式 则改变标题内容
    if (self.visitor) {
        
        btnTitles = @[@"TA的日报",@"班级日报",@"职业日报"];
    }

    for (int i = 0 ; i < 3; i ++) {
        
        //添加标题
        UILabel *titleL = [[UILabel alloc] initOfTipLael];
        titleL.text = subTitles[i];
        titleL.numberOfLines = 0;
        titleL.frame = CGRectMake(10*WIDTH_SCALE, 60*HEIGHT_SCALE*i, kWindowWidth - 85*HEIGHT_SCALE, 60*HEIGHT_SCALE);
        
        NSMutableAttributedString *describeString = [[NSMutableAttributedString alloc] initWithString:subTitles[i]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];//调整行间距
        [describeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, describeString.length)];
        titleL.attributedText = describeString;

        [titlesAndBtnsView addSubview:titleL];
        
        //添加按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:color_24c9a8 forState:UIControlStateNormal];
        [button setTitleColor:color_ffffff forState:UIControlStateSelected];
        button.tag = i;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.layer.borderColor = color_24c9a8.CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
        [button addTarget:self action:@selector(clickDailyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [titlesAndBtnsView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(titleL.mas_centerY);
            make.right.mas_equalTo(titlesAndBtnsView.mas_right).offset(-8*WIDTH_SCALE);
            make.size.mas_equalTo(CGSizeMake(65*WIDTH_SCALE, 30*HEIGHT_SCALE));
        }];
        
        //在第一行和第二行下添加提示line
        if (i != 2) {
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10*WIDTH_SCALE, 59*HEIGHT_SCALE*i + 59*HEIGHT_SCALE + + 380*HEIGHT_SCALE, kWindowWidth - 10*WIDTH_SCALE, 1)];
            line.backgroundColor = color_dfeaff;
            [titlesAndBtnsView addSubview:line];
        }
    }

    //如果不是访客模式 则添加学习窍门模块
    if(!self.visitor){
        
        //创建学习窍门contenView
        UIView *learnTipContentView = [[UIView alloc] init];
        learnTipContentView.backgroundColor = [UIColor whiteColor];
        [contentScrollV addSubview:learnTipContentView];
        [learnTipContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(titlesAndBtnsView.mas_bottom).offset(10*HEIGHT_SCALE);
            make.size.mas_equalTo(CGSizeMake(kWindowWidth, 50*HEIGHT_SCALE*4));
            make.left.mas_equalTo(contentScrollV.mas_left);
        }];
        
        //添加提示label
        TaskDetailTipView *tipLabel = [[TaskDetailTipView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50*HEIGHT_SCALE)];
        tipLabel.title = @"学习窍门";
        [learnTipContentView addSubview:tipLabel];
        
        //设置内容文本
        NSArray *titleBtns = @[@"1.学习中遇到了问题苦思冥想仍然无法解决?",@"2.总结一天的学习并安排明天的学习计划?",@"3.希望沟通，在你需要的时候答疑解惑?",@"4.发现超级棒的学习文档、视频或书籍?"];
        
        //添加四个文本提示按钮 点击之后跳转到不同页面
        for (int i = 0; i < 4; i ++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:color_7892a5 forState:UIControlStateNormal];
            [button setTitleColor:color_ffffff forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_SCALE];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [button setTitle:titleBtns[i] forState:UIControlStateNormal];
            button.tag = i;
            
            button.frame = CGRectMake(20*WIDTH_SCALE, 60 + i * 30*HEIGHT_SCALE, kWindowWidth - 30*WIDTH_SCALE, 30*HEIGHT_SCALE);
            [button addTarget:self action:@selector(clickSkillBtn:) forControlEvents:UIControlEventTouchUpInside];
            [learnTipContentView addSubview:button];
        }
    }
}

#pragma mark 加载网络数据

-(void)loadUserInfo{
    
    NSInteger uid;
    
    //访客模式和查看我的信息 获取不同的id
    if(self.visitor){
        
        uid = self.visitorId;
    }else{
        
        uid = [UserTool userId];
    }
    
    //创建请求参数
    NSString *strOfUrl = [NSString stringWithFormat:@"%@",API_PersonFullInfo];
    NSDictionary *paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",uid],@"uids",[UserTool userModel].token,@"token",nil];
    
    WK(weakSelf);
    [HttpService sendGetHttpRequestWithUrl:strOfUrl paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
        
        if(jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]){
            
                NSDictionary *dataDic = (NSDictionary*)jsonDic;
                
                if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
                    
                    //获取个人信息数据
                    NSArray *users = [dataDic objectForKey:@"users"];
                    NSDictionary *userInfoDic = [users firstObject];
                    
                    [weakSelf.infoModel setValuesForKeysWithDictionary:userInfoDic];
                    
                    weakSelf.infoModel.personCreateAt = [[userInfoDic objectForKey:@"createAt"] integerValue];
                    weakSelf.infoModel.uid = [[userInfoDic objectForKey:@"id"] integerValue];
                    
                    //获取班级信息数据
                    NSDictionary *classDic = [dataDic objectForKey:@"classes"];
                    if(classDic && classDic.count != 0){
                        
                        NSDictionary *classInfoDic = [[classDic allValues] firstObject];
                        if (classInfoDic && [classInfoDic isKindOfClass:[NSDictionary class]]) {
                            
                            [weakSelf.infoModel setValuesForKeysWithDictionary:classInfoDic];
                            weakSelf.infoModel.classCreateAt = [[classInfoDic objectForKey:@"createAt"] integerValue];
                            weakSelf.infoModel.cid = [[classInfoDic objectForKey:@"id"] integerValue];
                        }
                    }
                }
            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSelf updateUserData];
        });
    }];
}

#pragma mark 观察者代理方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    WK(weakSelf);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (change.count == 0) {
            return;
        }
        UIImage *headImage = [change objectForKey:@"new"];
        
        if ([headImage isKindOfClass:[NSNull class]]) {
            return;
        }
        
        UIImage *blureImage = [self blureImage:headImage withInputRadius:12];
        
        //如果是用ipod直接拍照上传的则需要旋转角度
        if (blureImage.size.width == 3264 && blureImage.size.height == 2448) {
            
            blureImage = [UIImage imageWithCGImage:blureImage.CGImage scale:1.0f orientation:UIImageOrientationRight];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.headBackImageV.image = blureImage;
            if (self.headImageV.observationInfo) {
                
                [self.headImageV removeObserver:self forKeyPath:@"image"];
            }
        });
    });
}

//更新上方用户数据
-(void)updateUserData{
    
    //设置用户头像
     [self.headImageV sd_setImageWithURL:[NSURL URLWithString:self.infoModel.thumb] placeholderImage:[UIImage imageNamed:@"men-image"]];
    
    //设置班级名数据
    NSDictionary * jobNameAndIdDic = [NSDictionary dictionaryWithObjectsAndKeys:@"CSS",@"1",@"JS",@"2",@"android",@"3",@"iOS",@"4",@"JAVA",@"5",@"OP",@"6",@"PM",@"7",@"UI",@"8",nil];
    
    NSString *typeName = nil;
    if ([self.infoModel.type isEqualToString:@"online"] || [self.infoModel.type isEqualToString:@"outside"]) {
        typeName = @"线上";
    }else if ([self.infoModel.type isEqualToString:@"offline"]) {
        typeName = @"线下";
    }else{
        typeName = @"无班级";
    }
    
    NSString *jobName = nil;
    if (self.infoModel.oid == 0) {
        
        jobName = @"--";
    }else{
        
        jobName = [jobNameAndIdDic objectForKey:[NSString stringWithFormat:@"%lu",self.infoModel.oid]];
    }
    
    self.classNmaeL.text = [NSString stringWithFormat:@"%@%@-%@",typeName,jobName,self.infoModel.name];
    
    //设置成立时间
    NSString *createTime = [PTTDateKit dateLineFormatFrom1970WithTimeInterval:self.infoModel.classCreateAt];
    if (createTime.length > 0) {
        
         self.creatTimeL.text = createTime;
    }else{
        
        self.creatTimeL.text = @"--";
    }
   
    
    //设置QQ群号
    self.qqL.text = [NSString stringWithFormat:@"%lu",self.infoModel.qq];
    
    //设置班级人数
    self.peopleNumberL.text = [NSString stringWithFormat:@"%lu/20",self.infoModel.total];
    
    //设置入学时间
    NSString *joinTime = [PTTDateKit dateLineFormatFrom1970WithTimeInterval:self.infoModel.personCreateAt];
    if (joinTime.length > 0) {
        
        self.joinTimeL.text = joinTime;
    }else{
        
        self.joinTimeL.text = @"--";
    }
    
    //设置学号
    self.myNumberL.text = [NSString stringWithFormat:@"%lu",self.infoModel.studyNumber];
    
    /*特殊情况  如果班级状态是"无班级"
     则将"我的班级" 字段设置为 "暂无加入班级"
     将班级成立时间和入学时间置为 --
     */
    if ([typeName isEqualToString:@"无班级"]) {
        
        self.classNmaeL.text = @"暂无加入班级";
        self.creatTimeL.text = @"--";
        self.joinTimeL.text = @"--";
    }
}

//生成高斯模糊背景
- (UIImage *)blureImage:(UIImage *)originImage withInputRadius:(CGFloat)inputRadius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:originImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

-(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}


#pragma mark 按钮触发事件
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//日报按钮点击事件
-(void)clickDailyBtn:(UIButton*)button{
    
    _tapOfShow = 1;
    switch (button.tag) {
        case 0:
        {
            //推出我的日报页面
            JobDailyController *jobDailyControl = [[JobDailyController alloc] init];
            jobDailyControl.uid = (int)self.infoModel.uid;
            self.navigationController.navigationBar.translucent = NO;

            //如果是访客模式  则添加访客标志
            jobDailyControl.visitor = self.visitor;
            [self.navigationController pushViewController:jobDailyControl animated:YES];
        }
            break;
        case 1:
        {
            //设置班级名数据
            NSDictionary * jobNameAndIdDic = [NSDictionary dictionaryWithObjectsAndKeys:@"CSS",@"1",@"JS",@"2",@"android",@"3",@"iOS",@"4",@"JAVA",@"5",@"OP",@"6",@"PM",@"7",@"UI",@"8",nil];
            
            //点击班级日报  进入班级详情页面,默认展示班级日报内容
            ClassDetailController *classDetailVC = [[ClassDetailController alloc] init];
            classDetailVC.cid = (int)self.infoModel.cid;
            classDetailVC.jobName = [jobNameAndIdDic objectForKey:[NSString stringWithFormat:@"%lu",self.infoModel.oid]];
            _tapOfShow = 0;
            [self.navigationController pushViewController:classDetailVC animated:YES];
        }
            break;
        case 2:
        {
            //推出职业日报页面
            JobDailyController *jobDailyVC = [[JobDailyController alloc] init];
            jobDailyVC.oid = (int)self.infoModel.oid;
            
            self.navigationController.navigationBar.translucent = NO;

            [self.navigationController pushViewController:jobDailyVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//点击窍门按钮之后跳转到对应的界面
-(void)clickSkillBtn:(id)sender{
    
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton*)sender;
        NSInteger btnTag = button.tag;
        
        switch (btnTag) {
            case 1:
            {
                //推出写日报界面,需要判断用户是否已经报名某个职业,没有报名的话提示用户去报名
                if (self.infoModel.cid == 0) {
                    [PTTShowAlertView showAlertViewWithTitle:@"提示" message:@"去选择职业报名？" cancleBtnTitle:@"取消" cancelAction:nil sureBtnTitle:@"确定" sureAction:^{
                        
                        JobsListController *joblistController = [[JobsListController alloc] init];
                        [self.navigationController pushViewController:joblistController animated:YES];
                    }];
                }else{
                    
                    WirteDailyController *writeVC = [[WirteDailyController alloc] init];
                    [self presentViewController:writeVC animated:YES completion:nil];
                }
                
            }
                break;
            case 2:
            {
                if (self.infoModel.cid == 0) {
                    [PTTShowAlertView showAlertViewWithTitle:@"提示" message:@"去选择职业报名？" cancleBtnTitle:@"取消" cancelAction:nil sureBtnTitle:@"确定" sureAction:^{
                        
                        JobsListController *joblistController = [[JobsListController alloc] init];
                        [self.navigationController pushViewController:joblistController animated:YES];
                    }];
                }else{
                    
                    //设置班级职业名数据
                    NSDictionary * jobNameAndIdDic = [NSDictionary dictionaryWithObjectsAndKeys:@"CSS",@"1",@"JS",@"2",@"android",@"3",@"iOS",@"4",@"JAVA",@"5",@"OP",@"6",@"PM",@"7",@"UI",@"8",nil];
                    
                    ClassDetailController *classVC = [[ClassDetailController alloc] init];
                    
                    classVC.cid = self.infoModel.cid;
                    classVC.selectMatesV = YES;
                    classVC.jobName = [jobNameAndIdDic objectForKey:[NSString stringWithFormat:@"%lu",self.infoModel.oid]];

                    [self.navigationController pushViewController:classVC animated:YES];
                }
            }
                break;
            default:{
                
                ResourceController *resourseVC = [[ResourceController alloc] init];
                resourseVC.pushFromSkill = YES;
                [self.navigationController pushViewController:resourseVC animated:YES];
            }
                break;
        }
    }
}

#pragma mark 懒加载

-(UIImageView *)headBackImageV{
    if (!_headBackImageV) {
        _headBackImageV = [[UIImageView alloc] init];
    }
    return _headBackImageV;
}

-(UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] init];
        _headImageV.frame = CGRectMake(kWindowWidth/2 - 50*HEIGHT_SCALE, - 50*HEIGHT_SCALE, 100*HEIGHT_SCALE, 100*HEIGHT_SCALE);
        _headImageV.layer.masksToBounds  = YES;
        _headImageV.backgroundColor = [UIColor whiteColor];
        _headImageV.layer.cornerRadius = 100*HEIGHT_SCALE/2.f;
    }
    return _headImageV;
}

-(UILabel *)classNmaeL{
    if (!_classNmaeL) {
        _classNmaeL = [[UILabel alloc] initOfSubLabel];
    }
    return _classNmaeL;
}

-(UILabel *)creatTimeL{
    if (!_creatTimeL) {
        _creatTimeL = [[UILabel alloc] initOfSubLabel];
    }
    return _creatTimeL;
}

-(UILabel *)qqL{
    if (!_qqL) {
        _qqL = [[UILabel alloc] initOfSubLabel];
    }
    return _qqL;
}

-(UILabel *)peopleNumberL{
    if (!_peopleNumberL) {
        _peopleNumberL = [[UILabel alloc] initOfSubLabel];
    }
    return _peopleNumberL;
}

-(UILabel *)joinTimeL{
    if (!_joinTimeL) {
        _joinTimeL = [[UILabel alloc] initOfSubLabel];
    }
    return _joinTimeL;
}

-(UILabel *)myNumberL{
    if (!_myNumberL) {
        _myNumberL = [[UILabel alloc] initOfSubLabel];
    }
    return _myNumberL;
}

-(SubUserModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [SubUserModel new];
    }
    return _infoModel;
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
