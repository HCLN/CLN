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
    UIBarButtonItem *favsButton = [[UIBarButtonItem alloc] initWithImage:favImage style:UIBarButtonItemStylePlain target:self action:@selector(addToFavorite:)];

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

    // TODO: car y walk location button

    // TODO: remainderlabel
}

- (void)addToFavorite:(id)sender {
}

- (void)shareDiscount:(id)sender {
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

@end
