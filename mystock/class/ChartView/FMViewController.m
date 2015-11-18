//
//  FMViewController.m
//  Kline
//
//  Created by zhaomingxi on 14-2-9.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import "FMViewController.h"
#import "lineView.h"
#import "UIColor+helper.h"

@interface FMViewController ()
{
    lineView *lineview;
    UIButton *btnDay;
    UIButton *btnWeek;
    UIButton *btnMonth;
}


@end

@implementation FMViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
- (id)init {
    if(self = [super init]){
        _dicStock = [NSDictionary dictionary];
        [self initData];
    }
    return self;
}

- (void)initData {
    self.arrayStock = [NSArray array];
}

-(void)viewDidLoad{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showDoubleStock)];
    UIButton *buttonNext = [UIButton buttonWithType:UIButtonTypeContactAdd];
    buttonNext.frame = CGRectMake(0, self.view.frame.size.height - 60, 40, 40);
    [buttonNext setBackgroundColor:[UIColor redColor]];
    [buttonNext addTarget:self action:@selector(showDoubleStock) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:buttonNext];
    // 日k按钮
    btnDay = [[UIButton alloc] initWithFrame:CGRectMake(20, 70, 50, 30)];
    [btnDay setTitle:@"日K" forState:UIControlStateNormal];
    [btnDay addTarget:self action:@selector(kDayLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnDay];
    [self.view addSubview:btnDay];
    // 周k按钮
    btnWeek = [[UIButton alloc] initWithFrame:CGRectMake(75, 70, 50, 30)];
    [btnWeek setTitle:@"周K" forState:UIControlStateNormal];
    [btnWeek addTarget:self action:@selector(kWeekLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnWeek];
    [self.view addSubview:btnWeek];
    // 月k按钮
    btnMonth = [[UIButton alloc] initWithFrame:CGRectMake(130, 70, 50, 30)];
    [btnMonth setTitle:@"月K" forState:UIControlStateNormal];
    [btnMonth addTarget:self action:@selector(kMonthLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnMonth];
    [self.view addSubview:btnMonth];
    
    // 放大
    UIButton *btnBig = [[UIButton alloc] initWithFrame:CGRectMake(185, 70, 50, 30)];
    [btnBig setTitle:@"+" forState:UIControlStateNormal];
    [btnBig addTarget:self action:@selector(kBigLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnBig];
    [self.view addSubview:btnBig];
    
    // 缩小
    UIButton *btnSmall = [[UIButton alloc] initWithFrame:CGRectMake(240, 70, 50, 30)];
    [btnSmall setTitle:@"-" forState:UIControlStateNormal];
    [btnSmall addTarget:self action:@selector(kSmallLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnSmall];
    [self.view addSubview:btnSmall];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#111111" withAlpha:1];

    [self reloadView];
}

- (void)showDoubleStock {
    self.index ++;
    [self reloadView];
}

- (void)reloadView {
    if (self.index >= self.arrayStock.count) {
        return;
    }
    // 添加k线图
    [lineview removeFromSuperview];
    lineview = nil;
    lineview = [[lineView alloc] init];
    if (self.arrayStock.count == 0) {
        lineview.dicStock = self.dicStock;
    } else {
        lineview.dicStock = self.arrayStock[self.index];
    }
    [self setTitle:[NSString stringWithFormat:@"%@%@",lineview.dicStock[@"stockname"], lineview.dicStock[@"stockcode"]]];

    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0, 120);
    frame.size = CGSizeMake(310, 200);
    lineview.frame = frame;
    //lineview.backgroundColor = [UIColor blueColor];
    lineview.req_type = @"d";
    lineview.req_freq = @"601888.SS";
    lineview.kLineWidth = 5;
    lineview.kLinePadding = 0.5;
    [self.view addSubview:lineview];
    [lineview start]; // k线图运行
    [self setButtonAttrWithClick:btnDay];
}


-(void)kDayLine{
    [self setButtonAttrWithClick:btnDay];
    [self setButtonAttr:btnMonth];
    [self setButtonAttr:btnWeek];
    lineview.req_type = @"d";
    [self kUpdate];
}

-(void)kWeekLine{
    [self setButtonAttrWithClick:btnWeek];
    [self setButtonAttr:btnMonth];
    [self setButtonAttr:btnDay];
    lineview.req_type = @"w";
    [self kUpdate];
}

-(void)kMonthLine{
    [self setButtonAttrWithClick:btnMonth];
    [self setButtonAttr:btnWeek];
    [self setButtonAttr:btnDay];
    lineview.req_type = @"m";
    [self kUpdate];
}

-(void)kBigLine{
    lineview.kLineWidth += 1;
    [self kUpdate];
}

-(void)kSmallLine{
    lineview.kLineWidth -= 1;
    if (lineview.kLineWidth<=1) {
        lineview.kLineWidth = 1;
    }
    [self kUpdate];
}

-(void)kUpdate{
    [lineview update];
}

-(void)setButtonAttr:(UIButton*)button{
    button.backgroundColor = [UIColor blackColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)setButtonAttrWithClick:(UIButton*)button{
    button.backgroundColor = [UIColor colorWithHexString:@"cccccc" withAlpha:1];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

@end
