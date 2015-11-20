//
//  DaysChartModel.h
//  HYStockChartDemo
//
//  Created by liujianzhong on 15/11/12.
//  Copyright © 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , kStockTianjiEMACycle) {
    kStockTianjiEMACycle_1 = 1,
    kStockTianjiEMACycle_2 = 2
};

@interface DaysChartModel : NSObject

@property (nonatomic, strong) NSString *MACD_12EMA;
@property (nonatomic, strong) NSString *MACD_26EMA;
@property (nonatomic, strong) NSString *EMA;


@property (nonatomic, strong) NSString *EMA_Tianji_1;
@property (nonatomic, strong) NSString *EMA_Tianji_2;

@property (nonatomic, strong) NSString *closePrice;
@property (nonatomic, strong) NSString *heightPrice;
@property (nonatomic, strong) NSString *lowPrice;
//@property (nonatomic, strong) NSString *closePrice;
@property (nonatomic, strong) NSString *volume;

@property (nonatomic, strong) NSString *MACD_DEA;

@property (nonatomic, strong) NSString *MA5;
@property (nonatomic, strong) NSString *MA10;
@property (nonatomic, strong) NSString *MA20;

@property (nonatomic, strong) NSString *volMA5;
@property (nonatomic, strong) NSString *volMA10;

- (instancetype)initWithDic:(NSDictionary *) dic;


@end
