//
//  SearchViewController.h
//  mystock
//
//  Created by Ryan on 14-6-4.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewCell.h"
#import "StockBriefViewController.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SearchTableViewCellDelegate>{
    BOOL isADD;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *sTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *historyArray;

@property (nonatomic, strong) StockBriefViewController *stockBriefVC;

@end
