//
//  colorModel.m
//  Kline
//
//  Created by zhaomingxi on 14-2-9.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//
/**
 上证所股票市值排名（前十）
 名次	股票代码	股票简称	市价总值
 　　(万元)	所占总市值的比例
 　　(%)
 1	601857	中国石油	205479116.75	6.38
 2	601398	工商银行	143433697.07	4.45
 3	601288	农业银行	115269675.21	3.58
 4	601988	中国银行	98638260.95	3.06
 5	601628	中国人寿	85209884.76	2.64
 6	600028	中国石化	65170399.85	2.02
 7	601318	中国平安	46694200.32	1.45
 8	601166	兴业银行	39419284.74	1.22
 9	600036	招商银行	35543671.25	1.10
 10	601088	中国神华	35142401.88	1.09
 
 所占总市值的比例总计：26.99%
 
 
 深交所股票市值排名（前十）
 序号	证券代码	证券简称	总股本	总市值	流通股本	流通市值
 1	000166	申万宏源	14,856,744,977	284,952,368,658.86	3,254,680,459	62,424,771,203.62
 2	002736	国信证券	8,200,000,000	244,606,000,000.00	1,200,000,000	35,796,000,000.00
 3	000001	平安银行	13,709,873,744	223,470,942,027.20	11,797,403,365	192,297,674,849.50
 4	000776	广发证券	5,919,291,464	176,513,271,456.48	5,919,291,464	176,513,271,456.48
 5	000725	京东方A	33,950,977,574	166,359,790,112.60	11,505,664,365	56,377,755,388.50
 6	000333	美的集团	4,215,808,472	140,006,999,355.12	2,244,558,472	74,541,786,855.12
 7	000002	万 科A	9,731,152,613	137,403,874,895.56	9,712,476,010	137,140,161,261.20
 8	000651	格力电器	3,007,865,439	132,285,922,007.22	2,985,887,255	131,319,321,474.90
 9	002415	海康威视	4,069,128,026	126,142,968,806.00	3,150,471,106	97,664,604,286.00
 10	002304	洋河股份	1,076,420,000	96,759,393,800.00	877,319,434	78,862,243,922.26
 数据截止2015年4月14日[14]
 */
#import "colorModel.h"


@implementation colorModel : NSObject

+ (void)load
{
    
    NSString *string = StockCode;
    NSArray *arrayCode = [string componentsSeparatedByString:@"("];
    NSMutableArray *arrayStock = [NSMutableArray array];
    NSMutableArray *arrayStockHuA = [NSMutableArray array];
    NSMutableArray *arrayStockSHA = [NSMutableArray array];
    for (NSString *code in arrayCode) {
        NSString *stringStockCode = [code substringToIndex:6];
        [arrayStock addObject:stringStockCode];
        
        if ([stringStockCode rangeOfString:@"600"].length >0) {
            [arrayStockHuA addObject:stringStockCode];
        }
        
        if ([stringStockCode rangeOfString:@"00"].location == 0) {
            [arrayStockSHA addObject:stringStockCode];
        }
    }
}

+ (NSMutableArray *)getSA {
    NSString *string = StockCode;
    NSArray *arrayCode = [string componentsSeparatedByString:@"("];
    NSMutableArray *arrayStock = [NSMutableArray array];
    NSMutableArray *arrayStockHuA = [NSMutableArray array];
    NSMutableArray *arrayStockSHA = [NSMutableArray array];
    for (NSString *code in arrayCode) {
        NSString *stringStockCode = [code substringToIndex:6];
        [arrayStock addObject:stringStockCode];
        
        if ([stringStockCode rangeOfString:@"600"].length >0) {
            [arrayStockHuA addObject:stringStockCode];
        }
        
        if ([stringStockCode rangeOfString:@"00"].location == 0) {
            [arrayStockSHA addObject:stringStockCode];
        }
    }
    return arrayStockSHA;
}

+ (NSMutableArray *)getHA {
    NSString *string = StockCode;
    NSArray *arrayCode = [string componentsSeparatedByString:@"("];
    NSMutableArray *arrayStock = [NSMutableArray array];
    NSMutableArray *arrayStockHuA = [NSMutableArray array];
    NSMutableArray *arrayStockSHA = [NSMutableArray array];
    for (NSString *code in arrayCode) {
        NSString *stringStockCode = [code substringToIndex:6];
        [arrayStock addObject:stringStockCode];
        
        if ([stringStockCode rangeOfString:@"600"].length >0) {//600开头的是沪a
            [arrayStockHuA addObject:stringStockCode];
        }
        
        if ([stringStockCode rangeOfString:@"00"].location == 0) {
            [arrayStockSHA addObject:stringStockCode];
        }
    }
    return arrayStockHuA;
}

+ (NSArray *)getStockCodeInfo {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"localstocktjz2" withExtension:@"plist"]];
    NSMutableArray *arrayStock = [NSMutableArray array];
    for (NSString *stringStockKey in [dic allKeys]) {
        NSArray *array = [NSArray arrayWithObject:[dic objectForKey:stringStockKey]];
        NSLog(@"%d", [[array objectAtIndex:0] count]);
        if ([[array objectAtIndex:0] count] == 4) {
            NSDictionary *dic = @{@"innercode":array[0][0],@"stockcode":array[0][1],@"stockname":array[0][2]};
            [arrayStock addObject:dic];
        }

    }
    
//    innercode = 473;
//    market = 2;
//    nowprice = "12.97";
//    stockcode = 000960;
//    stockname = "\U9521\U4e1a\U80a1\U4efd";
//    totalvalue = "149.31\U4ebf";
//    updown = "0.00";
//    updownrate = "0.00";
    return arrayStock;
}

/**仅仅沪A*/
+ (NSArray *)getStockCodeInfo600 {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"local600" withExtension:@"plist"]];
    NSMutableArray *arrayStock = [NSMutableArray array];
    for (NSString *stringStockKey in [dic allKeys]) {
        NSArray *array = [NSArray arrayWithObject:[dic objectForKey:stringStockKey]];
        NSLog(@"%d", [[array objectAtIndex:0] count]);
        if ([[array objectAtIndex:0] count] == 4) {
            NSDictionary *dic = @{@"innercode":array[0][0],@"stockcode":array[0][1],@"stockname":array[0][2]};
            [arrayStock addObject:dic];
        }
    }
    return arrayStock;
}



@end
