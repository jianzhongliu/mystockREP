//
//  SuggestDetailViewController.h
//  mystock
//
//  Created by Ryan on 14-6-11.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockLineView.h"

@interface SuggestDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *stockDic;
@property (nonatomic, strong) NSArray *downArray;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) StockLineView *stockLineView;

- (id)initWithStock:(NSDictionary *)dic;

@end
