//
//  SuggestStockViewController.m
//  mystock
//
//  Created by liujianzhong on 15/7/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "SortByUPRateViewController.h"
#import "CaculationFunction.h"
#import "RquestTotalStock.h"
#import "colorModel.h"
#import "getData.h"
#import "commond.h"

@interface SortByUPRateViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrayLow;//地量柱

@property (nonatomic, assign) NSInteger index;

@end

@implementation SortByUPRateViewController
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
//    [colorModel getStockCodeInfo];
    self.arrayLow = [NSMutableArray arrayWithArray:[[CaculationFunction share] getUPMore]];
    
}

- (void)initUI {
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"下降率";
    self.navigationItem.titleView = titleLabel;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showDoubleStock)];

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
    return self.arrayLow.count;
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
    NSString *stringTitle = [NSString stringWithFormat:@"%@%@ // %@ ///%@",[self.arrayLow[indexPath.row] objectForKey:@"innercode"], [[self.arrayLow[indexPath.row] objectForKey:@"sorceData"] objectForKey:@"stockname"], [self.arrayLow[indexPath.row] objectForKey:@"storck"], [self.arrayLow[indexPath.row] objectForKey:@"rate"]];
    
    cell.textLabel.text = stringTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FMViewController *sDetailVC = [[FMViewController alloc] init];
    sDetailVC.arrayStock = [self getArrayData:self.arrayLow];
    [self.navigationController pushViewController:sDetailVC animated:YES];
    
}

- (NSArray *)getArrayData:(NSArray *) array {
    NSMutableArray *arrayResult = [NSMutableArray array];
    for (NSDictionary *dic  in array) {
        [arrayResult addObject:[dic objectForKey:@"sorceData"]];
    }
    return arrayResult;
}
@end
