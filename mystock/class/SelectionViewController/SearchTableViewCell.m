//
//  SearchTableViewCell.m
//  mystock
//
//  Created by Ryan on 14-6-2.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 160, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = HEI_(18);
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"鸿博股份";
        [self.contentView addSubview:_nameLabel];
        
        self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 33, 160, 12)];
        _codeLabel.backgroundColor = [UIColor clearColor];
        _codeLabel.font = HEI_(10);
        _codeLabel.textColor = [UIColor lightGrayColor];
        _codeLabel.text = @"002229";
        [self.contentView addSubview:_codeLabel];
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _addBtn.frame = CGRectMake(280, 15, 20, 20);
        [_addBtn addTarget:self action:@selector(addFocus) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
        
        self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 50)];
        _addLabel.backgroundColor = [UIColor clearColor];
        _addLabel.font = HEI_(12);
        _addLabel.textColor = BLUE_COLOR;
        _addLabel.textAlignment = NSTextAlignmentRight;
        _addLabel.text = @"已添加";
        [self.contentView addSubview:_addLabel];
        _addLabel.hidden = YES;
        
        UIView *tempView = [[UIView alloc] initWithFrame:self.bounds];
        tempView.backgroundColor = NAVI_COLOR;
        self.selectedBackgroundView = tempView;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSDictionary *)dic{
    self.cellDic = dic;
    
    _nameLabel.text = [_cellDic objForKey:@"name"];
    _codeLabel.text = [_cellDic objForKey:@"code"];
    
    BOOL showADD = [[_cellDic objForKey:@"focus"] intValue] == 1 ? NO:YES;
    if (showADD) {
        _addBtn.hidden = NO;
        _addLabel.hidden = YES;
    }else{
        _addBtn.hidden = YES;
        _addLabel.hidden = NO;
    }
}

#pragma mark - Custom Method
- (void)addFocus{
    if (_delegate && [_delegate respondsToSelector:@selector(add_click:)]) {
        [_delegate add_click:_cellDic];
    }
}
@end
