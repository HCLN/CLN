//
//  FavoritesViewController.m
//  CLN
//
//  Created by Developer on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesTableViewCell.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesTableViewCell *cell = (FavoritesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FAVS_CELL" forIndexPath:indexPath];
    if (cell) {
        cell.establishmentLabel.text = @"Musimundo";
        cell.discountDescriptionLabel.text = @"2x1 en electrodomesticos hasta 20hs";
        cell.establishmentLogoImageView.imageURL =
            [NSURL URLWithString:@"http://www.musimundo.com/musica/musimundo.png"];
    }
    return cell;
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
