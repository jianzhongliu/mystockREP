//
//  FunctionMethodsUtil.h
//  DistributionProject
//
//  Created by liujianzhong on 15/7/15.
//  Copyright © 2015年 T.E.N_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionMethodsUtil : NSObject

/**获取当前显示的viewcontroller*/
+ (UIViewController *)getCurrentRootViewController;

/**获取设备UUID*/
+ (NSString *)genUUID;

@end
