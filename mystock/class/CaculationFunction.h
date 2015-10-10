//
//  CaculationFunction.h
//  mystock
//
//  Created by liujianzhong on 15/7/30.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaculationFunction : NSObject

@property (nonatomic, strong) NSMutableArray *arraySourceData;//元数据
@property (nonatomic, strong) NSMutableArray *arrayDouble;//倍
@property (nonatomic, strong) NSMutableArray *arrayLow;//地量
@property (nonatomic, strong) NSMutableArray *arrayBetween;//价差
@property (nonatomic, strong) NSMutableArray *arrayMoneyData;//散装对比
@property (nonatomic, strong) NSMutableArray *arrayDayPrice;//5日价格

+ (instancetype)share;
/**地量绿*/
- (NSArray *)lowStockes;
/**三日内一字板
 */
- (NSArray *)stopStock;
/**数天数,最高价大于当天最高价除以数据总天数(比如60)，60天中价格大于今天的天数比例*/
- (NSArray *)daysUpOfNow;

/**今日倍量柱*/
- (NSArray *)todayDouble;
/**超跌排序*/
- (NSArray *)getDownMore;
/**找精准点*/
- (NSArray *)averageValue:(NSString *)code;
/**精准线*/
- (NSArray *)jingzhunxian;

- (NSArray *)getMoneyListOrderByNumber;
/**主在入，价在跌*/
- (NSArray *)getMoneyEnterAndPriceDepress;

@end
