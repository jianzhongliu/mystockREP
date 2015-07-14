//
//  SuggestDetailViewController.m
//  mystock
//
//  Created by Ryan on 14-6-11.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "SuggestDetailViewController.h"

@interface SuggestDetailViewController ()

@end

@implementation SuggestDetailViewController

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
    
    UILabel *closeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 85, 130, 20)];
    closeTitleLabel.backgroundColor = [UIColor clearColor];
    closeTitleLabel.font = HEI_(16);
    closeTitleLabel.textColor = [UIColor whiteColor];
    closeTitleLabel.text = @"收盘价：";
    [self.view addSubview:closeTitleLabel];
    [closeTitleLabel sizeToFit];
    
    UILabel *closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(closeTitleLabel.frame.origin.x+closeTitleLabel.frame.size.width, 85, 130, 20)];
    closeLabel.backgroundColor = [UIColor clearColor];
    closeLabel.font = HEI_(16);
    closeLabel.textColor = [UIColor whiteColor];
    closeLabel.text = [_stockDic objForKey:@"close"];
    [self.view addSubview:closeLabel];
    
    UILabel *percentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 85, 130, 20)];
    percentTitleLabel.backgroundColor = [UIColor clearColor];
    percentTitleLabel.font = HEI_(16);
    percentTitleLabel.textColor = [UIColor whiteColor];
    percentTitleLabel.text = @"涨跌幅：";
    [self.view addSubview:percentTitleLabel];
    [percentTitleLabel sizeToFit];
    
    NSString *percent = [_stockDic objForKey:@"percent"];
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(percentTitleLabel.frame.origin.x+percentTitleLabel.frame.size.width, 85, 130, 20)];
    percentLabel.textAlignment = NSTextAlignmentCenter;
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.font = HEI_(16);
    percentLabel.textColor = [UIColor whiteColor];
    percentLabel.text = [percent stringByAppendingString:@"%"];
    [self.view addSubview:percentLabel];
    [percentLabel sizeToFit];
    
    if ([percent floatValue] >= 0) {
        percentLabel.backgroundColor = RED_COLOR;
    }else{
        percentLabel.backgroundColor = DARK_GREEN_COLOR;
    }
    
    percentLabel.frame = CGRectMake(percentLabel.frame.origin.x, percentLabel.frame.origin.y-5, percentLabel.frame.size.width+20, percentLabel.frame.size.height+10);
    
    
    UILabel *scoreTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 130, 20)];
    scoreTitleLabel.backgroundColor = [UIColor clearColor];
    scoreTitleLabel.font = HEI_(16);
    scoreTitleLabel.textColor = [UIColor whiteColor];
    scoreTitleLabel.text = @"得分：";
    [self.view addSubview:scoreTitleLabel];
    [scoreTitleLabel sizeToFit];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreTitleLabel.frame.origin.x+scoreTitleLabel.frame.size.width, 130, 130, 20)];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = HEI_(16);
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.text = [_stockDic objForKey:@"score"];
    [self.view addSubview:scoreLabel];
    
    UILabel *reasonTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 130, 20)];
    reasonTitleLabel.backgroundColor = [UIColor clearColor];
    reasonTitleLabel.font = HEI_(16);
    reasonTitleLabel.textColor = [UIColor whiteColor];
    reasonTitleLabel.text = @"推荐理由：";
    [self.view addSubview:reasonTitleLabel];
    [reasonTitleLabel sizeToFit];
    
    NSString *reasonStr = [_stockDic objForKey:@"reason"];
    float origin_X = reasonTitleLabel.frame.origin.x+reasonTitleLabel.frame.size.width;
    
    NSDictionary *attribute = @{NSFontAttributeName: HEI_(16)};
    CGSize size = [reasonStr boundingRectWithSize:CGSizeMake(320-15-origin_X, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(origin_X, 175, size.width, size.height)];
    reasonLabel.backgroundColor = [UIColor clearColor];
    reasonLabel.font = HEI_(16);
    reasonLabel.textColor = [UIColor whiteColor];
    reasonLabel.numberOfLines = 0;
    reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    reasonLabel.text = reasonStr;
    [self.view addSubview:reasonLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自选股" style:UIBarButtonItemStylePlain target:self action:@selector(go_qqStock:)];
    
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
    imageBackBtn.frame = CGRectMake(0, 0, 300, 170);
    imageBackBtn.backgroundColor = [UIColor clearColor];
    [imageBackBtn addTarget:self action:@selector(pic_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageBackBtn];
    imageBackBtn.frame = CGRectMake(10, reasonLabel.frame.origin.y+reasonLabel.frame.size.height+40, 300, 170);
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 170)];
    _imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageView];
    _imageView.frame = CGRectMake(10, reasonLabel.frame.origin.y+reasonLabel.frame.size.height+40, 300, 170);
    
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
- (void)go_qqStock:(id)sender{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = [_stockDic objForKey:@"code"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"qqstock://"]]; // 跳转自选股
}

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
