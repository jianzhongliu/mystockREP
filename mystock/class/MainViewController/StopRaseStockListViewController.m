//
//  StopRaseStockListViewController.m
//  mystock
//
//  Created by liujianzhong on 15/7/31.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "StopRaseStockListViewController.h"
#import "StopRaseStockViewCell.h"
#import "MBProgressHUD.h"
#import "colorModel.h"

@interface StopRaseStockListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayStock;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *arrayShang;

@end

@implementation StopRaseStockListViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    [self requestData:self.pageIndex ++];
}

- (void)initData {
    self.arrayShang = [NSMutableArray array];
    [self.arrayShang addObjectsFromArray:[colorModel getStockCodeInfo600]];
    [self.arrayShang addObjectsFromArray:[colorModel getSA]];
    
    self.arrayStock = [NSMutableArray array];
    self.pageIndex = 0;
}

- (void)initUI {
    [self.view addSubview:self.tableView];
}
- (void)requestData:(NSInteger) page{
    NSString *urlString = [NSString stringWithFormat:@"http://www.178448.com/fjzt-1.html?page=%d",page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *stringContent = operation.responseString;
        NSMutableArray *arrayBlockData = [NSMutableArray arrayWithArray:[stringContent componentsSeparatedByString:@"<td class=\"bzt\">-"]];
        if (arrayBlockData.count > 5) {
            [arrayBlockData removeObjectAtIndex:0];
            [arrayBlockData removeObjectAtIndex:arrayBlockData.count - 1];
            [arrayBlockData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *signalData = obj;
                signalData = [signalData stringByReplacingOccurrencesOfString:@"</td>" withString:@""];
                NSArray *array = [signalData componentsSeparatedByString:@"<td>"];
                NSString *numbers = [[array[2] componentsSeparatedByString:@"<td class=\"bzt\">"] objectAtIndex:1];

                if ([signalData rangeOfString:@"getprice"].length > 0 && array.count >= 8) {
                    if ([[array[3] stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue] > 70 && [numbers integerValue] > 100) {
                        [self.arrayStock addObject:array];
                    }
                }
            }];
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = [NSString stringWithFormat:@"当前：%d",self.pageIndex];
        [hud hide:YES afterDelay:0.2];
        if (self.pageIndex < 70) {
            [self requestData:self.pageIndex++];
            
        }
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayStock.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"identify";
    StopRaseStockViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[StopRaseStockViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell configCellWithData:self.arrayStock[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *stock = [self.arrayStock objectAtIndex:indexPath.row];
    [self.arrayShang enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dicEnum = [NSDictionary dictionaryWithDictionary:obj];
            NSLog(@"%@", [dicEnum objectForKey:@"stockname"]);
            if ([[dicEnum objectForKey:@"stockname"] rangeOfString:stock[4]].length > 0) {
                FMViewController *sDetailVC = [[FMViewController alloc] init];
                //            NSDictionary *dic = @{@"innercode":arrayEnum[0], @"stockcode":arrayEnum[1],@"stockname":arrayEnum[2]};
                sDetailVC.dicStock = dicEnum;
                [self.navigationController pushViewController:sDetailVC animated:YES];
            }
        }
    }];
}

@end
