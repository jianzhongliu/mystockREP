//
//  DBManager.m
//  mystock
//
//  Created by liujianzhong on 15/8/18.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
+ (void)load {
    [DBManager share];
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
//        [self initData];
    }
    return self;
}

- (void)initData {
    self.arrayCode = [NSMutableArray array];
    NSString *stringCode = threeDCode;
    [self.arrayCode addObjectsFromArray:[stringCode componentsSeparatedByString:@"|"]];
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            
            int a0 = 0;
            int a1 = 0;
            int a2 = 0;
            int a3 = 0;
            int a4 = 0;
            int a5 = 0;
            int a6 = 0;
            int a7 = 0;
            int a8 = 0;
            int a9 = 0;
            for (int p = 0; p < self.arrayCode.count - 1; p++) {
                NSString *stringCode = self.arrayCode[p];
                if ([stringCode rangeOfString:[NSString stringWithFormat:@"%@",@(i)]].length > 0 && [stringCode rangeOfString:[NSString stringWithFormat:@"%@",@(j)]].length > 0 ) {
                    NSString *stringNext = self.arrayCode[p+1];
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(0)]].length > 0) {
                        a0 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(1)]].length > 0) {
                        a1 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(2)]].length > 0) {
                        a2 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(3)]].length > 0) {
                        a3 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(4)]].length > 0) {
                        a4 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(5)]].length > 0) {
                        a5 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(6)]].length > 0) {
                        a6 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(7)]].length > 0) {
                        a7 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(8)]].length > 0) {
                        a8 ++;
                    }
                    if ([stringNext rangeOfString:[NSString stringWithFormat:@"%@",@(9)]].length > 0) {
                        a9 ++;
                    }
                }
            }
            NSLog(@"组合%d/%d=====%d-%d-%d-%d-%d-%d-%d-%d-%d-%d",i,j, a0, a1,a2,a3,a4,a5,a6,a7,a8,a9);
//            NSLog(@"组合%d/%d=====%.3f-%.3f-%.3f-%.3f-%.3f-%.3f-%.3f-%.3f-%.3f-%.3f",i,j, a0/(self.arrayCode.count + 0.000001f), a1/(self.arrayCode.count + 0.000001f),a2/(self.arrayCode.count + 0.000001f),a3/(self.arrayCode.count + 0.000001f),a4/(self.arrayCode.count + 0.000001f),a5/(self.arrayCode.count + 0.000001f),a6/(self.arrayCode.count + 0.000001f),a7/(self.arrayCode.count + 0.000001f),a8/(self.arrayCode.count + 0.000001f),a9/(self.arrayCode.count + 0.000001f));
        }
    }
    
    
}

- (NSArray *)fetchStockLocation {
    NSMutableArray *arrayResult = [NSMutableArray array];
    FMDatabase *dbBase = [FMDatabase databaseWithPath:kDBFilePath];
    NSString *sql = @"select * from stock";
    if ([dbBase open]) {
        FMResultSet *result = [dbBase executeQuery:sql];
        while ([result next]) {
            [arrayResult addObject:[result stringForColumn:@"content"]];
        }
    }
    [dbBase close];
    return arrayResult;
}


@end
