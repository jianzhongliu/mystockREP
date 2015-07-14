//
//  StockLineView.h
//  mystock
//
//  Created by Ryan on 14-6-12.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockLineView : UIView

@property (nonatomic, strong) UIImageView *lineImageView;

- (id)initWithFrame:(CGRect)frame displayImage:(UIImage *)image;

@end
