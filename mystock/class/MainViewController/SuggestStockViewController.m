//
//  SuggestStockViewController.m
//  mystock
//
//  Created by liujianzhong on 15/7/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "SuggestStockViewController.h"
#import "DoubleListViewController.h"
#import "StopRaseStockListViewController.h"
#import "LowestListViewController.h"
#import "SortByDownRateViewController.h"
#import "SortStockValueViewController.h"
#import "JingzhunLineViewController.h"
#import "MoneyListViewController.h"
#import "ZiJingViewController.h"

@interface SuggestStockViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger requestCount;

@end

@implementation SuggestStockViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestCount = 0;
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"选股工具";
    self.navigationItem.titleView = titleLabel;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromRequest:) name:@"currentRequestData" object:nil];
}

- (void)getDataFromRequest:(NSDictionary *) info {
    self.requestCount ++;
    if (self.requestCount / 30 == self.requestCount/30.0f) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = [NSString stringWithFormat:@"已完成%d",self.requestCount];
        [hud hide:YES afterDelay:3];
    }
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
    return 8;
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
    
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"发现倍量柱";
        }
            break;
        case 1:{
            cell.textLabel.text = @"guhaimingdeng";
        }
            break;
        case 2:{
            cell.textLabel.text = @"发现百日低量柱";
        }
            break;
        case 3:{
            cell.textLabel.text = @"超跌排序";
        }
            break;
        case 4:{
            cell.textLabel.text = @"差多值";
        }
            break;
        case 5:{
            cell.textLabel.text = @"精准线";
        }
            break;
        case 6:{
            cell.textLabel.text = @"装散对比";
        }
            break;
        case 7:{
            cell.textLabel.text = @"资金流";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            DoubleListViewController *controller = [[DoubleListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:{
            StopRaseStockListViewController *controller = [[StopRaseStockListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:{
            LowestListViewController *controller = [[LowestListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:{
            SortByDownRateViewController *controller = [[SortByDownRateViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 4:{
            SortStockValueViewController *controller = [[SortStockValueViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:{
            JingzhunLineViewController *controller = [[JingzhunLineViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 6:{
            MoneyListViewController *controller = [[MoneyListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 7:{
            ZiJingViewController *controller = [[ZiJingViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
    
}
@end
