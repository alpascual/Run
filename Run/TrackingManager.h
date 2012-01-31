//
//  TrackingManager.h
//  PolioTraker
//
//  Created by Al Pascual on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import <SystemConfiguration/SystemConfiguration.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


@interface TrackingManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) NSTimer *gpsTimer;
@property (nonatomic) NSTimeInterval gpsTimerInterval;
@property (nonatomic) NSTimeInterval submitInterval;

@property (nonatomic, strong) NSTimer *timerForEditing;
@property (nonatomic) NSInteger gpsCounter;
@property (nonatomic, strong) CLLocation *lastLocation;
//@property (nonatomic, strong) NSTimer *checkOnlineAvailableTimer;


- (void) startUpTracking;
- (void) changeDesiredAccuracy:(CLLocationAccuracy) accuracy;
- (void) changeGpsIntervalInSeconds:(NSTimeInterval)interval;
- (void) changeDistanceFilter:(CLLocationDistance)filter;
- (void) submitPoint:(CLLocation *) newPoint;
-(BOOL) validNetworkConnection;


@end
