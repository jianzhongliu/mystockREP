//
//  SettingViewController.m
//  mystock
//
//  Created by Ryan on 14-6-20.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "SettingViewController.h"
#import "FMViewControllerExcersize.h"

@interface SettingViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SettingViewController

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

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
    self.view.backgroundColor = [UIColor redColor];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"设置";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(back_click:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(right_click)];
    [self.view addSubview:self.webView];
    
}
- (void)right_click {
    FMViewControllerExcersize *controller = [[FMViewControllerExcersize alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.frame = self.view.bounds;
    NSString *webUrl = @"http://www.feinongdata.com/kuaixun";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:webUrl]];
    [self.webView loadRequest:request];
    
}

#pragma mark - Custom Method
- (void)back_click:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOpenDrawer object:nil];
}

- (void)refresh_focus_list{
    // 初始化本地数据库
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:kDBFilePath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:kDBFileName ofType:@""];
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:kDBFilePath error:nil];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"同步数据中....";
    [hud hide:YES afterDelay:30];
        
    NSMutableDictionary *sendDataDict = [NSMutableDictionary dictionary];
    //添加默认参数
    [sendDataDict setValue:@"focus_list" forKey:@"m"];
    [sendDataDict setValue:@"0" forKey:@"act"];
    
    //__block AppDelegate *blockSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:apiHost parameters:sendDataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if (responseObject == nil || [responseObject objForKey:@"result"] == 0) {
            return;
        }
        
        NSArray *dataArray = [responseObject objForKey:@"data"];
        NSMutableArray *tempArray = [NSMutableArray array];
        
        FMDatabase *dbBase = [FMDatabase databaseWithPath:kDBFilePath];
        
        NSString *sql = @"update corp_codes set focus = %d, order_num = %d where code = %@";
    
        if ([dbBase open]) {
            for (NSDictionary *item in dataArray) {
                if ([dbBase executeUpdateWithFormat:sql,[[item objForKey:@"focus"] intValue],[[item objForKey:@"order_num"] intValue],[item objForKey:@"code"]]) {
                    
                }else{
                    
                    break;
                }
            }
                
                
            sql = @"select * from corp_codes where focus = 1";
                
            FMResultSet *result = [dbBase executeQuery:sql];
            while ([result next]) {
                NSDictionary *sDic = @{@"code":[result stringForColumn:@"code"],
                                        @"name":[result stringForColumn:@"name"],
                                        @"focus":[NSNumber numberWithInt:[result intForColumn:@"focus"]],
                                        @"order_num":[NSNumber numberWithInt:[result intForColumn:@"order_num"]]};
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:sDic];
                [tempArray addObject:tempDic];
            }
                
        }
            
        [dbBase close];
        
        kAppDelegate.sArray = tempArray;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
@end
