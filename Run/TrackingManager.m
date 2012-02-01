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


@synthesize timerForEditing = _timerForEditing;
//@synthesize checkOnlineAvailableTimer = _checkOnlineAvailableTimer;
@synthesize submitInterval = _submitInterval;
@synthesize lastLocation = _lastLocation;



- (void) startUpTracking
{   
    // Set up GPS for tracking with the best settings    
    self.locMgr = [[CLLocationManager alloc] init]; // Create new instance of locMgr
    self.locMgr.delegate = self; // Set the delegate as self.
    
    self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locMgr.distanceFilter = 1.0f;
         
    [self.locMgr startUpdatingLocation];
    
    
}

- (void) stopTracking
{
    [self.locMgr stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    
    NSTimeInterval ageInSeconds = [newLocation.timestamp timeIntervalSinceNow];
    
    //ensure you have an accurate and non-cached reading in meters 500 and in seconds 10
    if( newLocation.horizontalAccuracy > 500.0 || fabs(ageInSeconds) > 10 )
        return;
   
    NSLog(@"GPS Point %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"Accuracy %f", newLocation.horizontalAccuracy);
    NSLog(@"Elevation %f", newLocation.altitude);
    NSLog(@"Speed in miles %f", (newLocation.speed * 2.2369));
    
    self.lastLocation = newLocation;
    // Send the gps x = long and y = lat to the server
    [self submitPoint:newLocation];    
   
    
}


- (void) submitPoint:(CLLocation *) newPoint {
   
    
    /*if ( [self validNetworkConnection] == YES ) {
        
        NSUserDefaults *myPrefs = [NSUserDefaults standardUserDefaults]; 
        if ( [myPrefs objectForKey:@"twitteruser"] != nil && [myPrefs objectForKey:@"hashtag"] != nil)
        {
            NSString *twitterUser = [myPrefs objectForKey:@"twitteruser"];
            NSString *hashTag = [myPrefs objectForKey:@"hashtag"];
            NSString *Long = [[NSString alloc] initWithFormat:@"%f", newPoint.coordinate.longitude];
            NSString *Lat = [[NSString alloc] initWithFormat:@"%f", newPoint.coordinate.latitude];
        
        
            // send the request to the server here
            NSString *myRequestString = [[NSString alloc] initWithFormat:@"http://tracker.alsandbox.us/api/Create?TwitterName=%@&Long=%@&Lat=%@&sHashTag=%@", twitterUser, Long, Lat, hashTag ];
            NSLog(@"Submitting %@", myRequestString);
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:myRequestString]];
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *get = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            NSLog(@"Response: %@", get);
        }
    }*/
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

@end
