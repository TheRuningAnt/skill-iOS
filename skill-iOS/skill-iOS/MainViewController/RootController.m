//
//  RootController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/21.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "RootController.h"

#import "HomePageController.h"
#import "ResourceController.h"
#import "MineController.h"

//该控制器为根控制器  所以在这里监听随时可能会发来的推送信息
@interface RootController()

@end

@implementation RootController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    HomePageController *homePageController = [[HomePageController alloc] init];
    [self addOneChlildVc:homePageController title:@"首页" nonSelectImageName:@"nonselect-homepage" selectedImageName:@"select-homepage"];
    
    ResourceController *resourceController = [[ResourceController alloc] init];
    [self addOneChlildVc:resourceController title:@"资源" nonSelectImageName:@"nonselect-library" selectedImageName:@"select-library"];
    
    MineController *mineController = [[MineController alloc] init];
    [self addOneChlildVc:mineController title:@"我的" nonSelectImageName:@"nonselect-mine" selectedImageName:@"select-mine"];
    
    self.selectedIndex = 0;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title nonSelectImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.tabBarItem.title = title;
    //设置tabbaritem上的文字颜色
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color_24c9a7,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    // 设置图标
    UIImage *image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childVc.tabBarItem.image = image;
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

@end
