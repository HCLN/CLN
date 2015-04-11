//
//  AppDelegate.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "AppDelegate.h"
#import "SynchManager.h"
#import "Discount.h"

@interface AppDelegate () {
    CLLocationManager* sharedLocationManager;
}

@property (nonatomic, retain) UIViewController *settingsVC;
@property (nonatomic, retain) UIViewController *mainVC;
@property (nonatomic, retain) MFSideMenuContainerViewController *container;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"CLN-Model"];

    //    Discount* d1 = [Discount MR_createEntity];
    //    d1.identifier = @"ident1";
    //    d1.category = @"Gastronomia";
    //    d1.discountCards = @"Classic-Premium";
    //    d1.discountDescription = @"Sobre el total de tu factura";
    //    d1.discountType = @"20%";
    //    d1.startDate = [NSDate date];
    //    d1.endDate = [NSDate date];
    //    d1.establishmentName = @"Enogarage";
    //    d1.notified = [NSNumber numberWithBool:NO];
    //    d1.pointLatitude = @-34.53449;
    //    d1.pointLongitude = @-58.46757;
    //    d1.subCategory = @"Compras Gastronómicas";
    //    d1.images = @"nombre=50106.jpg:Tipo=7:Great=0-nombre=50107.jpg:Tipo=13:Great=1-nombre=50108.jpg:Tipo=13:Great=0-nombre=50109.jpg:Tipo=13:Great=0-nombre=50110.jpg:Tipo=13:Great=0-nombre=50111.jpg:Tipo=13:Great=0";

    [SynchManager update];

    [self startLocationManager:launchOptions];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application {
}

- (void)applicationDidEnterBackground:(UIApplication*)application {
    [self stopLocationManager];
    [self startMonitoringLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication*)application {
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
    [self stopLocationManager];
    [self initLocationManager];
    [self startMonitoringLocationChanges];
}

- (void)applicationWillTerminate:(UIApplication*)application {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    [MagicalRecord cleanUp];
}

#pragma mark Location

- (void)locationManager:(CLLocationManager*)manager
     didUpdateLocations:(NSArray*)locations {
    NSLog(@"locationManager didUpdateLocations: %@", locations);

    NSUInteger count = [locations count];
    if (count > 0) {
        CLLocation* newLocation = [locations objectAtIndex:count - 1];
        _lastLocation = newLocation;

        [SynchManager update];
    }
}

- (CLLocationManager*)sharedLocationManager {
    sharedLocationManager = [[CLLocationManager alloc] init];
    sharedLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    sharedLocationManager.activityType = CLActivityTypeOtherNavigation;
    sharedLocationManager.distanceFilter = 1500; // each 1500 mtrs
    return sharedLocationManager;
}

- (void)startLocationManager:(NSDictionary*)launchOptions {
    UIAlertView* alert = nil;
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        alert = [[UIAlertView alloc]
                initWithTitle:@""
                      message:@"La aplicación requiere actualizar en segundo plano. Para activarlo ve a Ajustes > General > Actualización en segundo plano"
                     delegate:nil
            cancelButtonTitle:@"Ok"
            otherButtonTitles:nil, nil];
        [alert show];
    } else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        alert = [[UIAlertView alloc]
                initWithTitle:@""
                      message:@"Las funciones de esta aplicación son limitados debido a las actualizaciones en segundo plano están desactivadas."
                     delegate:nil
            cancelButtonTitle:@"Ok"
            otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
            [self initLocationManager];
            [self startMonitoringLocationChanges];
        }
    }
}

- (void)initLocationManager {
    sharedLocationManager = [self sharedLocationManager];
    sharedLocationManager.delegate = self;
}

- (void)startMonitoringLocationChanges {
    if (IS_OS_8_OR_LATER) {
        [sharedLocationManager requestAlwaysAuthorization];
    }

    [sharedLocationManager startMonitoringSignificantLocationChanges];
}

- (void)stopLocationManager {
    if (sharedLocationManager)
        [sharedLocationManager stopMonitoringSignificantLocationChanges];
}

@end
