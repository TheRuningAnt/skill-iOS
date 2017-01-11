//
//  BasicViewController.m
//  MakeLearn-iOS
//
//  Created by 王晨飞 on 16/7/4.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "BasicViewController.h"
#import "PTTReachability.h"

@interface BasicViewController ()

{
    BOOL showNavigationBar;
}

@end

@implementation BasicViewController


/**
 创建指定属性的Controller
 
 @param backImageStr 返回按钮的图片名
 @return 一般返回子类实例对象
 */
-(id)initWithBackBtnImageStr:(NSString*)backImageStr{
    
    self = [super init];
    if (self) {
        
        [self setUpControlWithBackImageStr:backImageStr];
    }
    
    return self;
}

//设置页面属性
-(void)setUpControlWithBackImageStr:(NSString*)backImageStr{
    
    self.view.backgroundColor = color_e8efed;

    //设置导航栏返回按钮
    if (backImageStr) {
    
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"backImageStr"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItems = @[item1];
    }
}

//导航栏返回按钮触发事件
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
