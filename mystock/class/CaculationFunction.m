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
//    [[CaculationFunction share] goldenColumn];
//    [[CaculationFunction share] falseDown];
//    [[CaculationFunction share] falseUp];
//    [[CaculationFunction share] averageValue];
//    NSLog(@"%@", [[CaculationFunction share] getDownMore]);
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

/**超跌排序*/
- (NSArray *)getDownMore {
    NSMutableArray *arrayValueEveryDay = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arrayOneStock = dic[@"timedata"];
        if (arrayOneStock.count > 0) {
            NSInteger lowPrice = [[arrayOneStock[0] objectForKey:@"lowp"] integerValue];
            NSInteger hightPrice = [[arrayOneStock[0] objectForKey:@"highp"] integerValue] ;
            for (int s = 0 ; s<arrayOneStock.count ; s++) {
                NSInteger currentHightPrice = [[arrayOneStock[s] objectForKey:@"highp"] integerValue];
                if (currentHightPrice > hightPrice) {
                    hightPrice = currentHightPrice;
                }
                
//                if(currentLowPrice < lowPrice){
//                    lowPrice = currentLowPrice;
//                }
            }
            NSDictionary *dicTemp = @{@"innercode":dic[@"innercode"], @"storck":dic[@"stockcode"],@"hight":@(hightPrice), @"todayLow":@(lowPrice), @"rate":@((hightPrice-lowPrice)/(hightPrice + 0.000001f))};
            [arrayValueEveryDay addObject:dicTemp];
        }
    }
    NSArray *array2 = [arrayValueEveryDay sortedArrayUsingComparator:
                       ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                           // 先按照姓排序
                   NSComparisonResult result = [obj1[@"rate"] compare:obj2[@"rate"]];

                   return result;
                       }];
    return array2;
}


/**高量柱数据
 高量柱结果：降：289=====升:69=====上涨率：0.19=====涨幅：0.30=======跌幅：0.17
 100日高量柱结果：降：268=====升:25=====上涨率：0.09=====涨幅：0.13=======跌幅：0.37
 */
- (void)hightColumnRate {
    int days = 6;
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
            if (arraySingleDay.count > index + days) {
                if ([arraySingleDay[index + days][@"preclose"] integerValue] > [dicLow[@"preclose"] integerValue]) {
                  uprate += ([arraySingleDay[index + days][@"preclose"] integerValue] - [dicLow[@"preclose"] integerValue]) / [dicLow[@"preclose"] floatValue];
                    up ++ ;
                } else {
                  downRate += ([dicLow[@"preclose"] integerValue] - [arraySingleDay[index + days][@"preclose"] integerValue]) / [dicLow[@"preclose"] floatValue];
                    low ++ ;
                }
            }
        }
    }
    NSLog(@"高量柱结果：降：%d=====升:%d=====上涨率：%.2f=====涨幅：%.2f=======跌幅：%.2f", low, up, up/(up+low +0.000001f), uprate / (up + 0.000001), downRate/ (low+0.000000001));
}

/**低量柱数据
 低量柱结果：降：61=====升:298=====上涨率：0.83======涨幅:0.20 ===== 跌幅:0.04
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
            if (arraySingleDay.count > index - days) {
                if ([arraySingleDay[index - days][@"nowv"] integerValue] > [dicLow[@"nowv"] integerValue]) {
                  int data = [arraySingleDay[index - days][@"nowv"] integerValue] - [dicLow[@"nowv"] integerValue];
                    uprate += data / ([dicLow[@"nowv"] integerValue] + 0.000000000000001f);
                    up ++ ;
                    NSLog(@"time:%@======lowValue:%@ ===== ID%@ ======%.3f", arraySingleDay[index][@"times"], arraySingleDay[index][@"lowp"], dic[@"stockcode"], data / ([dicLow[@"nowv"] integerValue] + 0.000000000000001f));
                } else {
                    downRate += ([dicLow[@"nowv"] integerValue] - [arraySingleDay[index - days][@"nowv"] integerValue]) /  [dicLow[@"nowv"] floatValue];
                    low ++ ;
                }
            }
        }
    }
    NSLog(@"低量柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
}

/**倍量柱数据
 6日倍量柱结果：降：1429=====升:5159=====上涨率：0.78======涨幅:0.06 ===== 跌幅:0.04
 40日倍量柱结果：降：1194=====升:4706=====上涨率：0.80======涨幅:0.28 ===== 跌幅:0.13
 60倍量柱结果：降：828=====升:4782=====上涨率：0.85======涨幅:0.38 ===== 跌幅:0.11
 100倍量柱结果：降：303=====升:4631=====上涨率：0.94======涨幅:0.55 ===== 跌幅:0.09
 */
- (void)dowblecolumn {
    int days = 60;//时差天数
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
                    if (arraySingleStock.count > s  && s > days) {
                        if ([arraySingleStock[s - days][@"nowv"] integerValue] > [arraySingleStock[s][@"nowv"] integerValue]) {
                            int data = [arraySingleStock[s - days][@"nowv"] integerValue] - [arraySingleStock[s][@"nowv"] integerValue];
                            uprate += data / ([arraySingleStock[s][@"nowv"] integerValue] + 0.000000000000001f);
                            NSLog(@"time:%@======lowValue:%@ ===== ID%@ ======%.3f", arraySingleStock[s][@"times"], arraySingleStock[s][@"lowp"], dic[@"stockcode"], data / ([arraySingleStock[s][@"nowv"] integerValue] + 0.000000000000001f));
                            up ++ ;
                        } else {
                            downRate += ([arraySingleStock[s][@"nowv"] integerValue] - [arraySingleStock[s - days][@"nowv"] integerValue]) /  [arraySingleStock[s][@"nowv"] floatValue];
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
10日黄金量柱当天为基准价位结果：降：70=====升:444=====上涨率：0.86======涨幅:0.15 ===== 跌幅:0.05
10日后看黄金量柱确认后的结果：降：238=====升:276=====上涨率：0.54======涨幅:0.09 ===== 跌幅:0.06
100日黄金量柱结果：降：17=====升:139=====上涨率：0.89======涨幅:0.61 ===== 跌幅:0.11

 */
- (NSArray *)goldenColumn {
    int days = 20;//时差天数
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
                if (arraySingleStock.count > s + 4 && arraySingleStock.count > s+days && s > days) {//黄金柱后三天
                    if ([[arraySingleStock[s] objectForKey:@"curvol"] integerValue] > [[arraySingleStock[s -1] objectForKey:@"curvol"] integerValue] && [[arraySingleStock[s -1] objectForKey:@"curvol"] integerValue] > [[arraySingleStock[s -2] objectForKey:@"curvol"] integerValue] && [[arraySingleStock[s -2] objectForKey:@"curvol"] integerValue] > [[arraySingleStock[s -3] objectForKey:@"curvol"] integerValue]) {
                        if ([[arraySingleStock[s] objectForKey:@"preclose"] integerValue] < [[arraySingleStock[s -1] objectForKey:@"preclose"] integerValue] && [[arraySingleStock[s -1] objectForKey:@"preclose"] integerValue] <[[arraySingleStock[s -2] objectForKey:@"preclose"] integerValue] && [[arraySingleStock[s -2] objectForKey:@"preclose"] integerValue] < [[arraySingleStock[s -3] objectForKey:@"preclose"] integerValue]) {
                            
                            if (s < 6) {
                                [arrayGolden addObject:dic];
                            }
                            //这个是标准的黄金柱
                            //黄金柱确定后入手，也就是户那个进驻后第三天入手胜率不高
                            NSInteger goldenDay = [[arraySingleStock[s - 3] objectForKey:@"preclose"] integerValue];
                            NSInteger lastDay = [[arraySingleStock[s - days] objectForKey:@"preclose"] integerValue];
                            if (goldenDay > lastDay) {
                                low ++;
                                //下跌
                                float currentDayDown = (goldenDay - lastDay) / (goldenDay + 0.0000001f);
                                downRate += currentDayDown;
                                NSLog(@"下跌%@======%@====今日下跌幅度%.2f", arraySingleStock[s][@"times"], dic[@"stockcode"],currentDayDown);

                            } else {
                                up ++;
                                float currentUp = (lastDay - goldenDay)/(goldenDay + 0.0000000f);
                                NSLog(@"下跌%@======%@====今日上涨幅度%.2f", arraySingleStock[s][@"times"], dic[@"stockcode"],currentUp);
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
            if ([dicLow[@"curvol"] integerValue] == [[arraySingleDay[0] objectForKey:@"curvol"] integerValue] || [dicLow[@"curvol"] integerValue] == [[arraySingleDay[1] objectForKey:@"curvol"] integerValue]||[dicLow[@"curvol"] integerValue] == [[arraySingleDay[2] objectForKey:@"curvol"] integerValue]) {
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


/**假阴真阳
假阴真阳柱结果：降：1384=====升:1941=====上涨率：0.58======涨幅:0.07 ===== 跌幅:0.05
 */
- (void)falseDown {
    int days = 20;//时差天数
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            for (int s = 0 ; s<arraySingleStock.count ; s++) {
                if ([[arraySingleStock[s] objectForKey:@"preclose"] integerValue] < [[arraySingleStock[s] objectForKey:@"nowv"] integerValue] && [[arraySingleStock[s] objectForKey:@"openp"] integerValue] > [[arraySingleStock[s] objectForKey:@"nowv"] integerValue]) {
                    //假阴真阳
                    if (arraySingleStock.count > s+days && s >= days) {
                        if ([arraySingleStock[s - days][@"nowv"] integerValue] > [arraySingleStock[s][@"nowv"] integerValue]) {
                            NSLog(@"%@======%@", arraySingleStock[s][@"times"], dic[@"stockcode"]);
                            int data = [arraySingleStock[s - days][@"nowv"] integerValue] - [arraySingleStock[s][@"nowv"] integerValue];
                            uprate += data / ([arraySingleStock[s][@"nowv"] integerValue] + 0.000000000000001f);
                            up ++ ;
                        } else {
                            downRate += ([arraySingleStock[s][@"nowv"] integerValue] - [arraySingleStock[s - days][@"nowv"] integerValue]) /  [arraySingleStock[s][@"nowv"] floatValue];
                            low ++ ;
                        }
                    }
                }
            }
        }
    }
    NSLog(@"假阴真阳柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
}

/**假阳真阴
 假阳真阴柱结果：降：1706=====升:2535=====上涨率：0.60======涨幅:0.08 ===== 跌幅:0.05
 */
- (void)falseUp {
    int days = 5;//时差天数
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            for (int s = 0 ; s<arraySingleStock.count ; s++) {
                if ([[arraySingleStock[s] objectForKey:@"preclose"] integerValue] > [[arraySingleStock[s] objectForKey:@"nowv"] integerValue] && [[arraySingleStock[s] objectForKey:@"openp"] integerValue] < [[arraySingleStock[s] objectForKey:@"nowv"] integerValue]) {
                    //假阳真阴
                    if (arraySingleStock.count > s+days && s >= days) {
                        if ([arraySingleStock[s - days][@"nowv"] integerValue] > [arraySingleStock[s][@"nowv"] integerValue]) {
                            NSLog(@"%@======%@", arraySingleStock[s][@"times"], dic[@"stockcode"]);
                            int data = [arraySingleStock[s - days][@"nowv"] integerValue] - [arraySingleStock[s][@"nowv"] integerValue];
                            uprate += data / ([arraySingleStock[s][@"nowv"] integerValue] + 0.000000000000001f);
                            up ++ ;
                        } else {
                            downRate += ([arraySingleStock[s][@"nowv"] integerValue] - [arraySingleStock[s - days][@"nowv"] integerValue]) /  [arraySingleStock[s][@"nowv"] floatValue];
                            low ++ ;
                        }
                    }
                }
            }
        }
    }
    NSLog(@"假阳真阴柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
}

- (void)averageValue {
    
    NSMutableArray *arrayValueEveryDay = [NSMutableArray array];

    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            NSMutableArray *arraySingleStockNumber = [NSMutableArray array];
            for (int s = 0 ; s<arraySingleStock.count ; s++) {
                [arraySingleStockNumber addObject:@([[arraySingleStock[s] objectForKey:@"openp"] integerValue])];
                [arraySingleStockNumber addObject:@([[arraySingleStock[s] objectForKey:@"highp"] integerValue])];
                [arraySingleStockNumber addObject:@([[arraySingleStock[s] objectForKey:@"lowp"] integerValue])];
                [arraySingleStockNumber addObject:@([[arraySingleStock[s] objectForKey:@"nowv"] integerValue])];
            }
            
            [arrayValueEveryDay addObject:arraySingleStockNumber];
        }
    }
    NSLog(@"=========%@", arrayValueEveryDay);
}

@end
