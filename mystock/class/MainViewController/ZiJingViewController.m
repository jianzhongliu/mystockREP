//
//  SuggestStockViewController.m
//  mystock
//
//  Created by liujianzhong on 15/7/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "ZiJingViewController.h"
#import "RquestTotalStock.h"
#import "CaculationFunction.h"
#import "colorModel.h"
#import "getData.h"
#import "commond.h"
#import "TYAPIProxy.h"

@interface ZiJingViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labelContent;

@end

@implementation ZiJingViewController
- (UILabel *)labelContent {
    if (_labelContent == nil) {
        _labelContent = [[UILabel alloc] init];
        _labelContent.numberOfLines = 0;
        _labelContent.lineBreakMode = NSLineBreakByCharWrapping;
        _labelContent.font = [UIFont systemFontOfSize:13];
    }
    return _labelContent;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = NO;
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    }
    return _scrollView;
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
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.labelContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestHttpRequest];
}

- (void)requestHttpRequest {
    NSString *url = @"http://vis.10jqka.com.cn/bbd/index/flash/type/10/symbol/10/date//auto_push/0/minute_last_push_time/0";
    [[TYAPIProxy shareProxy] callGETWithParams:@{} identify:url methodName:@"" successCallBack:^(TYURLResponse *response) {
        NSArray *array = [response.content objectForKey:@"data"];
        NSMutableArray *showData = [NSMutableArray array];
        for (NSArray *arrayTemp in array) {
            [showData addObject:[NSString stringWithFormat:@"%@    %@",arrayTemp[0],arrayTemp[3]]];
        }
        
        NSString *string = [NSString stringWithFormat:@"%@", showData];
        self.labelContent.text = string;
        [self.labelContent sizeToFit];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.labelContent.frame.size.height);
    } faildCallBack:^(TYURLResponse *response) {
        
    }];

}


@end
