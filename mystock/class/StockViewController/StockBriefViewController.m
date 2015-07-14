//
//  StockBriefViewController.m
//  mystock
//
//  Created by Ryan on 14-6-11.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "StockBriefViewController.h"

@interface StockBriefViewController ()

@end

@implementation StockBriefViewController

- (id)initWithStock:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.stockDic = dic;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    
    NSString *codeStr = [_stockDic objForKey:@"code"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    titleLabel.font = HEI_(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [_stockDic objForKey:@"name"];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 160, 20)];
    codeLabel.font = HEI_(12);
    codeLabel.backgroundColor = [UIColor clearColor];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.textColor = [UIColor whiteColor];
    codeLabel.text = codeStr;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:titleLabel];
    [titleView addSubview:codeLabel];
    
    self.navigationItem.titleView = titleView;
    
    NSString *tempStr = [codeStr substringToIndex:0];
    NSString *marketStr;
    if ([tempStr isEqualToString:@"6"]) {
        marketStr = @"sh";
    }else{
        marketStr = @"sz";
    }
    
    NSString *minDownStr = [NSString stringWithFormat:@"http://image.sinajs.cn/newchart/min/n/%@%@.gif",marketStr,codeStr];
    NSString *dailyDownStr = [NSString stringWithFormat:@"http://image.sinajs.cn/newchart/daily/n/%@%@.gif",marketStr,codeStr];
    NSString *weeklyDownStr = [NSString stringWithFormat:@"http://image.sinajs.cn/newchart/weekly/n/%@%@.gif",marketStr,codeStr];
    NSString *monthlyDownStr = [NSString stringWithFormat:@"http://image.sinajs.cn/newchart/monthly/n/%@%@.gif",marketStr,codeStr];
    
    self.downArray = @[minDownStr,dailyDownStr,weeklyDownStr,monthlyDownStr];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 240, 30)];
    [_segmentedControl insertSegmentWithTitle:@"分时" atIndex:0 animated:NO];
    [_segmentedControl insertSegmentWithTitle:@"日线" atIndex:1 animated:NO];
    [_segmentedControl insertSegmentWithTitle:@"周线" atIndex:2 animated:NO];
    [_segmentedControl insertSegmentWithTitle:@"月线" atIndex:3 animated:NO];
    [_segmentedControl addTarget:self action:@selector(select_type:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl setSelectedSegmentIndex:0];
    [self.view addSubview:_segmentedControl];
    _segmentedControl.center = CGPointMake(160, self.view.bounds.size.height-30-30);
    
    UIButton *imageBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBackBtn.frame = CGRectMake(0, 0, 300, 160);
    imageBackBtn.backgroundColor = [UIColor clearColor];
    [imageBackBtn addTarget:self action:@selector(pic_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageBackBtn];
    imageBackBtn.center = self.view.center;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 170)];
    _imageView.center = self.view.center;
    _imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *downStr = [_downArray objectAtIndex:0];
    NSURL *url=[NSURL URLWithString:downStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error ) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image=image;
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)select_type:(id)sender{
    UISegmentedControl *item = (UISegmentedControl *)sender;
    int sIndex = (int)item.selectedSegmentIndex;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *downStr = [_downArray objectAtIndex:sIndex];
    NSURL *url=[NSURL URLWithString:downStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error ) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image=image;
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)pic_click:(id)sender{
    self.stockLineView = [[StockLineView alloc] initWithFrame:self.view.bounds displayImage:_imageView.image];
    _stockLineView.alpha = 0;
    [kAppDelegate.window addSubview:_stockLineView];
    [UIView animateWithDuration:0.3 animations:^{
        _stockLineView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_line_view)];
    [_stockLineView addGestureRecognizer:tapGesture];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)close_line_view{
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        _stockLineView.alpha = 0;
    } completion:^(BOOL finished) {
        [_stockLineView removeFromSuperview];
        self.stockLineView = nil;
        
    }];
}
@end
