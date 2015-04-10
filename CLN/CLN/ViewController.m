//
//  ViewController.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "ViewController.h"
#import "DiscountTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  DiscountTableViewCell* cell = (DiscountTableViewCell*)
      [tableView dequeueReusableCellWithIdentifier:@"DISCOUNT_CELL"];
  if (cell) {
    cell.establishmentLabel.text = @"Musimundo";
    cell.discountDescriptionLabel.text = @"2x1 en electrodomesticos hasta 20hs";
    cell.establishmentLogoImageView.imageURL =
        [NSURL URLWithString:@"http://www.musimundo.com/musica/musimundo.png"];
  }
  return cell;
}

@end
