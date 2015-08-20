//
//  DBManager.h
//  mystock
//
//  Created by liujianzhong on 15/8/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrayCode;
+ (instancetype)share;

- (NSArray *)fetchStockLocationWithKey:(NSString *) key;
- (void )insertIntoDBWith:(NSArray *) lines Key:(NSString *) key;

@end
