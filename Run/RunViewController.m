//
//  RunViewController.m
//  Run
//
//  Created by Al Pascual on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RunViewController.h"

@implementation RunViewController

@synthesize sparkLineViewAltitude = _sparkLineViewAltitude;
@synthesize sparkLineViewSpeed = _sparkLineViewSpeed;
@synthesize trackingManager = _trackingManager;
@synthesize speed = _speed;
@synthesize time = _time;
@synthesize gpsAccuracy = _gpsAccuracy;
@synthesize altitude = _altitude;
@synthesize gpsTimer = _gpsTimer;
@synthesize miles = _miles;
@synthesize start = _start;
@synthesize altitudeArray = _altitudeArray;
@synthesize speedArray = _speedArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trackingManager = [[TrackingManager alloc] init];
    self.trackingManager.bStarted = NO;
    [self.trackingManager startUpTracking];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Start and Actions

- (IBAction)switchChanged:(id)sender {
    
    UISegmentedControl *segment = sender;
    
    if ( segment.selectedSegmentIndex == 0 )
        [self startRun];
    else
        [self stopRun];
}

- (void) startRun {
    self.trackingManager.bStarted = YES;
    [self.trackingManager startUpTracking];
    
    [SVStatusHUD showWithoutImage:@"Starting..."];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.gpsTimer = [NSTimer scheduledTimerWithTimeInterval:(0.9) target:self selector:
                     @selector(refreshTimer:) userInfo:nil repeats:YES];
    
    self.start = [NSDate date];
    
    self.speedArray = [[NSMutableArray alloc] init];
    self.altitudeArray = [[NSMutableArray alloc] init];
    //TODO UI change and reset counter
    
    //TODO start timer to update UI
}

- (void) stopRun {    
    self.trackingManager.bStarted = NO;
    [self.trackingManager stopTracking];
    
    [SVStatusHUD showWithoutImage:@"Stopping..."];
    
    [self.gpsTimer invalidate];
    self.gpsTimer = nil;
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}



- (void)refreshTimer:(NSTimer *)timer {
    
    if ( self.trackingManager.gpsTotals.speed > 0 ) {
        self.speed.text = [[NSString alloc] initWithFormat:@"%.2f mph", (self.trackingManager.gpsTotals.speed * 2.2369)];
        NSNumber *tempSpeed = [[NSNumber alloc] initWithDouble:(self.trackingManager.gpsTotals.speed * 2.2369)];
        [self.speedArray addObject:tempSpeed];
        NSLog(@"Speed values is %@", tempSpeed);
    }
    else {
        NSNumber * iSpeed = [[NSNumber alloc] initWithDouble:-self.trackingManager.gpsTotals.speed];
        self.speed.text = [[NSString alloc] initWithFormat:@"%.2f mph", iSpeed];
        [self.speedArray addObject:iSpeed];
        NSLog(@"Speed values is %@", iSpeed);
    }
    
    self.altitude.text = [[NSString alloc] initWithFormat:@"%.2f alt.", self.trackingManager.gpsTotals.altitude];
    
    NSNumber *tempAltitude = [[NSNumber alloc] initWithDouble:self.trackingManager.gpsTotals.altitude];
    
    // For test only
    /*int ranNo=  random()%100+1;
    NSNumber *tempAltitude = [[NSNumber alloc] initWithInt:ranNo];
     */
    
    [self.altitudeArray addObject:tempAltitude];
    NSLog(@"Altitude values is %@", tempAltitude);
    
    self.miles.text = [[NSString alloc] initWithFormat:@"%.2f mi", self.trackingManager.gpsTotals.distanceTotal];
    
    self.gpsAccuracy.text = [[NSString alloc] initWithFormat:@"%.2f gps acc.", self.trackingManager.gpsTotals.accuracy];
    
    NSTimeInterval timeInterval = [self.start timeIntervalSinceNow];
    NSInteger ti = (NSInteger)timeInterval;
    NSInteger seconds = ti % 60;
    seconds = -seconds;
    NSInteger minutes = (ti / 60) % 60;
    minutes = -minutes;
    NSInteger hours = (ti / 3600);
    hours = -hours;
        
    // If you want to get the individual digits of the units, use div again
    
    // with a divisor of 10.    
    NSLog(@"%d:%d:%d", hours, minutes, seconds);
    self.time.text = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
    
    [self setupLineGraphics];
}

- (void) setupLineGraphics {
    self.sparkLineViewAltitude.dataValues = self.altitudeArray;
    self.sparkLineViewAltitude.labelText = @"Altitude";
    self.sparkLineViewAltitude.currentValueColor = [UIColor redColor];
    self.sparkLineViewAltitude.penColor = [UIColor blueColor];
    self.sparkLineViewAltitude.penWidth = 3.0f;
    self.sparkLineViewAltitude.rangeOverlayLowerLimit = nil;
    self.sparkLineViewAltitude.rangeOverlayUpperLimit = nil;
    
    self.sparkLineViewSpeed.dataValues = self.speedArray;
    self.sparkLineViewSpeed.labelText = @"Speed";
    self.sparkLineViewSpeed.currentValueColor = [UIColor greenColor];
    self.sparkLineViewSpeed.currentValueFormat = @"%.0f";
    self.sparkLineViewSpeed.penColor = [UIColor redColor];
    self.sparkLineViewSpeed.penWidth = 3.0f;
    self.sparkLineViewSpeed.rangeOverlayLowerLimit = nil;
    self.sparkLineViewSpeed.rangeOverlayUpperLimit = nil;
    
    [self.sparkLineViewAltitude reloadInputViews];
    [self.sparkLineViewSpeed reloadInputViews];
    
    //reset the arrays if they are too big
}



@end
