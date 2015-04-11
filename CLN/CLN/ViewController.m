//
//  ViewController.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "ViewController.h"
#import "Discount.h"
#import "DiscountTableViewCell.h"
#import "MapAnnotation.h"
#import "ColorCategory.h"
#import "DetailsViewController.h"
#import "SynchManager.h"

#import <CoreLocation/CoreLocation.h>

@interface ViewController () {
    IBOutlet UITableView *discountTable;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *categoriesView;

    UISearchBar *searchBar;

    CLLocationManager *locationManager;

    NSArray *allDiscounts;
    CLLocation *location;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSearch)];

    [gestureRecognizer setCancelsTouchesInView:NO];

    [self.view addGestureRecognizer:gestureRecognizer];

    [self initializeMap];
    [self initializeLocationManager];

    [self updateData];

    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
    searchBar.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];

    categoriesView.layer.cornerRadius = 5;
    categoriesView.layer.masksToBounds = YES;

    UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@"Volver"
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
    [newBackButton setTintColor:[UIColor whiteColor]];
    [[self navigationItem] setBackBarButtonItem:newBackButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"NOTIFICATIONS_HAS_BEEN_UPDATED" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"CATEGORIES_HAS_CHANGED" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    UIImage *image = [UIImage imageNamed:@"Logo-Club-La-Nacion-Blanco.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(50, 0, 89, 60);
    [imageView setTag:666];
    [self.navigationController.navigationBar addSubview:imageView];
}

- (void)updateData {
    allDiscounts = [self getAllDiscounts];
    [self addAnnotationsToMap:allDiscounts];
    [discountTable reloadData];
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return [allDiscounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountTableViewCell *cell = (DiscountTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:@"DISCOUNT_CELL" forIndexPath:indexPath];
    if (cell) {
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.establishmentLogoImageView];
        cell.location = location;
        [cell configureWithDiscount:[allDiscounts objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountTableViewCell *cell = (DiscountTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];

    [self performSegueWithIdentifier:@"DETAILS_SEGUE" sender:cell.discount];
}

- (NSArray *)getAllDiscounts {
    NSArray *selectedArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
    NSDate *now = [NSDate date];
    return [Discount MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"category IN %@ AND startDate<= %@ AND endDate >= %@", selectedArray, now, now]];
}

- (IBAction)toogleSettingsMenu:(id)sender {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"toogleSettingsMenu"
                      object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    location = newLocation;
    [SynchManager updateWithLatitude:[NSString stringWithFormat:@"%f", location.coordinate.latitude]
                           Longitude:[NSString stringWithFormat:@"%f", location.coordinate.longitude]
                            Distance:@"3000"];

    [self onBtLocationTouchDown:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)mySearchBar
    textDidChange:(NSString *)searchText {
    allDiscounts = [self filterListForSearchedText:searchText];
    [self addAnnotationsToMap:allDiscounts];
    [discountTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)mySearchBar {
    NSLog(@"cancel");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)mySearchBar {
    NSLog(@"searchBarSearchButtonClicked");
    [mySearchBar resignFirstResponder];
}

- (void)cancelSearch {
    [searchBar resignFirstResponder];
}

- (NSArray *)filterListForSearchedText:(NSString *)text {
    NSArray *filteredValues = [self getAllDiscounts];
    if ([text isEqualToString:@""])
        return filteredValues;

    return [filteredValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.establishmentName CONTAINS[cd] %@", text]];
}

#pragma mark Map
- (IBAction)onBtLocationTouchDown:(id)sender {
    if (location != nil) {
        [self centerMap:location radius:2000];
        [locationManager stopUpdatingLocation];
    }
}

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

- (void)addAnnotationsToMap:(NSArray *)discountArray {
    [mapView removeAnnotations:mapView.annotations];

    for (Discount *discount in discountArray) {
        MapAnnotation *ann = [[MapAnnotation alloc] init];
        ann.discount = discount;
        ann.title = discount.establishmentName;
        ann.subtitle = [NSString stringWithFormat:@"%@ %@", discount.discountType, discount.discountDescription];
        ann.coordinate = CLLocationCoordinate2DMake([discount.pointLatitude floatValue], [discount.pointLongitude floatValue]);
        ann.color = [ColorCategory colorForCategory:discount.category];

        [mapView addAnnotation:ann];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DETAILS_SEGUE"]) {
        DetailsViewController *detVC = [segue destinationViewController];
        detVC.discount = (Discount *)sender;
    }
}

#pragma MARK - Categories
- (IBAction)onBtCategoriesTouchDown:(id)sender {
    [self performSegueWithIdentifier:@"OPEN_SETTINGS_SEGUE" sender:self];
}

@end
