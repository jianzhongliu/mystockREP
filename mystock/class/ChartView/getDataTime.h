//
//  getData.h
//  Kline
//
//  Created by zhaomingxi on 14-2-10.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReturnBlock)(void);

@interface getDataTime : NSObject
@property (nonatomic,retain) NSMutableArray *data;//数组里地数据是数组
@property (nonatomic, strong) NSMutableArray *arrayDicData;//数组中的数据是dic

@property (nonatomic,retain) NSArray *dayDatas;
@property (nonatomic,retain) NSMutableArray *category;
@property (nonatomic,retain) NSString *lastTime;
@property (nonatomic,retain) UILabel *status;
@property (nonatomic,assign) BOOL isFinish;
@property (nonatomic,assign) CGFloat maxValue;
@property (nonatomic,assign) CGFloat minValue;
@property (nonatomic,assign) CGFloat volMaxValue;//量柱最大值
@property (nonatomic,assign) CGFloat volMinValue;//量柱最小值

@property (nonatomic,assign) CGFloat MACDPMaxValue;//MACD_DIF最大值正数
@property (nonatomic,assign) CGFloat MACDPMinValue;//MACD_DIF最小值正数

@property (nonatomic,assign) CGFloat MACDMMaxValue;//MACD_DIF最大值负数
@property (nonatomic,assign) CGFloat MACDMMinValue;//MACD_DIF最小值负数

@property (nonatomic,assign) NSInteger kCount;
@property (nonatomic,retain) NSString *req_type;
@property (nonatomic,retain) NSDictionary *todayStock;

@property (nonatomic, strong) ReturnBlock blockCallBack;
-(id)initWithUrl:(NSString*)url stock:(NSDictionary *) dicStock;

@end
