//
//  JobSkillController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/31.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "JobSkillController.h"

@interface JobSkillController ()

@property (nonatomic,strong) UIImageView *skillImageV;

@property (nonatomic,strong) UIScrollView *contentView;

@property (nonatomic,strong) NSDictionary *imageAttrsDic;

@end

@implementation JobSkillController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_24c9a7,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"职业技能";
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"职业技能模块"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //退出友盟页面统计
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"职业技能模块"];
}

//布局页面
-(void)setupUI{
    
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setShadowImage:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    //创建图片链接
    NSString *urlStr = [NSString stringWithFormat:@"http://www.jnshu.com/images/%@.png",self.jobName];
    
    NSArray *arrayOfImageAttrs = [self.imageAttrsDic objectForKey:self.jobName];
    CGFloat imageHeight = kWindowWidth/[arrayOfImageAttrs[0] floatValue]*[arrayOfImageAttrs[1] floatValue];
    CGFloat imageWidth = kWindowWidth;
    
    //创建图片
    self.skillImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    self.skillImageV.userInteractionEnabled = YES;
    [self.skillImageV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"job-list-placeHolder"]];
    
    //给图片添加双击放大手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    tap.numberOfTouchesRequired = 1;;
    tap.numberOfTapsRequired = 2;
    [self.skillImageV addGestureRecognizer:tap];
    
    //给图片添加捏合手势
    UIPinchGestureRecognizer *pinchImage = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    [self.skillImageV addGestureRecognizer:pinchImage];
    
    //创建contentView
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.view.frame.size.height)];
    self.contentView.contentSize = CGSizeMake(self.skillImageV.frame.size.width, self.skillImageV.frame.size.height + 64);
    self.contentView.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.userInteractionEnabled = YES;
    
    //添加子视图
    [self.contentView addSubview:self.skillImageV];
    [self.view addSubview:self.contentView];
    
    [self.view addSubview:self.contentView];
}

//点击图片触发方法
-(void)clickImage{

    NSArray *arrayOfImageAttrs = [self.imageAttrsDic objectForKey:self.jobName];
    
    CGFloat originalWidth = [arrayOfImageAttrs[0] floatValue];
    CGFloat originalHeight = [arrayOfImageAttrs[1] floatValue];
    
    WK(weakSelf);

    if (self.skillImageV.frame.size.width != originalWidth) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.skillImageV.frame = CGRectMake(0, 0, originalWidth, originalHeight);
            weakSelf.contentView.contentSize = weakSelf.skillImageV.frame.size;
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.skillImageV.frame = CGRectMake(0, 0, kWindowWidth, kWindowWidth/originalWidth*originalHeight);
            weakSelf.contentView.contentSize = weakSelf.skillImageV.frame.size;
        }];
    }
}

//添加图片捏合手势
-(void)pinchImage:(UIPinchGestureRecognizer*)sender
{
 
    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;
    sender.view.frame = CGRectMake(10*sender.scale, 5*sender.scale, sender.view.frame.size.width, sender.view.frame.size.height);
    self.contentView.contentSize = CGSizeMake(sender.view.frame.size.width*sender.scale, sender.view.frame.size.height*sender.scale + 100*sender.scale);
}

-(NSDictionary *)imageAttrsDic{
    if (!_imageAttrsDic) {
        _imageAttrsDic = [NSDictionary dictionaryWithObjectsAndKeys:@[@"1017",@"1948"],@"css",@[@"1009",@"932"],@"js",@[@"1176",@"1054"],@"android",@[@"1322",@"1603"],@"ios",@[@"733",@"1469"],@"java",@[@"644",@"2121"],@"op",@[@"594",@"1711"],@"pm",@[@"688",@"3164"],@"ui-skill", nil];
    }
    return _imageAttrsDic;
}

#pragma mark 导航栏返回按钮触发方法
-(void)back{
    
    [self.contentView removeFromSuperview];
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
