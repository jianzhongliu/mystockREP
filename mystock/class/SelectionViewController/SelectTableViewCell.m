//
//  SelectTableViewCell.m
//  mystock
//
//  Created by Ryan on 14-6-2.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "SelectTableViewCell.h"

@implementation SelectTableViewCell

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

- (void)setCellData:(NSDictionary *)cellDic{
    _nameLabel.text = [cellDic objForKey:@"name"];
    _codeLabel.text = [cellDic objForKey:@"code"];
}
@end
