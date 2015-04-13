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

    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _settingsVC = [storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
    _mainVC = [storyboard instantiateViewControllerWithIdentifier:@"mainVC"];

    _container = [MFSideMenuContainerViewController
        containerWithCenterViewController:_mainVC
                   leftMenuViewController:_settingsVC
                  rightMenuViewController:nil];
    self.window.rootViewController = _container;
    [self.window makeKeyAndVisible];

    NSDictionary *categoryDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CategoryColor" ofType:@"plist"]];
    NSArray *allCategories = [[categoryDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];

    NSArray *selectedCategories = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] mutableCopy];
    if (!selectedCategories) {
        selectedCategories = [[NSArray arrayWithArray:allCategories] mutableCopy];
        [[NSUserDefaults standardUserDefaults] setValue:selectedCategories forKey:@"categories"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSNumber *ratio = [[NSUserDefaults standardUserDefaults] objectForKey:@"ratio"];
    if (!ratio) {
        [[NSUserDefaults standardUserDefaults] setValue:
                                                   @3000
                                                 forKey:@"ratio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSettingsMenuButtonTouchUp) name:@"toogleSettingsMenu" object:nil];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"CLN-Model"];

    [self startLocationManager:launchOptions];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartMonitoring) name:@"RATIO_HAS_CHANGE" object:nil];

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

- (void)restartMonitoring {
    [self stopLocationManager];
    [self initLocationManager];
    [self startMonitoringLocationChanges];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self restartMonitoring];
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

        NSNumber *ratio = [[NSUserDefaults standardUserDefaults] objectForKey:@"ratio"];
        [SynchManager updateWithLatitude:latitudeSt Longitude:longitudeSt Distance:[NSString stringWithFormat:@"%f", [ratio floatValue]]];
    }
}

- (CLLocationManager *)sharedLocationManager {
    NSNumber *ratio = [[NSUserDefaults standardUserDefaults] objectForKey:@"ratio"];

    sharedLocationManager = [[CLLocationManager alloc] init];
    sharedLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    sharedLocationManager.activityType = CLActivityTypeOtherNavigation;
    sharedLocationManager.distanceFilter = 100;
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
