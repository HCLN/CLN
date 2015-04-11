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
    if (selected) {
        self.categoryActiveIndicator.backgroundColor = [UIColor colorWithCGColor:self.categoryActiveIndicator.layer.borderColor];
        self.categoryActiveIndicator.layer.borderWidth = 0.0f;
    } else {
        self.categoryActiveIndicator.layer.borderColor = [self.categoryActiveIndicator.backgroundColor CGColor];
        self.categoryActiveIndicator.backgroundColor = [UIColor clearColor];
        self.categoryActiveIndicator.layer.borderWidth = 1.0f;
    }
}

@end
