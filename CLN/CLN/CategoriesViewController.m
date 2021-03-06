//
//  CategoriesViewController.m
//  CLN
//
//  Created by Pablo Castarataro on 4/11/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoryCell.h"
#import "ColorCategory.h"

@interface CategoriesViewController () {
    NSArray *allCategories;
    NSMutableArray *selectedCategories;

    IBOutlet UISlider *slider;
    IBOutlet UILabel *radioLabel;
}

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *categoryDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CategoryColor" ofType:@"plist"]];
    allCategories = [[categoryDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    selectedCategories = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] mutableCopy];

    slider.value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ratio"] floatValue];
    [radioLabel setText:[NSString stringWithFormat:@"%0.fm", slider.value]];
}

- (void)cancelCategories:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:@"CATEGORY_CELL" forIndexPath:indexPath];
    if (cell) {
        NSString *categoryName = [allCategories objectAtIndex:indexPath.row];
        cell.categoryNameLabel.text = categoryName;
        cell.categoryActiveIndicator.backgroundColor = [ColorCategory colorForCategory:categoryName];
        cell.categoryActiveIndicator.layer.borderColor = [[ColorCategory colorForCategory:categoryName] CGColor];

        BOOL s = [self array:selectedCategories containts:categoryName];
        if (s)
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *removedCategory = [allCategories objectAtIndex:indexPath.row];
    [selectedCategories removeObject:removedCategory];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *addedCategory = [allCategories objectAtIndex:indexPath.row];
    [selectedCategories addObject:addedCategory];
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setValue:selectedCategories forKey:@"categories"];

    if (slider.value != [[[NSUserDefaults standardUserDefaults] objectForKey:@"ratio"] floatValue]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RATIO_HAS_CHANGE" object:selectedCategories];
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:slider.value] forKey:@"ratio"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"CATEGORIES_HAS_CHANGED" object:selectedCategories];
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self save];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)array:(NSArray *)arr containts:(NSString *)category {
    for (NSString *st in arr) {
        if ([st isEqualToString:category])
            return YES;
    }
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)onSliderValueChanged:(UISlider *)sender {
    [radioLabel setText:[NSString stringWithFormat:@"%0.fm", sender.value]];
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
