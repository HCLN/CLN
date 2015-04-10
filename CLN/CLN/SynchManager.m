//
//  SynchManager.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "SynchManager.h"
#import "URLManager.h"
#import "Discount.h"
#import "AFNetworking.h"

@implementation SynchManager

+ (void)update {
    NSString *apiURL = [URLManager apiURL];

    NSString *latitude = @"-34.5332422";
    NSString *longitude = @"-58.4672752";
    NSString *distance = @"1200";
    NSString *url = [NSString stringWithFormat:apiURL, latitude, longitude, distance];
    //NSString *url = @"http://localhost:8888/lala.json";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        for (NSMutableDictionary *discountObject in responseObject) {
            NSString* identifier = [discountObject objectForKey:@"id"];
            BOOL exists = ([[Discount MR_findByAttribute:@"identifier" withValue:identifier] count] > 0);
            if(!exists) {
                Discount* discount = [Discount MR_createEntity];
                discount.notified = [NSNumber numberWithBool:YES];
                [discount setupFromDictionary:discountObject];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATIONS_HAS_BEEN_UPDATED" object:nil];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
