//
//  StopRaseStockViewCell.m
//  mystock
//
//  Created by liujianzhong on 15/7/31.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "StopRaseStockViewCell.h"

@interface StopRaseStockViewCell ()

@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelRise;
@property (nonatomic, strong) UILabel *labelReason;

@end

@implementation StopRaseStockViewCell
- (UILabel *)labelName {
    if (_labelName == nil) {
        _labelName = [[UILabel alloc] init];
        _labelName.numberOfLines = 0;
        _labelName.lineBreakMode = NSLineBreakByCharWrapping;
        _labelName.font = [UIFont systemFontOfSize:13];
    }
    return _labelName;
}

- (UILabel *)labelRise {
    if (_labelRise == nil) {
        _labelRise = [[UILabel alloc] init];
        _labelRise.numberOfLines = 0;
        _labelRise.lineBreakMode = NSLineBreakByCharWrapping;
        _labelRise.font = [UIFont systemFontOfSize:13];
    }
    return _labelRise;
}

- (UILabel *)labelReason {
    if (_labelReason == nil) {
        _labelReason = [[UILabel alloc] init];
        _labelReason.numberOfLines = 0;
        _labelReason.lineBreakMode = NSLineBreakByCharWrapping;
        _labelReason.font = [UIFont systemFontOfSize:13];
    }
    return _labelReason;
}


#pragma mark - lifecycleMethod
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.labelName.frame = CGRectMake(0, 10, 80, 40);
    self.labelRise.frame = CGRectMake(80, 10, 100, 40);
    self.labelReason.frame = CGRectMake(180, 10, 120, 40);
    [self.contentView addSubview:self.labelName];
    [self.contentView addSubview:self.labelRise];
    [self.contentView addSubview:self.labelReason];
}

- (void)configCellWithData:(id) celldata {
    NSArray *array = (NSArray *)celldata;
    if (array.count < 8) {
        return;
    }
    NSString *numbers = [[array[2] componentsSeparatedByString:@"<td class=\"bzt\">"] objectAtIndex:1];
    
    self.labelName.text = [NSString stringWithFormat:@"%@%@", array[4], array[3]];
    self.labelRise.text = [NSString stringWithFormat:@"%@%@", numbers, array[6]];
    self.labelReason.text = array[5];
}

- (CGFloat)fetchCellHight {
    
    return 0;
}


@end
