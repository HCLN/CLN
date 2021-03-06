//
//  DiscountTableViewCell.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "DiscountTableViewCell.h"
#import "URLManager.h"
#import "ColorCategory.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

@implementation DiscountTableViewCell

- (void)configureWithDiscount:(Discount *)discount {
    self.discount = discount;

    UIColor *color = [ColorCategory colorForCategory:self.discount.category];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", [URLManager baseImagesURL], [self.discount getLogoPath]];
    NSString *descriptionText = [NSString stringWithFormat:@"%@ %@", discount.discountType, discount.discountDescription];

    //    NSString *distance = [self.discount getDistanceInMeters:_location.coordinate.latitude LongitudeFrom:_location.coordinate.longitude LatitudeTo:self.discount.pointLatitude LongitudeTo:self.discount.pointLongitude];

    NSString *distance = [self.discount getDistanceInMetersLatitudeTo:
                          [NSNumber numberWithDouble:_location.coordinate.latitude]
                                                          LongitudeTo:
                          [NSNumber numberWithDouble:_location.coordinate.longitude]];

    [self.categoryColorIndicatorView setBackgroundColor:color];
    [self.establishmentLabel setText:[NSString stringWithFormat:@"%@ (%@m)", self.discount.establishmentName, distance]];
    [self.discountDescriptionLabel setText:descriptionText];

    self.establishmentLogoImageView.image = [UIImage imageNamed:@"placeimage"];
    self.establishmentLogoImageView.imageURL = [NSURL URLWithString:fullURL];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.establishmentLogoImageView.layer.cornerRadius = 5.0;
    self.establishmentLogoImageView.layer.masksToBounds = YES;
}

@end
