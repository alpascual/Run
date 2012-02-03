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

@interface RunViewController : UIViewController

@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewAltitude;
@property (nonatomic, strong) TrackingManager *trackingManager;
@property (nonatomic, strong) NSTimer *gpsTimer;

@property (nonatomic, strong) IBOutlet UILabel *speed;
@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UILabel *gpsAccuracy;
@property (nonatomic, strong) IBOutlet UILabel *altitude;
@property (nonatomic, strong) IBOutlet UILabel *miles;


- (void) startRun;
- (void) stopRun;


@end
