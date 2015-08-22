//
//  SuggestStockViewController.m
//  mystock
//
//  Created by liujianzhong on 15/7/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "MoneyListViewController.h"
#import "RquestTotalStock.h"
#import "CaculationFunction.h"
#import "colorModel.h"
#import "getData.h"
#import "commond.h"

@interface MoneyListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayShang;//沪市A股
@property (nonatomic, strong) NSMutableArray *arrayShen;//深市A股
@property (nonatomic, strong) NSMutableArray *arrayDouble;//倍量柱

@property (nonatomic, assign) NSInteger index;

@end

@implementation MoneyListViewController
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
//    [colorModel getStockCodeInfo];
//    [self.arrayShang addObjectsFromArray:[colorModel getStockCodeInfo600]];
//    [self.arrayShen addObjectsFromArray:[colorModel getSA]];
    NSMutableArray *arrayLocalStock = [NSMutableArray arrayWithArray:[[CaculationFunction share] getMoneyListOrderByNumber]];
    self.arrayDouble = [NSMutableArray arrayWithArray:arrayLocalStock];
    
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
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
    NSArray *arrayTemp = self.arrayDouble[indexPath.row];
    CGFloat rate = ([arrayTemp[1] floatValue] + [arrayTemp[2] floatValue])/([arrayTemp[1] floatValue] + [arrayTemp[2] floatValue] + [arrayTemp[5] floatValue] + [arrayTemp[6] floatValue]);
    NSString *stringTitle = [NSString stringWithFormat:@"%@   %@===rate:%.3f", arrayTemp[0], arrayTemp[12], rate];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = stringTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    FMViewController *sDetailVC = [[FMViewController alloc] init];
//    sDetailVC.dicStock = self.arrayDouble[indexPath.row];
//    [self.navigationController pushViewController:sDetailVC animated:YES];
    
}

@end
