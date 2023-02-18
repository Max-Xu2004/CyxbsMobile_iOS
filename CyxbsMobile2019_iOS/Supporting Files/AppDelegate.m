//
//  AppDelegate.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/22.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "AppDelegate.h"

#import "CyxbsTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 这个回掉和消息推送有关。iOS的远程推送需要在真机上调试，如果注册成功，就能在这个方法中获取APNs（APNs是Apple Push Notification service的简称）返回的DeviceToken，
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    RisingLog("🆃", @"%@", hexToken);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [Bugly startWithAppId:@"41e7a3c1b3"];

    UIViewController *vc = [[CyxbsTabBarController alloc] init];
    
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)settingBaseURL{
    NSString *baseURL;
#ifdef DEBUG
    // 测试环境
    baseURL = @"https://be-dev.redrock.cqupt.edu.cn/";
//    baseURL = @"https://be-prod.redrock.team/";
#else
    // 正式环境
    baseURL = @"https://be-prod.redrock.cqupt.edu.cn/";
#endif
    [NSUserDefaults.standardUserDefaults setObject:baseURL forKey:@"baseURL"];
}

- (void)_umeng_rising {
    
}

//- (void)_umeng {
//    //开发者需要显式的调用此函数，日志系统才能工作
//    [UMCommonLogManager setUpUMCommonLogManager];
//    //初始化umenge功能
//    [UMConfigure setLogEnabled:NO];
//    [UMConfigure initWithAppkey:@"573183a5e0f55a59c9000694" channel:nil];
//
//
//    //开发者需要显式的调用此函数，日志系统才能工作
//    [UMCommonLogManager setUpUMCommonLogManager];
//
//    //配置统计场景，E_UM_NORMAL为普通场景
//    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景
//
//    //umeng推送设置
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
//    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
//    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//
//        } else {
//
//        }
//    }];
//
//    [UMessage openDebugMode:YES];
//    [UMessage setWebViewClassString:@"UMWebViewController"];
//    [UMessage addLaunchMessage];
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            //获取用户是否同意开启通知
//            if (granted) {
//                NSLog(@"request authorization successed!");
//            }
//        }];
//
//
//}

#pragma mark - Unused

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_applicationDidBecomeActive" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    NSURLComponents *componets = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    if ([componets.path isEqualToString:@"/schedule/detail"]) {
        CyxbsTabBarController *tabController = (CyxbsTabBarController *)self.window.rootViewController;
        [tabController presentScheduleControllerWithPan:nil completion:^(UIViewController * _Nonnull vc) {
            id service = [[vc performSelector:NSSelectorFromString(@"presenter")] performSelector:NSSelectorFromString(@"service")];
            NSUInteger idx[3] = {componets.queryItems[0].value.integerValue, componets.queryItems[1].value.integerValue, componets.queryItems[2].value.integerValue};
            [service performSelector:NSSelectorFromString(@"collectionView:didSelectItemAtIndexPath:") withObject:[service performSelector:NSSelectorFromString(@"collectionView")] withObject:[NSIndexPath indexPathWithIndexes:idx length:3]];
        }];
    }
    
#pragma clang diagnostic pop
    return YES;
}

@end

