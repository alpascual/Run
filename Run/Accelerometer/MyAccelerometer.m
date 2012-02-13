//
//  MyAccelerometer.m
//  Recovery
//
//  Created by Al Pascual on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAccelerometer.h"


@implementation MyAccelerometer

@synthesize accelerometerManager = _accelerometerManager;
@synthesize database = _database;
@synthesize uniqueId = _uniqueId;
@synthesize X = _X;
@synthesize Y = _Y;
@synthesize Z = _Z;
@synthesize lastAcceleration = _lastAcceleration;
@synthesize accTimer = _accTimer;

- (id) init {
    self = [super init];
    if (self != nil) {
        
        self.database = [[GpsDatabaseManager alloc] init];
        
        self.accelerometerManager = [UIAccelerometer sharedAccelerometer];
        self.accelerometerManager.delegate = self;
        
        self.accTimer = [NSTimer scheduledTimerWithTimeInterval:(5.0) target:self selector:
                         @selector(refreshTimer:) userInfo:nil repeats:YES];
        
    }
    return self;
}

- (void) stop {
    self.accelerometerManager.delegate = nil;
    [self.accTimer invalidate];
    self.accTimer = nil;
}

- (void)refreshTimer:(NSTimer *)timer {
    if ( self.lastAcceleration != nil) {
        if ( self.uniqueId != nil && self.uniqueId.length > 0 ) {
            [self.database addMovement:self.lastAcceleration:self.uniqueId];
        }
        
        self.X = self.lastAcceleration.x;
        self.Y = self.lastAcceleration.y;
        self.Z = self.lastAcceleration.z;
    }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
    // Record it only once every 5 seconds
    
    self.lastAcceleration = acceleration;
    return;
    
    // record the numbers here and the database
    if ( self.uniqueId != nil && self.uniqueId.length > 0 ) {
        [self.database addMovement:acceleration:self.uniqueId];
    }
    
    self.X = acceleration.x;
    self.Y = acceleration.y;
    self.Z = acceleration.z;
    
    //labelX.text = [NSString stringWithFormat:@"%@%f", @"X: ", acceleration.x];
	//labelY.text = [NSString stringWithFormat:@"%@%f", @"Y: ", acceleration.y];
	//labelZ.text = [NSString stringWithFormat:@"%@%f", @"Z: ", acceleration.z];
	
//	self.progressX.progress = ABS(acceleration.x);
//	self.progressY.progress = ABS(acceleration.y);
//	self.progressZ.progress = ABS(acceleration.z);
}

@end
