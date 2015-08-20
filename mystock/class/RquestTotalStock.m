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
//    for (int i = 0; i < 20; i ++) {
    [self requestStockWithIndex:self.index ++ number:number];
//    }
}

- (void)initData {
    self.index = 0;
    self.arrayLines = [NSMutableArray array];
    self.arrayResult = [NSMutableArray array];
    self.arrayShang = [NSMutableArray array];
    self.arrayShen = [NSMutableArray array];
    [self.arrayShang addObjectsFromArray:[colorModel getStockCodeInfo600]];
    [self.arrayShen addObjectsFromArray:[colorModel getSA]];
}

- (void)requestStockWithIndex:(NSInteger) index number:(NSInteger) number{
    if (index >= self.arrayShang.count) {
        [self localisationData];
        return;
    }
    if (index >= self.arrayShang.count) {
        NSString *message = [NSString stringWithFormat:@"当前数量:%d", index];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求结束" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } else {
        if (index > 0 && index / 100 == index/100.0f) {
            NSString *message = [NSString stringWithFormat:@"当前数量:%d", index];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"整数提醒" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
        }
    }
    NSMutableArray *arrayDoubleStock = [NSMutableArray array];
    [arrayDoubleStock addObjectsFromArray:self.arrayShang];
    [arrayDoubleStock addObjectsFromArray:self.arrayShen];
    
    NSDictionary *code = [self.arrayShang objectAtIndex:index];
    NSString *url = [NSString stringWithFormat:@"http://hq.niuguwang.com/aquote/quotedata/KLine.ashx?ex=1&code=%@&type=5&count=%d&packtype=0&version=2.0.5", code[@"innercode"], number];
    __block NSString *identify = [NSString stringWithFormat:@"%@", code[@"innercode"]];
    [[TYAPIProxy shareProxy] callGETWithParams:code identify:url methodName:@"" successCallBack:^(TYURLResponse *response) {
        if (response.content == nil) {
            return;
        }
        
        [self.arrayLines addObject:@{@"response":response.content,@"identify":identify}];
        
//        NSMutableArray *lines = [NSMutableArray array];
//        for (NSDictionary *dic in [response.content objectForKey:@"timedata"]) {
//            [lines addObject:[self dicStockToString:dic]];
//        }
//        NSLog(@"%@", response.content);
//        [commond setUserDefaults:lines forKey:[commond md5HexDigest:[[NSString alloc] initWithFormat:@"%@",identify]]];
        [self.arrayResult addObject:response.content];
//        //存储源数据
//        [commond setUserDefaults:self.arrayResult forKey:@"sourceData"];
//
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentRequestData" object:self.arrayResult];
        
//        [self recomentDoubleStock:response.content];
        [self requestStockWithIndex:self.index ++ number:number];
    } faildCallBack:^(TYURLResponse *response) {
        [self requestStockWithIndex:self.index ++ number:number];
    }];
}

- (void)localisationData {
//    for (NSDictionary *response in self.arrayLines) {
//        NSMutableArray *lines = [NSMutableArray array];
//        for (NSDictionary *dic in [response[@"response"] objectForKey:@"timedata"]) {
//            [lines addObject:[self dicStockToString:dic]];
//        }
//        NSLog(@"%@", response);
//        [[DBManager share] insertIntoDBWith:lines Key:response[@"identify"]];
//        [commond setUserDefaults:lines forKey:[commond md5HexDigest:[[NSString alloc] initWithFormat:@"%@",response[@"identify"]]]];
//    }
    [commond setUserDefaults:self.arrayLines forKey:@"lines"];

    [commond setUserDefaults:self.arrayResult forKey:@"sourceData"];
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

//-(void)changeData:(NSArray*)lines{
//    NSMutableArray *data =[[NSMutableArray alloc] init];
//    NSMutableArray *category =[[NSMutableArray alloc] init];
//    NSArray *newArray = lines;
//    newArray = [newArray objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:
//                                           NSMakeRange(0, self.kCount>=newArray.count?newArray.count:self.kCount)]]; // 只要前面指定的数据
//    //NSLog(@"lines:%@",newArray);
//    NSInteger idx;
//    int MA5=5,MA10=10,MA20=20; // 均线统计
//    for (idx = newArray.count-1; idx > 0; idx--) {
//        NSString *line = [newArray objectAtIndex:idx];
//        if([line isEqualToString:@""]){
//            continue;
//        }
//        NSArray   *arr = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
//        // 收盘价的最小值和最大值
//        if ([[arr objectAtIndex:2] floatValue]>self.maxValue) {
//            self.maxValue = [[arr objectAtIndex:2] floatValue];
//        }
//        if ([[arr objectAtIndex:3] floatValue]<self.minValue) {
//            self.minValue = [[arr objectAtIndex:3] floatValue];
//        }
//        // 成交量的最大值最小值
//        if ([[arr objectAtIndex:5] floatValue]>self.volMaxValue) {
//            self.volMaxValue = [[arr objectAtIndex:5] floatValue];
//        }
//        if ([[arr objectAtIndex:5] floatValue]<self.volMinValue) {
//            self.volMinValue = [[arr objectAtIndex:5] floatValue];
//        }
//        NSMutableArray *item =[[NSMutableArray alloc] init];
//        [item addObject:[arr objectAtIndex:1]]; // open
//        [item addObject:[arr objectAtIndex:2]]; // high
//        [item addObject:[arr objectAtIndex:3]]; // low
//        [item addObject:[arr objectAtIndex:4]]; // close
//        [item addObject:[arr objectAtIndex:5]]; // volume 成交量
//        CGFloat idxLocation = [lines indexOfObject:line];
//        // MA5
//        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA5)]]]; // 前五日收盘价平均值
//        // MA10
//        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA10)]]]; // 前十日收盘价平均值
//        // MA20
//        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA20)]]]; // 前二十日收盘价平均值
//        // 前面二十个数据不要了，因为只是用来画均线的
//        [category addObject:[arr objectAtIndex:0]]; // date
//        [data addObject:item];
//    }
//    if(data.count==0){
//        self.status.text = @"Error!";
//        return;
//    }
//    
//    self.data = data; // Open,High,Low,Close,Adj Close,Volume
//    self.category = category; // Date
//    //NSLog(@"%@",data);
//}


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

@end
