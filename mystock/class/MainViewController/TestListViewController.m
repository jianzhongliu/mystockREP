//
//  SuggestStockViewController.m
//  mystock
//
//  Created by liujianzhong on 15/7/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "TestListViewController.h"
#import "RquestTotalStock.h"
#import "CaculationFunction.h"
#import "colorModel.h"
#import "getData.h"
#import "commond.h"

@interface TestListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayShang;//沪市A股
@property (nonatomic, strong) NSMutableArray *arrayShen;//深市A股
@property (nonatomic, strong) NSMutableArray *arrayDouble;//倍量柱

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *labelTotal;

@end

@implementation TestListViewController
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


- (UILabel *)labelTotal {
    if (_labelTotal == nil) {
        _labelTotal = [[UILabel alloc] init];
        _labelTotal.numberOfLines = 0;
        _labelTotal.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTotal.textAlignment = NSTextAlignmentLeft;
        _labelTotal.font = [UIFont systemFontOfSize:14];
        _labelTotal.text = @"";
        _labelTotal.textColor = [UIColor whiteColor];
    }
    return _labelTotal;
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
    
    NSMutableArray *arrayLocalStock = [NSMutableArray arrayWithArray:[[CaculationFunction share] arraySourceData]];
    NSArray *arrayLocal =  [commond getUserDefaults:@"localStock"];
    for (NSString *localStockCode in arrayLocal) {
        for (NSDictionary *dic in arrayLocalStock) {
            if ([localStockCode isKindOfClass:[NSString class]] && [localStockCode isEqualToString:dic[@"stockcode"]]) {
                [self.arrayDouble addObject:dic];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)deleteLocalStock {
    [commond setUserDefaults:@[] forKey:@"localStock"];
    [self.arrayDouble removeAllObjects];
    [self.tableView reloadData];
}

- (void)initUI {
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"猜测";
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(deleteLocalStock)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.labelTotal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0,40,self.view.bounds.size.width,self.view.bounds.size.height-40);
    self.labelTotal.frame = CGRectMake(0,64,self.tableView.frame.size.width,40);
    [self caculateRate];
}

- (void)caculateRate {
    NSInteger raise = 0;
    NSInteger down = 0;
    for (NSDictionary *dicStock in self.arrayDouble) {
        NSArray *arrayStock = dicStock[@"timedata"];
        if (arrayStock.count > 2) {
            if ([arrayStock[0][@"nowv"] doubleValue] > [arrayStock[0][@"preclose"] doubleValue]) {
                raise ++;
            } else {
                down ++;
            }
        }
    }
    self.labelTotal.text = [NSString stringWithFormat:@"总数：%ld   上:%ld   下：%ld  成功率：%.3f%@",(raise+down),raise,down,(raise/(raise+down +0.000001))*100,@"%"];
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
    NSString *stringTitle = [NSString stringWithFormat:@"%@ // %@", [self.arrayDouble[indexPath.row] objectForKey:@"stockname"], [self.arrayDouble[indexPath.row] objectForKey:@"stockcode"] ];
    
    cell.textLabel.text = stringTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FMViewController *sDetailVC = [[FMViewController alloc] init];
    //    sDetailVC.dicStock = self.arrayLow[indexPath.row];
    sDetailVC.arrayStock = self.arrayDouble;
    sDetailVC.index = indexPath.row;
    [self.navigationController pushViewController:sDetailVC animated:YES];
    
}

@end
