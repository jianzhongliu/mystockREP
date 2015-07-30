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
    [[CaculationFunction share] lowColumnRate];
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





- (void)lowColumnRate {
    int low = 0;//下降
    int up = 0;//上涨
    for (int i = 0; i < self.arraySourceData.count; i++) {
        NSDictionary *dic = self.arraySourceData[i];
        NSArray *arraySingleDay = dic[@"timedata"];
        NSDictionary *dicLow = arraySingleDay[0];
        for (NSDictionary *dicDay in arraySingleDay) {
            if ([dicDay[@"curvol"] integerValue]> [dicLow[@"curvol"] integerValue]) {
                dicLow = dicDay;
            }
        }
        int index = [arraySingleDay indexOfObject:dicLow];
        if (arraySingleDay.count > index + 3) {
            if ([arraySingleDay[index + 3][@"preclose"] integerValue] > [dicLow[@"preclose"] integerValue]) {
                up ++ ;
            } else {
                low ++ ;
            }
        }
    }
    NSLog(@"低量柱结果：降：%d=====升:%d=====上涨率：%.2f", low, up, up/(up+low +0.000001f));
}


//- (NSArray *)priceRank {
//    NSArray *array = [NSArray arrayWithArray:self.arraySourceData];
    
    
    
//    NSArray *arrayResult = [array sortedArrayUsingSelector:@selector(comparePrice:)];

    
//}


//- (NSComparisonResult)comparePrice:(NSDictionary *)dic {
//    NSComparisonResult result = [dic[@"timedata"] compare:stu.lastname];
//    // 如果有相同的姓，就比较名字
//    if (result == NSOrderedSame) {
//        result = [self.firstname compare:stu.firstname];
//    }
//    return result;
//}

@end
