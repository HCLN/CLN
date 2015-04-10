//
//  Discount.h
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData+MagicalRecord.h"

@interface Discount : NSManagedObject

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSNumber *pointLongitude;
@property (nonatomic, retain) NSNumber *pointLatitude;
@property (nonatomic, retain) NSString *images;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSString *establishmentName;
@property (nonatomic, retain) NSString *discountDescription;
@property (nonatomic, retain) NSString *discountType;
@property (nonatomic, retain) NSString *discountCards;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *subCategory;
@property (nonatomic, retain) NSNumber *notified;

- (void)setupFromDictionary:(NSDictionary *)dictionary;
- (NSString *)getLogoPath;

@end
