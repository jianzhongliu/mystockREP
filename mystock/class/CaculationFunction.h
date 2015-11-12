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

/**超跌排序*/
- (NSArray *)getDownMore;
/**涨幅排序*/
- (NSArray *)getUPMore;
/**价格排序*/
- (NSArray *)getPriceOrder;
/**地量绿*/
- (NSArray *)lowStockes;
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
