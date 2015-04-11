//
//  Discount.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "Discount.h"

@implementation Discount

@dynamic identifier;
@dynamic pointLongitude;
@dynamic pointLatitude;
@dynamic images;
@dynamic startDate;
@dynamic endDate;
@dynamic establishmentName;
@dynamic discountDescription;
@dynamic discountType;
@dynamic discountCards;
@dynamic category;
@dynamic subCategory;
@dynamic notified;
@dynamic isFavorite;

- (void)setupFromDictionary:(NSDictionary*)dictionary {
    NSArray* point = [dictionary objectForKey:@"point"];
    NSDictionary* benfit = [dictionary objectForKey:@"beneficio"];

    NSString* identifier = [dictionary objectForKey:@"id"];
    NSString* category = [benfit objectForKey:@"categoria"];
    NSString* subCategory = [benfit objectForKey:@"subcategoria"];
    NSString* from = [dictionary objectForKey:@"desde"];
    NSString* to = [dictionary objectForKey:@"hasta"];

    NSString* images = [dictionary objectForKey:@"imagen"];
    NSString* name = [benfit objectForKey:@"nombre"];
    NSString* type = [benfit objectForKey:@"tipo"];
    NSString* benfitDescription = [benfit objectForKey:@"descripcion"];
    NSString* cards = [benfit objectForKey:@"tarjeta"];
    NSNumber* latitude = [point objectAtIndex:0];
    NSNumber* longitude = [point objectAtIndex:1];

    self.identifier = identifier;
    self.category = category;
    self.subCategory = subCategory;
    self.startDate = [self parseDateString:from];
    self.endDate = [self parseDateString:to];
    self.images = images;
    self.establishmentName = name;
    self.discountType = type;
    self.discountDescription = benfitDescription;
    self.discountCards = cards;
    self.pointLatitude = latitude;
    self.pointLongitude = longitude;
}

- (NSString*)getLogoPath {
    NSArray* parsedImages = [self.images componentsSeparatedByString:@"-"];
    for (NSString* imageDetail in parsedImages) {
        if ([imageDetail containsString:@":Tipo=7:"]) {
            parsedImages = [imageDetail componentsSeparatedByString:@":"];
            if ([parsedImages count] > 0) {
                parsedImages = [[parsedImages objectAtIndex:0] componentsSeparatedByString:@"="];
                if ([parsedImages count] == 2) {
                    return [parsedImages objectAtIndex:1];
                }
            }
        }
    }
    return nil;
}

- (NSDate*)parseDateString:(NSString*)dateString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [formatter dateFromString:dateString];
}

@end
