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
#import "DBManager.h"

@interface FMViewControllerExcersize ()
{
    lineView *lineview;
    UIButton *btnDay;
    UIButton *btnWeek;
    UIButton *btnMonth;
}

@property (nonatomic, strong) UIButton *buttonLeft;
@property (nonatomic, strong) UIButton *buttonRight;
@property (nonatomic, strong) UILabel *lableCount;//结果

@property (nonatomic, assign) NSInteger leftCount;//错
@property (nonatomic, assign) NSInteger rightCount;//对

@property (nonatomic, strong) UIButton *buttonExercises;
@property (nonatomic, strong) UIButton *buttonNext;

@property (nonatomic, strong) NSMutableDictionary *dicCurrentStock;
@property (nonatomic, strong) NSMutableDictionary *dicSourceData;//选中的那个原始数据
@property (nonatomic, assign) NSInteger indector;

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
    self.arrayStock = [NSMutableArray arrayWithArray:[[DBManager share] fetchStockLocationWithKey:@"sourceData"]];
    self.dicCurrentStock = [NSMutableDictionary dictionary];
    self.indector = 0;
    
    self.leftCount = 0;
    self.rightCount = 0;
    
}

-(void)viewDidLoad{
    
    self.buttonExercises.frame = CGRectMake(20, self.view.frame.size.height - 40, 40, 40);
    [self.view addSubview:self.buttonExercises];
    
    self.buttonNext.frame = CGRectMake(60, self.view.frame.size.height - 40, 40, 40);
    [self.view addSubview:self.buttonNext];
    
    
    self.buttonLeft.frame = CGRectMake(120, self.view.frame.size.height - 40, 40, 40);
    [self.view addSubview:self.buttonLeft];
    
    self.buttonRight.frame = CGRectMake(180, self.view.frame.size.height - 40, 40, 40);
    [self.view addSubview:self.buttonRight];
    
    
    self.lableCount.frame = CGRectMake(10, self.view.frame.size.height - 70, 200, 25);
    [self.view addSubview:self.lableCount];
    
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
//    [self.view addSubview:btnWeek];
    // 月k按钮
    btnMonth = [[UIButton alloc] initWithFrame:CGRectMake(130, 70, 50, 30)];
    [btnMonth setTitle:@"月K" forState:UIControlStateNormal];
    [btnMonth addTarget:self action:@selector(kMonthLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnMonth];
//    [self.view addSubview:btnMonth];
    
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

    [self doExersiseReloadView];
}

- (void)showDoubleStock {
    [self doExersiseReloadView];
}

- (void)doExersiseReloadView {
    // 添加k线图
    [lineview removeFromSuperview];
    lineview = nil;
    lineview = [[lineView alloc] init];

    lineview.dicStock = self.dicCurrentStock;
    
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
    int stockIndex = (0 + (arc4random() % (self.arrayStock.count + 1)));

    if (stockIndex >= self.arrayStock.count) {
        return;
    }
    self.dicSourceData = self.arrayStock[stockIndex];
    [self.dicCurrentStock setValuesForKeysWithDictionary:self.dicSourceData];
    int dayIndex = (0 + (arc4random() % ([self.dicCurrentStock[@"timedata"] count] + 1)));
    self.indector = dayIndex;
    if (dayIndex >= [[self.dicCurrentStock objectForKey:@"timedata"] count] ) {
        return;
    }
    
    NSMutableArray *arraySoureData = [NSMutableArray array];
    [arraySoureData addObjectsFromArray:[self.dicCurrentStock objectForKey:@"timedata"]];

    NSArray *tempArray = [self subobjectsAtArray:arraySoureData from:self.indector];
    
    [arraySoureData removeAllObjects];
    [arraySoureData addObjectsFromArray:tempArray];
    //    [dic removeObjectForKey:@"timedata"];
    [self.dicCurrentStock setObject:arraySoureData forKey:@"timedata"];

    [self doExersiseReloadView];
}

//下一个数据
- (void)didNext {
    self.indector --;
    if (self.indector >= [self.dicSourceData[@"timedata"] count]) {
        return;
    }
    NSMutableArray *originData = [NSMutableArray arrayWithArray:self.dicCurrentStock[@"timedata"]];
    
    [originData insertObject:[self.dicSourceData[@"timedata"] objectAtIndex:self.indector] atIndex:0];

    [self.dicCurrentStock setObject:originData forKey:@"timedata"];
    [self doExersiseReloadView];
}

- (void)didLeft {
    self.leftCount ++;
    self.lableCount.text = [NSString stringWithFormat:@"错：%ld         对：%ld", self.leftCount, self.rightCount];
    
}

- (void)didRight {
    self.rightCount ++;
    self.lableCount.text = [NSString stringWithFormat:@"错：%ld         对：%ld", self.leftCount, self.rightCount];
}

#pragma mark -- getter && setter

- (UIButton *)buttonExercises {
    if (_buttonExercises == nil) {
        _buttonExercises = [UIButton buttonWithType:UIButtonTypeContactAdd];
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
        _buttonNext = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [_buttonNext setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [_buttonNext setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateHighlighted];
        [_buttonNext addTarget:self action:@selector(didNext) forControlEvents:UIControlEventTouchUpInside];
        _buttonNext.selected = NO;
        _buttonNext.backgroundColor = [UIColor redColor];
        [_buttonNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _buttonNext.titleLabel.font = [UIFont systemFontOfSize:13];
        _buttonNext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _buttonNext;
    
}

- (UIButton *)buttonLeft {
    if (_buttonLeft == nil) {
        _buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonLeft setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [_buttonLeft setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateHighlighted];
        [_buttonLeft addTarget:self action:@selector(didLeft) forControlEvents:UIControlEventTouchUpInside];
        _buttonLeft.selected = NO;
        [_buttonLeft setTitle:@"error" forState:UIControlStateNormal];
        [_buttonLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _buttonLeft.titleLabel.font = [UIFont systemFontOfSize:13];
        _buttonLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _buttonLeft;
    
}

- (UIButton *)buttonRight {
    if (_buttonRight == nil) {
        _buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonRight setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [_buttonRight setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateHighlighted];
        [_buttonRight addTarget:self action:@selector(didRight) forControlEvents:UIControlEventTouchUpInside];
        _buttonRight.selected = NO;
        [_buttonRight setTitle:@"right" forState:UIControlStateNormal];
        [_buttonRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _buttonRight.titleLabel.font = [UIFont systemFontOfSize:13];
        _buttonRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _buttonRight;
    
}

- (UILabel *)lableCount {
    if (_lableCount == nil) {
        _lableCount = [[UILabel alloc] init];
        _lableCount.numberOfLines = 0;
        _lableCount.lineBreakMode = NSLineBreakByCharWrapping;
        _lableCount.font = [UIFont systemFontOfSize:13];
        _lableCount.textColor = [UIColor redColor];
    }
    return _lableCount;
}

- (NSArray *)subobjectsAtArray:(NSArray *) array from:(NSInteger ) index {
    NSMutableArray *arraySort = [NSMutableArray arrayWithArray:array];
    for (int j = 0; j<index; j++) {
        [arraySort removeObjectAtIndex:0];
    }
    return arraySort;
}

@end
