//
//  SelectionViewController.h
//  mystock
//
//  Created by Ryan on 14-5-19.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "StockBriefViewController.h"
#import "FMDB.h"

@interface SelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *sTableView;
@property (nonatomic, strong) NSMutableArray *sArray;

@property (nonatomic, strong) StockBriefViewController *stockBriefVC;

@end
