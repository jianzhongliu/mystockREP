//
//  CaculationFunction.h
//  mystock
////缩量柱，极阴次阳，长发顶天，倍量伸缩，假阴真阳，涨停板，倍量过左锋，长腿才发，单阳不破，阳后双阴，三种以上能到>90%
//突破涨停
//002486，均线：5 13，20， 60
//主升浪：13天，普通的5天，在第一天买入，一般股票启动不会只有一天
//  Created by liujianzhong on 15/7/30.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//
/**
 curvol = 2985565;
 highp = 490;
 lowp = 464;
 nowv = 472;
 openp = 473;
 preclose = 476;
 times = 20121221000000;
 */
#import <UIKit/UIKit.h>

@interface CaculationFunction : NSObject

@property (nonatomic, assign) NSInteger lowDay;//低量柱计算天数，默认是20天
@property (nonatomic, assign) BOOL isDowble;//是否是倍量
@property (nonatomic, strong) NSMutableArray *arraySourceData;//元数据
@property (nonatomic, strong) NSMutableArray *arrayDouble;//倍
@property (nonatomic, strong) NSMutableArray *arrayLow;//地量
@property (nonatomic, strong) NSMutableArray *arrayBetween;//价差
@property (nonatomic, strong) NSMutableArray *arrayMoneyData;//散装对比
@property (nonatomic, strong) NSMutableArray *arrayDayPrice;//5日价格

+ (instancetype)share;

/**超跌排序*/
- (NSArray *)getDownMore;
/**涨幅排序*/
- (NSArray *)getUPMore;
/**价格排序*/
- (NSArray *)getPriceOrder;
/**地量绿*/
- (NSArray *)lowStockes;
/**下跌天数排行*/
- (NSArray *)downStockesDownDays;
/**低位星*/
- (NSArray *)lowStockesStar;
/**昨日低量柱
 */
- (NSArray *)yesterdayLowStockes;
/**地量数,打印数据
 */
- (NSArray *)yesterdayLowStockesNumberWithDay:(NSInteger) index;
/**三日内一字板
 */
- (NSArray *)stopStock;
/**数天数,最高价大于当天最高价除以数据总天数(比如60)，60天中价格大于今天的天数比例*/
- (NSArray *)daysUpOfNow;

/**今日倍量柱*/
- (NSArray *)todayDouble;
/**
 ST类型
 */
- (NSArray *)STStock;
/**
 今日低开高走
 */
- (NSArray *)lowStartHeighStop;
/**缩倍柱+30日地量柱+倍量柱
 表示有主力故意在玩弄，避开系统风险，很容易就是牛股了
 下面数据虽然才65%,但是这类股分启动上升时期和启动下跌时期
 低量柱结果：降：267=====升:494=====上涨率：0.65======涨幅:131.22 ===== 跌幅:76.72
 */
- (NSArray *)doubleLowDouble;


/**缩倍柱*/
- (void)dowbleLowcolumn;

/**找精准点*/
- (NSArray *)averageValue:(NSString *)code;
/**精准线*/
- (NSArray *)jingzhunxian;

- (NSArray *)getMoneyListOrderByNumber;
/**主在入，价在跌*/
- (NSArray *)getMoneyEnterAndPriceDepress;

@end
