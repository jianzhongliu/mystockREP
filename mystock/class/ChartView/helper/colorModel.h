//
//  colorModel.h
//  Kline
//
//  Created by zhaomingxi on 14-2-9.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface colorModel : NSObject
@property (nonatomic,assign) int R;
@property (nonatomic,assign) int G;
@property (nonatomic,assign) int B;
@property (nonatomic,assign) CGFloat alpha;

+ (NSMutableArray *)getSA;
+ (NSMutableArray *)getHA;
+ (NSArray *)getStockCodeInfo;

/**仅仅沪A*/
+ (NSArray *)getStockCodeInfo600;
/**仅仅深A*/
+ (NSArray *)getStockCodeInfo002;

@end
