//
//  TrackingManager.m
//  PolioTraker
//
//  Created by Al Pascual on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackingManager.h"


@implementation TrackingManager

@synthesize locMgr = _locMgr;
@synthesize gpsTimer = _gpsTimer;
@synthesize DistancePoints = _DistancePoints;
@synthesize gpsTotals = _gpsTotals;
@synthesize timerForEditing = _timerForEditing;
@synthesize bStarted = _bStarted;
@synthesize submitInterval = _submitInterval;
@synthesize lastLocation = _lastLocation;
@synthesize uniqueID = _uniqueID;
@synthesize database = _database;



- (void) startUpTracking
{   
    // Set up GPS for tracking with the best settings    
    self.locMgr = [[CLLocationManager alloc] init]; // Create new instance of locMgr
    self.locMgr.delegate = self; // Set the delegate as self.
    
    self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locMgr.distanceFilter = 1.0f;
         
    [self.locMgr startUpdatingLocation];
    
    self.DistancePoints = [[NSMutableArray alloc] init];
    self.gpsTotals = [[GpsTotals alloc] init];
    self.gpsTotals.altitudeMax = 0;
    self.gpsTotals.altitudeMin = 9999;
    
    self.database = [[GpsDatabaseManager alloc] init];    
}

- (void) stopTracking
{
    [self.locMgr stopUpdatingLocation];
    //self.DistancePoints = nil;
    //self.gpsTotals = nil;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    
    if ( self.bStarted == NO )
        return;
    
    NSTimeInterval ageInSeconds = [newLocation.timestamp timeIntervalSinceNow];
    
    //ensure you have an accurate and non-cached reading in meters 500 and in seconds 10
    if( newLocation.horizontalAccuracy > 500.0 || fabs(ageInSeconds) > 10 )
        return;
   
    NSLog(@"GPS Point %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"Accuracy %f", newLocation.horizontalAccuracy);
    NSLog(@"Elevation %f", newLocation.altitude);
    NSLog(@"Speed in miles %f", (newLocation.speed * 2.2369));
    
    
    // Send the gps x = long and y = lat to the server
    [self submitPoint:newLocation];    
   
    self.lastLocation = newLocation;
    
}


- (void) submitPoint:(CLLocation *) newPoint {
    DistancePoint *mypoint = [[DistancePoint alloc] init];
    mypoint.point = newPoint;
    if ( self.lastLocation != nil ) {
        CLLocationDistance dist = [newPoint distanceFromLocation:self.lastLocation];
        double kilometers = dist / 1000;
        NSLog(@"kilometers %f", kilometers);
        mypoint.distanceFrom = kilometers * 0.6213711922;
        NSLog(@"miles %f", mypoint.distanceFrom);
        self.gpsTotals.distanceTotal += mypoint.distanceFrom;
    }
    else {
        mypoint.distanceFrom = 0;
        self.gpsTotals.distanceTotal = 0;
    }
    
    NSLog(@"distance for this point %f", mypoint.distanceFrom);
    NSLog(@"Total distance %f", self.gpsTotals.distanceTotal);
    
    // Set the max altitude
    if ( newPoint.altitude > self.gpsTotals.altitudeMax )
        self.gpsTotals.altitudeMax = newPoint.altitude;
    if ( newPoint.altitude < self.gpsTotals.altitudeMin )
        self.gpsTotals.altitudeMin = newPoint.altitude;
        
    mypoint.altitude = newPoint.altitude;
    
    // Make sure we don't get bad points
    if ( newPoint.speed > 0 ) {
        self.gpsTotals.speed = newPoint.speed;
        self.gpsTotals.avgSpeed += newPoint.speed;
    }
    
    self.gpsTotals.altitude = newPoint.altitude;
    self.gpsTotals.accuracy = newPoint.horizontalAccuracy;
    
    [self.DistancePoints addObject:mypoint];
    NSLog(@"Total points %d",self.DistancePoints.count);
    
    // Save into the database
    [self.database addPoint:newPoint :self.gpsTotals.uniqueID :mypoint :self.gpsTotals];
}

- (void)timerRestartGPS:(NSTimer *)timer 
{
    [self.gpsTimer invalidate];
    self.gpsTimer = nil;
    
    // Check GPS again
    [self.locMgr startUpdatingLocation];
    
}

/*Used to specify the accuracy level desired. The location service will try its best to achieve
 *    your desired accuracy. However, it is not guaranteed. To optimize
 *    power performance, be sure to specify an appropriate accuracy for your usage scenario (eg,
 *    use a large accuracy value when only a coarse location is needed).
 
 extern const CLLocationAccuracy kCLLocationAccuracyBestForNavigation __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
 extern const CLLocationAccuracy kCLLocationAccuracyBest;
 extern const CLLocationAccuracy kCLLocationAccuracyNearestTenMeters;
 extern const CLLocationAccuracy kCLLocationAccuracyHundredMeters;
 extern const CLLocationAccuracy kCLLocationAccuracyKilometer;
 extern const CLLocationAccuracy kCLLocationAccuracyThreeKilometers;*/
- (void) changeDesiredAccuracy:(CLLocationAccuracy) accuracy{
    self.locMgr.desiredAccuracy = accuracy;
    
    NSLog(@"Accuracy %f", accuracy);
    
    [self.locMgr stopUpdatingLocation];
    [self.locMgr startUpdatingLocation];
}


//The following was adapted from the Rechability Apple sample
-(BOOL) validNetworkConnection
{
    struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
    
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    
    SCNetworkReachabilityFlags flags = 0;
    Boolean bFlagsValid = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!bFlagsValid)
        return NO;
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
	{
		// if target host is not reachable
		return NO;//NotReachable;
	}
    
	BOOL retVal = NO;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
	{
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		retVal = YES;
	}
	
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            retVal = YES;
        }
    }
	
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
	{
		// ... but WWAN connections are OK if the calling application
		//     is using the CFNetwork (CFSocketStream?) APIs.
		retVal = YES;
	}
    
	return retVal;
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    NSLog(@"Did Enter Region");
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Arrived" message:@"You have arrived to your destination" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
}

@end
