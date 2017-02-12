//
//  RquestTotalStock.m
//  mystock
//
//  Created by liujianzhong on 15/8/4.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "RquestTotalStock.h"
#import "TYApiProxy.h"
#import "DBManager.h"

@implementation RquestTotalStock
+ (void)load {
//    [[RquestTotalStock share] requestMoneyWithIndex:0];
}
+ (instancetype)share{
    static RquestTotalStock *stock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (stock == nil) {
            stock = [[RquestTotalStock alloc] init];
        }
    });
    return stock;
}

- (id)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)startLoadingDataWith:(NSInteger )number {
    self.index = 0;
    [self requestStockWithIndex:self.index ++ number:number];
}

- (void)startLoadingMoney {
    self.index = 0;
    [self requestMoneyWithIndex:self.index];
}

- (void)initData {
    self.index = 0;
    self.arrayLines = [NSMutableArray array];
    self.arrayResult = [NSMutableArray array];
    self.arrayShang = [NSMutableArray array];
    self.arrayShen = [NSMutableArray array];
    self.arrayMoney = [NSMutableArray array];
    self.arrayDayPrice = [NSMutableArray array];
    
    [self.arrayShang addObjectsFromArray:[colorModel getStockCodeInfo600]];
    [self.arrayShang addObjectsFromArray:[colorModel getStockCodeInfo002]];
}

- (void)requestStockWithIndex:(NSInteger) index number:(NSInteger) number{
    if (index >= self.arrayShang.count) {
        [self localisationData];
        return;
    }
    NSDictionary *code = [self.arrayShang objectAtIndex:index];
    NSString *url = [NSString stringWithFormat:@"http://hq.niuguwang.com/aquote/quotedata/KLine.ashx?ex=1&code=%@&type=5&count=%d&packtype=0&version=2.0.5", code[@"innercode"], number];
    __block NSString *identify = [NSString stringWithFormat:@"%@", code[@"innercode"]];
    __weak typeof(self) blockSelf = self;
    [[TYAPIProxy shareProxy] callGETWithParams:code identify:url methodName:@"" successCallBack:^(TYURLResponse *response) {
        if (response.content == nil) {
            return;
        }
        [blockSelf.arrayLines addObject:@{@"response":response.content,@"identify":identify}];
        [blockSelf.arrayResult addObject:response.content];
        
//        if ([[response.content objectForKey:@"timedata"] count] > 0 && [[[[response.content objectForKey:@"timedata"] objectAtIndex:0] objectForKey:@"times"] containsString:[self getcurrentTime]]) {
//            [blockSelf.arrayResult addObject:response.content];
//        } else  {
//            NSLog(@"767381290%@",response.content);
//        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentRequestData" object:nil];
        
//        [self recomentDoubleStock:response.content];
        [blockSelf requestStockWithIndex:self.index ++ number:number];
    } faildCallBack:^(TYURLResponse *response) {
        [blockSelf requestStockWithIndex:self.index ++ number:number];
    }];
}

- (void)requestMoneyWithIndex:(NSInteger) index{
    if (index >= self.arrayShang.count) {
        [self localisationMoneyData];
        return;
    }
    NSDictionary *code = [self.arrayShang objectAtIndex:index];
    NSString *url = [NSString stringWithFormat:@"http://ifzq.gtimg.cn/appstock/app/kline/kline?p=1&param=sh%@,day,,,5", code[@"stockcode"]];
    __block NSString *identify = @"";
   identify = [NSString stringWithFormat:@"sh%@", code[@"stockcode"]];

    if (index > 1066) {
        url = [NSString stringWithFormat:@"http://ifzq.gtimg.cn/appstock/app/kline/kline?p=1&param=sz%@,day,,,5", code[@"stockcode"]];
        identify = [NSString stringWithFormat:@"sz%@", code[@"stockcode"]];
    }
    [[TYAPIProxy shareProxy] callGETWithParams:code identify:url methodName:@"" successCallBack:^(TYURLResponse *response) {
        if (response.content == nil) {
            return;
        }
        NSDictionary *dic = (NSDictionary *)response.content;
       NSMutableArray *dicResultData = [[[dic[@"data"] objectForKey:identify] objectForKey:@"qt"] objectForKey:@"zjlx"];
        NSLog(@"%@", dicResultData);
        if (dicResultData != nil) {
            [self.arrayMoney addObject:dicResultData];
        }
        NSMutableArray *dicDayPrice = [[dic[@"data"] objectForKey:identify] objectForKey:@"day"];
        [dicDayPrice addObjectsFromArray:dicResultData];
        if (dicDayPrice != nil) {
            [self.arrayDayPrice addObject:dicDayPrice];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentRequestData" object:self.arrayMoney];
        [self requestMoneyWithIndex:self.index ++];
    } faildCallBack:^(TYURLResponse *response) {
        [self requestMoneyWithIndex:self.index ++];
    }];
}

- (void)localisationData {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"结束了" message:@"全部请求完成" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [[DBManager share] insertIntoDBWith:self.arrayLines Key:@"lines"];
    [[DBManager share] insertIntoDBWith:self.arrayResult Key:@"sourceData"];

    [self.arrayLines removeAllObjects];
    [self.arrayResult removeAllObjects];
}

- (void)localisationMoneyData {
    [commond setUserDefaults:self.arrayMoney forKey:@"moneyData"];
    [commond setUserDefaults:self.arrayDayPrice forKey:@"dayPrice"];
    [self.arrayMoney removeAllObjects];
    [self.arrayDayPrice removeAllObjects];
}

- (void)recomentDoubleStock:(NSDictionary *) respose {
    NSArray *array = [NSArray arrayWithArray:respose[@"timedata"]];
    if (array.count < 3) {
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:array[0]];
    NSDictionary *dicYesteday = [NSDictionary dictionaryWithDictionary:array[1]];
    NSMutableArray *arrayLocalStock = [NSMutableArray arrayWithArray:(NSArray *)[commond getUserDefaults:@"Double"]];
    if ([dic[@"curvol"] floatValue] > 2* [dicYesteday[@"curvol"] floatValue] && [dic[@"curvol"] floatValue] < 10* [dicYesteday[@"curvol"] floatValue]) {
        NSDictionary *dic = @{@"innercode":respose[@"innercode"], @"stockcode":respose[@"stockcode"],@"stockname":respose[@"stockname"]};
        if ([respose[@"stockcode"] rangeOfString:@"600"].length > 0) {
            [arrayLocalStock addObject:dic];
            [commond setUserDefaults:arrayLocalStock forKey:@"Double"];        }
        
    }
}

- (NSString *)dicStockToString:(NSDictionary *) dic{
    NSString *date = [self dateFormater:[dic objectForKey:@"times"]];
    NSString *todyOpen = [NSString stringWithFormat:@"%.2f",[dic[@"openp"] floatValue] / 100.0f];//jin开
    NSString *todyHigh =[NSString stringWithFormat:@"%.2f",[dic[@"highp"] floatValue] / 100.0f] ;//最高
    NSString *todyLow = [NSString stringWithFormat:@"%.2f",[dic[@"lowp"] floatValue] / 100.0f] ;//最低
    NSString *todeClose = [NSString stringWithFormat:@"%.2f",[dic[@"nowv"] floatValue] / 100.0f] ;//今收
    NSString *temp = [NSString stringWithFormat:@"%.2f",[dic[@"curvol"] floatValue] / 100.0f] ;
    NSString *data = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@", date,todyOpen,todyHigh,todyLow,todeClose,temp];
    return data;
}

- (NSString *)dateFormater:(NSString *) time {
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    dateForm.dateFormat = @"yyyyMMddHHmmss";
    NSDate *timeString = [dateForm dateFromString:time];
    dateForm.dateFormat = @"yyyy-MM-dd";
    return [dateForm stringFromDate:timeString];
}

-(CGFloat)sumArrayWithData:(NSArray*)data andRange:(NSRange)range{
    CGFloat value = 0;
    if (data.count - range.location>range.length) {
        NSArray *newArray = [data objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:range]];
        for (NSString *item in newArray) {
            NSArray *arr = [item componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            value += [[arr objectAtIndex:4] floatValue];
        }
        if (value>0) {
            value = value / newArray.count;
        }
    }
    return value;
}

- (NSString *)getcurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
