//
//  CategoryCell.m
//  CLN
//
//  Created by Pablo Castarataro on 4/11/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.categoryActiveIndicator.hidden = !selected;
}

@end
