//
//  DaysChartModel.m
//  HYStockChartDemo
//
//  Created by liujianzhong on 15/11/12.
//  Copyright © 2015年 jimubox. All rights reserved.
//

#import "DaysChartModel.h"

@implementation DaysChartModel

- (instancetype)initWithDic:(NSDictionary *) dic {
    if (self = [super init]) {
        if (dic != nil) {
            self.openPrice = dic[@"open"];
            self.highPrice = dic[@"high"];
            self.lowPrice = dic[@"low"];
            self.closePrice = dic[@"close"];
            self.volume = dic[@"volume"];
            self.MA5 = dic[@"MA5"];
            self.MA10 = dic[@"MA10"];
            self.MA20 = dic[@"MA20"];
            self.date = dic[@"date"];
        }
    }
    return self;
}

@end
