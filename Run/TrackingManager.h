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

#import "DistancePoint.h"
#import "GpsTotals.h"
#import "GpsDatabaseManager.h"


@interface TrackingManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) NSTimer *gpsTimer;

@property (nonatomic) NSTimeInterval submitInterval;

@property (nonatomic, strong) NSTimer *timerForEditing;
@property (nonatomic, strong) CLLocation *lastLocation;

@property (nonatomic, strong) NSMutableArray *DistancePoints;
@property (nonatomic, strong) GpsTotals *gpsTotals;

@property (nonatomic) BOOL bStarted;
@property (nonatomic, strong) NSString *uniqueID;

@property (nonatomic,strong) GpsDatabaseManager *database;


- (void) startUpTracking;
- (void) submitPoint:(CLLocation *) newPoint;
-(BOOL) validNetworkConnection;
- (void) stopTracking;


@end
