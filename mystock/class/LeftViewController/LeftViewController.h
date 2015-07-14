//
//  LeftViewController.h
//  mystock
//
//  Created by Ryan on 14-5-19.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"

@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *menuTableView;
@property (nonatomic, weak) MSDynamicsDrawerViewController *drawerVC;

@end
