//
//  SettingViewController.h
//  mystock
//
//  Created by Ryan on 14-6-20.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *settingTableView;

@end
