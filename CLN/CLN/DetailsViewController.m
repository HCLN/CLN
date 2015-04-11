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
#import "MapAnnotation.h"
#import "ColorCategory.h"
#import "SynchManager.h"

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
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    CLLocation *location;
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
    if ([self.discount.isFavorite isEqual:[NSNumber numberWithBool:YES]]) {
        favImage = [UIImage imageNamed:@"like-filled"];
    }
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

    if ([self.discount.discountCards isEqualToString:@"Premium"]) {
        [classicCard setImage:[UIImage imageNamed:@"premium_card"]];
    } else if ([self.discount.discountCards isEqualToString:@"Classic"]) {
        [classicCard setImage:[UIImage imageNamed:@"classic_card"]];
    } else {
        [premiumCard setImage:[UIImage imageNamed:@"premium_card"]];
        [classicCard setImage:[UIImage imageNamed:@"classic_card"]];
    }

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

    [self initializeMap];
    [self initializeLocationManager];
    [self addAnnotationToMap];
}

- (void)addToFavorite:(id)sender {
    if ([self.discount.isFavorite isEqual:[NSNumber numberWithBool:YES]]) {
        self.discount.isFavorite = [NSNumber numberWithBool:NO];
        [favsButton setImage:[UIImage imageNamed:@"like"]];
    } else {
        self.discount.isFavorite = [NSNumber numberWithBool:YES];
        [favsButton setImage:[UIImage imageNamed:@"like-filled"]];
    }
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
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

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    location = newLocation;
    [SynchManager updateWithLatitude:[NSString stringWithFormat:@"%f", location.coordinate.latitude]
                           Longitude:[NSString stringWithFormat:@"%f", location.coordinate.longitude]
                            Distance:@"3000"];
    if (location != nil) {
        [self centerMap:location radius:2000];
        [locationManager stopUpdatingLocation];
    }
}

#pragma mark Map

- (void)initializeMap {
    mapView.delegate = self;
    [mapView setShowsUserLocation:YES];
}

- (void)initializeLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [locationManager startUpdatingLocation];
}

- (void)centerMap:(CLLocation *)centerLocation radius:(NSInteger)radius {
    if (location)
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, radius, radius) animated:YES];
}

- (void)addAnnotationToMap {
    [self centerMap:location radius:2000];

    [mapView removeAnnotations:mapView.annotations];

    MapAnnotation *ann = [[MapAnnotation alloc] init];
    ann.discount = self.discount;
    ann.title = self.discount.establishmentName;
    ann.subtitle = [NSString stringWithFormat:@"%@ %@", self.discount.discountType, self.discount.discountDescription];
    ann.coordinate = CLLocationCoordinate2DMake([self.discount.pointLatitude floatValue], [self.discount.pointLongitude floatValue]);
    ann.color = [ColorCategory colorForCategory:self.discount.category];

    [mapView addAnnotation:ann];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation class] == [MapAnnotation class]) {
        MapAnnotation *ann = (MapAnnotation *)annotation;
        MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        UIImage *image = [self pinImageForCategory:ann.discount.category];
        annView.annotation = annotation;
        annView.image = image;
        return annView;
    }
    return nil;
}

- (UIImage *)pinImageForCategory:(NSString *)categoryName {
    return [ColorCategory pinForCategory:categoryName];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
