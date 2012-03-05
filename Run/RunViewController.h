//
//  RunViewController.h
//  Run
//
//  Created by Al Pascual on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBSparkLineView.h"
#import "TrackingManager.h"
#import "SVStatusHUD.h"
#import "GpsDatabaseManager.h"
#import "RunProtocol.h"
#import "MyAccelerometer.h"
#import "DistanceVoiceFeedback.h"
#import "TimeVoiceFeedback.h"

@interface RunViewController : UIViewController


@property (nonatomic, strong) TrackingManager *trackingManager;
@property (nonatomic, strong) NSTimer *gpsTimer;
@property (nonatomic, strong) NSDate *start;

@property (nonatomic, strong) IBOutlet UILabel *speed;
@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UILabel *gpsAccuracy;
@property (nonatomic, strong) IBOutlet UILabel *altitude;
@property (nonatomic, strong) IBOutlet UILabel *miles;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UILabel *walkLabel;
@property (nonatomic, strong) IBOutlet UILabel *distancePerTime;

@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewAltitude;
@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewSpeed;
@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewAcceleration;
@property (nonatomic, strong) NSMutableArray *altitudeArray;
@property (nonatomic, strong) NSMutableArray *speedArray;
@property (nonatomic, strong) NSMutableArray *accelerationArray;

@property (nonatomic, strong) id <RunProtocol> delegate;
@property (nonatomic, strong) GpsDatabaseManager *database;
@property (nonatomic, strong) MyAccelerometer *acceleration;
@property (nonatomic) double avgSpeed;
@property (nonatomic, strong) IBOutlet UIToolbar *myToolbar;

@property (nonatomic, strong) DistanceVoiceFeedback *voiceFeedback;
@property (nonatomic, strong) TimeVoiceFeedback *timeFeedback;


- (void) startRun;
- (void) stopRun;
- (void) setupLineGraphics;


@end
