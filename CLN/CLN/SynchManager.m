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

+ (void)updateWithLatitude:(NSString *)latitude Longitude:(NSString *)longitude Distance:(NSString *)distance {
    NSString *apiURL = [URLManager apiURL];
    NSString *url = [NSString stringWithFormat:apiURL, latitude, longitude, distance];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSInteger count = 0;
        for (NSMutableDictionary *discountObject in responseObject) {
            NSString* identifier = [discountObject objectForKey:@"id"];
            BOOL exists = ([[Discount MR_findByAttribute:@"identifier" withValue:identifier] count] > 0);
            if(!exists) {
                Discount* discount = [Discount MR_createEntity];
                discount.notified = [NSNumber numberWithBool:YES];
                [discount setupFromDictionary:discountObject];
                count ++;
            }
        }
        if(count > 0) {
            // mando notificacion
            NSLog(@"6");
            NSString* message = [NSString stringWithFormat:@"Tienes %ld beneficios cerca!", count];
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            [notification setAlertBody:message];
            [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            [notification setTimeZone:[NSTimeZone defaultTimeZone]];
            [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATIONS_HAS_BEEN_UPDATED" object:nil];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
