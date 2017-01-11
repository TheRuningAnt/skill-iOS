//
//  AppDelegate.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/21.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "AppDelegate.h"
#import "RootController.h"
#import "LoginViewController.h"

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [NSThread sleepForTimeInterval:1];
    
    //集成友盟统计
    UMConfigInstance.appKey = @"58290d489f06fd4478003819";
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //验证是否有本地用户登陆
    if ([UserTool userModel].token) {
        
        //将其第一次登录的标志撤销
        UserModel *model = [UserTool userModel];
        model.firstLogin = NO;
        model.htmlTag = 0;
        [UserTool save:model];
        
        //登录友盟分析
        [MobClick profileSignInWithPUID:[UserTool userModel].userNumber];
        [MobClick startWithConfigure:UMConfigInstance];
        
        RootController *rootVc = [[RootController alloc] init];
        rootVc.view.backgroundColor = [UIColor whiteColor];

        self.window.rootViewController  = rootVc;
        
    }else{
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        self.window.rootViewController = nav;
    }
    
    /**
     *  集成环信推送
     */
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"jnshu4#jnshu4"];
    options.apnsCertName = @"ProductP12";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //获取当前的用户的登录名和密码  登录环信接收发送通知,登录用户名为用户的手机号,密码为123456
    NSString *account = [UserTool userModel].userNumber;
    
    if (account) {
        
        //登录环信
        [[EMClient sharedClient] loginWithUsername:account
                                          password:@"123456"
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                NSLog(@"环信登陆成功");
                                                EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
                                                emoptions.displayStyle = EMPushDisplayStyleSimpleBanner;
                                                [[EMClient sharedClient] updatePushOptionsToServer];
                                            } else {
                                                NSLog(@"环信登陆失败");
                                            }
                                        }];
    }

    /**
     APNS离线推送  iOS8 注册APNS
     */
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    return YES;
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    //在App将要进入后台的时候  刷新角标
    [self loadUnreadMessageData];
}

static NSInteger _page;
static NSInteger unreadMessageNum;

//循环调用获取未读消息数字  并刷新角标
-(void)loadUnreadMessageData{
    _page = 1;
    unreadMessageNum = 0;
    [self loadUnreadMessageNumberWithPage:_page];
}

//获取未读消息数字
-(void)loadUnreadMessageNumberWithPage:(NSInteger)page{
    
    KCheckNetWorkAndRetuen(^(){
    })
    
    WK(weakSelf);
    NSDictionary *paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",page],@"page",@"10",@"size",@"1",@"status",[UserTool userModel].token,@"token", nil];
    [HttpService sendGetHttpRequestWithUrl:API_Message paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
        
        if (jsonDic && [jsonDic isKindOfClass:[NSArray class]]&&jsonDic.count != 0 ) {
            
            NSArray *array = (NSArray*)jsonDic;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[obj objectForKey:@"unread"] integerValue] == 1) {
                        unreadMessageNum ++;
                    }
                }
            }];
            
            UIApplication *application = [UIApplication sharedApplication]; [application setApplicationIconBadgeNumber:unreadMessageNum];
            
            if (array.count > 0) {
                
                _page ++;
                [weakSelf loadUnreadMessageNumberWithPage:_page];
            }
        }
    }];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
