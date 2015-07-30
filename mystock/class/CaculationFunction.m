//
//  CaculationFunction.m
//  mystock
//
//  Created by liujianzhong on 15/7/30.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "CaculationFunction.h"
#import "RquestTotalStock.h"
#import "commond.h"

@implementation CaculationFunction
+ (void)load {
//    [[CaculationFunction share] lowColumnRate];
//    [[CaculationFunction share] hightColumnRate];
//    NSLog(@"%@", [[CaculationFunction share] todayDouble]) ;
//    NSLog(@"%@", [[CaculationFunction share] lowStockes]) ;
//    [[CaculationFunction share] dowblecolumn];
    [[CaculationFunction share] goldenColumn];
}

+ (instancetype)share {
    static CaculationFunction *caculat;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (caculat == nil) {
            caculat = [[CaculationFunction alloc] init];
        }
    });
    return caculat;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.arraySourceData = [NSMutableArray arrayWithArray:[commond getUserDefaults:@"sourceData"]];
    self.arrayBetween = [NSMutableArray array];
    self.arrayDouble = [NSMutableArray array];
    self.arrayLow = [NSMutableArray array];
}

/**高量柱数据
 高量柱结果：降：110=====升:32=====上涨率：0.23=====涨幅：0.17=======跌幅：0.13
 */
- (void)hightColumnRate {
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        if (arraySingleDay.count > 0) {
            NSDictionary *dicLow = arraySingleDay[0];
            for (NSDictionary *dicDay in arraySingleDay) {
                if ([dicDay[@"curvol"] integerValue] > [dicLow[@"curvol"] integerValue]) {
                    dicLow = dicDay;
                }
            }
            int index = [arraySingleDay indexOfObject:dicLow];
//            NSLog(@"%@======%@", dicLow[@"times"], dic[@"stockcode"]);
            if (arraySingleDay.count > index + 5) {
                if ([arraySingleDay[index + 5][@"preclose"] integerValue] > [dicLow[@"preclose"] integerValue]) {
                  uprate += ([arraySingleDay[index + 5][@"preclose"] integerValue] - [dicLow[@"preclose"] integerValue]) / [dicLow[@"preclose"] floatValue];
                    up ++ ;
                } else {
                  downRate += ([dicLow[@"preclose"] integerValue] - [arraySingleDay[index + 5][@"preclose"] integerValue]) / [dicLow[@"preclose"] floatValue];
                    low ++ ;
                }
            }
        }
    }
    NSLog(@"高量柱结果：降：%d=====升:%d=====上涨率：%.2f=====涨幅：%.2f=======跌幅：%.2f", low, up, up/(up+low +0.000001f), uprate / (up + 0.000001), downRate/ (low+0.000000001));
}

/**低量柱数据
 低量柱结果：降：17=====升:60=====上涨率：0.78======涨幅:0.19 ===== 跌幅:0.05
 */
- (void)lowColumnRate {
    int days = 6;//时差天数
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        if (arraySingleDay.count > 0) {
            NSDictionary *dicLow = arraySingleDay[0];
            for (NSDictionary *dicDay in arraySingleDay) {
                if ([dicDay[@"curvol"] integerValue] <= [dicLow[@"curvol"] integerValue]) {
                    dicLow = dicDay;
                }
            }
            int index = [arraySingleDay indexOfObject:dicLow];
            NSLog(@"%@======%@", dicLow[@"times"], dic[@"stockcode"]);
            if (arraySingleDay.count > index + days) {
                if ([arraySingleDay[index + days][@"preclose"] integerValue] > [dicLow[@"preclose"] integerValue]) {
                  int data = [arraySingleDay[index + days][@"preclose"] integerValue] - [dicLow[@"preclose"] integerValue];
                    uprate += data / ([dicLow[@"preclose"] integerValue] + 0.000000000000001f);
                    up ++ ;
                } else {
                    downRate += ([dicLow[@"preclose"] integerValue] - [arraySingleDay[index + days][@"preclose"] integerValue]) /  [dicLow[@"preclose"] floatValue];
                    low ++ ;
                }
            }
        }

    }
    NSLog(@"低量柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
}

/**倍量柱数据
 倍量柱结果：降：45=====升:72=====上涨率：0.62======涨幅:0.21 ===== 跌幅:0.11
 */
- (void)dowblecolumn {
    int days = 10;//时差天数
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            for (int s = 1 ; s<arraySingleStock.count ; s++) {
                if (2*[[arraySingleStock[s] objectForKey:@"curvol"] integerValue] <= [[arraySingleStock[s -1] objectForKey:@"curvol"] integerValue]) {
                    //就是倍量柱了
                    if (arraySingleStock.count > s + days) {
                        if ([arraySingleStock[s + days][@"preclose"] integerValue] > [arraySingleStock[s][@"preclose"] integerValue]) {
                            NSLog(@"%@======%@", arraySingleStock[s][@"times"], dic[@"stockcode"]);
                            int data = [arraySingleStock[s + days][@"preclose"] integerValue] - [arraySingleStock[s][@"preclose"] integerValue];
                            uprate += data / ([arraySingleStock[s][@"preclose"] integerValue] + 0.000000000000001f);
                            up ++ ;
                        } else {
                            downRate += ([arraySingleStock[s][@"preclose"] integerValue] - [arraySingleStock[s + days][@"preclose"] integerValue]) /  [arraySingleStock[s][@"preclose"] floatValue];
                            low ++ ;
                        }
                    }
                }
            }
        }
    }
    NSLog(@"倍量柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
}

/**黄金柱柱数据
黄金量柱结果：降：1=====升:6=====上涨率：0.86======涨幅:0.37 ===== 跌幅:0.22
 */
- (NSArray *)goldenColumn {
    int days = 12;//时差天数
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    NSMutableArray *arrayGolden = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            for (int s = 3 ; s<arraySingleStock.count ; s++) {
                if (arraySingleStock.count > s + 4 && arraySingleStock.count > s+days) {//黄金柱后三天
                    if ([[arraySingleStock[s] objectForKey:@"curvol"] integerValue] > [[arraySingleStock[s -1] objectForKey:@"curvol"] integerValue] && [[arraySingleStock[s -1] objectForKey:@"curvol"] integerValue] > [[arraySingleStock[s -2] objectForKey:@"curvol"] integerValue] && [[arraySingleStock[s -2] objectForKey:@"curvol"] integerValue] > [[arraySingleStock[s -3] objectForKey:@"curvol"] integerValue]) {
                        if ([[arraySingleStock[s] objectForKey:@"preclose"] integerValue] < [[arraySingleStock[s -1] objectForKey:@"preclose"] integerValue] && [[arraySingleStock[s -1] objectForKey:@"preclose"] integerValue] <[[arraySingleStock[s -2] objectForKey:@"preclose"] integerValue] && [[arraySingleStock[s -2] objectForKey:@"preclose"] integerValue] < [[arraySingleStock[s -3] objectForKey:@"preclose"] integerValue]) {
                            
                            if (s < 6) {
                                [arrayGolden addObject:dic];
                            }
                            //这个是标准的黄金柱
                            NSLog(@"%@======%@", arraySingleStock[s][@"times"], dic[@"stockcode"]);
                            
                            NSInteger goldenDay = [[arraySingleStock[s] objectForKey:@"preclose"] integerValue];
                            NSInteger lastDay = [[arraySingleStock[s + days] objectForKey:@"preclose"] integerValue];
                            if (goldenDay > lastDay) {
                                low ++;
                                //下跌
                                downRate += (goldenDay - lastDay) / (goldenDay + 0.0000001f);
                                
                            } else {
                                up ++;
                                uprate += (lastDay - goldenDay)/(goldenDay + 0.0000000f);
                            }
                        }
                }
                }
            }
        }
    }
    NSLog(@"黄金量柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
    return arrayGolden;
}


/**今天低量柱
 */
- (NSArray *)lowStockes {
    NSMutableArray *arrayLow = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        if (arraySingleDay.count > 0) {
            NSDictionary *dicLow = arraySingleDay[0];
            for (NSDictionary *dicDay in arraySingleDay) {
                if ([dicDay[@"curvol"] integerValue] <= [dicLow[@"curvol"] integerValue]) {
                    dicLow = dicDay;
                }
            }
            if ([dicLow[@"curvol"] integerValue] == [[arraySingleDay[0] objectForKey:@"curvol"] integerValue]) {
                [arrayLow addObject:dic];
            }
        }
        
    }
    return arrayLow;
}

/**今日倍量柱*/
- (NSArray *)todayDouble {
    NSMutableArray *arrayDouble = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i ++) {
        if ([[self.arraySourceData[0] objectForKey:@"curvol"] floatValue] > 2.0f * [[self.arraySourceData[1] objectForKey:@"curvol"] floatValue] ) {
            [arrayDouble addObject:self.arraySourceData[i]];
        }
    }
    return arrayDouble;
}


/**假阴真阳*/

/**假阳真阴*/

@end
