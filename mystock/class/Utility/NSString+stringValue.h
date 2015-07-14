//
//  NSString+stringValue.h
//  LeheV2
//
//  Created by zhangluyi on 11-8-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_stringValue)

- (NSString *)stringValue;
- (NSString *)removeSpace;
- (NSString *)trimTagCode;
- (NSString *)removeSpaceAndNewLine;

@end
