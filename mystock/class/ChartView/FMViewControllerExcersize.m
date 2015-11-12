//
//  FMViewController.m
//  Kline
//
//  Created by zhaomingxi on 14-2-9.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import "FMViewControllerExcersize.h"
#import "lineView.h"
#import "UIColor+helper.h"

@interface FMViewControllerExcersize ()
{
    lineView *lineview;
    UIButton *btnDay;
    UIButton *btnWeek;
    UIButton *btnMonth;
}

@property (nonatomic, strong) UIButton *buttonExercises;
@property (nonatomic, strong) UIButton *buttonNext;
@property (nonatomic, assign) NSInteger index;

@end

@implementation FMViewControllerExcersize

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
    
    self.buttonExercises.frame = CGRectMake(0, self.view.frame.size.height - 40, 40, 40);
    
    [self.view addSubview:self.buttonExercises];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showDoubleStock)];

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

- (void)doExersiseReloadView {
    
    int stockIndex = (0 + (arc4random() % (self.arrayStock.count + 1)));
    int dayIndex = (0 + (arc4random() % (200 + 1)));
    if (stockIndex >= self.arrayStock.count) {
        return;
    }
    NSMutableDictionary *dic = self.arrayStock[stockIndex];
    
    if (dayIndex >= [[dic objectForKey:@"timedata"] count] ) {
        return;
    }
    
    NSMutableArray *arraySoureData = [NSMutableArray array];
    [arraySoureData addObjectsFromArray:[dic objectForKey:@"timedata"]];
    
    NSArray *tempArray = [self subobjectsAtArray:arraySoureData from:dayIndex];
    
    [arraySoureData removeAllObjects];
    [arraySoureData addObjectsFromArray:tempArray];
//    [dic removeObjectForKey:@"timedata"];
    [dic setObject:arraySoureData forKey:@"timedata"];
    
    // 添加k线图
    [lineview removeFromSuperview];
    lineview = nil;
    lineview = [[lineView alloc] init];

    lineview.dicStock = dic;
    
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

//做练习
- (void)didDoExcersice {
    [self doExersiseReloadView];
}

//下一个数据
- (void)didNext {

}

#pragma mark -- getter && setter

- (UIButton *)buttonExercises {
    if (_buttonExercises == nil) {
        _buttonExercises = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonExercises setBackgroundColor:[UIColor yellowColor]];
        [_buttonExercises setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [_buttonExercises setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateHighlighted];
        [_buttonExercises addTarget:self action:@selector(didDoExcersice) forControlEvents:UIControlEventTouchUpInside];
        _buttonExercises.selected = NO;
        [_buttonExercises setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _buttonExercises.titleLabel.font = [UIFont systemFontOfSize:13];
        _buttonExercises.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _buttonExercises ;
    
}

- (UIButton *)buttonNext {
    if (_buttonNext == nil) {
        _buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonNext setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [_buttonNext setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateHighlighted];
        [_buttonNext addTarget:self action:@selector(didNext) forControlEvents:UIControlEventTouchUpInside];
        _buttonNext.selected = NO;
        [_buttonNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _buttonNext.titleLabel.font = [UIFont systemFontOfSize:13];
        _buttonNext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _buttonNext;
    
}

- (NSArray *)subobjectsAtArray:(NSArray *) array from:(NSInteger ) index {
    NSMutableArray *arrayResult = [NSMutableArray array];
    if (array.count <= index) {
        return array;
    }
    for (int i = 0; i < index; i ++ ) {
        [arrayResult addObject:[array objectAtIndex:(array.count - i - 1)]];
    }
    return arrayResult;
}

@end
