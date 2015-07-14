//
//  SearchViewController.m
//  mystock
//
//  Created by Ryan on 14-6-2.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "SearchViewController.h"

static NSString *searchCellIdentifier = @"searchCell";

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isADD = NO;
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    
    [self initHistoryArray];
    
    self.dataArray = [NSMutableArray arrayWithArray:_historyArray];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"搜索列表";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back_click:)];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    _searchBar.backgroundColor = NAVI_COLOR;
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.barStyle = UIBarStyleBlack;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    self.sTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, self.view.bounds.size.width, self.view.bounds.size.height-108)];
    _sTableView.delegate = self;
    _sTableView.dataSource = self;
    _sTableView.backgroundColor = [UIColor clearColor];
    _sTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_sTableView];
    
    [_sTableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:searchCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)back_click:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)initHistoryArray{
    if (self.historyArray == nil) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:SEARCH_FILEPATH]) {
            self.historyArray = [NSMutableArray arrayWithContentsOfFile:SEARCH_FILEPATH];
        }
    }
    
    if (_historyArray == nil) {
        self.historyArray = [NSMutableArray array];
    }
}

- (void)requestData{
    if ([[_searchBar.text trimTagCode] isEqualToString:@""]) {
        self.dataArray = _historyArray;
    }else{
        FMDatabase *dbBase = [FMDatabase databaseWithPath:kDBFilePath];
        NSString *sql = @"select * from corp_codes where code like '%";
        sql = [sql stringByAppendingString:_searchBar.text];
        sql = [sql stringByAppendingString:@"%'"];
        if ([dbBase open]) {
            FMResultSet *result = [dbBase executeQuery:sql];
            [_dataArray removeAllObjects];
            while ([result next]) {
                NSDictionary *sDic = @{@"code":[result stringForColumn:@"code"],
                                       @"name":[result stringForColumn:@"name"],
                                       @"focus":[NSNumber numberWithInt:[result intForColumn:@"focus"]],
                                       @"order_num":[NSNumber numberWithInt:[result intForColumn:@"order_num"]]};
                [_dataArray addObject:sDic];
            }
        }
        
        [dbBase close];
    }
    
    [_sTableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionP{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    [cell setCellData:[_dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.stockBriefVC = [[StockBriefViewController alloc] initWithStock:[_dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:_stockBriefVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self requestData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self requestData];
}

#pragma mark - SearchTableViewCellDelegate
- (void)add_click:(NSDictionary *)dic{
    if (isADD) {
        return;
    }
    
    isADD = YES;
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSMutableDictionary *sendDataDict = [NSMutableDictionary dictionary];
    //添加默认参数
    [sendDataDict setValue:@"focus_list" forKey:@"m"];
    [sendDataDict setValue:@"1" forKey:@"act"];
    [sendDataDict setValue:[tempDic objForKey:@"code"] forKey:@"code"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:apiHost parameters:sendDataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DMLog(@"JSON: %@", responseObject);
        if (responseObject == nil || [responseObject objForKey:@"result"] == 0) {
            return;
        }
        
        FMDatabase *dbBase = [FMDatabase databaseWithPath:kDBFilePath];
        
        NSString *sql = @"update corp_codes set focus = '1' WHERE code = %@";
        if ([dbBase open]) {
            if ([dbBase executeUpdateWithFormat:sql,[tempDic objForKey:@"code"]]) {
                // 添加入关注列表
                [kSArray addObject:tempDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshSelection object:nil];
                
                // 写入搜索历史
                [tempDic setValue:[NSNumber numberWithInt:1] forKey:@"focus"];
                
                for (NSDictionary *item in _historyArray) {
                    if ([[item objForKey:@"code"] isEqualToString:[tempDic objForKey:@"code"]]) {
                        [_historyArray removeObject:item];
                        break;
                    }
                }
                
                [_historyArray insertObject:tempDic atIndex:0];
                
                if ([_historyArray count]>100) {
                    [_historyArray subarrayWithRange:NSMakeRange([_historyArray count]-100, 100)];
                }
                [_historyArray writeToFile:SEARCH_FILEPATH atomically:YES];
                
                // 刷新当前列表
                [self requestData];
                [_sTableView reloadData];
                
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:hud];
                
                // Set custom view mode
                hud.mode = MBProgressHUDModeCustomView;
                hud.userInteractionEnabled = NO;
                hud.labelText = @"添加成功";
                
                [hud show:YES];
                [hud hide:YES afterDelay:1];
            }
        }
        
        [dbBase close];
        
        isADD = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        isADD = NO;
        DMLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
}

@end
