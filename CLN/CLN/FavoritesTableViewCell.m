//
//  FavoritesTableViewCell.m
//  CLN
//
//  Created by Developer on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "FavoritesTableViewCell.h"
#import "ColorCategory.h"
#import "URLManager.h"

@implementation FavoritesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithDiscount:(Discount *)discount {
    self.discount = discount;

    UIColor *color = [ColorCategory colorForCategory:self.discount.category];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", [URLManager baseImagesURL], [self.discount getLogoPath]];
    NSString *descriptionText = [NSString stringWithFormat:@"%@ %@", discount.discountType, discount.discountDescription];

    [self.categoryColorIndicatorView setBackgroundColor:color];
    [self.establishmentLabel setText:self.discount.establishmentName];
    [self.discountDescriptionLabel setText:descriptionText];

    self.establishmentLogoImageView.image = [UIImage imageNamed:@"placeimage"];
    self.establishmentLogoImageView.imageURL = [NSURL URLWithString:fullURL];
}

@end
