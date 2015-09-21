//
//  DBManager.m
//  mystock
//
//  Created by liujianzhong on 15/8/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "DBManager.h"
#import "NSArray+TYAFNetworking.h"
#import "commond.h"

@implementation DBManager
+ (void)load {
//    NSArray *array = [NSMutableArray arrayWithArray:[commond getUserDefaults:@"sourceData"]];

//    [[DBManager share] insertIntoDBWith:array Key:@"sourceData"];
//    NSArray *dataSource = [[DBManager share] fetchStockLocationWithKey:@"sourceData"];
//    NSArray *arrayLines =  [[DBManager share] fetchStockLocationWithKey:@"lines"];
    
}

+ (instancetype)share {
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[DBManager alloc] init];
        }
    });
    return manager;
}

- (id)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {

}
-(void)openDB{
    self.db = [FMDatabase databaseWithPath:kDBFilePath];
    if (![self.db open]) {
        return ;
    }
}

- (void)closeDB {
    [self.db close];
}

- (NSArray *)fetchStockLocationWithKey:(NSString *) key {
    NSMutableArray *arrayResult = [NSMutableArray array];
    [self openDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM stock WHERE key = '%@';",key];
        FMResultSet *result = [self.db executeQuery:sql];
        while ([result next]) {
            NSString *content = [result stringForColumn:@"content"];
            NSError *error = nil;
            NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            [arrayResult addObject:dic];
        }
    return arrayResult;
}

- (void )insertIntoDBWith:(NSArray *) lines Key:(NSString *) key {
    [self deleteDBWithKey:key];
    [self openDB];
    NSString *sql = @"CREATE TABLE IF NOT EXISTS stock(content varchar, key varchar);";
    [self.db executeUpdate:sql];
    for (NSArray *array in lines) {
        NSString *stringLine = [array JSONString];
        NSString *sql = @"INSERT INTO stock(content,key) VALUES(?,?)";
        if (![self.db executeUpdate:sql, stringLine, key]) {
            NSLog(@"数据处理失败");
        }
    }
    [self closeDB];
    NSArray *arrayLines =  [[DBManager share] fetchStockLocationWithKey:@"lines"];
}

- (void )deleteDBWithKey:(NSString *) key {
    [self openDB];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM stock WHERE key = %@;", key];
    [self.db executeUpdate:sql];
    [self closeDB];
}

@end
