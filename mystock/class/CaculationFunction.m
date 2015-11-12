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
#import "DBManager.h"

@implementation CaculationFunction
+ (void)load {
    
    [[CaculationFunction share] Trate];
//        [[CaculationFunction share] lowLiangRate];
//    [[CaculationFunction share] getPriceOrder];
//    [[CaculationFunction share] lowColumnRate];
//    [[CaculationFunction share] hightColumnRate];
//    NSLog(@"%@", [[CaculationFunction share] todayDouble]) ;
//    NSLog(@"%@", [[CaculationFunction share] lowStockes]) ;
//    [[CaculationFunction share] dowblecolumn];
//    [[CaculationFunction share] goldenColumn];
//    [[CaculationFunction share] falseDown];
//    [[CaculationFunction share] daysUpOfNow];//当前价格位置
//    [[CaculationFunction share] falseUp];
//    [[CaculationFunction share] averageValue];
//    NSLog(@"%@", [[CaculationFunction share] getDownMore]);
    
//    [[CaculationFunction share] getMoneyEnterAndPriceDepress];
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
    self.arraySourceData = [NSMutableArray arrayWithArray:[[DBManager share] fetchStockLocationWithKey:@"sourceData"]];
    self.arrayMoneyData = [NSMutableArray arrayWithArray:[commond getUserDefaults:@"moneyData"]];
    self.arrayDayPrice = [NSMutableArray arrayWithArray:[commond getUserDefaults:@"dayPrice"]];
    
    self.arrayBetween = [NSMutableArray array];//
    self.arrayDouble = [NSMutableArray array];
    self.arrayLow = [NSMutableArray array];
    
}

#pragma mark - 数据展示
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
            }
            NSDictionary *dicTemp = @{@"sorceData":dic,@"innercode":dic[@"innercode"], @"storck":dic[@"stockcode"],@"hight":@(hightPrice), @"todayLow":@(lowPrice), @"rate":@((hightPrice-lowPrice)/(hightPrice + 0.000001f))};
            [arrayValueEveryDay addObject:dicTemp];
        }
    }
    NSArray *array2 = [arrayValueEveryDay sortedArrayUsingComparator:
                       ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                   NSComparisonResult result = [obj2[@"rate"] compare:obj1[@"rate"]];

                   return result;
                       }];
    return array2;
}

/**涨幅排序*/
- (NSArray *)getUPMore {
    NSMutableArray *arrayValueEveryDay = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arrayOneStock = dic[@"timedata"];
        if (arrayOneStock.count > 0) {
            NSInteger lowPrice = [[arrayOneStock[0] objectForKey:@"lowp"] integerValue];
            NSInteger todayClosePrice = [[arrayOneStock[0] objectForKey:@"nowv"] integerValue] ;
            for (int s = 0 ; s<arrayOneStock.count ; s++) {
                NSInteger currentHightPrice = [[arrayOneStock[s] objectForKey:@"lowp"] integerValue];
                if (lowPrice > currentHightPrice) {
                    lowPrice = currentHightPrice;
                }
            }
            if (todayClosePrice > lowPrice) {
                NSDictionary *dicTemp = @{@"sorceData":dic,@"innercode":dic[@"innercode"], @"storck":dic[@"stockcode"],@"todayClosePrice":@(todayClosePrice), @"todayLow":@(lowPrice), @"rate":@((todayClosePrice-lowPrice)/(lowPrice + 0.000001f))};
                [arrayValueEveryDay addObject:dicTemp];
            }
        }
    }
    NSArray *array2 = [arrayValueEveryDay sortedArrayUsingComparator:
                       ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                           NSComparisonResult result = [obj2[@"rate"] compare:obj1[@"rate"]];
                           
                           return result;
                       }];
    return array2;
}

/**价格排序*/
- (NSArray *)getPriceOrder {
    NSArray *array2 = [self.arraySourceData sortedArrayUsingComparator:
                       ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                           NSString *open1 = [obj1[@"openp"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                           open1 = [open1 stringByReplacingOccurrencesOfString:@"+" withString:@""];
                           open1 = [open1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                           NSString *open2 = [obj2[@"openp"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                           open2 = [open2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
                           open2 = [open2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                           
                           NSNumber *number1 = [NSNumber numberWithInteger:[open1 integerValue]];
                           NSNumber *number2 = [NSNumber numberWithInteger:[open2 integerValue]];
                           NSLog(@"%@=======%@",open1,open2);
                           NSComparisonResult result = [number1 compare:number2];
                           return result;
                       }];
    return array2;
}

/**三日内今天低量柱
 */
- (NSArray *)lowStockes {
    NSInteger days = 20;//比较多少天以内的数据，一般20日内就是一个月的最低点
    NSMutableArray *arrayLow = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        arraySingleDay = [self subobjectsAtArray:arraySingleDay from:days];
        if (arraySingleDay.count > 0) {
            NSDictionary *dicLow ;
            for (NSDictionary *dicDay in arraySingleDay) {
                if (dicLow == nil) {
                    dicLow = dicDay;
                }
                if (dicLow != nil && [dicDay[@"curvol"] integerValue] <= [dicLow[@"curvol"] integerValue] && [[dicDay objectForKey:@"lowp"] integerValue] != [[dicDay objectForKey:@"highp"] integerValue]) {
                    dicLow = dicDay;
                }
            }
            if (([dicLow[@"curvol"] integerValue] == [[arraySingleDay[0] objectForKey:@"curvol"] integerValue] || [dicLow[@"curvol"] integerValue] == [[arraySingleDay[1] objectForKey:@"curvol"] integerValue] || [dicLow[@"curvol"] integerValue] == [[arraySingleDay[2] objectForKey:@"curvol"] integerValue]) && [[dicLow objectForKey:@"lowp"] integerValue] != [[dicLow objectForKey:@"highp"] integerValue]) {
                [arrayLow addObject:dic];
            }
        }
    }
    return arrayLow;
}

/**三日内一字板
 */
- (NSArray *)stopStock {
    NSMutableArray *arrayLow = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        if (arraySingleDay.count > 0) {
            NSDictionary *dicLow = arraySingleDay[0];
            
            BOOL today = NO;
            BOOL yesterday = NO;
            BOOL lastday = NO;
            if ([[arraySingleDay[0] objectForKey:@"highp"] integerValue] == [[arraySingleDay[0] objectForKey:@"lowp"] integerValue] && [[arraySingleDay[0] objectForKey:@"lowp"] integerValue] == [[arraySingleDay[0] objectForKey:@"nowv"] integerValue] && [[arraySingleDay[0] objectForKey:@"nowv"] integerValue] == [[arraySingleDay[0] objectForKey:@"openp"] integerValue]) {
                today = YES;
            }
            if ([[arraySingleDay[1] objectForKey:@"highp"] integerValue] == [[arraySingleDay[1] objectForKey:@"lowp"] integerValue] && [[arraySingleDay[1] objectForKey:@"lowp"] integerValue] == [[arraySingleDay[1] objectForKey:@"nowv"] integerValue] && [[arraySingleDay[1] objectForKey:@"nowv"] integerValue] == [[arraySingleDay[1] objectForKey:@"openp"] integerValue]) {
                yesterday = YES;
            }
            if ([[arraySingleDay[2] objectForKey:@"highp"] integerValue] == [[arraySingleDay[2] objectForKey:@"lowp"] integerValue] && [[arraySingleDay[2] objectForKey:@"lowp"] integerValue] == [[arraySingleDay[2] objectForKey:@"nowv"] integerValue] && [[arraySingleDay[2] objectForKey:@"nowv"] integerValue] == [[arraySingleDay[2] objectForKey:@"openp"] integerValue]) {
                lastday = YES;
            }
            if (today == YES || lastday == YES || yesterday == YES) {
                [arrayLow addObject:dic];
            }
        }
    }
    return arrayLow;
}

/**今日倍量柱*/
- (NSArray *)todayDouble {
    NSMutableArray *arrayDouble = [NSMutableArray array];
    for (NSDictionary *dicTemp in self.arraySourceData){
        NSArray *arrayDataList = dicTemp[@"timedata"];
        
        if (arrayDataList.count > 0 && [[arrayDataList[0] objectForKey:@"curvol"] floatValue] > 2.0f * [[arrayDataList[1] objectForKey:@"curvol"] floatValue] && [[arrayDataList[1] objectForKey:@"lowp"] integerValue] != [[arrayDataList[1] objectForKey:@"highp"] integerValue]) {
            [arrayDouble addObject:dicTemp];
        }
    }
    return arrayDouble;
}

/**找精准点*/
- (NSArray *)averageValue:(NSString *)code {
    NSMutableArray *arrayValueEveryDay = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        if ([dic[@"stockcode"] integerValue]== [code integerValue]) {
            NSArray *arraySingleStock = dic[@"timedata"];
            if (arraySingleStock.count > 0) {
                for (int s = 0 ; s<arraySingleStock.count ; s++) {
                    [arrayValueEveryDay addObject:@([[arraySingleStock[s] objectForKey:@"openp"] integerValue])];
                    [arrayValueEveryDay addObject:@([[arraySingleStock[s] objectForKey:@"highp"] integerValue])];
                    [arrayValueEveryDay addObject:@([[arraySingleStock[s] objectForKey:@"lowp"] integerValue])];
                    [arrayValueEveryDay addObject:@([[arraySingleStock[s] objectForKey:@"nowv"] integerValue])];
                }
            }
        }
    }
    NSArray *arrayTemp = [arrayValueEveryDay sortedArrayUsingSelector:@selector(compare:)];
    return arrayTemp;
}


/**数天数,最高价大于当天最高价除以数据总天数(比如60)，60天中价格大于今天的天数比例*/
- (NSArray *)daysUpOfNow{
    NSMutableArray *arrayValueEveryDay = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.arraySourceData[i]];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            int number = 0;
            for (int s = 1 ; s<arraySingleStock.count ; s++) {
                NSDictionary *dicToday = arraySingleStock[0];
                if ([dicToday[@"highp"] floatValue] < [arraySingleStock[s][@"highp"] floatValue]) {
                    number ++;
                }
            }
            CGFloat rate = (number + 0.00000001)/(arraySingleStock.count+0.0001) * 100;
            NSString *numberRate = [NSString stringWithFormat:@"%.5f",rate];
            [dic setObject:numberRate forKey:@"updayrate"];
            
            [arrayValueEveryDay addObject:dic];
        }
    }
    NSArray *arraySorted = [arrayValueEveryDay sortedArrayUsingComparator:
                            ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                                NSComparisonResult result = [obj2[@"updayrate"] compare:obj1[@"updayrate"]];
                                return result;
                            }];
    NSLog(@"数天数：===%@",arraySorted[0]);
    return arraySorted;
}

/**缩倍柱+30日地量柱+倍量柱
 表示有主力故意在玩弄，避开系统风险，很容易就是牛股了
 下面数据虽然才65%,但是这类股分启动上升时期和启动下跌时期
 低量柱结果：降：267=====升:494=====上涨率：0.65======涨幅:131.22 ===== 跌幅:76.72
 */
- (NSArray *)doubleLowDouble {
    int days = 10;//时差天数
    NSInteger area = 20;//左右各一半，取样区间
    int low = 0;//下降
    int up = 0;//上涨
    int distancetoday = 10;//收集最近n天的这种组合股
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    NSMutableArray *arrayResult = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        if (arraySingleDay.count > 0) {
            for (int index = 0; index < arraySingleDay.count; index ++ ) {
                if (arraySingleDay.count > index + area && index >= area && index > days){
                    int count = 0;
                    for (int number = 0; number < area; number ++) {
                        if ([arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index + number + 1][@"curvol"] integerValue] ) {
                            count ++;
                        } else {
                            break;
                        }
                        if (index < distancetoday && count == area && 2 * [arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index - 1][@"curvol"] integerValue] && [arraySingleDay[index][@"openp"] integerValue] != [arraySingleDay[index][@"nowv"] integerValue] && 2* [arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index + 1][@"curvol"] integerValue]) {
                            if ([arraySingleDay[index - days][@"nowv"] integerValue] > [arraySingleDay[index][@"nowv"] integerValue]) {
                                up ++;
                                uprate += [arraySingleDay[index - days][@"nowv"] integerValue] - [arraySingleDay[index][@"nowv"] integerValue];
                                NSInteger data = [arraySingleDay[index - days][@"nowv"] integerValue] - [arraySingleDay[index][@"nowv"] integerValue];
                                NSLog(@"time:%@======lowValue:%@ ===== ID%@ =====上涨%.3f", arraySingleDay[index][@"times"], arraySingleDay[index][@"lowp"], dic[@"stockcode"], data / ([arraySingleDay[index][@"nowv"] integerValue] + 0.000000000000001f));

                                [arrayResult addObject:dic];
                            } else {
                                low ++;
                                downRate += [arraySingleDay[index][@"nowv"] integerValue] - [arraySingleDay[index - days][@"nowv"] integerValue];
                                
                                NSInteger data = [arraySingleDay[index - days][@"nowv"] integerValue] - [arraySingleDay[index][@"nowv"] integerValue];
                                NSLog(@"time:%@======lowValue:%@ ===== ID%@ =====下跌%.3f", arraySingleDay[index][@"times"], arraySingleDay[index][@"lowp"], dic[@"stockcode"], data / ([arraySingleDay[index][@"nowv"] integerValue] + 0.000000000000001f));
                            }
                        }
                    }
                }
            }
        }
    }
    NSLog(@"低量柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));

    return arrayResult;
}

/**
 
 ST类型
 
 */
- (NSArray *)STStock {

    NSMutableArray *arrayResult = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        if (arraySingleDay.count > 0 && [dic[@"stockname"] containsString:@"ST"]) {
            [arrayResult addObject:dic];
        }
    }
    return arrayResult;
}

#pragma mark - 数据概率计算

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
    int days = 10;//时差天数
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
                if ([arraySingleDay[index - days][@"nowv"] integerValue] >= [dicLow[@"nowv"] integerValue]) {
                  int data = [arraySingleDay[index - days][@"nowv"] integerValue] - [dicLow[@"nowv"] integerValue];
                    if ([dicLow[@"openp"] integerValue] != [dicLow[@"nowv"] integerValue] ) {
                        uprate += data / ([dicLow[@"nowv"] integerValue] + 0.000000000000001f);
                        up ++ ;
                        NSLog(@"time:%@======lowValue:%@ ===== ID%@ ======%.3f", arraySingleDay[index][@"times"], arraySingleDay[index][@"lowp"], dic[@"stockcode"], data / ([dicLow[@"nowv"] integerValue] + 0.000000000000001f));
                    }
                } else {
                    int data = [dicLow[@"nowv"] integerValue] - [arraySingleDay[index - days][@"nowv"] integerValue];
                    if ([dicLow[@"openp"] integerValue] != [dicLow[@"nowv"] integerValue] ) {
                        downRate += data / [dicLow[@"nowv"] floatValue];
                        low ++ ;
                        NSLog(@"time:%@======lowValue:%@ ===== ID%@ ======下降%.3f", arraySingleDay[index][@"times"], arraySingleDay[index][@"lowp"], dic[@"stockcode"], data / ([dicLow[@"nowv"] integerValue] + 0.000000000000001f));
                    }
                }
            }
        }
    }
    NSLog(@"低量柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
}

/**缩倍+低量柱+倍量数据
 低量柱+倍量柱结果：降：1133=====升:2015=====上涨率：0.64======涨幅:120.28 ===== 跌幅:66.79
 缩倍+低量柱结果：降：1261=====升:2314=====上涨率：0.65======涨幅:105.95 ===== 跌幅:68.28
 30日地量柱结果：降：8653=====升:13745=====上涨率：0.61======涨幅:96.90 ===== 跌幅:95.89
 缩倍+低量柱+倍量结果：降：267=====升:494=====上涨率：0.65======涨幅:131.22 ===== 跌幅:76.72
 */
- (void)lowLiangRate {
    int days = 10;//时差天数
    NSInteger area = 30;//左右各一半，取样区间
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        if (arraySingleDay.count > 0) {
            for (int index = 0; index < arraySingleDay.count; index ++ ) {
                if (arraySingleDay.count > index + area && index >= area && index > days){
                    int count = 0;
                    for (int number = 0; number < area; number ++) {
                        if ([arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index + number + 1][@"curvol"] integerValue] ) {
                            count ++;
                        } else {
                            break;
                        }
                        if (count == area && 2 * [arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index - 1][@"curvol"] integerValue] && [arraySingleDay[index][@"openp"] integerValue] != [arraySingleDay[index][@"nowv"] integerValue] && 2* [arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index + 1][@"curvol"] integerValue]) {
                            if ([arraySingleDay[index - days][@"nowv"] integerValue] > [arraySingleDay[index][@"nowv"] integerValue]) {
                                up ++;
                                uprate += [arraySingleDay[index - days][@"nowv"] integerValue] - [arraySingleDay[index][@"nowv"] integerValue];
                                NSInteger data = [arraySingleDay[index - days][@"nowv"] integerValue] - [arraySingleDay[index][@"nowv"] integerValue];
                                if (YES == [self isDoubleLowDoubleWithDic:dic]) {
                                    NSLog(@"time:%@======lowValue:%@ ===== ID%@ =====上涨%.3f", arraySingleDay[index][@"times"], arraySingleDay[index][@"lowp"], dic[@"stockcode"], data / ([arraySingleDay[index][@"nowv"] integerValue] + 0.000000000000001f));

                                }
                            } else {
                                low ++;
                                downRate += [arraySingleDay[index][@"nowv"] integerValue] - [arraySingleDay[index - days][@"nowv"] integerValue];
                                
                                NSInteger data = [arraySingleDay[index - days][@"nowv"] integerValue] - [arraySingleDay[index][@"nowv"] integerValue];
                                NSLog(@"time:%@======lowValue:%@ ===== ID%@ =====下跌%.3f", arraySingleDay[index][@"times"], arraySingleDay[index][@"lowp"], dic[@"stockcode"], data / ([arraySingleDay[index][@"nowv"] integerValue] + 0.000000000000001f));
                            }
                        }
                    }
                }
            }
        }
    }
    NSLog(@"低量柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
}

/**倍量柱数据
取600个交易日的数据，也就是三年多的数据做基本数据分析结果如下：
倍量柱60天之后涨幅结果：降：1422=====升:2266=====上涨率：0.61======涨幅:0.30 ===== 跌幅:0.17
倍量柱3天之后涨幅结果： 降：1424=====升:3033=====上涨率：0.68======涨幅:0.10 ===== 跌幅:0.06
倍量柱5天之后涨幅结果：降：1495=====升:2954=====上涨率：0.66======涨幅:0.12 ===== 跌幅:0.08
倍量柱10天之后涨幅结果：降：11402=====升:23401=====上涨率：0.67======涨幅:0.10 ===== 跌幅:0.06
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

                if (2*[[arraySingleStock[s] objectForKey:@"curvol"] integerValue] <= [[arraySingleStock[s -1] objectForKey:@"curvol"] integerValue] &&  [[arraySingleStock[s] objectForKey:@"highp"] integerValue] != [[arraySingleStock[s] objectForKey:@"lowp"] integerValue]) {
                    //就是倍量柱了
                    if (arraySingleStock.count > s  && s > days) {
                        if ([arraySingleStock[s - days][@"nowv"] integerValue] > [arraySingleStock[s][@"nowv"] integerValue]) {
                            int data = [arraySingleStock[s - days][@"nowv"] integerValue] - [arraySingleStock[s][@"nowv"] integerValue];
                            uprate += data / ([arraySingleStock[s][@"nowv"] integerValue] + 0.000000000000001f);
                            NSLog(@"time:%@======lowValue:%@ ===== ID%@ ======%.3f", arraySingleStock[s][@"times"], arraySingleStock[s][@"lowp"], dic[@"stockcode"], data / ([arraySingleStock[s][@"nowv"] integerValue] + 0.000000000000001f));
                            up ++ ;
                        } else {
                            downRate += ([arraySingleStock[s][@"nowv"] integerValue] - [arraySingleStock[s - days][@"nowv"] integerValue]) /  [arraySingleStock[s][@"nowv"] floatValue];
                            int data = [arraySingleStock[s - days][@"nowv"] integerValue] - [arraySingleStock[s][@"nowv"] integerValue];

                            NSLog(@"time:%@======lowValue:%@ ===== ID%@ ======%.3f", arraySingleStock[s][@"times"], arraySingleStock[s][@"lowp"], dic[@"stockcode"], data / ([arraySingleStock[s][@"nowv"] integerValue] + 0.000000000000001f));

                            low ++ ;
                        }
                    }
                }
            }
        }
    }
    NSLog(@"倍量柱结果：降：%d=====升:%d=====上涨率：%.2f======涨幅:%.2f ===== 跌幅:%.2f", low, up, up/(up+low +0.000001f), uprate/(up + 0.0000000001f), downRate / (low + 0.00000001));
}
/**缩倍量柱数据
 取600个交易日的数据，也就是三年多的数据做基本数据分析结果如下：
 倍量柱60天之后涨幅结果：降：1422=====升:2266=====上涨率：0.61======涨幅:0.30 ===== 跌幅:0.17
 倍量柱3天之后涨幅结果： 降：1424=====升:3033=====上涨率：0.68======涨幅:0.10 ===== 跌幅:0.06
 倍量柱5天之后涨幅结果：降：1495=====升:2954=====上涨率：0.66======涨幅:0.12 ===== 跌幅:0.08
 倍量柱10天之后涨幅结果降：1625=====升:2798=====上涨率：0.63======涨幅:0.16 ===== 跌幅:0.09
 */
- (void)dowbleLowcolumn {
    int days = 10;//时差天数
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            for (int s = 1 ; s<arraySingleStock.count - 1 ; s++) {
                if (2*[[arraySingleStock[s] objectForKey:@"curvol"] integerValue] < [[arraySingleStock[s + 1] objectForKey:@"curvol"] integerValue]) {
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

/**T字板
一字板之后最高点高于前一天收盘价比例为90%

 */
- (void)stopWorld {
    int days = 5;//板的个数
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            for (int s = 2 ; s<arraySingleStock.count - 3 ; s++) {
                if ([[arraySingleStock[s] objectForKey:@"highp"] integerValue] == [[arraySingleStock[s] objectForKey:@"lowp"] integerValue] && [[arraySingleStock[s +1] objectForKey:@"highp"] integerValue] == [[arraySingleStock[s +1] objectForKey:@"lowp"] integerValue] && [[arraySingleStock[s +2] objectForKey:@"highp"] integerValue] == [[arraySingleStock[s +2] objectForKey:@"lowp"] integerValue] && [[arraySingleStock[s +3] objectForKey:@"highp"] integerValue] == [[arraySingleStock[s +3] objectForKey:@"lowp"] integerValue]) {
                    if ([[arraySingleStock[s -1] objectForKey:@"highp"] integerValue] == [[arraySingleStock[s -1] objectForKey:@"lowp"] integerValue]) {
                        
                    } else {
                        if ([[arraySingleStock[s -2] objectForKey:@"preclose"] integerValue] < [[arraySingleStock[s -2] objectForKey:@"highp"] integerValue]) {
                            up++;
                        } else {
                            low ++;
                        }
                    }
                }
            }
        }
    }
    NSLog(@"一字板之后上涨：%d下跌:%d;上涨率:%.2f", up ,low,up/(low + up +0.000001));
}

/**T字板

 
 */
- (void)Trate {
    int days = 5;//板的个数
    int low = 0;//下降
    int up = 0;//上涨
    CGFloat uprate = 0.0f;
    CGFloat downRate = 0.0f;
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        if (arraySingleStock.count > 0) {
            for (int s = 2 ; s<arraySingleStock.count - 3 ; s++) {
                if ([[arraySingleStock[s + 1] objectForKey:@"highp"] integerValue] == [[arraySingleStock[s + 1] objectForKey:@"lowp"] integerValue] && [[arraySingleStock[s] objectForKey:@"highp"] integerValue] == [[arraySingleStock[s] objectForKey:@"openp"] integerValue] && [[arraySingleStock[s] objectForKey:@"openp"] integerValue] == [[arraySingleStock[s] objectForKey:@"nowv"] integerValue] && [[arraySingleStock[s] objectForKey:@"highp"] integerValue] > [[arraySingleStock[s] objectForKey:@"lowp"] integerValue]) {

                    if ([[arraySingleStock[s -1] objectForKey:@"preclose"] integerValue] < [[arraySingleStock[s -1] objectForKey:@"highp"] integerValue]) {
                        up++;
                        
                    } else {
                        low ++;
                        NSLog(@"%@:%@",dic[@"stockcode"], arraySingleStock[s-1][@"times"]);
                    }
                }
            }
        }
    }
    NSLog(@"T字板之后上涨：%d下跌:%d;上涨率:%.2f", up ,low,up/(low + up +0.000001));
}

/**精准线*/
- (NSArray *)jingzhunxian {
    NSMutableArray *arrayValueEveryDay = [NSMutableArray array];
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSMutableDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleStock = dic[@"timedata"];
        NSArray *arrayValue = [self averageValue:[NSString stringWithFormat:@"%@", dic[@"stockcode"]]];
        if (arraySingleStock.count > 0) {
            
            int open = [[arraySingleStock[0] objectForKey:@"openp"] integerValue];
            int highp = [[arraySingleStock[0] objectForKey:@"highp"] integerValue];
            int lowp = [[arraySingleStock[0] objectForKey:@"lowp"] integerValue];
            int nowv = [[arraySingleStock[0] objectForKey:@"nowv"] integerValue];
            
            int o = 0;
            int h = 0;
            int l = 0;
            int n = 0;
            
            for (int s = 0 ; s<arrayValue.count ; s++) {
                if (open == [arrayValue[s] integerValue]) {
                    o ++;
                }
                if (highp == [arrayValue[s] integerValue]) {
                    h ++;
                }
                if (lowp == [arrayValue[s] integerValue]) {
                    l ++;
                }
                if (nowv == [arrayValue[s] integerValue]) {
                    n ++;
                }
            }
            if (o >= 3 || h >= 3 || l>=3 || n >= 3) {
                NSString *valueDetail = [NSString stringWithFormat:@"最低：%d个 最高：%d个 开盘：%d个 收盘：%d个",l,h,o,n];
                [dic setObject:valueDetail forKey:@"detail"];
                [dic setObject:@(o) forKey:@"o"];
                [dic setObject:@(h) forKey:@"h"];
                [dic setObject:@(l) forKey:@"l"];
                [dic setObject:@(n) forKey:@"n"];
                [arrayValueEveryDay addObject:dic];
            }
        }
    }
    NSArray *arrayValueEveryDayOrder = [arrayValueEveryDay sortedArrayUsingComparator:
                       ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                           NSInteger obj1number = [obj1[@"o"] integerValue] + [obj1[@"h"] integerValue] +[obj1[@"l"] integerValue] +[obj1[@"n"] integerValue];
                           
                           NSInteger obj2number = [obj2[@"o"] integerValue] + [obj2[@"h"] integerValue] +[obj2[@"l"] integerValue] +[obj2[@"n"] integerValue];
                           
                           NSComparisonResult result = [@(obj2number) compare:@(obj1number)];
                           
                           return result;
                       }];
    
    return arrayValueEveryDayOrder;
}

/**主交易量大于散*/
- (NSArray *)getMoneyListOrderByNumber {
    NSMutableArray *arrayResult = [NSMutableArray array];
    for (NSArray *arrayTemp in self.arrayMoneyData) {
        if (arrayTemp.count == 18 && [arrayTemp[1] floatValue] + [arrayTemp[2] floatValue] > [arrayTemp[5] floatValue] + [arrayTemp[6] floatValue]) {
            [arrayResult addObject:arrayTemp];
        }
    }
    NSArray *arraySorted = [arrayResult sortedArrayUsingComparator:
                       ^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
                           CGFloat rate1 = ([obj1[1] floatValue] + [obj1[2] floatValue])/([obj1[1] floatValue] + [obj1[2] floatValue] + [obj1[5] floatValue] + [obj1[6] floatValue]);
                           CGFloat rate2 = ([obj2[1] floatValue] + [obj2[2] floatValue])/([obj2[1] floatValue] + [obj2[2] floatValue] + [obj2[5] floatValue] + [obj2[6] floatValue]);
                           NSComparisonResult result = [@(rate2) compare:@(rate1)];
                           return result;
                       }];
    return arraySorted;
}

/**主在入，价在跌*/
- (NSArray *)getMoneyEnterAndPriceDepress {
    NSMutableArray *arrayResult = [NSMutableArray array];
    for (NSMutableArray *arrayTemp in self.arrayDayPrice) {
        if (arrayTemp.count == 23) {
            NSArray *arrayTodayPrice = [arrayTemp objectAtIndex:4];
            NSArray *arrayYesterdayPrice = [arrayTemp objectAtIndex:3];
            if ([arrayTodayPrice[2] floatValue] < [arrayYesterdayPrice[2] floatValue]) {//价在跌
                if ([arrayTodayPrice[5] floatValue] > 2*[arrayYesterdayPrice[5] floatValue]) {//多倍量
                    if ([arrayTemp[6] floatValue] > [arrayTemp[7] floatValue]) {//庄在入
                        [arrayTemp removeObjectsInRange:NSMakeRange(0, 5)];
                        [arrayResult addObject:arrayTemp];
                    }
                }
            }
        }
    }
    NSArray *arraySorted = [arrayResult sortedArrayUsingComparator:
                            ^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
                                CGFloat rate1 = ([obj1[6] floatValue] + [obj1[7] floatValue])/([obj1[6] floatValue] + [obj1[7] floatValue] + [obj1[10] floatValue] + [obj1[11] floatValue]);
                                CGFloat rate2 = ([obj2[6] floatValue] + [obj2[7] floatValue])/([obj2[6] floatValue] + [obj2[7] floatValue] + [obj2[10] floatValue] + [obj2[11] floatValue]);
                                NSComparisonResult result = [@(rate2) compare:@(rate1)];
                                return result;
                            }];
    NSLog(@"%@",arraySorted);
    return arraySorted;
}

/**是否符合缩倍 + 30日低 + 倍量
结果：降：267=====升:494=====上涨率：0.65======涨幅:131.22 ===== 跌幅:76.72
 经过验证，发现涨跌幅超过20%的此类股，要么是准备启动，上冲，要么就是准备加速下跌。而大的趋势，macd线直接可以看出来，并且上涨的幅度平均是下跌的两倍，并且下跌一般就是4个点以内。
 */
- (BOOL)isDoubleLowDoubleWithDic:(NSDictionary *) dic {
    int days = 10;//时差天数
    NSInteger area = 20;//左右各一半，取样区间
    int distancetoday = 10;//收集最近n天的这种组合股
        NSArray *arraySingleDay = dic[@"timedata"];
        if (arraySingleDay.count > 0) {
            for (int index = 0; index < arraySingleDay.count; index ++ ) {
                if (arraySingleDay.count > index + area && index >= area && index > days){
                    int count = 0;
                    for (int number = 0; number < area; number ++) {
                        if ([arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index + number + 1][@"curvol"] integerValue] ) {
                            count ++;
                        } else {
                            break;
                        }
                        if (index < distancetoday && count == area && 2 * [arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index - 1][@"curvol"] integerValue] && [arraySingleDay[index][@"openp"] integerValue] != [arraySingleDay[index][@"nowv"] integerValue] && 2* [arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index + 1][@"curvol"] integerValue]) {
                            return YES;
                        }
                    }
                }
            }
        }
    return NO;
}

/**最近5天是否有倍量柱*/
- (BOOL)isDoubleThesDayWithDic:(NSDictionary *) dic {
    NSArray *arrayDataList = dic[@"timedata"];
    for (int index = 0; index < 5; index ++) {
        if (arrayDataList.count > 0 && [[arrayDataList[index] objectForKey:@"curvol"] floatValue] > 2.0f * [[arrayDataList[index + 1] objectForKey:@"curvol"] floatValue]) {
            return YES;
        }
    }
    return NO;
}

/**是否是30日地量柱*/
- (BOOL)isLow30DayWithDic:(NSDictionary *) dic {
    int days = 10;//时差天数
    NSInteger area = 30;//取样周期
    int distancetoday = 5;//收集最近n天的30日地量柱
    NSArray *arraySingleDay = dic[@"timedata"];
    if (arraySingleDay.count > 0) {
        for (int index = 0; index < arraySingleDay.count; index ++ ) {
            if (arraySingleDay.count > index + area && index >= area && index > days){
                int count = 0;
                for (int number = 0; number < area; number ++) {
                    if ([arraySingleDay[index][@"curvol"] integerValue] <  [arraySingleDay[index + number + 1][@"curvol"] integerValue] ) {
                        count ++;
                    } else {
                        break;
                    }
                    if (index < distancetoday && count == area && [arraySingleDay[index][@"openp"] integerValue] != [arraySingleDay[index][@"nowv"] integerValue]) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

/***/


- (NSArray *)subobjectsAtArray:(NSArray *) array from:(NSInteger ) index {
    NSMutableArray *arrayResult = [NSMutableArray array];
    if (array.count <= index) {
        return array;
    }
    for (int i = 0; i < index; i ++ ) {
        [arrayResult addObject:[array objectAtIndex:i]];
    }
    return arrayResult;
}

@end
