//
//  SearchTableViewCell.h
//  mystock
//
//  Created by Ryan on 14-6-2.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTableViewCellDelegate <NSObject>

- (void)add_click:(NSDictionary *)dic;

@end

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *addLabel;

@property (nonatomic, strong) NSDictionary *cellDic;
@property (nonatomic, unsafe_unretained) id<SearchTableViewCellDelegate>delegate;


- (void)setCellData:(NSDictionary *)dic;

@end
