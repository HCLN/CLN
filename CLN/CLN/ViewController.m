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
@property (strong, nonatomic) IBOutlet UIView *categoriesView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
    searchBar.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];

    UIImage *image = [UIImage imageNamed:@"Logo-Club-La-Nacion-Blanco.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(50, 0, 89, 60);
    [self.navigationController.navigationBar addSubview:imageView];

    self.categoriesView.layer.cornerRadius = 5;
    self.categoriesView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountTableViewCell *cell = (DiscountTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:@"DISCOUNT_CELL"];
    if (cell) {
        cell.establishmentLabel.text = @"Musimundo";
        cell.discountDescriptionLabel.text = @"2x1 en electrodomesticos hasta 20hs";
        cell.establishmentLogoImageView.imageURL =
            [NSURL URLWithString:@"http://www.musimundo.com/musica/musimundo.png"];
    }
    return cell;
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
