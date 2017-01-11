//
//  NavigationViewController.m
//  MakeLearn-iOS
//
//  Created by 王晨飞 on 16/7/4.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "NavigationViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIColor+Simple.h"

@interface NavigationViewController ()
/**
 *  标签lb
 */
@property (nonatomic, strong) UILabel *title_lb;
/**
 *  当前的控制器，用来获取title和设置title
 */
@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation NavigationViewController

// 是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航条
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)navigationPop
{
    [self popToRootViewControllerAnimated:YES];
}

/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationbar_background"] forBarMetrics:UIBarMetricsDefault];
    
    //设置导航栏标题的颜色
    UIColor * color = color_51d4b9;
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSDictionary *dict = @{NSForegroundColorAttributeName:color,
                           NSFontAttributeName:font,
                           };
    self.navigationBar.titleTextAttributes = dict;
}

/**
 *  当第一次使用这个类的时候调用1次
 */
+ (void)initialize
{
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置导航栏背景
    if (!iOS7) {
        [appearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    }
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    [appearance setTitleTextAttributes:textAttrs];
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
//  textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    [appearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        self.viewController = viewController;
        
//        self.title_lb.text = viewController.title;
//        [self.title_lb sizeToFit];
//        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithCustomView:self.title_lb];

        //返回按钮和标题
        UIBarButtonItem *backItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self action:@selector(back)];
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItems = @[backItem];
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_more" highImageName:@"navigationbar_more_highlighted" target:self action:@selector(more)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
#warning 这里用的是self, 因为self就是当前正在使用的导航控制器
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UILabel *)title_lb
{
    if(!_title_lb)
    {
        _title_lb = [[UILabel alloc]init];
        _title_lb.font = [UIFont systemFontOfSize:16*HEIGHT_SCALE];
        _title_lb.textColor = [UIColor colorFromHex:@"ffffff"];
    }
    return _title_lb;
}

#pragma mark - set方法
- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    self.title_lb.text = _titleString;
    [self.title_lb sizeToFit];
    NSLog(@"%lu",(unsigned long)self.viewControllers.count);
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithCustomView:self.title_lb];
    if(self.viewControllers.count > 1)
    {
        UIBarButtonItem *backItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self action:@selector(back)];
        
        self.viewController.navigationItem.leftBarButtonItems = @[backItem, titleItem];
    }
    else
    {
        BasicViewController *basicController = (BasicViewController *)self.viewControllers.lastObject;
        basicController.navigationItem.leftBarButtonItems = @[titleItem];
    }
}


@end
