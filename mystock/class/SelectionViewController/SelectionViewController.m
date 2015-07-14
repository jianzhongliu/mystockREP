//
//  SelectionViewController.m
//  mystock
//
//  Created by Ryan on 14-5-19.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "SelectionViewController.h"
#import "SelectTableViewCell.h"

NSString * const SelectCellReuseIdentifier = @"SelectCell";

@interface SelectionViewController ()

@end

@implementation SelectionViewController

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
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    
    self.sTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _sTableView.delegate = self;
    _sTableView.dataSource = self;
    _sTableView.backgroundColor = [UIColor clearColor];
    _sTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_sTableView];
    
    [_sTableView registerClass:[SelectTableViewCell class] forCellReuseIdentifier:SelectCellReuseIdentifier];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"关注列表";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(back_click:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search_click:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh_table:) name:kNotificationRefreshSelection object:nil];
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

- (void)search_click:(id)sender{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:searchVC] animated:YES completion:^{
        
    }];
}

- (void)refresh_table:(NSNotification *)noti{
    [_sTableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionP{
    return [kSArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectCellReuseIdentifier forIndexPath:indexPath];

    [cell setCellData:[kSArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.stockBriefVC = [[StockBriefViewController alloc] initWithStock:[kSArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:_stockBriefVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *tempDic = [kSArray objectAtIndex:indexPath.row];
        
        NSMutableDictionary *sendDataDict = [NSMutableDictionary dictionary];
        //添加默认参数
        [sendDataDict setValue:@"focus_list" forKey:@"m"];
        [sendDataDict setValue:@"3" forKey:@"act"];
        [sendDataDict setValue:[tempDic objForKey:@"code"] forKey:@"code"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:apiHost parameters:sendDataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DMLog(@"JSON: %@", responseObject);
            if (responseObject == nil || [responseObject objForKey:@"result"] == 0) {
                return;
            }
            
            FMDatabase *dbBase = [FMDatabase databaseWithPath:kDBFilePath];
            
            NSString *sql = @"update corp_codes set focus = '0' WHERE code = %@";
            if ([dbBase open]) {
                if ([dbBase executeUpdateWithFormat:sql,[tempDic objForKey:@"code"]]) {
                    // 从自选中删除
                    [kSArray removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    // 更换搜索历史中标签
                    if ([[NSFileManager defaultManager] fileExistsAtPath:SEARCH_FILEPATH]) {
                        NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:SEARCH_FILEPATH];
                        for (NSDictionary *item in historyArray) {
                            if ([[item objForKey:@"code"] isEqualToString:[tempDic objForKey:@"code"]]) {
                                [item setValue:[NSNumber numberWithInt:0] forKey:@"focus"];
                                break;
                            }
                        }
                        
                        [historyArray writeToFile:SEARCH_FILEPATH atomically:YES];
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:hud];
                    
                    // Set custom view mode
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.userInteractionEnabled = NO;
                    hud.labelText = @"删除成功";
                    
                    [hud show:YES];
                    [hud hide:YES afterDelay:1];
                }
            }
            
            [dbBase close];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DMLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



@end
