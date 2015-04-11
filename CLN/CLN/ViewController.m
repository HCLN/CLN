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
    IBOutlet UITableView* discountTable;
    IBOutlet MKMapView* mapView;

    NSArray* allDiscounts;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeMap];
    [self updateData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"NOTIFICATIONS_HAS_BEEN_UPDATED" object:nil];
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

- (NSArray*)getAllDiscounts {
    return [Discount MR_findAll];
}

@end
