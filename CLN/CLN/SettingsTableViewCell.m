//
//  SettingsTableViewCell.m
//  CLN
//
//  Created by Developer on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self customizeForSelected:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [self customizeForSelected:highlighted];
}

- (void)customizeForSelected:(BOOL)selected {
    //    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]];
    //
    //    if (selected) {
    //        [self.settingLabel setTextColor:[UIColor blackColor]];
    //        [self.contentView setBackgroundColor:[UIColor darkGrayColor]];
    //    } else {
    //        [self.settingLabel setTextColor:[UIColor whiteColor]];
    //        [self.contentView setBackgroundColor:[UIColor clearColor]];
    //
    //        [self.textLabel setTextColor:[UIColor colorWithRed:80 / 255.0 green:77 / 255.0 blue:80 / 255.0 alpha:1.0]];
    //    }
}

@end
