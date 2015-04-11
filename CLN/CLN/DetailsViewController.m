//
//  DetailsViewController.m
//  CLN
//
//  Created by Developer on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "DetailsViewController.h"
#import "AsyncImageView.h"
#import "URLManager.h"
#import <MapKit/MapKit.h>

@interface DetailsViewController () {
    IBOutlet AsyncImageView *logoImage;
    IBOutlet UILabel *establishmentLabel;
    IBOutlet UILabel *discountTypeLabel;
    IBOutlet UILabel *discountDescLabel;
    IBOutlet UIImageView *classicCard;
    IBOutlet UIImageView *premiumCard;
    IBOutlet UIButton *carLocationButton;
    IBOutlet UIButton *walkLocationButton;
    IBOutlet UILabel *remainderLabel;
    IBOutlet UIButton *termsButton;
    UIBarButtonItem *favsButton;
}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if (view.tag == 666) {
            [view removeFromSuperview];
        }
    }

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UIImage *favImage = [UIImage imageNamed:@"like.png"];
    UIButton *favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favBtn.bounds = CGRectMake(0, 0, favImage.size.width, favImage.size.height);
    [favBtn setImage:favImage forState:UIControlStateNormal];
    favsButton = [[UIBarButtonItem alloc] initWithImage:favImage style:UIBarButtonItemStylePlain target:self action:@selector(addToFavorite:)];

    UIImage *shareImage = [UIImage imageNamed:@"share.png"];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.bounds = CGRectMake(0, 0, shareImage.size.width, shareImage.size.height);
    [shareBtn setImage:shareImage forState:UIControlStateNormal];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(addToFavorite:)];

    NSArray *myButtonArray = [[NSArray alloc] initWithObjects:favsButton, shareButton, nil];
    self.navigationItem.rightBarButtonItems = myButtonArray;

    //

    NSString *fullURL = [NSString stringWithFormat:@"%@%@", [URLManager baseImagesURL], [self.discount getLogoPath]];
    logoImage.imageURL = [NSURL URLWithString:fullURL];
    logoImage.layer.cornerRadius = 10;
    logoImage.layer.masksToBounds = YES;
    logoImage.layer.shadowColor = [[UIColor grayColor] CGColor];
    logoImage.layer.shadowOffset = CGSizeMake(0, 1);
    logoImage.layer.shadowOpacity = 1;
    logoImage.layer.shadowRadius = 1.0;
    logoImage.clipsToBounds = NO;

    [establishmentLabel setText:self.discount.establishmentName];

    [discountTypeLabel setText:self.discount.discountType];

    [discountDescLabel setText:self.discount.discountDescription];

    // TODO: tarjetas
    if ([self.discount.discountCards isEqualToString:@"Premium"]) {
        [classicCard setImage:[UIImage imageNamed:@"premium_card"]];
    } else if ([self.discount.discountCards isEqualToString:@"Classic"]) {
        [classicCard setImage:[UIImage imageNamed:@"classic_card"]];
    } else {
        [premiumCard setImage:[UIImage imageNamed:@"premium_card"]];
        [classicCard setImage:[UIImage imageNamed:@"classic_card"]];
    }

    // TODO: remainderlabel
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate date]
                                                          toDate:self.discount.endDate
                                                         options:0];
    NSString *remainderText = @"-";
    if (components.day > 1) {
        remainderText = [NSString stringWithFormat:@"%ld días", (long)components.day];
    } else if (components.day <= 1) {
        components = [gregorianCalendar components:NSHourCalendarUnit
                                          fromDate:[NSDate date]
                                            toDate:self.discount.endDate
                                           options:0];
        NSString *hs = @"horas";
        if (components.hour == 1) {
            hs = @"hora";
        }
        remainderText = [NSString stringWithFormat:@"%ld %@", (long)components.hour, hs];
    }

    [remainderLabel setText:remainderText];
}

- (void)addToFavorite:(id)sender {
    [favsButton setImage:[UIImage imageNamed:@"like-filled"]];
    //    [favsButton setImage:[UIImage imageNamed:@"like"]];
}

- (void)shareDiscount:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCarLocationClick:(id)sender {
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.discount.pointLatitude doubleValue], [self.discount.pointLongitude doubleValue]) addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:place];
    destination.name = self.discount.establishmentName;
    NSArray *items = [[NSArray alloc] initWithObjects:destination, nil];
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      MKLaunchOptionsDirectionsModeDriving,
                                                      MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

- (IBAction)onWalkLocationClick:(id)sender {
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.discount.pointLatitude doubleValue], [self.discount.pointLongitude doubleValue]) addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:place];
    destination.name = self.discount.establishmentName;
    NSArray *items = [[NSArray alloc] initWithObjects:destination, nil];
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      MKLaunchOptionsDirectionsModeWalking,
                                                      MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
