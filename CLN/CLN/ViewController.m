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

@interface ViewController () {
    IBOutlet UITableView *discountTable;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *categoriesView;

    NSArray *allDiscounts;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeMap];
    [self updateData];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
    searchBar.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"NOTIFICATIONS_HAS_BEEN_UPDATED" object:nil];
    UIImage *image = [UIImage imageNamed:@"Logo-Club-La-Nacion-Blanco.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(50, 0, 89, 60);
    [self.navigationController.navigationBar addSubview:imageView];

    categoriesView.layer.cornerRadius = 5;
    categoriesView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initializeMap {
    mapView.delegate = self;
    [mapView setShowsUserLocation:YES];
}

- (void)centerMap {
    //    if (!delegate.lastLocation)
    //        return;
    //    [mapView setRegion:MKCoordinateRegionMakeWithDistance(delegate.lastLocation.coordinate, 2000, 2000) animated:YES];

    //    MapAnnotation* ann = [[MapAnnotation alloc] init];
    //    ann.title = @"Musimundo";
    //    ann.subtitle = @"2x1 en electrodomesticos";
    //    ann.coordinate = delegate.lastLocation.coordinate;
    //
    //    [mapView removeAnnotations:mapView.annotations];
    //    [mapView addAnnotation:ann];
}

- (void)updateData {
    allDiscounts = [self getAllDiscounts];
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountTableViewCell *cell = (DiscountTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:@"DISCOUNT_CELL"];
    if (cell) {
        [cell configureWithDiscount:[allDiscounts objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (NSArray *)getAllDiscounts {
    return [Discount MR_findAll];
}

- (IBAction)toogleSettingsMenu:(id)sender {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"toogleSettingsMenu"
                      object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
