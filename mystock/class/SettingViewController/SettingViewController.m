//
//  SettingViewController.m
//  mystock
//
//  Created by Ryan on 14-6-20.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "SettingViewController.h"
#import "FMViewControllerExcersize.h"
#import "TimeLineChartViewController.h"
#import "CaculationFunction.h"

@interface SettingViewController ()<UIActionSheetDelegate>

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
    
    UIButton *buttonDay = [UIButton buttonWithType:UIButtonTypeContactAdd];
    buttonDay.frame = CGRectMake(100, 100, 40, 40);
    buttonDay.backgroundColor = [UIColor yellowColor];
    [buttonDay addTarget:self action:@selector(selectDays) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:buttonDay];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button setTitle:@"分时" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showTimeStock) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 300, 80, 40);
    [self.view addSubview:button];
    
    
    UIButton *buttonUpStop = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonUpStop setTitle:@"涨停练习" forState:UIControlStateNormal];
    [buttonUpStop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonUpStop addTarget:self action:@selector(setUpStop) forControlEvents:UIControlEventTouchUpInside];
    buttonUpStop.backgroundColor = [UIColor blueColor];
    buttonUpStop.titleLabel.font = [UIFont systemFontOfSize:12];
    buttonUpStop.frame = CGRectMake(10, 300, 80, 40);
    [self.view addSubview:buttonUpStop];
    
    UIButton *buttonDownStop = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDownStop setTitle:@"跌停练习" forState:UIControlStateNormal];
    [buttonDownStop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonDownStop addTarget:self action:@selector(setDownStop) forControlEvents:UIControlEventTouchUpInside];
    buttonDownStop.titleLabel.font = [UIFont systemFontOfSize:12];
    buttonDownStop.backgroundColor = [UIColor blueColor];
    buttonDownStop.frame = CGRectMake(100, 300, 80, 40);
    [self.view addSubview:buttonDownStop];
    
    UIButton *buttonDouble = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDouble setTitle:@"倍量练习" forState:UIControlStateNormal];
    [buttonDouble setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonDouble addTarget:self action:@selector(setDoubleKline) forControlEvents:UIControlEventTouchUpInside];
    buttonDouble.titleLabel.font = [UIFont systemFontOfSize:12];
    buttonDouble.backgroundColor = [UIColor blueColor];
    buttonDouble.frame = CGRectMake(190, 300, 80, 40);
    [self.view addSubview:buttonDouble];
    
    UIButton *buttonNomal = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonNomal setTitle:@"50天后" forState:UIControlStateNormal];
    [buttonNomal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNomal addTarget:self action:@selector(setNomalKline) forControlEvents:UIControlEventTouchUpInside];
    buttonNomal.titleLabel.font = [UIFont systemFontOfSize:12];
    buttonNomal.backgroundColor = [UIColor blueColor];
    buttonNomal.frame = CGRectMake(190, 400, 80, 40);
    [self.view addSubview:buttonNomal];
    [CaculationFunction share].isLow = YES;
}

- (void)setDownStop {
    [CaculationFunction share].isDownStop = YES;
    [CaculationFunction share].isDowble = NO;
    [CaculationFunction share].isUpStop = NO;
    [CaculationFunction share].isLow = NO;
}

- (void)setUpStop {
    [CaculationFunction share].isUpStop = YES;
    [CaculationFunction share].isDownStop = NO;
    [CaculationFunction share].isDowble = NO;
    [CaculationFunction share].isLow = NO;
}

- (void)setDoubleKline {
     [CaculationFunction share].isDowble = YES;
    [CaculationFunction share].isUpStop = NO;
    [CaculationFunction share].isDownStop = NO;
    [CaculationFunction share].isLow = NO;
}

- (void)setNomalKline {
    [CaculationFunction share].isDowble = NO;
    [CaculationFunction share].isUpStop = NO;
    [CaculationFunction share].isDownStop = NO;
    [CaculationFunction share].isNomal = YES;
    [CaculationFunction share].isLow = NO;
}

- (void)showTimeStock {
    TimeLineChartViewController *controller = [[TimeLineChartViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)right_click {
    FMViewControllerExcersize *controller = [[FMViewControllerExcersize alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)selectDays {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"100-9",@"70-8",@"50-7",@"40-6",@"30-5",@"20-4",@"10-3",@"5-2", nil];
    [action showInView:self.view];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  {
    switch (buttonIndex) {
        case 0:
        {
            [CaculationFunction share].lowDay = 100;
            [CaculationFunction share].lowRate = 9;
        }
            break;
        case 1:
        {
            [CaculationFunction share].lowDay = 70;
            [CaculationFunction share].lowRate = 8;

        }
            break;
        case 2:
        {
            [CaculationFunction share].lowDay = 50;
            [CaculationFunction share].lowRate = 7;

        }
            break;
        case 3:
        {
            [CaculationFunction share].lowDay = 40;
            [CaculationFunction share].lowRate = 6;

        }
            break;
        case 4:
        {
            [CaculationFunction share].lowDay = 30;
            [CaculationFunction share].lowRate = 5;

        }
            break;
        case 5:
        {
            [CaculationFunction share].lowDay = 20;
            [CaculationFunction share].lowRate = 4;

        }
            break;
        case 6:
        {
            [CaculationFunction share].lowDay = 10;
            [CaculationFunction share].lowRate = 3;

        }
            break;
        case 7:
        {
            [CaculationFunction share].lowDay = 5;
            [CaculationFunction share].lowRate = 2;

        }
            break;
        default:
            break;
    }
}
@end
