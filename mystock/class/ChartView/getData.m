//
//  getData.m
//  Kline
//
//  Created by zhaomingxi on 14-2-10.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import "getData.h"

#import "commond.h"

@implementation getData

-(id)init{
    self = [super init];
    if (self){
        self.isFinish = NO;
        self.maxValue = 0;
        self.minValue = CGFLOAT_MAX;
        self.volMaxValue = 0;
        self.volMinValue = CGFLOAT_MAX;
        self.todayStock = [NSDictionary dictionary];
    }
    return  self;
}

-(id)initWithUrl:(NSString*)url fresh:(BOOL) isRefresh{
    if (self){
        // 取缓存的每天数据
        NSArray *tempArray = (NSArray*)[commond getUserDefaults:@"daydatas"];
        if (tempArray.count>0) {
            self.dayDatas = tempArray;
        }

        NSArray *lines = (NSArray*)[commond getUserDefaults:[commond md5HexDigest:url]];
        
        if (isRefresh == NO && lines.count>0) {
            [self changeData:lines];
        }else{
            NSLog(@"url:%@",url);
            NSURL *nurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSString *url = @"http://hq.niuguwang.com/aquote/userdata/getuserstocks.ashx?version=2.0.5&packtype=0&usertoken=njayg_XK-3AJQ9gsPjN9RHzmVogatdxspIs7v0KUj88*&s=App%20Store";
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DMLog(@"JSON: %@", responseObject);
                if (responseObject == nil) {
                    return;
                }
                self.status.text = @"";
                NSString *content = responseObject;
                NSMutableArray *lines = [NSMutableArray array];
//                [lines addObject:@"2010-03-15,17.95,17.99,17.45,17.56,6857700,16.89"];
                for (NSDictionary *dic in [responseObject objectForKey:@"timedata"]) {
                    [lines addObject:[self dicStockToString:dic]];
                }
                if ([self.req_type isEqualToString:@"d"]) {
                    self.dayDatas = lines;
                    [commond setUserDefaults:lines forKey:@"daydatas"];
                }
                [commond setUserDefaults:lines forKey:[commond md5HexDigest:[[NSString alloc] initWithFormat:@"%@",url]]];
                [self changeData:lines];
                self.isFinish = YES;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                	self.status.text = @"Error!";
                    self.isFinish = YES;
            }];
            
            
//            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nurl];
//            [request setTimeOutSeconds:30];
//            [request setCachePolicy:ASIUseDefaultCachePolicy];
//            [request startSynchronous];
//            // 加载完成执行此块
//            [self Finished:request];
        }
	}
    return self;
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
//- (void)Finished:(ASIHTTPRequest *)request
//{
//	self.status.text = @"";
//    NSString *content = [request responseString];
//    NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    if ([self.req_type isEqualToString:@"d"]) {
//        self.dayDatas = lines;
//        [commond setUserDefaults:lines forKey:@"daydatas"];
//    }
//    [commond setUserDefaults:lines forKey:[commond md5HexDigest:[[NSString alloc] initWithFormat:@"%@",request.url]]];
//    [self changeData:lines];
//    request = nil;
//    self.isFinish = YES;
//    
//}

-(void)changeData:(NSArray*)lines{
    NSMutableArray *data =[[NSMutableArray alloc] init];
	NSMutableArray *category =[[NSMutableArray alloc] init];
    NSArray *newArray = lines;
    newArray = [newArray objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:
                                           NSMakeRange(0, self.kCount>=newArray.count?newArray.count:self.kCount)]]; // 只要前面指定的数据
    //NSLog(@"lines:%@",newArray);
    NSInteger idx;
    int MA5=5,MA10=10,MA20=20; // 均线统计
    for (idx = newArray.count-1; idx > 0; idx--) {
        NSString *line = [newArray objectAtIndex:idx];
        if([line isEqualToString:@""]){
            continue;
        }
        NSArray   *arr = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        // 收盘价的最小值和最大值
        if ([[arr objectAtIndex:2] floatValue]>self.maxValue) {
            self.maxValue = [[arr objectAtIndex:2] floatValue];
        }
        if ([[arr objectAtIndex:3] floatValue]<self.minValue) {
            self.minValue = [[arr objectAtIndex:3] floatValue];
        }
        // 成交量的最大值最小值
        if ([[arr objectAtIndex:5] floatValue]>self.volMaxValue) {
            self.volMaxValue = [[arr objectAtIndex:5] floatValue];
        }
        if ([[arr objectAtIndex:5] floatValue]<self.volMinValue) {
            self.volMinValue = [[arr objectAtIndex:5] floatValue];
        }
        NSMutableArray *item =[[NSMutableArray alloc] init];
        [item addObject:[arr objectAtIndex:1]]; // open
        [item addObject:[arr objectAtIndex:2]]; // high
        [item addObject:[arr objectAtIndex:3]]; // low
        [item addObject:[arr objectAtIndex:4]]; // close
        [item addObject:[arr objectAtIndex:5]]; // volume 成交量
        CGFloat idxLocation = [lines indexOfObject:line];
        // MA5
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA5)]]]; // 前五日收盘价平均值
        // MA10
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA10)]]]; // 前十日收盘价平均值
        // MA20
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA20)]]]; // 前二十日收盘价平均值
        // 前面二十个数据不要了，因为只是用来画均线的
        [category addObject:[arr objectAtIndex:0]]; // date
        [data addObject:item];
    }
	if(data.count==0){
		self.status.text = @"Error!";
	    return;
	}
    
    self.data = data; // Open,High,Low,Close,Adj Close,Volume
    self.category = category; // Date
    //NSLog(@"%@",data);
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
//- (void)Failed:(ASIHTTPRequest *)request{
//	self.status.text = @"Error!";
//    request = nil;
//    self.isFinish = YES;
//}

-(void)dealloc{

}
@end
