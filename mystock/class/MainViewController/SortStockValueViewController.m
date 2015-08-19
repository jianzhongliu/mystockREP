//
//  SuggestStockViewController.m
//  mystock
//
//  Created by liujianzhong on 15/7/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "SortStockValueViewController.h"
#import "RquestTotalStock.h"
#import "CaculationFunction.h"
#import "colorModel.h"
#import "getData.h"
#import "commond.h"

@interface SortStockValueViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayShang;//沪市A股
@property (nonatomic, strong) NSMutableArray *arrayShen;//深市A股
@property (nonatomic, strong) NSMutableArray *arrayDouble;//倍量柱
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) NSInteger index;

@end

@implementation SortStockValueViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKGROUND_COLOR;
        _tableView.separatorColor = [UIColor clearColor];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

#pragma mark - lifeCycleMethods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initData {
    self.index = 0;
    self.arrayShang = [NSMutableArray array];
    self.arrayShen = [NSMutableArray array];
    self.arrayDouble = [NSMutableArray array];
}

- (void)initUI {
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"倍量柱";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showDoubleStock)];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    self.searchBar.frame = CGRectMake(0, 0, 320, 45);
    self.tableView.tableHeaderView = self.searchBar;
}

- (void)requestDataWithIndex:(NSInteger) index {
    if (index > self.arrayDouble.count) {
        return;
    }
    NSMutableArray *arrayDoubleStock = [NSMutableArray array];
    [arrayDoubleStock addObjectsFromArray:self.arrayShang];
    [arrayDoubleStock addObjectsFromArray:self.arrayShen];
    NSDictionary *code = [self.arrayShang objectAtIndex:index];
    getData *data = [[getData alloc] init];
    __weak typeof(self) blockSelf = self;
    data.blockCallBack = ^{
        [blockSelf requestDataWithIndex:blockSelf.index ++];
        [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:blockSelf.view animated:YES];
        hud.labelText = [NSString stringWithFormat:@"当前：%d",self.index ];
        [hud hide:YES afterDelay:0.2];
    };
    NSString *url = [NSString stringWithFormat:@"http://hq.niuguwang.com/aquote/quotedata/KLine.ashx?ex=1&code=%@&type=5&count=300&packtype=0&version=2.0.5", code[@"innercode"]];
    data = [data initWithUrl:url fresh:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayDouble.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellDefaultIdentifier = @"cellDefault";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDefaultIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDefaultIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *tempView = [[UIView alloc] initWithFrame:cell.bounds];
        tempView.backgroundColor = NAVI_COLOR;
        cell.selectedBackgroundView = tempView;
        
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    NSString *stringTitle = [NSString stringWithFormat:@"%@",self.arrayDouble[indexPath.row]];
    
    cell.textLabel.text = stringTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    FMViewController *sDetailVC = [[FMViewController alloc] init];
//    sDetailVC.dicStock = self.arrayDouble[indexPath.row];
//    [self.navigationController pushViewController:sDetailVC animated:YES];
    
}

- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSMutableArray *arrayLocalStock = [NSMutableArray arrayWithArray:[[CaculationFunction share] averageValue:searchBar.text]];
    [self.arrayDouble removeAllObjects];
    [self.arrayDouble addObjectsFromArray:arrayLocalStock];
    [self.tableView reloadData];
}
@end
