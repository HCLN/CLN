//
//  DetailsViewController.h
//  CLN
//
//  Created by Developer on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Discount.h"
#import <MapKit/MapKit.h>

@interface DetailsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) Discount* discount;

@end
