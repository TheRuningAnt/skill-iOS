//
//  JobIntroduceController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/31.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "JobIntroduceController.h"
#import "TaskDetailTipView.h"

@interface JobIntroduceController ()

@property (nonatomic,strong) NSArray *jobIntroduceArray;

@end

@implementation JobIntroduceController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_24c9a7,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"职业简介";
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"职业简介模块"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [self loadData];

    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"职业简介模块"];
}

//布局页面
-(void)setupUI{
    
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setShadowImage:nil];
    self.view.backgroundColor = color_e8efed;
    
    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[item1];
}

//根据获取下来的数据,布局页面子控件
-(void)setupSubViews{
    
    __block CGFloat totalHeight = 0;
    
    //创建保存各个展示模块的数组
    __block NSMutableArray *subViews = @[].mutableCopy;
    
    if(self.jobIntroduceArray && self.jobIntroduceArray.count != 0){
        
        [self.jobIntroduceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if (obj && [obj isKindOfClass:[NSDictionary class]] && ((NSDictionary*)obj).count !=0   ) {
        
                //创建提示label
                TaskDetailTipView* tipView = [[TaskDetailTipView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50*HEIGHT_SCALE)];
                tipView.title = [obj objectForKey:@"name"];
                
                //创建描述Label
                NSString *describ = [obj objectForKey:@"content"];
                CGFloat describHeight = KTextHeight(describ);
                
                UILabel *describL = [[UILabel alloc] initWithFrame:CGRectMake(20, 50*HEIGHT_SCALE, kWindowWidth - 20, describHeight + 20)];
                describL.backgroundColor = [UIColor whiteColor];
                describL.textColor = color_7892a5;
                describL.text = describ;
                describL.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
                describL.backgroundColor = [UIColor whiteColor];
                describL.layer.borderWidth = 1;
                describL.layer.borderColor = [UIColor whiteColor].CGColor;
                describL.numberOfLines = 0;
                
                //创建下方分割线
                UILabel *lineOfDown = [[UILabel alloc] initWithFrame:CGRectMake(0, 50*HEIGHT_SCALE +describL.height - 1, kWindowWidth, 0.5)];
                lineOfDown.backgroundColor = color_dfeaff;
                
                //创建子容器view
                UIView *subContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50*HEIGHT_SCALE +describL.height)];
                subContentView.backgroundColor = [UIColor whiteColor];
                
                [subContentView addSubview:tipView];
                [subContentView addSubview:describL];
                [subContentView addSubview:lineOfDown];
                
                [subViews addObject:subContentView];
                
                totalHeight = totalHeight + subContentView.height + 10*HEIGHT_SCALE;
            }
        }];
        
        //创建根容器scrollView
        __block UIScrollView *contextView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.view.height)];
        contextView.contentSize = CGSizeMake(kWindowWidth, totalHeight);
        contextView.backgroundColor = color_e8efed;
        contextView.showsVerticalScrollIndicator = NO;
        contextView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:contextView];
        
        __block UIView *lastView= nil;

        //遍历添子控件
        if (subViews.count != 0) {
            
            [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                UIView *view = (UIView*)obj;
                [contextView addSubview:view];
                
                if (!lastView) {
                    
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                       
                        make.top.mas_equalTo(contextView.mas_top).offset(0);
                        make.left.mas_equalTo(contextView.mas_left);
                        make.height.mas_equalTo(view.height);
                        make.width.mas_equalTo(kWindowWidth);
                    }];
                }else{
                    
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.mas_equalTo(lastView.mas_bottom).offset(10*HEIGHT_SCALE);
                        make.left.mas_equalTo(contextView.mas_left);
                        make.height.mas_equalTo(view.height);
                        make.width.mas_equalTo(kWindowWidth);
                    }];
                }
                
                lastView = view;
            }];
        }
    }
}

#pragma mark 获取职业简介数据
-(void)loadData{
    
    WK(weakSelf);
    
    //每次请求网络数据前检测网络状态
    KCheckNetWorkAndRetuen(^(){})
    
    NSString *url = [NSString stringWithFormat:@"%@%lu",API_JobDetail,self.jobId];
    
    [HttpService sendGetHttpRequestWithUrl:url paraments:nil successBlock:^(NSDictionary *jsonDic) {
        
        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
            NSString *modulesStr = [jsonDic objectForKey:@"modules"];
            
            if (modulesStr) {
                
                NSData *modulesData = [modulesStr dataUsingEncoding:NSUTF8StringEncoding];
                weakSelf.jobIntroduceArray = [NSJSONSerialization JSONObjectWithData:modulesData options:NSJSONReadingAllowFragments error:nil];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf setupSubViews];
        });
    }];
}

#pragma mark 导航栏返回按钮触发方法
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 懒加载
-(NSArray *)jobIntroduceArray{
    if (!_jobIntroduceArray) {
        _jobIntroduceArray = [NSArray array];
    }
    return _jobIntroduceArray;
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
