//
//  SelectTableViewCell.h
//  mystock
//
//  Created by Ryan on 14-6-2.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;

- (void)setCellData:(NSDictionary *)cellDic;

@end
