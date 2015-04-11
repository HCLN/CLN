//
//  FavoritesViewController.m
//  CLN
//
//  Created by Developer on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesTableViewCell.h"
#import "Discount.h"

@interface FavoritesViewController () {
    IBOutlet UITableView *table;

    NSArray *arrDiscounts;
}

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrDiscounts = [Discount MR_findByAttribute:@"isFavorite" withValue:[NSNumber numberWithBool:YES]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    arrDiscounts = [Discount MR_findByAttribute:@"isFavorite" withValue:[NSNumber numberWithBool:YES]];
    [table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrDiscounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesTableViewCell *cell = (FavoritesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FAVS_CELL" forIndexPath:indexPath];
    if (cell) {
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.establishmentLogoImageView];
        [cell configureWithDiscount:[arrDiscounts objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesTableViewCell *cell = (FavoritesTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];

    [self performSegueWithIdentifier:@"DETAIL_FAV_SEGUE" sender:cell.discount];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DETAIL_FAV_SEGUE"]) {
        FavoritesTableViewCell *detVC = [segue destinationViewController];
        detVC.discount = (Discount *)sender;
    }
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
