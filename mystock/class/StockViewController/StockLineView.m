//
//  StockLineView.m
//  mystock
//
//  Created by Ryan on 14-6-12.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "StockLineView.h"

@implementation StockLineView

- (id)initWithFrame:(CGRect)frame displayImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = BACKGROUND_COLOR;
        
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        _lineImageView.image = image;
        _lineImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        _lineImageView.center = self.center;
        [self addSubview:_lineImageView];
    }
    return self;
}


@end
