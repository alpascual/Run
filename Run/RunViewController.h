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

@interface RunViewController : UIViewController

@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewAltitude;
@property (nonatomic, strong) TrackingManager *trackingManager;


- (void) startRun;
- (void) stopRun;


@end
