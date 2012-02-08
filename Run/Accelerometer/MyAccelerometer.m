//
//  MyAccelerometer.m
//  Recovery
//
//  Created by Al Pascual on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAccelerometer.h"


@implementation MyAccelerometer

@synthesize accelerometerManager;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.accelerometerManager = [UIAccelerometer sharedAccelerometer];
        self.accelerometerManager.delegate = self; 
    }
    return self;
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
    //TODO, record the numbers here and the database
    
    //labelX.text = [NSString stringWithFormat:@"%@%f", @"X: ", acceleration.x];
	//labelY.text = [NSString stringWithFormat:@"%@%f", @"Y: ", acceleration.y];
	//labelZ.text = [NSString stringWithFormat:@"%@%f", @"Z: ", acceleration.z];
	
//	self.progressX.progress = ABS(acceleration.x);
//	self.progressY.progress = ABS(acceleration.y);
//	self.progressZ.progress = ABS(acceleration.z);
}

@end
