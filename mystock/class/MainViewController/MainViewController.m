//
//  MainViewController.m
//  mystock
//
//  Created by Ryan on 14-5-19.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "MainViewController.h"
#import "SuggestTableViewCell.h"

NSString * const SuggestCellReuseIdentifier = @"SuggestCell";

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    self.dateStr = [format stringFromDate:[NSDate date]];
    
    self.suggestArray = [NSMutableArray array];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"推荐列表";
    self.navigationItem.titleView = titleLabel;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(back_click:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(open_datePicker:)];
    
    self.sTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _sTableView.delegate = self;
    _sTableView.dataSource = self;
    _sTableView.backgroundColor = [UIColor clearColor];
    _sTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_sTableView];
    
    [_sTableView registerClass:[SuggestTableViewCell class] forCellReuseIdentifier:SuggestCellReuseIdentifier];
    
    [self initDatePicker];
    
    [self request_suggest_list];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)back_click:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOpenDrawer object:nil];
}

- (void)open_datePicker:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        _dateView.frame = CGRectMake(0, SCREEN_HEIGHT-260, 320, 260);
    }];
}

- (void)initDatePicker{
    self.dateView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 260)];
    _dateView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dateView];
    
    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(conform_click:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _toolBar.translucent = YES;
    _toolBar.barStyle = UIBarStyleDefault;
    _toolBar.barTintColor = NAVI_COLOR;
    _toolBar.tintColor = [UIColor whiteColor];
    [_toolBar setItems:[NSArray arrayWithObjects:flexibleSpace,confirmBtn, nil]];
    [_dateView addSubview:_toolBar];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.timeZone = [NSTimeZone systemTimeZone];
    _datePicker.date = [NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_dateView addSubview:_datePicker];
}

- (void)conform_click:(id)sender{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    self.dateStr = [format stringFromDate:[_datePicker date]];
    
    [UIView animateWithDuration:0.3 animations:^{
        _dateView.frame = CGRectMake(0, SCREEN_HEIGHT, 320, 260);
    } completion:^(BOOL finished) {
        [self request_suggest_list];
    }];
}

- (void)request_suggest_list{
    NSMutableDictionary *sendDataDict = [NSMutableDictionary dictionaryWithDictionary:@{@"ryhclientmacid":@"ad42614e026943949bfc92ce84913e337f3038b1",@"s":@"App Store",@"stockversion":@"1436803200",@"version":@"2.0.5",@"packtype":@"0"}];
    //添加默认参数
//    [sendDataDict setValue:@"get_suggest" forKey:@"m"];
//    [sendDataDict setValue:_dateStr forKey:@"rtime"];
    
    
    BOOL needHUD = [[PersistenceHelper dataForKey:@"hasInitDB"] boolValue];
    if (needHUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"推荐ing....";
        [hud hide:YES afterDelay:30];
    }
//    http://hq.niuguwang.com/aquote/quotedata/stocksyn.ashx?ryhclientmacid=ad42614e026943949bfc92ce84913e337f3038b1&s=App%20Store&stockversion=1436803200&version=2.0.5&packtype=0
    NSString *url = @"http://hq.niuguwang.com/aquote/userdata/getuserstocks.ashx?version=2.0.5&packtype=0&usertoken=njayg_XK-3AJQ9gsPjN9RHzmVogatdxspIs7v0KUj88*&s=App%20Store";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DMLog(@"JSON: %@", responseObject);
        if (responseObject == nil) {
            return;
        }
        
        self.suggestArray = [responseObject objForKey:@"list"];
        [_sTableView reloadData];
        
        if (needHUD) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DMLog(@"Error: %@", error);
        if (needHUD) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionP{
    return [_suggestArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SuggestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SuggestCellReuseIdentifier forIndexPath:indexPath];
    
    [cell setCellData:[_suggestArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.sDetailVC = [[FMViewController alloc] init];
    
    self.sDetailVC.dicStock = [_suggestArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:_sDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    backView.backgroundColor = NAVI_COLOR;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 80, 36)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = HEI_(16);
    nameLabel.textColor = TITLE_BLUE_COLOR;
    nameLabel.text = @"名称代码";
    [backView addSubview:nameLabel];
    
    UILabel *closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 80, 36)];
    closeLabel.textAlignment = NSTextAlignmentRight;
    closeLabel.backgroundColor = [UIColor clearColor];
    closeLabel.font = HEI_(16);
    closeLabel.textColor = TITLE_BLUE_COLOR;
    closeLabel.text = @"最新价";
    [backView addSubview:closeLabel];
    
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(223, 0, 65, 36)];
    percentLabel.textAlignment = NSTextAlignmentRight;
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.font = HEI_(16);
    percentLabel.textColor = TITLE_BLUE_COLOR;
    percentLabel.text = @"涨跌幅";
    [backView addSubview:percentLabel];
    
    return backView;
}

@end
