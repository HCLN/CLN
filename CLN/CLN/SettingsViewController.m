//
//  SettingsViewController.m
//  CLN
//
//  Created by Developer on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"

@interface SettingsViewController () {
    NSArray *options;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    options = @[ @"Favoritos", @"Notificaciones" ];
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
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTableViewCell *cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SETTINGS_CELL" forIndexPath:indexPath];
    if (cell) {
        if (indexPath.row == 0) {
            [cell.iconoImage setImage:[UIImage imageNamed:@"star_icon"]];
        } else {
            [cell.iconoImage setImage:[UIImage imageNamed:@"notification_icon"]];
        }
        [cell.settingLabel setText:[options objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"SHOW_FAVS_SEGUE" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"SHOW_NOTIF_SEGUE" sender:self];
            break;
        default:
            break;
    }
}

@end
