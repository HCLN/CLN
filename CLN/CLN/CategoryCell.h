//
//  CategoryCell.h
//  CLN
//
//  Created by Pablo Castarataro on 4/11/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel* categoryNameLabel;
@property (nonatomic, retain) IBOutlet UIView* categoryActiveIndicator;

@end
