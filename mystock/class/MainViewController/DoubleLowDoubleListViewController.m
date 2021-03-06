//
//  SuggestStockViewController.m
//  mystock
//
//  Created by liujianzhong on 15/7/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "DoubleLowDoubleListViewController.h"
#import "RquestTotalStock.h"
#import "CaculationFunction.h"
#import "colorModel.h"
#import "getData.h"
#import "commond.h"

@interface DoubleLowDoubleListViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayShang;//沪市A股
@property (nonatomic, strong) NSMutableArray *arrayShen;//深市A股
@property (nonatomic, strong) NSMutableArray *arrayDouble;//倍量柱

@property (nonatomic, assign) NSInteger index;

@end

@implementation DoubleLowDoubleListViewController
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
    NSMutableArray *arrayLocalStock = [NSMutableArray arrayWithArray:[[CaculationFunction share] doubleLowDouble]];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showDoubleStock)];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
}

- (void)showDoubleStock {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择数据量" delegate:self
cancelButtonTitle:@"==" destructiveButtonTitle:nil otherButtonTitles:@"600",@"300",@"100",@"50",@"30",@"20",@"15", nil];
    [action showInView:self.view];

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
    data = [data initWithUrl:url stock:self.arrayDouble[index]];
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
    NSString *stringTitle = [NSString stringWithFormat:@"%@ // %@", [self.arrayDouble[indexPath.row] objectForKey:@"stockname"], [self.arrayDouble[indexPath.row] objectForKey:@"stockcode"]];
    
    cell.textLabel.text = stringTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FMViewController *sDetailVC = [[FMViewController alloc] init];
    //    sDetailVC.dicStock = self.arrayLow[indexPath.row];
    sDetailVC.arrayStock = self.arrayDouble;
    [self.navigationController pushViewController:sDetailVC animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger number = 0;
    switch (buttonIndex) {
        case 0:
        {
            number = 600;
        }
            break;
        case 1:
        {
            number = 300;
        }
            break;
        case 2:
        {
            number = 100;
        }
            break;
        case 3:
        {
            number = 50;
        }
            break;
        case 4:
        {
            number = 30;
        }
            break;
        case 5:
        {
            number = 20;
        }
            break;
        case 6:
        {
            number = 15;
        }
            break;
        default:
            break;
    }
    if (number > 0) {
        [commond setUserDefaults:@[] forKey:@"Double"];
        NSLog(@"%@", self.arrayDouble);
        //    [self requestDataWithIndex:self.index ++];
        [[RquestTotalStock share] startLoadingDataWith:number];//请求票面信息        
    }

}
@end
