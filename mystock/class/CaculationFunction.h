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


+ (instancetype)share;
/**地量绿*/
- (void)lowColumnRate;

@end
