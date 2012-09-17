//
//  AppDelegate.m
//  Run
//
//  Created by Al Pascual on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <MapKit/MapKit.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize trackingManager = _trackingManager;

//iCloud info
//http://goddess-gate.com/dc2/index.php/post/452



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // Are we being launched by Maps to show a route?
    if ([MKDirectionsRequest isDirectionsRequestURL:url]) {
        
        // Decode the directions request from the launch URL.
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] initWithContentsOfURL:url];
        MKMapItem *startItem = [request source];
        MKMapItem *endItem = [request destination];
        
//        AGSPoint *startPoint = nil;
//        AGSPoint *endPoint = nil;
        CLLocationCoordinate2D endPoint;
        
        if ([startItem isCurrentLocation]) {
            
            //endPoint = [self convertCoordinatesToPoint:endItem.placemark.coordinate];
            
            // Get directions to end place from current location.
            //            MyPlace *endPlace = [[MyPlace alloc] initWithName:endItem.name coordinate:endItem.placemark.coordinate];
            //            [self.mapViewController routeFromCurrentLocationToPlace:endPlace];
            
        } else if ([endItem isCurrentLocation]) {
            
            //startPoint = [self convertCoordinatesToPoint:startItem.placemark.coordinate];
            
            // Get directions from start place to current location.
            //            MyPlace *startPlace = [[MyPlace alloc] initWithName:startItem.name coordinate:startItem.placemark.coordinate];
            //            [self.mapViewController routeFromPlaceToCurrentLocation:startPlace];
            
        } else {
            
            endPoint = endItem.placemark.coordinate;
            //startPoint = [self convertCoordinatesToPoint:startItem.placemark.coordinate];
            
            // Get directions between the start and end location.
            //            MyPlace *startPlace = [[MyPlace alloc] initWithName:startItem.name coordinate:startItem.placemark.coordinate];
            //            MyPlace *endPlace = [[MyPlace alloc] initWithName:endItem.name coordinate:endItem.placemark.coordinate];
            //            [self.mapViewController routeFromPlace:startPlace toPlace:endPlace];
        }
        
        // Adding a callout to the user and save the point
        // Add a Region Here and show a callout
        CLRegion *myRegion = [[CLRegion alloc] initCircularRegionWithCenter:endPoint radius:2 identifier:@"RunEnd"];
        [SVStatusHUD showWithoutImage:@"Region saved"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:myRegion forKey:@"endPoint"];
        [defaults setObject:endItem forKey:@"endItem"];
        [defaults synchronize];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    UIApplication*    app = [UIApplication sharedApplication];
    NSLog(@"\n\nBackground called!\n\n");
    
    __block UIBackgroundTaskIdentifier bgTask; //Create a task object
    dispatch_block_t expirationHandler;
    expirationHandler = ^{
        
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
        
        
        bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
    };
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
    
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // inform others to stop tasks, if you like
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyApplicationEntersBackground" object:self];
        
        while ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            //NSLog(@"backgroundTimeRemaining: %f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
            
            
            [NSThread sleepForTimeInterval:10.0];  
            
        }   
        
        NSLog(@"\n\n endBackgroundTask going to be calledback \n\n");
        
    }); 
    
    [app endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
