//
//  MyAccelerometer.h
//  Recovery
//
//  Created by Al Pascual on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GpsDatabaseManager.h"


@interface MyAccelerometer : NSObject <UIAccelerometerDelegate>{

	UIAccelerometer *accelerometerManager;
	

}

@property (nonatomic, strong) UIAccelerometer *accelerometerManager; 
@property (nonatomic,strong) GpsDatabaseManager *database;
@property (nonatomic,strong) NSString *uniqueId;
@property (nonatomic) double X;
@property (nonatomic) double Y;
@property (nonatomic) double Z;

@property (nonatomic,strong) UIAcceleration *lastAcceleration;
@property (nonatomic, strong) NSTimer *accTimer;

- (void) stop;

@end
