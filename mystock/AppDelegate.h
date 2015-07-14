//
//  AppDelegate.h
//  mystock
//
//  Created by Ryan on 14-5-19.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftViewController.h"
#import "MainViewController.h"
#import "MSDynamicsDrawerStyler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,MSDynamicsDrawerViewControllerDelegate>{
    BOOL hasInitDB;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) LeftViewController *leftVC;
@property (nonatomic, strong) MainViewController *mainVC;
@property (nonatomic, strong) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

@property (nonatomic, strong) NSMutableArray *sArray;

@end
