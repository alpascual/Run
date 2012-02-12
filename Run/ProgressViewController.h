//
//  ProgressViewController.h
//  Run
//
//  Created by Albert Pascual on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RunProtocol.h"
#import "GpsDatabaseManager.h"
#import "ASBSparkLineView.h"

@interface ProgressViewController : UIViewController

@property (nonatomic, strong) id <RunProtocol> delegate;
@property (nonatomic, strong) NSTimer *uiTimer;
@property (nonatomic, strong) GpsDatabaseManager *database;
@property (nonatomic, strong) NSArray *historyRaw;

// distance, time, speed, time per mile
@property (nonatomic,strong) IBOutlet ASBSparkLineView *distance;
@property (nonatomic,strong) IBOutlet ASBSparkLineView *time;
@property (nonatomic,strong) IBOutlet ASBSparkLineView *speed;
@property (nonatomic,strong) IBOutlet ASBSparkLineView *timePerMile;

@property (nonatomic,strong) NSMutableArray *distanceArray;
@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSMutableArray *speedArray;
@property (nonatomic,strong) NSMutableArray *timePerMileArray;

@end
