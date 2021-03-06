//
//  AppDelegate.m
//  BaoChe
//
//  Created by swift on 14/10/25.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "AppDelegate.h"
#import "AppPropertiesInitialize.h"
#import "BaseTabBarVC.h"
#import "AllBusListVC.h"
#import "HomePageVC.h"
#import "UserCenterVC.h"
#import "MoreVC.h"
#import "LoginVC.h"
#import "BuyTicketVC.h"
#import "OrderListVC.h"
#import "UserInfoModel.h"
#import "PayManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [UserInfoModel setUserDefaultUserId:nil];
    
    // 进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
    
    BuyTicketVC *buyTicket = [BuyTicketVC loadFromNib];
    UINavigationController *buyTicketNav = [[UINavigationController alloc] initWithRootViewController:buyTicket];
    /*
    HomePageVC *homePage = [[HomePageVC alloc] init];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePage];
     */
    
    UserCenterVC *userCenter = [[UserCenterVC alloc] init];
    UINavigationController *userCenterNav = [[UINavigationController alloc] initWithRootViewController:userCenter];
    
    MoreVC *more = [[MoreVC alloc] init];
    UINavigationController *moreNav = [[UINavigationController alloc] initWithRootViewController:more];
    
    self.baseTabBarController = [[BaseTabBarVC alloc] init];
    _baseTabBarController.viewControllers = @[buyTicketNav, userCenterNav, moreNav];
    
    self.window.rootViewController = _baseTabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([sourceApplication containsString:@"com.alipay.iphoneclient"])
    {
        // 验证支付宝支付结果
        [[PayManager sharedInstance] verifyPayResultWithHandleOpenURL:url];
    }
    
    return YES;
}

@end
