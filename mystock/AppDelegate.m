//
//  AppDelegate.m
//  mystock
//
//  Created by Ryan on 14-5-19.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "AppDelegate.h"
//http://image.sinajs.cn/newchart/min/n/sh603979.gif //分时图


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.leftVC = [[LeftViewController alloc] init];
    self.mainVC = [[MainViewController alloc] init];

    self.dynamicsDrawerViewController = [[MSDynamicsDrawerViewController alloc] init];
    self.dynamicsDrawerViewController.delegate = self;
    
    // Add some example stylers
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerParallaxStyler styler]] forDirection:MSDynamicsDrawerDirectionRight];

    // 设置左侧
    [self.dynamicsDrawerViewController setDrawerViewController:_leftVC forDirection:MSDynamicsDrawerDirectionLeft];
    _leftVC.drawerVC = _dynamicsDrawerViewController;
    
    // 设置中间
    _dynamicsDrawerViewController.paneViewController = [[UINavigationController alloc] initWithRootViewController:_mainVC];
    
    // 右侧
//    [self.dynamicsDrawerViewController setDrawerViewController:_selectVC forDirection:MSDynamicsDrawerDirectionRight];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = BACKGROUND_COLOR;
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = _dynamicsDrawerViewController;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self initDB];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDrawer) name:kNotificationOpenDrawer object:nil];
    
    //启动远程推送
    UIRemoteNotificationType type = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Remote Notification
// 请求远程通知回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * tokenAsString = [[[deviceToken description]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    DMLog(@"token : %@", tokenAsString);
    
    NSMutableDictionary *sendDataDict = [NSMutableDictionary dictionary];
    //添加默认参数
    [sendDataDict setValue:@"device_token" forKey:@"m"];
    [sendDataDict setValue:tokenAsString forKey:@"token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:apiHost parameters:sendDataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DMLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DMLog(@"Error: %@", error);
    }];
    
}

// Provide a user explanation for when the registration fails
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DMLog(@"!!!!!!!Error in registration. Error: %@", error);
}

#pragma mark - 程序收到远程推送消息 Remote notification
// Handle an actual notification收到某一个消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	DMLog(@"%@", userInfo);

}


#pragma mark - Custom Method
- (void)openDrawer{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:^{
        
    }];
}

- (void)initDB{
    
    // 初始化本地数据库
    self.sArray = [NSMutableArray array];
    hasInitDB = [[PersistenceHelper dataForKey:@"hasInitDB"] boolValue];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:kDBFilePath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:kDBFileName ofType:@""];
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:kDBFilePath error:nil];
    }
    
    if (!hasInitDB) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//        hud.labelText = @"初始化中....";
//        [hud hide:YES afterDelay:30];
        
        NSMutableDictionary *sendDataDict = [NSMutableDictionary dictionary];
        //添加默认参数
        [sendDataDict setValue:@"focus_list" forKey:@"m"];
        [sendDataDict setValue:@"0" forKey:@"act"];
        
        __block AppDelegate *blockSelf = self;
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        [manager GET:apiHost parameters:sendDataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            DMLog(@"JSON: %@", responseObject);
//            if (responseObject == nil || [responseObject objForKey:@"result"] == 0) {
//                return;
//            }
//            
//            NSArray *dataArray = [responseObject objForKey:@"data"];
//            
//            FMDatabase *dbBase = [FMDatabase databaseWithPath:kDBFilePath];
//            
//            NSString *sql = @"insert into corp_codes (code,name,focus,order_num) values (%@,%@,%d,%d)";
//            
//            if ([dbBase open]) {
//                for (NSDictionary *item in dataArray) {
//                    if ([dbBase executeUpdateWithFormat:sql,[item objForKey:@"code"],[item objForKey:@"name"],[[item objForKey:@"focus"] intValue],[[item objForKey:@"order_num"] intValue]]) {
//                        hasInitDB = YES;
//                    }else{
//                        hasInitDB = NO;
//                        break;
//                    }
//                }
//                
//                
//                sql = @"select * from corp_codes where focus = 1";
//                
//                FMResultSet *result = [dbBase executeQuery:sql];
//                while ([result next]) {
//                    NSDictionary *sDic = @{@"code":[result stringForColumn:@"code"],
//                                           @"name":[result stringForColumn:@"name"],
//                                           @"focus":[NSNumber numberWithInt:[result intForColumn:@"focus"]],
//                                           @"order_num":[NSNumber numberWithInt:[result intForColumn:@"order_num"]]};
//                    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:sDic];
//                    [blockSelf->_sArray addObject:tempDic];
//                }
//                
//            }
//            
//            [dbBase close];
//            
//            [PersistenceHelper setData:[NSNumber numberWithBool:hasInitDB] forKey:@"hasInitDB"];
//            
//            [MBProgressHUD hideHUDForView:self.window animated:YES];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            DMLog(@"Error: %@", error);
//            [MBProgressHUD hideHUDForView:self.window animated:YES];
//        }];
    }else{
        FMDatabase *dbBase = [FMDatabase databaseWithPath:kDBFilePath];
        NSString *sql = @"select * from corp_codes where focus = 1";
        if ([dbBase open]) {
            FMResultSet *result = [dbBase executeQuery:sql];
            while ([result next]) {
                NSDictionary *sDic = @{@"code":[result stringForColumn:@"code"],
                                       @"name":[result stringForColumn:@"name"],
                                       @"focus":[NSNumber numberWithInt:[result intForColumn:@"focus"]],
                                       @"order_num":[NSNumber numberWithInt:[result intForColumn:@"order_num"]]};
               //NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:sDic];
                [_sArray addObject:sDic];
            }
        }
        
        [dbBase close];
    }
}
@end
