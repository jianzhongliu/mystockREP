//
//  RquestTotalStock.h
//  mystock
//
//  Created by liujianzhong on 15/8/4.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "colorModel.h"
#import "commond.h"

@interface RquestTotalStock : NSObject

@property (nonatomic, strong) NSMutableArray *arrayShang;
@property (nonatomic, strong) NSMutableArray *arrayShen;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *arrayResult;

+ (instancetype)share;
- (void)startLoadingDataWith:(NSInteger )number ;
@end
