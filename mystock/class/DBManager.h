//
//  DBManager.h
//  mystock
//
//  Created by liujianzhong on 15/8/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JSONKit.h"

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrayCode;
@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)share;

- (void )deleteDBWithKey:(NSString *) key;
- (NSArray *)fetchStockLocationWithKey:(NSString *) key;
- (void )insertIntoDBWith:(NSArray *) lines Key:(NSString *) key;

@end
