//
//  RquestTotalStock.h
//  mystock
//
//  Created by liujianzhong on 15/8/4.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "colorModel.h"
#import "commond.h"

@interface RquestTotalStock : NSObject

@property (nonatomic, strong) NSMutableArray *arrayShang;
@property (nonatomic, strong) NSMutableArray *arrayShen;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *arrayResult;
@property (nonatomic, strong) NSMutableArray *arrayLines;

@property (nonatomic, strong) NSMutableArray *arrayMoney;
@property (nonatomic, strong) NSMutableArray *arrayDayPrice;

+ (instancetype)share;
- (void)startLoadingDataWith:(NSInteger )number ;
- (void)startLoadingMoney;
@end
