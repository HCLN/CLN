//
//  AppDelegate.m
//  CLN
//
//  Created by Pablo Castarataro on 4/10/15.
//  Copyright (c) 2015 TBH. All rights reserved.
//

#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "SynchManager.h"
#import "Discount.h"

@interface AppDelegate () {
    CLLocationManager *sharedLocationManager;
}

@property (nonatomic, retain) UIViewController *settingsVC;
@property (nonatomic, retain) UIViewController *mainVC;
@property (nonatomic, retain) MFSideMenuContainerViewController *container;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _settingsVC = [storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
    _mainVC = [storyboard instantiateViewControllerWithIdentifier:@"mainVC"];

    _container = [MFSideMenuContainerViewController
        containerWithCenterViewController:_mainVC
                   leftMenuViewController:_settingsVC
                  rightMenuViewController:nil];
    self.window.rootViewController = _container;
    [self.window makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSettingsMenuButtonTouchUp) name:@"toogleSettingsMenu" object:nil];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"CLN-Model"];

    [self startLocationManager:launchOptions];

    return YES;
}

- (void)onSettingsMenuButtonTouchUp {
    [self.container toggleLeftSideMenuCompletion:^{
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];

    [self stopLocationManager];
    [self startMonitoringLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self stopLocationManager];
    [self initLocationManager];
    [self startMonitoringLocationChanges];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    [MagicalRecord cleanUp];
}

#pragma mark Location

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    NSLog(@"locationManager didUpdateLocations: %@", locations);

    NSUInteger count = [locations count];
    if (count > 0) {
        CLLocation *lastLocation = [locations objectAtIndex:0];
        NSString *latitudeSt = [NSString stringWithFormat:@"%f", lastLocation.coordinate.latitude];
        NSString *longitudeSt = [NSString stringWithFormat:@"%f", lastLocation.coordinate.longitude];

        [SynchManager updateWithLatitude:latitudeSt Longitude:longitudeSt Distance:@"3000"];
    }
}

- (CLLocationManager *)sharedLocationManager {
    sharedLocationManager = [[CLLocationManager alloc] init];
    sharedLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    sharedLocationManager.activityType = CLActivityTypeOtherNavigation;
    sharedLocationManager.distanceFilter = 1500; // each 1500 mtrs
    return sharedLocationManager;
}

- (void)startLocationManager:(NSDictionary *)launchOptions {
    UIAlertView *alert = nil;
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
