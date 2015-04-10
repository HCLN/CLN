//
//  DiscountTableViewCell.h
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Discount.h"
#import "AsyncImageView.h"

@interface DiscountTableViewCell : UITableViewCell

@property (nonatomic, retain) Discount* discount;

@property (nonatomic, retain) IBOutlet UIView* categoryColorIndicatorView;
@property (nonatomic, retain) IBOutlet UILabel* discountDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel* establishmentLabel;
@property (nonatomic, retain) IBOutlet AsyncImageView* establishmentLogoImageView;

- (void)configureWithDiscount:(Discount*)discount;

@end
